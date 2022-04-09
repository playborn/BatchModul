:strlen "string"
set "return="
setlocal
if ""%1""=="""" (goto usage) else (set "string=%~1" || exit /b 5)

(echo "%string%" & echo.) | findstr /O . | more +1 | (set /P offset= & call exit /B %%offset%%)
set /A "len=%ERRORLEVEL%-5" || exit /b 4
endlocal & (
	set /a "return=%len%" || exit /b 4
)
exit /b 0



:usage
echo HELP TEXT
exit /b 1



:: -DOC-
:: count chars in a string

::CHANGELOG
:: 9.04.22 : ERRORLEVEL normed