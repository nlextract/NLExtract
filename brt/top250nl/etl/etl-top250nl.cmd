:: ETL voor TOP250NL GML met gebruik Stetl.
::
:: Dit is een front-end/wrapper batch-script om uiteindelijk Stetl met een configuratie
:: (etl-top250nl-v1.2.1.cfg) en parameters (options\myoptions.args) aan te roepen. Dit script is
:: gebaseerd op het shell-script ../../../brk/etl-brk.sh.
::
:: Author: Frank Steggink
@echo off

setlocal

:: Gebruik Stetl meegeleverd met NLExtract (kan in theorie ook Stetl via pip install stetl zijn)
if "%STETL_HOME%"=="" (
    set STETL_HOME=../../../externals/stetl
)

:: Nodig voor imports
if "%PYTHONPATH%"=="" (
    set PYTHONPATH=%STETL_HOME%
) else (
    set PYTHONPATH=%STETL_HOME%;%PYTHONPATH%
)

:: Default argumenten/opties
set options_file=options\default.args

:: Overrule eventueel het default optiebestand door het gebruik van een host-gebaseerd optiebestand
:: options\<hostnaam>.args. 
if exist options\%COMPUTERNAME%.args set options_file=options\%COMPUTERNAME%.args

:: Evt via commandline overrulen: etl-top250nl.cmd <mijn optiebestand>
if not "%~1"=="" set options_file=%1

:: Uiteindelijke commando. Kan ook gewoon "stetl -c conf\etl-top250nl-v1.2.1.cfg -a ..." worden indien Stetl installed
python %STETL_HOME%\stetl\main.py -c conf\etl-top250nl-v1.2.1.cfg -a %options_file%

endlocal
