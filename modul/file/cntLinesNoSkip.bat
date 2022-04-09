:cntlines "file"
set "return="
setlocal
if "%~1"=="" (goto usage) else (set "file=%~1" || exit /b 5)
if not exist "%file%" exit /b 2
set "cmd=findstr /R /N "^^" "%file%" ^| find /C ":""

for /f "usebackq delims=" %%a in (`%cmd%`) do (
	set /a "number=%%a" || exit /b 4
)
endlocal & (
	set /a "return=%number%" || exit /b 4
)
exit /b 0




:usage
echo HELP TEXT
exit /b 1

:: ----DOC----
:: 	- INDEX BASE 1
::  - RETURNS THE NUMBER OF LINES IN A FILE (all lines)
::  - this is a way to count all lines even empty lines or lines with eol chars
::  - COMPATIBLE WITH [readLineNoSkip] or readLine if ther is no empty lines in file
::  - if you can use cntLines Modul it is faster but do not recognize empty lines
:: 	- FAST ON BIG FILES




::CHANGELOG
:: 9.04.22 : ERRORLEVEL normed