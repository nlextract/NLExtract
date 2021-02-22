# CBS Gemeentelijke Indeling

Bron: https://www.cbs.nl/nl-nl/onze-diensten/methoden/classificaties/overig/gemeentelijke-indelingen-per-jaar

Per jaar is er een CSV met de Gemeente/Provincie indeling voor dat jaar.

De CSV wordt aangemaakt door het Excel (.xlsx) bestand bij CBS te downloaden en
deze om te zetten naar CSV voor dat jaar. Bijvoorbeeld 2021.csv.

In de ETL is een Chain (met Stetl) om een jaar naar de Postgres tabel `provincie_gemeente`
om te zetten. De Woonplaats-Gemeente koppeling zit al in de BAG.
