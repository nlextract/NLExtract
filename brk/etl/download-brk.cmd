@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo U moet een doeldirectory opgeven.
    echo Aanroep: %~nx0 ^<doeldir^>
    goto :eof
)

:: Download gegevens: dataset IDs en 12 provincies
:: Zie https://www.pdok.nl/nl/producten/pdok-downloads/basis-registratie-kadaster/kadastrale-kaart
set base_url=https://geodatastore.pdok.nl/id/dataset

:: Datasets als tuples: datasetID en provincie naam
set datasets=ab1e23c5-cbf3-4da8-a993-9ce088cc70ed,Flevoland ^
58830183-c66d-41e7-aeb8-84ca33fe118a,Drenthe ^
55e7376d-d8a0-4f82-96a1-386782984cb3,Friesland ^
d731c350-9378-4044-ab94-b89a97f79bec,Gelderland ^
dccf8230-bd36-4515-975d-b7b0d496cce8,Groningen ^
71e39f29-7968-40e4-8792-8de5c9997256,Limburg ^
d434165b-7441-4263-b4da-9e58e8d036e4,Noord-Brabant ^
e0fa4cbb-3fb4-4e2f-a004-f86bdebb5837,Noord-Holland ^
fdd0fa6f-be66-4b87-81b5-d67700029702,Overijssel ^
f5554f62-4423-49bf-8987-d01ea0bda0ca,Utrecht ^
b1f9fd73-7050-4af1-a48e-85fbd06e17f2,Zeeland ^
131d387d-7222-46f0-a021-63b5b8852124,Zuid-Holland

:: Download
set doel_dir=%1

:: Ga door alle provincie-tuples
:download
for /f "tokens=1,*" %%i in ("%datasets%") do set "var1=%%i" &set "datasets=%%j"
for /f "tokens=1,2 delims=," %%i in ("%var1%") do set "uuid=%%i" &set "provincie=%%j"

set target_file="%doel_dir%\%provincie%.zip"
set target_url="%base_url%/%uuid%"

:download_inner
:: Haal bestand op
echo Downloading %provincie% ...
del /f "%target_file%" >nul 2>&1
wget -O "%target_file%" --no-check-certificate %target_url%

:: Controleer of het ZIP-bestand geopend kan worden
unzip -l %target_file%
if errorlevel 1 goto download_inner

:: Bestand is gedownload, ga door met het volgende bestand
echo Download %provincie% OK!
echo.
if not "%datasets%"=="" goto download

:: Het downloaden is gereed
echo Klaar, bestanden in %doel_dir%!

endlocal
