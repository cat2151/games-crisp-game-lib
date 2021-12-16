@echo off
setlocal
set BASE=.\
set TODAY=%date:~0,4%%date:~5,2%%date:~8,2%

rem copy
xcopy /ID %BASE%_template %BASE%%TODAY%

rem watch
start npm run watch_games

rem browser
start http://localhost:4000?%TODAY%

rem browser clipboard to main.js
start chromeClipboardSaver.bat %BASE%%TODAY%\main.js

rem vscode
code %BASE%%TODAY%\main.js
