var STATUS_MAPPING = {
    "-1": "onbekend proces",
    "0": "proces beëindigd"}
var UNKNOWN_STATUS = "onbekende status";

// Executes an AJAX call
function ajax(method, url, callback) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            if (callback) {
                callback(this.responseText);
            }
        }
    };
    xhttp.open(method, url, true);
    xhttp.send();
}

// Gets the GUID of the latest process
function getLatest() {
    var callback = function(response) {
        document.getElementById("latest").innerText = response;
        getStatus(response);
        getLog(response);
    }
    ajax("GET", "/latest", callback);
}

// Gets the status of the given process
function getStatus(guid) {
    var callback = function(response) {
        if (response in STATUS_MAPPING) {
            status = STATUS_MAPPING[response];
        } else {
            status = response;
        }
        document.getElementById("status").innerText = status;
    }
    ajax("GET", "/status/" + guid, callback);
}

// Gets the log file of the given process
function getLog(guid) {
    var callback = function(response) {
        document.getElementById("log").innerText = response;
    }
    var sel = document.getElementById("numlines");
    var numlines = sel.options[sel.selectedIndex].value;
    ajax("GET", "/log/" + guid + "/" + numlines, callback);
}

// Initializes the BAG-extract database
function cleanDatabase() {
    var callback = function(response) {
        location.reload();
    }
    ajax("POST", "/clean", callback);
}

// Loads a new extract in the BAG-extract database
function loadExtract() {
    var callback = function(response) {
        location.reload();
    }
    var fileName = document.getElementById("fileToLoad").value;
    ajax("POST", "/load/" + fileName, callback);
}
