#!/bin/bash

# Start our daemons
gunicorn app:app --bind unix:/tmp/gunicorn_flask.sock -w 4 -D
/usr/sbin/nginx

# Gunicorn/Flask running on port 5000, instead of a socket
#gunicorn -w 4 -b :5000 app:app -D

# Start the bash shell, so the image stays alive and we can access it later
/bin/bash
