<# : batch
@echo off
rem This file is both a batch file and a PowerShell script.
rem cmd runs only this block: it requests administrator rights, switches to the folder
rem of this file and runs the PowerShell part below. For PowerShell this block is a comment.
set "HB_SELF=%~f0"
net session > nul 2>&1 || (
    echo Requesting administrator rights...
    powershell -NoProfile -Command "Start-Process -FilePath $env:HB_SELF -Verb RunAs"
    exit /b
)
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ([IO.File]::ReadAllText($env:HB_SELF))"
pause
exit /b
#>

# hamster-bot manager for Windows (counterpart of install_local.sh and update_local.sh)
#
# USAGE
#   Create a separate folder for each bot (e.g. C:\bots\bot_1), put manage_local.bat into it
#   and double-click it. The bot is installed into the folder where this file is located,
#   so do not run it from the git repository or from a folder with other files.
#   Without downloading, from PowerShell (as administrator), inside the bot folder:
#     cd C:\bots\bot_1; irm https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master/manage_local.bat | iex
#
# On start the script shows the current state (install mode, autostart, process, port, firewall,
# version compared to version.txt on GitHub) and a menu with the actions available right now:
#   1. Install            - download hb.zip and settings_program.json only; run hb_c.exe manually
#   2. Install as service - download hb.zip, set the port in settings_program.json (and
#                           dashboard_mode = false), create the scheduled task, open the port
#                           in Windows Firewall, start the bot. Also converts a files-only install
#   3. Update             - files-only install: replace files (settings_program.json is kept);
#                           a running bot is stopped and started again in a new window
#   4. Update service     - stop the bot, replace files (settings_program.json is kept),
#                           start the bot again if autostart is enabled
#   5. Stop / Start
#   6. Disable (stop and remove from autostart) / Enable (add to autostart and start)
#   7. Remove             - remove the task, the firewall rule and run_service.cmd (bot files are kept
#                           as a files-only install); optionally delete the folder
#   8. Show log           - follow console.log (like journalctl --follow)
#   9. Open port          - ask for a TCP port (Enter = port from settings_program.json) and open it
#                           in Windows Firewall; replaces the hamster-bot-<folder name> rule
#
# NON-INTERACTIVE UPDATE
#   With HB_ACTION=update the menu is skipped and option 4 (service) or 3 (files only) is run
#   without questions. The "Update bot" button of the web interface starts the script this way.
#   Administrator rights are required only to update a service install.
#
# WHAT IS CREATED
#   \hamster-bot\<folder name>  Task Scheduler task: runs run_service.cmd under SYSTEM at Windows startup
#   run_service.cmd             runs hb_c.exe in a loop and restarts it 61 seconds after it exits
#                               (like Restart=always), writes the output to console.log
#   console.log                 console output of the bot, overwritten on every start
#   hamster-bot-<folder name>   Windows Firewall inbound rule for the bot port
#
# MANUAL REMOVAL (PowerShell as administrator)
#   Unregister-ScheduledTask -TaskPath '\hamster-bot\' -TaskName '<folder name>' -Confirm:$false
#   Remove-NetFirewallRule -DisplayName 'hamster-bot-<folder name>'
#   then stop hb_c.exe in Task Manager and delete the bot folder

