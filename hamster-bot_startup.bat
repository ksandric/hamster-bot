@echo off

echo launch bot N1
start "" "C:\bot\dreamcast_HiDeep\hamster-bot.exe"

echo wait 30 sec...
ping 127.0.0.1 -n 30 > nul

echo launch bot N2
start "" "C:\bot\dreamcast_HiDeep_2\hamster-bot.exe"

exit