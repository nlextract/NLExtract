var STATUS_MAPPING = {
    "-1": "onbekend proces",
    "0": "proces beëindigd",
    ">": "proces loopt"}
var UNKNOWN_STATUS = "onbekende status";

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

function getLatest() {
    var callback = function(response) {
        document.getElementById("latest").innerText = response;
        getStatus(response);
        getLog(response);
    }
    ajax("GET", "/latest", callback);
}

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

function getLog(guid) {
    var callback = function(response) {
        document.getElementById("log").innerText = response;
    }
    ajax("GET", "/log/" + guid, callback);
}

function reloadLog() {
    getLog(document.getElementById("latest").innerText);
}

function cleanDatabase() {
    var callback = function(response) {
        location.reload();
    }
    ajax("POST", "/clean", callback);
}

function loadExtract() {
    var callback = function(response) {
        location.reload();
    }
    var fileName = document.getElementById("fileToLoad").value;
    ajax("POST", "/load/" + fileName, callback);
}
