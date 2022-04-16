:: v0.0.2
::--changeLog--
::	+double check expected Attributes.
::  +BUG FIX missing :usage 

:isFile "File"
set "return="
setlocal
if "%~1"=="" goto usage
if not exist "%~1" exit /B 2
set "isFile="
set "fileAttributes=%~a1"

if "%fileAttributes:~0,1%"=="-" (
	set "isFile=true"
) else (
	if /i "%fileAttributes:~0,1%"=="d" (
		set "isFile=false"
	) else (
		exit /b 10
	)
)

endlocal & (
	set "return=%isFile%"
)
exit /B 0



:usage
echo HELP TEXT
exit /b 1