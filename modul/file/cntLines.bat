:cntLine "File"
set "return="
setlocal
if "%~1"=="" (goto usage) else (set "file=%~1" || exit /b 5)
if not exist "%file%" exit /b 2
set /a "lines=0"
For /f usebackq^ tokens^=*^ delims^=^ eol^= %%a in ("%file%") do (
	set /a "lines+=1" || exit /b 4
)
endlocal & (
	set "return=%lines%"
)
exit /b 0


:usage
echo HELP TEXT
exit /b 1


:: ----DOC----
:: 	- INDEX BASE 1
::  - RETURNS THE NUMBER OF LINES IN A FILE WITHOUT EMTPY LINES
::  - EMPTY LINES DO NOT COUNT !
::  - COMPATIBLE WITH [readLine]
::  - if you can use cntLineNoSkipModul it is faster on big files
:: 	- this modul is SLOW ON BIG FILES




::CHANGELOG
:: 9.04.22 : ERRORLEVEL normed