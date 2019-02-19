function main_dl_example_Canvas_2() {

    var ctx = canvas_example_2.getContext("2d");

    // красная линия
    ctx.lineWidth="1";              // ширина линии
    ctx.strokeStyle="#ff0000";      // цвет линии
    ctx.beginPath();
    ctx.moveTo(30, 30);
    ctx.lineTo(180, 30);
    ctx.stroke();

    // синяя линия
    ctx.lineWidth="3";
    ctx.strokeStyle="#0000ff";
    ctx.beginPath();
    ctx.moveTo(30, 60);
    ctx.lineTo(180, 60);
    ctx.stroke();

    // зеленая линия
    ctx.lineWidth="6";
    ctx.strokeStyle="#00ff00";
    ctx.beginPath();
    ctx.moveTo(30, 100);
    ctx.lineTo(180, 100);
    ctx.stroke();

    // фиолетовая линия
    ctx.lineWidth="12";
    ctx.strokeStyle="#990099";
    ctx.beginPath();
    ctx.moveTo(30, 150);
    ctx.lineTo(180, 150);
    ctx.stroke();


    // незакрашенный круг
    ctx.lineWidth="6";
    ctx.strokeStyle="#00ffff";
    ctx.beginPath();
    ctx.arc(240,55,30,0,2*Math.PI);
    ctx.stroke();

    // закрашенный круг
    ctx.fillStyle="#ffff00";            // цвет закраски
    ctx.beginPath();
    ctx.arc(260,135,50,0,2*Math.PI);
    ctx.fill();

    // незакрашенный прямоугольник
    ctx.lineWidth="10";
    ctx.strokeStyle="#888888";
    ctx.strokeRect(400,20,50,50);

    // закрашенный прямоугольник
    ctx.fillStyle="#ff99ff";
    ctx.fillRect(320,100,155,80);

    // незакрашенный многоугольник
    ctx.lineWidth="1";
    ctx.strokeStyle="#ff8888";
    ctx.beginPath();
    ctx.moveTo(500,25);
    ctx.lineTo(580,25);
    ctx.lineTo(500,105);
    ctx.closePath();                // соединяет последнюю точку с начальной
    ctx.stroke();

    // закрашенный многоугольник
    ctx.fillStyle="#8888ff";
    ctx.beginPath();
    ctx.moveTo(590,125);
    ctx.lineTo(590,45);
    ctx.lineTo(510,125);
    ctx.lineTo(510,155);
    ctx.fill();

}