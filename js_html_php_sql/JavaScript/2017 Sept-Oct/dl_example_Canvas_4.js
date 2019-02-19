function main_dl_example_Canvas_4() {

    var ctx = canvas_example_4.getContext("2d");
    var width = canvas_example_4.width;
    var height = canvas_example_4.height;

    ctx.fillStyle="#8888ff";
    var rx = 50, ry = 50;                       // координаты шара
    var vx = 2, vy = 2;                         // скорость шара
    var r = 25;                                 // радиус шара

    function step() {                           // шаг вычислений.
        tick();
        draw();
    }

    function tick() {                           // вычисление новой позиции шара
        if (rx - r < 0 || rx + r > width) vx = -vx;
        if (ry - r < 0 || ry + r > height) vy = -vy;
        rx = rx + vx;
        ry = ry + vy;
    }

    function draw() {                           // рисование шара
        ctx.clearRect(0, 0, width, height);     // очистить экран
        ctx.beginPath();
        ctx.arc(rx, ry, r, 0, 2 * Math.PI);
        ctx.fill();
    }

    setInterval(step, 1000 / 60);               // функция step будет запускаться 60 раз в секунду (60 раз / 1000 мс)

}