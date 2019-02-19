function HSVtoRGB(h, s, v) {                            // h, s, v: [0, 1]

    var r, g, b, i, f, p, q, t;

    i = Math.floor(h * 6);

    f = h * 6 - i;

    p = v * (1 - s);

    q = v * (1 - f * s);

    t = v * (1 - (1 - f) * s);

    switch (i % 6) {

        case 0: r = v, g = t, b = p; break;

        case 1: r = q, g = v, b = p; break;

        case 2: r = p, g = v, b = t; break;

        case 3: r = p, g = q, b = v; break;

        case 4: r = t, g = p, b = v; break;

        case 5: r = v, g = p, b = q; break;

    }

    return {

        r: Math.floor(r * 255),

        g: Math.floor(g * 255),

        b: Math.floor(b * 255)

    };

}

function RGBtoHEX(r, g, b) {                       // r, g, b: [0, 255]

    return "#" + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);

}