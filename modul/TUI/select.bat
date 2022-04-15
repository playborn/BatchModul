:: v 0.2 15.04.2022
:: %1 = STR A Path to a file
:: %2 = INT Selectable items per Page
:: %3 = STR a short INFO TEXT will be prompted under the Naviagtion // OPTIONAL
:: %4 = INT pre selected // OPTIONAL preConfig is 1
:: ----RESERVED RETURN VARS---
::	%value%  --> if user select a choice, value contain a string copy of the choice
::  %index%  --> if user select a choice, index contain a INTEGER of the index of the selected line
::  %return% --> NULL


:: CHANGELOG
:: 15.04.22  	+TAB wird zum Anziegen durch 4x SPACE ersetzt. Der RETURN Value bleibt original
::				+Neue Expand option, erlaubt die selectierte zeile aufzuklappen. Zeile wird nicht mehr gekürtzt dargestellt
::				+Neue GOTO function, erlaubt die eingabe der Zeilennummer.
::              +ERRORLEVEL genormt
::				+MODUL hat jetzt mehrere rückgabewerte, Errorlevel reserviert für fehlercode, %value% reserviert für "zeileninhalt", %index% reserviert für index der Zeile, %return% reserviert NULL
::				+Die Anzeige passt sich alle 2 sekunden der Fenster breite an
				
:: 03.12.21  	+Performance,die Datei wird nur sequenziell gelesen, einmal gelesene inhalte werden nicht erneut geladen.
::					-wirkt sich besonders positiv bei großen dateien aus.
::				-Anzeige der Maximalen auswahlmöglichkeiten entfernt

:gui.list.select "PATHlistFile" "INTitemsPerPage" "infoText" "preSelect"
@echo off
rem this Values will be returned
set "return="
set "index="
set "value="
setlocal ENABLEDELAYEDEXPANSION ENABLEEXTENSIONS

if exist "%~1" (set "file=%~1") else (goto usage)
if "%~2"=="" (goto usage) else (set /a "PageSize=%~2-1" || exit /b 4)
if "%~3"=="" (set "infoText=" || exit /b 5) else (set "infoText=%~3" || exit /b 5)
if "%~4"=="" (set /a "selectID=1") else (set /a "selectID=%~4" || exit /b 4)
rem probe if user preselect will work if not use 1 as preselect
if !selectID! NEQ 1 call :readLine "%file%" "%selectID%" || set /a "selectID=1"

rem initial start end calculation
set /a "startID=!selectID!" || exit /b 4
set /a "endID=!selectID!+%PageSize%" || exit /b 4

rem EOF is -1 because the end of file is unknow
set /a "EOF=-1"

rem MENU KEYS
set "upKey=w"
set "downKey=s"
set "pageUpKey=d"
set "pageDownKey=a"
set "selectKey=e"
set "abortKey=q"
set "gotoKey=k"
set "refreshKey=m"
set "expandKey=x"
rem true or false shows the navigation help
set "quickHelp=true"
rem true or false if true selected line is expandet to full length, if false line is cut like unselected 
set "unfoldSelected=false"


set "placeholderChar= "
set "PH="
set "space="
set "bar="

rem Find a name for themporary screen file
set "maxTrys=20"
set "trys=0"
:screenFile
set /a "trys+=1" || exit /b 4
set "screenFile=%tmp%\screen!random!.txt"
if %trys% GTR %maxTrys% exit /b 2
if exist "%screenFile%" goto screenFile


rem clean list. vars if ther is any
echo Initialising...
>NUL 2>&1 (
for /F "usebackq delims==" %%a in (`set list.`) do (
	set "%%a="
)
)

:gui.list.select.draw
rem wenn das ende der datei bekannt ist setze den pointer auf 1 wenn pointer überläuft
if not "%EOF%"=="-1" if !selectID! GTR !EOF! set /a "selectID=1"
rem wenn der pointer kleiner 1 ist und das ende der datei bekannt ist setze den pointer auf letzte zeile der datei sonst auf 1
IF !selectID! LSS 1 if %EOF% LEQ 0 (set /a "selectID=1") else (set /a "selectID=%EOF%" || exit /b 4)



if !selectID! GTR !endID! (
	set /a "startID=!selectID!-%PageSize%" || exit /b 4
	set /a "endID=!selectID!" || exit /B 4
)
if !selectID! LSS !startID! (
	set /a "startID=!selectID!" || exit /b 4
	set /a "endID=!selectID!+%PageSize%" || exit /b 4
)



FOR /L %%i in (%startID%,1,%endID%) do (
		rem diese if verhindert ständiges neu laden.
		if not defined list.%%i (
			call :readLine "%file%" %%i
			rem errlvl 6 = end of file
			if !errorlevel! EQU 6 (
				
				if "!EOF!"=="-1" set /a "EOF=%%i-1" || exit /b 4
			)
			rem hold one list with original for return
			set list.%%i.unchanged=!return!"
			rem exchange TAB to 4xSPACE to ensure strLen works correct for printing
			set "list.%%i=!return:	=    !" || exit /b 5
		)

)

:reDraw
call :strlen "!endID!"
if "!return!"=="!prefixLen!" (
	rem nothing
) else (
	set "PH="
	set /a "prefixLen=!return!" || exit /b 4
	for /L %%i in (1,1,!prefixLen!) do (
		set "PH=!PH!!placeholderChar!" || exit /b 5
	)
)

