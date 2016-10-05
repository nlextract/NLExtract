# Docker file BAG-extract
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
```docker stop bagextract```
```docker rm bagextract```
of
```docker rm -f bagextract```

# Aansturing BAG-extract
De Flask-applicatie is een work-in-progress. Meer informatie volgt later.
De webapplicatie is benaderbaar op IP-adres op poort 80. Gebruik op Windows het commando `docker-machine ip` om het IP-adres te achterhalen. Als je in je browser naar http://<ip-adres> gaat, dien je de tekst `De BAG-extract webservice draait!` te zien.

## Statuspagina
Endpoint: geen, static

## Herinitialiseren database
Endpoint: clean [POST]

## Laden extract (volledig of mutatie)
Endpoint: load [POST]

## Ophalen GUID laatste proces
Endpoint: latest [GET]

## Voortgang volgen
Endpoint: status [GET]

## Logging bekijken
Endpoint: log [GET]
