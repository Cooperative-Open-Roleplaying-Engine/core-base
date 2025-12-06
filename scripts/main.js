window.onload = init;

function init() {
    console.log("Starting script initialisation...");
    loadConditionsFromDataFile();
    loadOriginsFromDataFile();
    loadOccupationsFromDataFile();
    loadSkillsFromDataFile();
    loadAbilitiesFromDataFile();
    generateTableOfContent();
}

async function generateTableOfContent() {
    const headers = document.querySelectorAll(":is(h2, h3, h4, h5)");
    const toc = document.querySelector("#toc ul");
    template = document.querySelector("#toc_template");
    headers.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("li").classList.add(item.tagName);
        clone.querySelector("a").textContent = item.childNodes[0].textContent;
        const ref = item.id ? item.id : crypto.randomUUID();
        if (!item.id) { item.id = ref }
        clone.querySelector("a").href = "#" + ref;
        toc.appendChild(clone);
    })
}

async function loadDataFile(datafile) {
    console.log("Requesting data file: " + datafile)
    const request = new Request(datafile);
    const response = await fetch(request);
    return await response.json();
}

async function loadConditionsFromDataFile() {
    //datafile = "./data/conditions.json";
    const datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/conditions.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    const container = document.querySelector("#conditions");
    const template = document.querySelector("#conditions_template");
    data.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("dt").textContent = item.name;
        clone.querySelector("dd").textContent = item.description;
        container.appendChild(clone);
    });
}

async function loadOriginsFromDataFile() {
    //datafile = "./data/origins.json";
    const datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/origins.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    const container = document.querySelector("#charopts_origins");
    const template = document.querySelector("#origins_template");
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
    const template = document.querySelector("#ability_template");
    abilities.sort((a, b) => a.name.localeCompare(b.name));
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
    const datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/occupations.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    const container = document.querySelector("#charopts_occupations");
    const template = document.querySelector("#occupations_categories_template");
    data.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("h4").textContent = item.name;
        clone.querySelector("p").textContent = item.description;
        populateOccupationsFromTemplate(item.occupations, clone);
        container.appendChild(clone);
    })
}


function populateOccupationsFromTemplate(occupations, container) {
    const template = document.querySelector("#occupations_template");
    occupations.sort((a, b) => a.name.localeCompare(b.name));
    occupations.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("h5").textContent = item.name;
        clone.querySelector("p.description").textContent = item.description;
        container.appendChild(clone);
    });
}

async function loadSkillsFromDataFile() {
    //datafile = "./data/conditions.json";
    const datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/skills.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    const container = document.querySelector("#charopts_skills");
    const template = document.querySelector("#skills_categories_template");
    data.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("h4").textContent = item.name;
        clone.querySelector("p").textContent = item.description;
        populateSkillsFromTemplate(item.skills, clone);
        container.appendChild(clone);
    })
}

function populateSkillsFromTemplate(skills, container) {
    const template = document.querySelector("#skills_template");
    skills.sort((a, b) => a.name.localeCompare(b.name));
    skills.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("h5").textContent = item.name;
        const trait = document.createElement("span");
        trait.textContent = item.trait
        clone.querySelector("h5").appendChild(trait)
        clone.querySelector("p.description").textContent = item.description;
        if (item.specialisation) {

        }
        else {
            clone.querySelector("h6").remove();
            clone.querySelector("ul").remove();
        }
        container.appendChild(clone);
    });
}

async function loadAbilitiesFromDataFile() {
    //datafile = "./data/conditions.json";
    const datafile = "https://cooperative-open-roleplaying-engine.github.io/core-base/data/abilities.json"
    const data = await loadDataFile(datafile);

    data.sort((a, b) => a.name.localeCompare(b.name));

    const container = document.querySelector("#charopts_abilities");
    const template = document.querySelector("#abilities_categories_template");
    data.forEach(item => {
        const clone = document.importNode(template.content, true);
        clone.querySelector("h4").textContent = item.name;
        clone.querySelector("p").textContent = item.description;
        populateAbilitiesFromTemplate(item.abilities, clone);
        container.appendChild(clone);
    })
}
