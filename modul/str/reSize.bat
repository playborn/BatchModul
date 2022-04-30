
:: --DOC--
:: this function can generate max 4096 spaces. 
:: example: you can expand a empty string to 4096 chars
:: 		a string "Hallo" can be expandet to 5001 chars. because only 4096 space chars have to be build.


:: --changelog
:: 30.04.22 + added LEFT RIGHT CENTER PADDING, control via "STRCTR.padd <center|right|left>" default is left
:: 30.04.22 alpha v0.1

:resize2 "str" "SizeINT" "SPACE CHAR"
set "return="
setlocal EnableDelayedExpansion
:::DEPENDENCIE "str\len":::
set "strLenEngine=%~dp0\len.bat"
if not exist "!strLenEngine!" exit /B 1

((set^ "str=%~1") || exit /b 5)
rem replace TAB to 4x SPACE
if defined str ((set^ "str=!str:	=    !") || exit /b 5)
if "%~2"=="" (goto usage) else (set /a "wantedSize=%~2" || exit /b 4)
if "%~3"=="" (set "ph= ") else (set "ph=%~3" || exit /b 5)
set "space="

::CONFIG
rem left,right,center
if not defined STRCTR.padd (set STRCTR.padd=left)


call "!strLenEngine!" "!str!"
set /a "currentSize=!return!" || exit /b 4

set /a "diffSize=!wantedSize!-!currentSize!" || exit /b 4

rem if diffSize is GTR 0 generate space

if !diffSize! GTR 0 (
	set "space=!ph!"
	for %%i in (2 4 8 16 32 64 128 256 512 1024 2048 4096) do (
		((set^ "space=!space!!space!") || exit /b 5)
		set /a "probe=!diffSize!-%%i"
		if !probe! LEQ 0 (
			((set^ "space=!space:~0,%diffSize%!") || exit /b 5)
			goto done
		)
	)
	rem if loop is done the space cant be doubled and the program will fail
	rem the space generation is limited to 4096 because one more loop to 8192 is to big for batch
	rem error is defined as 5 cant handle string
	exit /b 5
)
:done
set /a "remainder=%diffSize% %% 2"
set /a "half=%diffSize%/2+%remainder"
if defined str ((set^ "str=!str:~0,%wantedSize%!") || exit /b 5)


if "%STRCTR.padd%"=="left" (
	((set^ "Str=!str!!space!") || exit /b 5)
)
if "%STRCTR.padd%"=="right" (
	
	((set^ "Str=!space!!str!") || exit /b 5)
)
if "%STRCTR.padd%"=="center" (
	
	if defined space ((set^ "Str=!space:~0,%half%!!str!!space:~%half%,%diffSize%!") || exit /b 5)
)

endlocal & (
	((set^ "return=%Str%") || exit /b 5)
)
exit /b 0