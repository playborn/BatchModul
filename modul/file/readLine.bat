

:readLine "File" "lineNumber"
set "return="
setlocal
if "%~1"=="" (goto usage) else (set "file=%~1" || exit /b 5)
if "%~2"=="" (goto usage) else (set /a "line=%~2-1" || exit /b 4)
if not exist "%file%" exit /b 2

if %line% GTR 0 (set "skip=skip^=%line%^ ") else (set "skip=")
For /f usebackq^ %skip%tokens^=*^ delims^=^ eol^= %%a in ("%file%") do (
	endlocal & (
		set "return=%%a" || exit /b 5
	)
	exit /b 0
)
exit /b 6



:usage
echo HELP TEXT
exit /b 1

:: ----DOC----
:: 	- INDEX BASE 1
::  - RETURNS A LINE FROM A FILE AS A STRING (emtpy lines will disapear)
::  - EMPTY LINES IN FILE WILL BE SKIPPED
::  - compatible with cntLines
::  - compatible with cntLinesNoSkip if no empty lines in files
:: 	- this modul is FAST ON BIG FILES-




::CHANGELOG
:: 9.04.22 : ERRORLEVEL normed
