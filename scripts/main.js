window.onload = init;

function init() {
    console.log("Starting script initialisation...");
    loadConditionsFromDataFile();
}

async function loadDataFile(datafile) {
    console.log("Requesting data file: " + datafile)
    const request = new Request(datafile);
    const response = await fetch(request);
    return await response.json();
}

async function loadConditionsFromDataFile() {
    //datafile = "./data/conditions.json";
    datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/conditions.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    container = document.querySelector("#conditions");
    template = document.querySelector("#conditions_template");
    data.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("dt").textContent = item.name;
        clone.querySelector("dd").textContent = item.description;
        container.appendChild(clone);
    });
}

async function loadOriginsFromDataFile() {
    //datafile = "./data/conditions.json";
    datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/origins.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    container = document.querySelector("#conditions");
    template = document.querySelector("#conditions_template");
    data.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("h4").textContent = item.name;
        clone.querySelector("p").textContent = item.description;
        container.appendChild(clone);
    });
}


