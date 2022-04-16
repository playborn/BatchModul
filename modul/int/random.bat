:: -changelog-
:: 11.04.21 v1.0.0
:: -DOC-
:: ----BATCH LIMITATION----
::  Biggest integer is 32-Bit on bit is reserved for negativ or positiv [-2147483647 - 2147483647] in binary [1111 1111 1111 1111 1111 1111 1111 1111 - 0111 1111 1111 1111 1111 1111 1111 1111]


:random(<Minimal Integer>, <Maximum Integer>)
set "return="
setlocal
if "%~1"=="" goto usage
if "%~2"=="" goto usage
if %~1 GTR %~2 goto usage
set /a "min=%~1" || exit /b 4
set /a "max=%~2" || exit /b 4
SET /a "rndNr=%RANDOM% %% (%max% - %min% + 1) + %min%" || exit /b 4
endlocal & (
	set /a "return=%rndNr%" || exit /b 4
)
exit /b 0

:usage
echo version 1.0.0
echo Returns a random Number in a given range
echo call %~n0  ^<MinimalINT^> ^<MaximumINT^>
echo.
echo It is limited by the cmd 32-Bit signed integer
exit /B 1