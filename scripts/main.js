import conditions from './data/conditions.json' assert {type: 'json'};

window.onload = init;

function init() {
    console.log("Starting script initialisation...");
    loadConditionsFromDataFile();
}

async function loadDataFile(datafile) {
    console.log("Requesting data: " + datafile)
    request = new Request(datafile);
    response = await fetch(request);
    return await response.json();
}

function loadConditionsFromDataFile() {
    //datafile = "./data/conditions.json";
    //data = loadDataFile(datafile);

    condList = document.querySelector("#conditions");
    template = document.querySelector("#conditions_template")
    console.log(conditions);
}