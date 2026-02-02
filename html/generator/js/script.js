let dotMap = {
    spawns:[]
}
function displayCode(){
    document.getElementById("result").innerHTML = "let dotMap = { spawns:"+JSON.stringify(dotMap.spawns)+"}";
}
document.getElementById("add").addEventListener("click", () => {
    
let coords = document.getElementById("coords").value;

coords = coords.split(",");

let x = coords[0].trim();
let y = coords[1].trim();

let name = document.getElementById("name").value;
let pin = document.getElementById("pin").value;
let pinSel = document.getElementById("pinSelected").value;
let image = document.getElementById("imageName").value;
let desc = document.getElementById("desc").value;

let spawn = {
    name: name,
    x: parseInt(y)*-1,
    y: parseInt(x)*-1,
    icon:pin,
    iconSelected:pinSel,
    image:"images/"+image,
    description:desc
}

dotMap.spawns.push(spawn);

displayCode();
})