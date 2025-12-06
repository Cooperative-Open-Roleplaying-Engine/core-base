window.onload = init;

function init() {
    console.log("Starting script initialisation...");
    loadConditionsFromDataFile();
    loadOriginsFromDataFile();
    loadOccupationsFromDataFile();
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
    //datafile = "./data/origins.json";
    datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/origins.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    container = document.querySelector("#charopts_origins");
    template = document.querySelector("#origins_template");
    data.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("h4").textContent = item.name;
        clone.querySelector("p.description").textContent = item.description;
        clone.querySelector("p.size").textContent = item.size;
        clone.querySelector("p.speed").textContent = item.speed;

        const skills = clone.querySelector("ul.skills")
        item.skills.forEach(skill => {
            const element = document.createElement("li");
            element.textContent = skill;
            skills.appendChild(element);
        })

        const o_abilities = clone.querySelector("ul.o_abilities")
        item.abilities.common.forEach(ability => {
            const element = document.createElement("li");
            element.textContent = ability;
            o_abilities.appendChild(element);
        })

        const u_abilities = clone.querySelector("ul.u_abilities")
        item.abilities.unique.forEach(ability => {
            const element = document.createElement("li");
            element.textContent = ability.name;
            u_abilities.appendChild(element);
        })
        if (item.abilities.unique) populateAbilitiesFromTemplate(item.abilities.unique, clone);

        container.appendChild(clone);
    });
}

function populateAbilitiesFromTemplate(abilities, container) {
    template = document.querySelector("#ability_template");
    abilities.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("th.name").textContent = item.name;
        clone.querySelector("th.cost").textContent = item.cost;
        clone.querySelector("tr.multiple td").textContent = item.multiple;
        clone.querySelector("tr.requires td").textContent = item.requires;
        clone.querySelector("tr.incompatibility td").textContent = item.incompatibility;
        clone.querySelector("tr.description td").textContent = item.description;

        container.appendChild(clone);
    });
}

async function loadOccupationsFromDataFile() {
    //datafile = "./data/conditions.json";
    datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/occupations.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    container = document.querySelector("#conditions");
    template = document.querySelector("#conditions_template");
    data.forEach(item => {
        const category = document.createElement("h4")
        category.textContent = item.name;
        container.appendChild(category)
        const description = document.createElement("p")
        description.textContent = item.description;
        container.appendChild(category);
        item.occupations.forEach(item => {
            const clone = document.importNode(template.content, true);
            clone.querySelector("dt").textContent = item.name;
            clone.querySelector("dd").textContent = item.description;
            container.appendChild(clone);
        })
    });
}


