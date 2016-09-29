import subprocess, traceback

from flask import Flask
app = Flask(__name__)

@app.route("/")
def root():
    return "De BAG-extract webservice draait!"

# TODO: support POST only
@app.route("/clean", methods=['GET', 'POST'])
def clean():
    try:
        cmd = "python /opt/nlextract/bag/src/bagextract.py -cj"
        subprocess.call(cmd.split())
        return "Clean database, commando: %s" % cmd
    except:
        tb = traceback.format_exc()
        return tb        
    
# TODO: support POST only
@app.route("/load/<filename>", methods=['GET', 'POST'])
def load(filename):
    try:
        cmd = "python /opt/nlextract/bag/src/bagextract.py -e /data/%s" % filename
        subprocess.call(cmd.split())
        return "Load data, commando: %s" % cmd
    except:
        tb = traceback.format_exc()
        return tb        

@app.route("/status", methods=['GET'])
def status():
    return "Status not implemented"

@app.route("/log", methods=['GET'])
def log():
    return "Log not implemented"
    
if __name__ == "__main__":
    app.run()
