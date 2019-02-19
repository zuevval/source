window.addEventListener("load", main, false);

function main () {
	var color = "default";
	var c = "#ff0000";
	ctx = canvas1.getContext("2d");
	ctx.beginPath();
	ctx.fillStyle = "#000000";
	ctx.fillRect(10, 10, 100, 100);
	ctx.closePath();
	button2.onclick = function() {
		text1.value = null;
	}
	button1.onclick = function() {
		color = text1.value;
		console.log(color);
		ctx.beginPath();
		switch (color) {
			case "orange": c = "#ff4700";
			break;
			case "yellow": c = "#ffff00";
			break;
			case "cyan": c = "#00ffea";
			break;
			case "blue": c = "#0033ff";
			break;
			case "red": c = "#ff0000";
			break;
			case "black": c = "#000000";
			break;
			case "green": c = "#0aff00";
			break;
			case "pink": c = "#ff00cb";
			break;
			case "violet": c = "#4902ff";
			break;
			default: c = "#ffffff";
		}
		ctx.fillStyle = c;
		console.log(ctx.fillStyle);
		ctx.fillRect(10, 10, 100, 100);
		ctx.strokeRect(10, 10, 100, 100);
		ctx.closePath();
	}
	
}