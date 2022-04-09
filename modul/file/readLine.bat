

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













































:readLine "File",lineInt
:: //CHANGE LOG
:: //EMPTY LINES WILL NOT BE SKIPPED
:: //IS VERY SLOW on BIG FILES because 'find' has to phrase the whole file every time
:: INDEX BASE 1
:: RETURNS A LINE FROM A FILE
:: ERRORLEVEL = 1 /File not found
:: ERRORLEVEL = 2 /END OF FILE, Line not found
:: errorlevel = 3 /cant assign Integer, number to big
set return=
setlocal
if exist "%~1" (set "file=%~1") else (exit /b 1)
set /a line=%~2+1 || exit /b 3
if %line% GTR 0 (set "skip=skip^=%line%^ ") else (set "skip=")
For /f usebackq^ %skip%tokens^=1^,2*^ delims^=]^ eol^= %%a in (`find /n /v "" "%file%"`) do (
	endlocal & set "return=%%b%%c"
	exit /b 0
)
exit /b 2