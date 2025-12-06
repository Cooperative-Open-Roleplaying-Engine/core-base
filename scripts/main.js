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

    conditions = document.querySelector("#conditions");
    template = document.querySelector("#conditions_template")
    data.forEach(condition => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("dt").textContent = condition.name;
        clone.querySelector("dd").textContent = condition.description;
        conditions.appendChild(clone);
    });
}