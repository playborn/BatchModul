:isFile "File"
set "return="
setlocal
if "%~1"=="" goto usage
if not exist "%~1" exit /B 2
set "isFile="
set "fileAttributes=%~a1"
if /i "%fileAttributes:~0,1%"=="d" (
	set "isFile=false"
) else (
	set "isFile=true"
)
endlocal & (
	set "return=%isFile%"
)
exit /B 0