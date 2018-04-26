### Instalation

* install stetl + dependencies
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