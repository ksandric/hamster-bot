@echo off

echo Starting bot #1
cd "C:\bots\bot_1"
start hamster-bot.exe

echo wait 30 sec...
ping 127.0.0.1 -n 30 > nul

echo Starting bot #2
cd "C:\bots\bot_2"
start hamster-bot.exe

echo wait 30 sec...
ping 127.0.0.1 -n 30 > nul

echo Starting bot #3
cd "C:\bots\bot_3"
start hamster-bot.exe

exit