
:cntToken "String" "delimiterChar"
set return=
setlocal ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS
rem workaround, works with some special chars
if ""%1""=="""" (goto usage) else (set "string=%~1" || exit /b 5)
if "%~2"=="" (goto usage) else (set "delimiter=%~2" || exit /b 5)
set /a "token=0" || exit /b 4

:process
for /F tokens^=1*^ delims^=^%delimiter%^ eol^= %%a in ("!string!") do (
	set /a "token+=1" || exit /b 4
	set "string=%%b" || exit /b 5
	goto process
)
endlocal & (
	set /a "return=%token%" || exit /b 5
)
exit /b 0

:usage
echo HELP TEXT
exit /b 1


:: -- DOC--
:: INDEX BASE 1
:: splits a string by a delimiter and count the tokens
:: Counts tokens from a given string.
:: ex. call cntToken "Name,age,gender" ","
:: returns "3"




::CHANGELOG
:: 9.04.22 : ERRORLEVEL normed
