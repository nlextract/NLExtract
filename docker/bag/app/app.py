import os, psutil, signal, sqlite3, subprocess, traceback, uuid
from subprocess import Popen

from flask import Flask, redirect
app = Flask(__name__)

DBNAME = 'process.db'

# Returns some text indicating we're up and running
@app.route("/")
def root():
    return "De BAG-extract webservice draait!"

# Cleans the BAG database, because a new full extract will be loaded
# TODO: support POST only
@app.route("/clean", methods=['GET', 'POST'])
def clean():
    try:
        cmd = "python /opt/nlextract/bag/src/bagextract.py -cj"
        guid = start_subprocess(cmd);
        return guid
    except:
        tb = traceback.format_exc()
        return tb

# Loads a BAG extract into the database
# TODO: support POST only
@app.route("/load/<filename>", methods=['GET', 'POST'])
def load(filename):
    try:
        cmd = "python /opt/nlextract/bag/src/bagextract.py -e /data/%s" % filename
        guid = start_subprocess(cmd);
        return guid
    except:
        tb = traceback.format_exc()
        return tb

# Returns the GUID of the latest started BAG extract process
@app.route("/latest", methods=['GET'])
def latest():
    conn = get_db_conn()
    c = conn.cursor()
    c.execute("SELECT guid FROM process WHERE pid=(SELECT MAX(pid) FROM process)")
    result = c.fetchone();
    if result is not None:
        return result[0]

    return "0"

# Returns the status of the running process based on the associated GUID
# Returns: > (running), 0 (finished) or -1 (doesn't exist)
@app.route("/status/<guid>", methods=['GET'])
def status(guid):
    try:
        conn = get_db_conn()
        c = conn.cursor()
        c.execute("SELECT pid FROM process WHERE guid='%s'" % guid)
        result = c.fetchone();
        if result is None:
            return "-1"

        pid = result[0]
        status = psutil.Process(int(pid)).status
        return str(status)
    except psutil.NoSuchProcess:
        return "0"
    except:
        tb = traceback.format_exc()
        return tb

# Redirects to the log file of the queried process
@app.route("/log/<guid>", methods=['GET'])
def log(guid):
    return redirect("static/logs/proc_%s.log" % guid, code=301)

def get_db_conn():
    filename = os.path.join(os.path.dirname(os.path.abspath(__file__)), DBNAME)
    return sqlite3.connect(filename)

def start_subprocess(cmd):
    guid = uuid.uuid4()
    logfile = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static/logs', 'proc_%s.log' % guid)
    log = open(logfile, "w")

    pid = Popen(cmd.split(), stdout=log, stderr=subprocess.STDOUT).pid
    # Force the process to run (all processes in fact)
    signal.signal(signal.SIGCHLD, signal.SIG_IGN)

    conn = get_db_conn()
    c = conn.cursor()
    c.execute("INSERT INTO process VALUES ('%s', %d)" % (guid, pid))
    conn.commit()

    return str(guid)

if __name__ == "__main__":
    app.run()
