@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo U moet een doeldirectory opgeven.
    echo Aanroep: %~nx0 ^<doeldir^>
    goto :eof
)


:: Download
set doel_dir=%1

:: Download URL
set download_url="https://api.pdok.nl/kadaster/kadastralekaart/download/v5_0/full/predefined/kadastralekaart-gml-nl-nohist.zip"
set target_file="%doel_dir%\dkk-gml-nl-nohist.zip"

:download_inner
:: Haal bestand op
echo Downloading BRK-DKK van %download_url% naar %target_file% ...
del /f "%target_file%" >nul 2>&1
wget -O "%target_file%" --no-check-certificate %download_url%

:: Controleer of het ZIP-bestand geopend kan worden
unzip -l %target_file%
if errorlevel 1 goto download_inner

:: Het downloaden is gereed
echo Klaar, bestanden in %doel_dir%!

endlocal
