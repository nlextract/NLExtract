:: Auteur: Just van den Broecke
:: Test script

:: Geport door Frank Steggink naar Windows CMD

set TOP10NL_HOME=%~dp0..

set TOP10NL_BIN=%TOP10NL_HOME%\bin
set TOP10NL_TEST_DATA=%TOP10NL_HOME%\test\data
set TOP10NL_TEST_TMP=%TOP10NL_HOME%\test\tmp

:: Temp dir voor gesplitste GML files and .gfs bestanden
rmdir /s /q %TOP10NL_TEST_TMP%
mkdir %TOP10NL_TEST_TMP%

python %TOP10NL_BIN%\top10-extract.py %TOP10NL_TEST_DATA%\test.gml --dir %TOP10NL_TEST_TMP%
