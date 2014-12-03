rem windows version  UNTESTED, PLEASE IMPROVE!

set gml_files=input

rem multi_opts=-splitlistfields~-maxsubfields 1

rem multi_opts=-splitlistfields

rem multi_opts=-fieldTypeToString~StringList

rem multi_opts=~


set multi="multi_opts=-fieldTypeToString~StringList"

python ..\..\externals\stetl\stetl\main.py -c etl-top10nl.cfg -a "database=top10nl host=127.0.0.1 port=5432 user=top10nl password=top10nl schema=stetltest temp_dir=temp max_features=20 gml_files=%gml_files% %multi%"