& {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    $REPO_URL = 'https://raw.githubusercontent.com/ksandric/hamster-bot/refs/heads/master'
    $TASK_PATH = '\hamster-bot\'

    # Current folder (the batch part switches to its own folder before starting)
    $DIR = (Get-Location).ProviderPath.TrimEnd('\')
    $NAME = Split-Path $DIR -Leaf
    $EXE = Join-Path $DIR 'hb_c.exe'
    $RUN_SCRIPT = Join-Path $DIR 'run_service.cmd'
    $SETTINGS = Join-Path $DIR 'settings_program.json'
    $LOG = Join-Path $DIR 'console.log'
    $RULE_NAME = "hamster-bot-$NAME"

    # Non-interactive update (see NON-INTERACTIVE UPDATE above). The variable is removed
    # so that the bot started by the script does not inherit it.
    $AUTO_UPDATE = $env:HB_ACTION -eq 'update'
    Remove-Item Env:HB_ACTION -ErrorAction SilentlyContinue

    # ---------- Output ----------

    function Print-Header([string]$text) {
        Write-Host ''
        Write-Host '========================================' -ForegroundColor Cyan
        Write-Host $text -ForegroundColor Cyan
        Write-Host '========================================' -ForegroundColor Cyan
    }

    function Print-Line([string]$label, [string]$value, [string]$color = 'Gray') {
        Write-Host ('{0,-10}' -f "${label}:") -ForegroundColor Cyan -NoNewline
        Write-Host $value -ForegroundColor $color
    }

    function Print-Ok([string]$text) { Write-Host "[OK] $text" -ForegroundColor Green }
    function Print-Warn([string]$text) { Write-Host "[!] $text" -ForegroundColor Yellow }
    function Print-Error([string]$text) { Write-Host "[ERROR] $text" -ForegroundColor Red }

    function Confirm-Yes([string]$question) {
        return (Read-Host "$question (y/N)") -match '^[yY]'
    }

    function Format-Uptime([TimeSpan]$t) {
        if ($t.Days -gt 0) { return '{0}d {1}h' -f $t.Days, $t.Hours }
        if ($t.Hours -gt 0) { return '{0}h {1}m' -f $t.Hours, $t.Minutes }
        return '{0}m' -f $t.Minutes
    }

    # ---------- State ----------

    function Get-BotProcess {
        Get-CimInstance Win32_Process -Filter "Name='hb_c.exe'" | Where-Object { $_.ExecutablePath -eq $EXE }
    }

    function Get-BotState {
        try { $tasks = @(Get-ScheduledTask -TaskPath $TASK_PATH -ErrorAction Stop) } catch { $tasks = @() }
        $task = $tasks | Where-Object { $_.Actions | Where-Object { $_.Execute -eq $RUN_SCRIPT } } | Select-Object -First 1
        # A task with the same name that belongs to a bot in another folder
        $conflict = $null
        if (-not $task) { $conflict = $tasks | Where-Object { $_.TaskName -eq $NAME } | Select-Object -First 1 }

        $port = $null
        if (Test-Path $SETTINGS) {
            $m = [regex]::Match([IO.File]::ReadAllText($SETTINGS), '"port"\s*:\s*(\d+)')
            if ($m.Success) { $port = [int]$m.Groups[1].Value }
        }
        $rulePorts = @()
        $rule = Get-NetFirewallRule -DisplayName $RULE_NAME -ErrorAction SilentlyContinue
        if ($rule) { $rulePorts = @($rule | Get-NetFirewallPortFilter | ForEach-Object { "$($_.LocalPort)" }) }

        [pscustomobject]@{
            Task      = $task
            Conflict  = $conflict
            Enabled   = [bool]($task -and $task.State -ne 'Disabled')
            Processes = @(Get-BotProcess)
            Port      = $port
            RulePorts = $rulePorts
        }
    }

    function Show-State($st) {
        Print-Header "hamster-bot: $NAME"
        Print-Line 'Folder' $DIR
        if ($st.Task) {
            Print-Line 'Install' "service ($TASK_PATH$($st.Task.TaskName))" Green
            if ($st.Enabled) { Print-Line 'Autostart' 'enabled' Green } else { Print-Line 'Autostart' 'disabled' Yellow }
        } elseif (Test-Path $EXE) {
            Print-Line 'Install' 'files only, no autostart (run hb_c.exe manually)' Green
        } else {
            Print-Line 'Install' 'not installed' Yellow
        }

        if ($st.Processes.Count -gt 0) {
            $p = $st.Processes[0]
            Print-Line 'Bot' ('running (PID {0}, started {1:yyyy-MM-dd HH:mm}, up {2})' -f $p.ProcessId, $p.CreationDate, (Format-Uptime ((Get-Date) - $p.CreationDate))) Green
        } else {
            Print-Line 'Bot' 'stopped' Yellow
        }

        if ($st.Port) {
            $listening = [Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpListeners() | Where-Object { $_.Port -eq $st.Port }
            if ($st.Processes.Count -gt 0) { $listenText = if ($listening) { 'listening' } else { 'not listening' } }
            else { $listenText = if ($listening) { 'used by another program' } else { 'free' } }
            if ($st.RulePorts -contains "$($st.Port)") { $fwText = 'open' }
            elseif ($st.RulePorts.Count -gt 0) { $fwText = "another port is open ($($st.RulePorts -join ', '))" }
            else { $fwText = 'closed' }
            $color = if ($listening -and $st.Processes.Count -gt 0 -and $st.RulePorts -contains "$($st.Port)") { 'Green' } else { 'Yellow' }
            Print-Line 'Port' "$($st.Port), $listenText, firewall: $fwText" $color
        }

        if (Test-Path $EXE) {
            $localDate = (Get-Item $EXE).LastWriteTime.Date
            $text = 'build {0:yyyy-MM-dd}' -f $localDate
            $color = 'Gray'
            if ($REMOTE_DATE) {
                if ($REMOTE_DATE -gt $localDate) { $text += ', update available ({0:yyyy-MM-dd})' -f $REMOTE_DATE; $color = 'Yellow' }
                else { $text += ', up to date' ; $color = 'Green' }
            }
            Print-Line 'Version' $text $color
        }
    }

    # ---------- Helpers ----------

    # Stops the task, hb_c.exe and the run_service.cmd wrapper from the bot folder
    function Stop-BotProcesses($task) {
        if ($task) { try { Stop-ScheduledTask -InputObject $task } catch { } }
        Get-CimInstance Win32_Process | Where-Object {
            $_.ExecutablePath -eq $EXE -or ($_.Name -eq 'cmd.exe' -and $_.CommandLine -and $_.CommandLine.Contains($RUN_SCRIPT))
        } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }
        for ($i = 0; $i -lt 20 -and (Get-BotProcess); $i++) { Start-Sleep -Milliseconds 500 }
    }

    function Start-Bot($task) {
        Remove-Item $LOG -Force -ErrorAction SilentlyContinue
        Start-ScheduledTask -InputObject $task -ErrorAction Stop
        for ($i = 0; $i -lt 20 -and -not (Get-BotProcess); $i++) { Start-Sleep -Milliseconds 500 }
        if (Get-BotProcess) { Print-Ok 'Bot started' } else { Print-Warn 'Bot did not start, check the log (option 8)' }
    }

    # Extracts the archive overwriting files; $exclude - file names to leave untouched
    function Expand-Zip([string]$zipPath, [string[]]$exclude) {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $zip = [IO.Compression.ZipFile]::OpenRead($zipPath)
        try {
            foreach ($entry in $zip.Entries) {
                $name = $entry.FullName -replace '/', '\'
                if ($name.EndsWith('\') -or $exclude -contains $name) { continue }
                $target = Join-Path $DIR $name
                $targetDir = Split-Path $target -Parent
                if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
                [IO.Compression.ZipFileExtensions]::ExtractToFile($entry, $target, $true)
            }
        } finally {
            $zip.Dispose()
        }
    }

    # Downloads and extracts hb.zip; returns $true on success
    function Get-Release([string[]]$exclude) {
        $zipPath = Join-Path $DIR 'new_ver.zip'
        try {
            Write-Host 'Downloading the latest version...'
            Invoke-WebRequest -Uri "$REPO_URL/hb.zip" -OutFile $zipPath -UseBasicParsing
            Print-Ok 'Archive downloaded'
            Expand-Zip $zipPath $exclude
            Print-Ok 'Files updated'
            return $true
        } catch {
            Print-Error "Failed to download or extract the archive: $($_.Exception.Message)"
            return $false
        } finally {
            Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        }
    }

    # run_service.cmd is started by the scheduled task. Task Scheduler cannot restart a program
    # after it exits, so the wrapper runs the bot in a loop with a 61 second pause (like Restart=always).
    # The task is found by the path to this file, so it must stay in the bot folder.
    function Write-RunScript {
        $content = @'
@echo off
chcp 65001 > nul
cd /d "%~dp0"
set "DOTNET_BUNDLE_EXTRACT_BASE_DIR=%~dp0.net"
:loop
hb_c.exe > console.log 2>&1
ping 127.0.0.1 -n 62 > nul
goto loop
'@
        [IO.File]::WriteAllText($RUN_SCRIPT, ($content -replace "`r?`n", "`r`n"), (New-Object Text.ASCIIEncoding))
    }

    function Read-Port {
        $ipProps = [Net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties()
        while ($true) {
            $port = Read-Host 'Enter port (80-65535)'
            if ($port -notmatch '^[0-9]+$') { Print-Error 'Please enter a valid number'; continue }
            $port = [int]$port
            if ($port -lt 80 -or $port -gt 65535) { Print-Error 'Port must be between 80 and 65535'; continue }
            $busy = @($ipProps.GetActiveTcpListeners()) + @($ipProps.GetActiveUdpListeners()) | Where-Object { $_.Port -eq $port }
            if ($busy) { Print-Error "Port $port is already in use"; continue }
            return $port
        }
    }

    # Creates (or replaces) the inbound firewall rule of the bot for the given TCP port
    function Set-FirewallRule([int]$port) {
        Get-NetFirewallRule -DisplayName $RULE_NAME -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction Stop
        New-NetFirewallRule -DisplayName $RULE_NAME -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Any -ErrorAction Stop | Out-Null
        Print-Ok "Port $port opened in Windows Firewall (rule $RULE_NAME)"
    }

    # Like journalctl --follow: shows console.log in real time
    function Show-Log {
        Print-Header 'Log (Ctrl+C to exit, the bot keeps running)'
        for ($i = 0; $i -lt 30 -and -not (Test-Path $LOG); $i++) { Start-Sleep -Seconds 1 }
        if (-not (Test-Path $LOG)) { Print-Warn "File $LOG not found"; return }
        Get-Content $LOG -Wait -Tail 50 -Encoding UTF8
    }

    # Downloads settings_program.json if it is missing; returns $true if the file exists
    function Get-Settings {
        if (Test-Path $SETTINGS) { return $true }
        Print-Warn 'settings_program.json not found, downloading it from the repository'
        try { Invoke-WebRequest -Uri "$REPO_URL/settings_program.json" -OutFile $SETTINGS -UseBasicParsing } catch { }
        if (-not (Test-Path $SETTINGS) -or (Get-Item $SETTINGS).Length -eq 0) {
            Remove-Item $SETTINGS -Force -ErrorAction SilentlyContinue
            Print-Error 'Failed to download settings_program.json'
            return $false
        }
        return $true
    }

    # ---------- Menu actions ----------

    # 1. Files only: no scheduled task, no firewall rule, settings are left as is
    function Install-Files {
        if (-not (Get-Release @('settings_program.json'))) { return }
        if (-not (Get-Settings)) { return }
        Print-Ok "Done! Run $EXE to start the bot"
    }

    # 3. Update of a files-only install
    function Update-Files($st) {
        $wasRunning = $st.Processes.Count -gt 0
        if ($wasRunning) {
            if (-not $AUTO_UPDATE -and -not (Confirm-Yes 'The bot is running. Stop it and update?')) { return }
            Stop-BotProcesses $null
            Print-Ok 'Bot stopped'
        }
        $ok = Get-Release @('settings_program.json')
        if ($wasRunning) {
            if (-not $ok) { Print-Warn 'Starting the previous version' }
            Start-Process -FilePath $EXE -WorkingDirectory $DIR
            Print-Ok 'Bot started in a new window'
        }
    }

    # 2. Install as service (also converts a files-only install)
    function Install-Bot {
        $port = Read-Port
        Print-Ok "Selected free port: $port"

        # The bot may have been started manually - otherwise hb_c.exe is locked
        Stop-BotProcesses $null
        if (-not (Get-Release @('settings_program.json'))) { return }
        if (-not (Get-Settings)) { return }

        # Replace values with regex to keep the file formatting
        $json = [IO.File]::ReadAllText($SETTINGS)
        if ($json -notmatch '"port"\s*:\s*\d+') { Print-Error "Parameter 'port' not found in settings_program.json"; return }
        $json = $json -replace '"port"\s*:\s*\d+', "`"port`": $port"
        if ($json -match '"dashboard_mode"\s*:') {
            $json = $json -replace '"dashboard_mode"\s*:\s*(true|false)', '"dashboard_mode": false'
        } else {
            Print-Warn "Parameter 'dashboard_mode' not found in settings_program.json"
        }
        [IO.File]::WriteAllText($SETTINGS, $json, (New-Object Text.UTF8Encoding($false)))
        Print-Ok "Port set to $port, console.dashboard_mode = false"

        Write-RunScript
        $action = New-ScheduledTaskAction -Execute $RUN_SCRIPT -WorkingDirectory $DIR
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
        $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
            -StartWhenAvailable -MultipleInstances IgnoreNew -RestartCount 999 -RestartInterval (New-TimeSpan -Minutes 1)
        $task = Register-ScheduledTask -TaskPath $TASK_PATH -TaskName $NAME -Action $action -Trigger $trigger -Principal $principal `
            -Settings $settings -Description "hamster-bot-$NAME" -Force -ErrorAction Stop
        Print-Ok "Scheduled task $TASK_PATH$NAME created"

        Set-FirewallRule $port

        Start-Bot $task
        Print-Ok 'Done!'
        Show-Log
    }

    # 4. Update of a service install
    function Update-Bot($st) {
        Stop-BotProcesses $st.Task
        Print-Ok 'Bot stopped'
        $ok = Get-Release @('settings_program.json')
        Write-RunScript
        if (-not $st.Enabled) {
            Print-Warn 'Autostart is disabled, the bot was not started. Enable it with option 6.'
            return
        }
        if (-not $ok) { Print-Warn 'Starting the previous version' }
        Start-Bot $st.Task
        if ($ok -and -not $AUTO_UPDATE) { Show-Log }
    }

    function Disable-Bot($st) {
        Stop-BotProcesses $st.Task
        Disable-ScheduledTask -InputObject $st.Task -ErrorAction Stop | Out-Null
        Print-Ok 'Bot stopped and will not start with Windows'
    }

    function Enable-Bot($st) {
        $task = Enable-ScheduledTask -InputObject $st.Task -ErrorAction Stop
        Print-Ok 'Autostart enabled'
        Start-Bot $task
    }

    # 9. Asks for a port and opens it in Windows Firewall
    function Open-Port($st) {
        $prompt = 'Enter TCP port to open (1-65535)'
        if ($st.Port) { $prompt += ", Enter = $($st.Port) from settings_program.json" } else { $prompt += ', Enter = cancel' }
        while ($true) {
            $port = "$(Read-Host $prompt)".Trim()
            if (-not $port) {
                if (-not $st.Port) { Print-Warn 'Cancelled'; return }
                $port = "$($st.Port)"
            }
            if ($port -match '^[0-9]{1,5}$' -and [int]$port -ge 1 -and [int]$port -le 65535) { break }
            Print-Error 'Port must be a number between 1 and 65535'
        }
        Set-FirewallRule ([int]$port)
    }

    # Returns $true if the whole bot folder was deleted
    function Remove-Bot($st) {
        if (-not (Confirm-Yes "Remove service $TASK_PATH$NAME?")) { return $false }
        Stop-BotProcesses $st.Task
        Unregister-ScheduledTask -InputObject $st.Task -Confirm:$false -ErrorAction Stop
        Get-NetFirewallRule -DisplayName $RULE_NAME -ErrorAction SilentlyContinue | Remove-NetFirewallRule -ErrorAction Stop
        Remove-Item $RUN_SCRIPT, $LOG -Force -ErrorAction SilentlyContinue
        Print-Ok 'Service and firewall rule removed'

        if (Test-Path (Join-Path $DIR '.git')) {
            Print-Warn 'The folder is a git repository, bot files are kept'
            return $false
        }

        if (-not (Confirm-Yes "Also delete folder $DIR with all files (settings, API keys, logs)?")) { return $false }
        Set-Location (Split-Path $DIR -Parent)
        Remove-Item $DIR -Recurse -Force
        Print-Ok "Folder $DIR deleted"
        return $true
    }

    # ---------- Start ----------

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin -and -not $AUTO_UPDATE) {
        Print-Error 'Run PowerShell as administrator'
        return
    }

    # Refuse to work in a system folder (e.g. C:\Windows\System32 of an administrator PowerShell)
    $forbidden = @($env:windir, $env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:USERPROFILE) | Where-Object { $_ } | ForEach-Object { $_.TrimEnd('\') }
    if ([IO.Path]::GetPathRoot($DIR).TrimEnd('\') -eq $DIR -or $forbidden -contains $DIR -or $DIR.StartsWith($env:windir + '\', 'OrdinalIgnoreCase')) {
        Print-Error "Folder '$DIR' cannot be used for the bot."
        Write-Host '        Create a separate folder (e.g. C:\bots\bot_1) and run the script from it.'
        return
    }

    $REMOTE_DATE = $null
    try {
        $v = (Invoke-RestMethod -Uri "$REPO_URL/version.txt" -TimeoutSec 5 -UseBasicParsing).Trim()
        $REMOTE_DATE = [datetime]::ParseExact($v, 'yyyy/MM/dd', [Globalization.CultureInfo]::InvariantCulture)
    } catch { }

    if ($AUTO_UPDATE) {
        try {
            $st = Get-BotState
            Show-State $st
            if ($st.Task) {
                if (-not $isAdmin) { Print-Error 'Administrator rights are required to update the service'; return }
                Update-Bot $st
            } elseif (Test-Path $EXE) {
                Update-Files $st
            } else {
                Print-Error "File $EXE not found"
            }
        } catch {
            Print-Error "$($_.Exception.Message) (line $($_.InvocationInfo.ScriptLineNumber))"
        }
        return
    }

    while ($true) {
        try {
            $st = Get-BotState
            Show-State $st
        } catch {
            Print-Error "Failed to check state: $($_.Exception.Message) (line $($_.InvocationInfo.ScriptLineNumber))"
            return
        }

        # Numbers are fixed, only the actions available in the current state are shown
        $menu = [ordered]@{}
        if (-not $st.Task) {
            $filesInstalled = Test-Path $EXE
            if (-not $filesInstalled) { $menu['1'] = 'Install into this folder (files only, no autostart)' }
            if ($st.Conflict) {
                Print-Warn "Task $TASK_PATH$NAME is already used by the bot in $($st.Conflict.Actions[0].WorkingDirectory). Rename this folder to install as service."
            } else {
                $menu['2'] = 'Install as service into this folder (autostart, restart on crash)'
            }
            if ($filesInstalled) { $menu['3'] = 'Update' }
        } else {
            $menu['4'] = 'Update service'
            if ($st.Processes.Count -gt 0) { $menu['5'] = 'Stop' } elseif ($st.Enabled) { $menu['5'] = 'Start' }
            if ($st.Enabled) { $menu['6'] = 'Disable (stop and remove from autostart)' } else { $menu['6'] = 'Enable (add to autostart and start)' }
            $menu['7'] = 'Remove service'
            $menu['8'] = 'Show log'
        }
        $menu['9'] = 'Open port in Windows Firewall'
        $menu['0'] = 'Exit'

        Write-Host ''
        foreach ($key in $menu.Keys) { Write-Host "  $key. $($menu[$key])" }
        $choice = "$(Read-Host 'Choose an action')".Trim()
        if (-not $menu.Contains($choice)) {
            Print-Error 'Invalid choice'
            continue
        }

        try {
            switch ($choice) {
                '0' { return }
                '1' { Install-Files }
                '2' { Install-Bot }
                '3' { Update-Files $st }
                '4' { Update-Bot $st }
                '5' {
                    if ($st.Processes.Count -gt 0) { Stop-BotProcesses $st.Task; Print-Ok 'Bot stopped' }
                    else { Start-Bot $st.Task }
                }
                '6' { if ($st.Enabled) { Disable-Bot $st } else { Enable-Bot $st } }
                '7' { if (Remove-Bot $st) { return } }
                '8' { Show-Log }
                '9' { Open-Port $st }
            }
        } catch {
            Print-Error "$($_.Exception.Message) (line $($_.InvocationInfo.ScriptLineNumber))"
        }
    }
}
