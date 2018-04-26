# Instalation

### install stetl + dependencies 
install xml2 for python
```
sudo apt install python2.7 libxml2 libxslt1.1 python-lxml
```
install GDAL
```
sudo apt install gdal-bin python-gdal
```
pull the stetl submodule
```
git submodule update --init --recursive 
```


* download data
* modify options/default.args to fit your needs
* run ./nlextract.sh -p brt/top10nl -d data/top10

### Structuur

```
<basisregistratie>/[subset]/doc/
<basisregistratie>/[subset]/style/
<basisregistratie>/[subset]/etl/

per project:
etl/conf/default.cfg
etl/data/
etl/gfs/
etl/meta/
etl/sql/
etl/test/
```