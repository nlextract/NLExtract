import os, psutil, signal, sqlite3, subprocess, traceback, uuid
from subprocess import Popen

from flask import Flask, redirect, abort
app = Flask(__name__)

DBNAME = 'process.db'
CURDIR = os.path.dirname(os.path.abspath(__file__))

# Redirects to the status page
@app.route("/")
def root():
    return redirect("static", code=301)

# Cleans the BAG database, because a new full extract will be loaded
@app.route("/clean", methods=['POST'])
def clean():
    try:
        cmd = "python /opt/nlextract/bag/src/bagextract.py -cj"
        guid = start_subprocess(cmd);
        return guid
    except:
        tb = traceback.format_exc()
        return tb

# Loads a BAG extract into the database
@app.route("/load/<filename>", methods=['POST'])
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
# Returns: status string (STATUS_RUNNING, etc), 0 (finished) or -1 (doesn't exist)
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
        status = psutil.Process(int(pid)).status()
        return str(status)
    except psutil.NoSuchProcess:
        return "0"
    except:
        tb = traceback.format_exc()
        return tb

# Gets the contents of the last 10 lines of the log file of the queried process
@app.route("/log/<guid>", methods=['GET'])
def log(guid):

    return logLines(guid, 10)

# Gets the last number of lines of the log file of the queried process
@app.route("/log/<guid>/<numlines>", methods=['GET'])
def logLines(guid, numlines):
    # Redirecting to static/logs isn't a good idea, because of Nginx caching. Caching could be
    # turned off, but that defeats the idea of static files

    try:
        numlinesnr = int(numlines)
    except ValueError:
        abort(422)

    logfile = os.path.join(CURDIR, 'static/logs', 'proc_%s.log' % guid)
    if not os.path.exists(logfile):
        abort(404)

    if numlinesnr >= 0:
        cmd = "tail -n %d %s" % (numlinesnr, logfile)
    else:
        cmd = "cat %s" % (logfile)

    data = subprocess.check_output(cmd.split())
    return data

def get_db_conn():
    filename = os.path.join(CURDIR, DBNAME)
    return sqlite3.connect(filename)

def start_subprocess(cmd):
    guid = uuid.uuid4()
    logfile = os.path.join(CURDIR, 'static/logs', 'proc_%s.log' % guid)
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
