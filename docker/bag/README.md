# Dockerfile BAG-extract
In deze Dockerfile wordt een image samengesteld voor BAG-extract. Op deze manier kan BAG-extract eenvoudig in iedere omgeving worden gedeployed. De BAG-extract commando's kunnen worden aangestuurd via de microservice die in de Docker-image wordt meegeleverd.

**Dit is een work-in-progress.** Pull-requests zijn van harte welkom! Wanneer de tijd rijp is, zal op Dockerhub de image worden gepost.

## Architectuur
De basis bestaat uit een Python 2.7-image, momenteel gebaseerd op Debian Jessie. Hierop zijn BAG-extract, [Flask](http://flask.pocoo.org/) (microservice framework) en [Gunicorn](http://gunicorn.org/) gedeployed. Met Flask wordt BAG-extract aangestuurd. Gunicorn wordt via de HTTP-server [nginx](http://nginx.org/) ontsloten. Er wordt van uitgegaan dat de Postgres-database op een andere machine (of image) wordt gehost. Zorg ervoor dat deze benaderbaar is vanuit de BAG-extract image.

Achtergrondinformatie:
* http://stackoverflow.com/questions/20766684/what-benefit-is-added-by-using-gunicorn-nginx-flask
* http://serverfault.com/questions/220046/why-is-setting-nginx-as-a-reverse-proxy-a-good-idea

## Prerequisites
Je moet Docker draaiend hebben. Als je Windows met Docker Toolbox gebruikt, moet je al een Linux VM hebben aangemaakt m.b.v. docker-machine. Zie de Docker-website voor meer informatie.

## Bestanden delen
In de Docker-image wordt een volume /data toegevoegd, waarmee bestanden uitgewisseld kunnen worden.

### Linux
Hier hoef je, als het goed is, geen speciale dingen te doen. Bij het uitvoeren van je image kun je d.m.v. ```-v <lokaal pad>:<container pad>``` een schijf delen.

### Windows
Op Windows is het delen van bestanden met een Linux-container lastig. Hoe je bestanden kunt delen, hangt ervan af of je Docker Toolbox of Docker for Windows gebruikt.

#### Docker Toolbox
Oracle VM VirtualBox Manager -> machine -> Instellingen -> Gedeelde mappen: voeg een nieuwe gedeelde map toe.  
Deze methode werkt niet. De gedeelde map wordt niet herkend. De gedeelde map, C:\Users, wordt wel herkend en ook kunnen de bestanden hierin worden bekeken.

#### Docker for Windows
Klik met de rechter muisknop op het Docker-icoon in de taakbalk. Kies Settings en daarna Shared Drives. Deze methode is niet door ons getest.

## Configuratie
Pas de instellingen in extract.conf aan. Deze wordt tijdens het bouwen van de image hierin gekopieerd. Als je PostgreSQL op de host draait, is, als je VirtualBox (Docker Toolbox op Windows of Mac) gebruikt, standaard 10.0.2.2.

# Docker-image
## Image bouwen
Voer het volgende commando uit:  
```docker build --rm -t bagextract:0.1 .```

## Image uitvoeren
Voer het volgende commando uit:  
```docker run -d -ti --name bagextract -p 80:80 bagextract:0.1```

Let op: hiermee wordt nog geen volume gemount!

### Volume mounten
Op Windows werkt het mounten van een volume in Docker niet heel goed. c:\Users is beschikbaar. Het beste wat je kunt doen is om in je profiel een map `bagdata` te maken, deze te vullen en deze als volgt mee te geven als volume bij het starten van je Docker-image.  
```docker run -d -ti --name bagextract -p 80:80 -v //c/Users/<username>/bagdata:/data bagextract:0.1```

Wanneer je attacht (`docker attach bagextract`), dan zie je met `ls /data` de inhoud van je bagdata-map.

## Image stoppen
Voer de volgende commando's uit:  
* `docker stop bagextract`
* `docker rm bagextract`

of `docker rm -f bagextract` (verwijderen met geforceerde stop).

# Aansturing BAG-extract
De Flask-applicatie is een work-in-progress. Meer informatie volgt later.  
De webapplicatie is benaderbaar op IP-adres op poort 80. Gebruik op Windows het commando `docker-machine ip` om het IP-adres te achterhalen. Als je in je browser naar http://\<ip-adres> gaat, dan krijg je de statuspagina van de BAG-extract webservice te zien.

## Statuspagina
Endpoint: geen (`http://<host>/`), static (`http://<host>/static`)  
Hiermee wordt de statuspagina van de Docker-image met BAG-extract opgevraagd. Hierop is de status en logging te zien van het proces dat draait of als laatste heeft gedraaid. Een proces wordt aangeduid met een GUID. Als een proces draait, is de status "running". Als het proces afgelopen is, is de status "proces beëindigd". De logging kan worden ververst. Tevens kan het aantal te tonen regels (standaard 10) worden aangepast.

Onder de logging zijn twee knoppen te zien:
* Initialiseer database: hiermee kan de BAG-database opnieuw worden geïnitialiseerd.
* Laad data: hiermee kan een ZIP-bestand in de BAG-database worden geladen.

## Initialiseren database
Endpoint: clean [POST] (`http://<host>/clean`)  
Hiermee kan de BAG-database worden geïnitialiseerd. Het BAG-schema wordt leeggemaakt en de tabellen worden opnieuw aangemaakt. Dit endpoint geef een GUID terug, waarmee meer informatie over het proces opgevraagd kan worden.

## Laden extract (volledig of mutatie)
Endpoint: load [POST] (`http://<host>/load/<filename>`)  
Hiermee kan een ZIP-bestand in de BAG-database worden geladen. Het ZIP-bestand dient van te voren al in de directory worden gezet die als `/data`-directory is gemount binnen de Docker-image. Ook dit endpoint geeft een GUID terug t.b.v. monitoring.

## Ophalen GUID laatste proces
Endpoint: latest [GET] (`http://<host>/latest`)  
Hiermee kan de GUID worden opgevraagd behorende bij het laatst uitgevoerde proces.

## Voortgang volgen
Endpoint: status [GET] (`http://<host>/status/<guid>`)  
Hiermee kan de status worden opgevraagd van het proces dat wordt aangegeven met de GUID. Er wordt of een status-string meegegeven (een van de constanten van psutil.Process, zoals STATUS_RUNNING), of 0 als het proces al beëindigd is, of -1 als het proces onbekend is.

## Logging bekijken
Endpoint: log [GET] (`http://<host>/log/<guid>`, `http://<host>/log/<guid>/<numlines>`)  
Hiermee wordt een logbestand opgevraagd dat wordt aangegeven met de GUID. Standaard worden de laatste 10 regels meegegeven. Door een negatieve waarde voor `numlines` mee te geven, kan het hele bestand worden opgevraagd.

## Alle logbestanden bekijken
Endpoint: static/logs (`http://<host>/static/logs`)  
Hiermee wordt de directory met logbestanden getoond, die als statische bestanden worden aangeboden.
