
:strGetToken "string" "Delims" "tokenInt"
set "return="

setlocal ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
rem workaround runs with some special chars
if ""%1""=="""" (goto usage) else (set "string=%~1" || exit /b 5)
if "%~2"=="" (goto usage) else (set "delimiter=%~2" || exit /b 5)
if "%~3"=="" (goto usage) else (set /a "wantedToken=%~3" || exit /b 4)
set /a "token=0"

:process
for /F tokens^=1*^ delims^=^%delimiter%^ eol^= %%a in ("%string%") do (
	set /a "token+=1" || exit /B 4
	if !token! EQU !wantedToken! (
		endlocal & (
			set "return=%%a" || exit /b 5
			exit /b 0
		)
	)
	set "string=%%b" || exit /b 5
	goto process
)
exit /b 6


:usage
echo HELP TEXT
exit /b 1

:: -DOC-
:: Index Base 1
:: gets a token from a given string
:: ex. call strGetToken "name,age,gender" "," "2"
:: returns "age"


::CHANGELOG
:: 9.04.22 : ERRORLEVEL normed