:len <string>
set "return="
(   
    setlocal EnableDelayedExpansion
    (set^ "str=%~1" || exit /b 5)
    if defined str (
        set /a "len=1"
        for %%i in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
            if "!str:~%%i,1!" NEQ "" ( 
                set /a "len+=%%i"
                (set^ "str=!str:~%%i!" || exit /b 5)
            )
        )
    ) ELSE (
        set /a "len=0"
    )
)
( 
    endlocal
    set /a "return=%len%"
    exit /b 0
)


:: -DOC-
:: returns the count of chars of a string

::CHANGELOG
:: v0.1