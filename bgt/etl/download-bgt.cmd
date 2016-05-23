@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo U moet een doeldirectory opgeven.
    echo Aanroep: %~nx0 ^<doeldir^>
    goto :eof
)

:: Datum die als enddate dient
for /f "tokens=*" %%a in ('date /t') do for %%b in (%%a) do set today=%%b

:: ID's van 64x64 km gebieden om de BGT te downloaden. Let op, de ID's mogen geen voorloopnullen bevatten
set blocks=9,11,12,13,14,15,18,24,26,27,36,37,39,45,48,49,50,51,56,57

:: Basis URL
set base_url="https://www.pdok.nl/download/service/extract.zip?extractset=citygml^&tiles=%%7B%%22layers%%22%%3A%%5B%%7B%%22aggregateLevel%%22%%3A0%%2C%%22codes%%22%%3A%%5B%%5D%%7D%%2C%%7B%%22aggregateLevel%%22%%3A1%%2C%%22codes%%22%%3A%%5B%%5D%%7D%%2C%%7B%%22aggregateLevel%%22%%3A2%%2C%%22codes%%22%%3A%%5B%%5D%%7D%%2C%%7B%%22aggregateLevel%%22%%3A3%%2C%%22codes%%22%%3A%%5B%%5D%%7D%%2C%%7B%%22aggregateLevel%%22%%3A4%%2C%%22codes%%22%%3A%%5B%%5D%%7D%%2C%%7B%%22aggregateLevel%%22%%3A5%%2C%%22codes%%22%%3A%%5B{block}%%5D%%7D%%5D%%7D^&excludedtypes=plaatsbepalingspunt^&history=true^&enddate=%today%"

:: Download
set doel_dir=%1

:: Ga door alle blokken
:download
for /f "tokens=1,* delims=," %%i in ("%blocks%") do set "block=%%i" &set "blocks=%%j"

set target_file="%doel_dir%\bgt_%block%.zip"
set target_url=%base_url:{block}=!block!%

:download_inner
:: Haal bestand op
echo Downloading blok %block% ...
del /f "%target_file%" >nul 2>&1
wget -O "%target_file%" --no-check-certificate %target_url%

:: Controleer of het ZIP-bestand geopend kan worden
unzip -l %target_file%
if errorlevel 1 goto download_inner

:: Bestand is gedownload, ga door met het volgende bestand
echo Download blok %block% OK!
echo.
if not "%blocks%"=="" goto download

:: Het downloaden is gereed
echo Klaar, bestanden in %doel_dir%!

endlocal