call :getScreenRes
if "!with!"=="!maxWith!" (
	rem nothing
) else (
	echo ^[Resizing Screen...^]
	set "space="
	set "bar="
	set /a "maxWith=!with!" || exit /b 4
	for /L %%i in (1,1,!maxWith!) do (
		set "space=!space! " || exit /b 5
		set "bar=!bar!_" || exit /b 5
	)
)


>"%screenFile%" (
FOR /L %%i in (%startID%,1,%endID%) do (
		set "print="
		if %%i EQU %selectID% (
			rem selected
			set "selectIDvalue=!list.%selectID%!" || exit /b 5
			set "print=%%i%PH%" || exit /B 5
			if "!unfoldSelected!"=="true" (
				rem use the whole line for print
				set "print=!print:~0,%prefixLen%!" || exit /B 5
				set "print=^>!print! ^| !list.%%i!" || exit /B 5
			) else (
				set "print=!print:~0,%prefixLen%!" || exit /B 5
				set "print=^>!print! ^| !list.%%i!!space!" || exit /B 5
				rem cut the line by screensize
				set "print=!print:~0,%maxWith%!" || exit /B 5
			)	
			
		) else (
			rem no select
			set "print=%%i%PH%" || exit /B 5
			set "print=!print:~0,%prefixLen%!" || exit /B 5
			set "print= !print! ^| !list.%%i!!space!" || exit /B 5
			rem cut the line by screenSize
			set "print=!print:~0,%maxWith%!" || exit /B 5
			
		)
		
		if !selectID! EQU %%i if %%i NEQ !startID! (
			call :strlen "!print!"
			if !return! GTR !maxWith! echo !bar!
		)
	
		echo !print!

		
		if !selectID! EQU %%i if %%i NEQ !endID! (
			call :strlen "!print!"
			if !return! GTR !maxWith! echo !bar!
		)
)
)
cls
echo %bar%
type "%screenFile%" || exit /b 2


echo %bar%
if "%quickHelp%"=="true" echo.^[ %upKey%=up %downKey%=down %pageUpKey%=pageUp %pageDownKey%=pageDown %abortKey%=abbruch %selectKey%=auswahl %gotoKey%=GOTO %expandKey%=expand^]
if defined infoText echo ^[ %infoText% ^]
choice /c %UpKey%%downKey%%pageUpKey%%pageDownKey%%selectKey%%abortKey%%gotoKey%%refreshKey%%expandKey% /d %refreshKey% /t 2 >NUL
set menu=%errorlevel%
if %menu% EQU 1 (
	rem UP
	set /a "selectID-=1" || exit /b 4
)
if %menu% EQU 2 (
	rem DOWN
	set /a "selectID+=1" || exit /b 4
)
if %menu% EQU 3 (
	rem PAGEUP
	set /a "selectID+=%PageSize%" || exit /b 4
)
if %menu% EQU 4 (
	rem PAGEDOWN
	set /a "selectID-=%PageSize%" || exit /b 4
)
if %menu% EQU 5 (
	rem select
	rem wenn EOF=0 die datei ist leer. es kann nichts selectiert werden.
	if "%EOF%"=="0" (
		set "selectID="
		set "selectIDvalue="
	)
	goto quit
)
if %menu% EQU 6 (
	rem ABORT
	rem unset selected values
	set "selectIDvalue="
	set "selectID="
	goto quit
)
if %menu% EQU 7 (
	rem GOTOKEY
	set /p "gotoID=GOTO:"
	rem probe if user input will work
	call :readLine "%file%" "!gotoID!"
	if !errorlevel! EQU 0 (
		set /a "selectID=!gotoID!"
	)
)
if %menu% EQU 8 (
	rem AutoRefresh for rebuild screen if size was changed
	goto reDraw
)
if %menu% EQU 9 (
	rem EXPAND KEY
	if "%unfoldSelected%"=="true" (set unfoldSelected=false) else (set unfoldSelected=true)
)
echo ^[loading...^]
goto gui.list.select.draw


:quit
if exist "%screenFile%" del "%screenFile%"
set "index=%selectID%"
set "value=!list.%selectID%.unchanged!"
endlocal & (
	set "index=%index%" || exit /b 5
	set "value=%value%" || exit /b 5
	rem set "return=%selectIDvalue%" || exit /b 5
	exit /b 0
)





:readLine "File" "lineNumber"
set "return="
setlocal
if "%~1"=="" (goto usage) else (set "file=%~1" || exit /b 5)
if "%~2"=="" (goto usage) else (set /a "line=%~2-1" || exit /b 4)
if not exist "%file%" exit /b 2
if %line% LSS 0 exit /b 1
if %line% GTR 0 (set "skip=skip^=%line%^ ") else (set "skip=")
For /f usebackq^ %skip%tokens^=*^ delims^=^ eol^= %%a in ("%file%") do (
	endlocal & (
		set "return=%%a" || exit /b 5
	)
	exit /b 0
)
exit /b 6

:count_lines "file"
set return=
setlocal
set "cmd=findstr /R /N "^^" "%~1" ^| find /C ":""

for /f "usebackq delims=" %%a in (`%cmd%`) do set number=%%a
endlocal & set return=%number%
exit /b 0

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



:getScreenRes
set cnt=0
for /F "usebackq skip=3 tokens=2 delims=: " %%a in (`mode CON`) do (
	set /a cnt+=1
	if !cnt! EQU 1 set "rows=%%a"
	if !cnt! EQU 2 set "cols=%%a"
)
endlocal & (
	set with=%cols%
	set high=%rows%
)
exit /b 0

:usage
echo HELP TEXT
exit /b 1








