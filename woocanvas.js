function drawLayers()
{
    context.canvas.width = context.canvas.width;
    for (var i in layers) {
        var layer = layers[i];
        context.translate(layer.x, layer.y);
        context.rotate(10);
        context.drawImage(layer.image, 0, 0);
        context.translate(-layer.x, -layer.y);
    }
}

function WooLayer(url) {
    layers.push(this);
    this.url = url;
    this.x = 300;
    this.y = 200;
    this.rotation = 0;
    this.scale = 1;
    this.image = new Image();
    this.image.onload = drawLayers;
    this.image.src = url;
}

function initCanvas()
{
    layers = new Array;

    canvas = $(".WooCanvas");
    canvas[0].width = canvas.width();
    canvas[0].height = canvas.height();
    context = canvas[0].getContext('2d');
    var mousedown = false;

    canvas.on("mousedown", function() {
            // Find which layer clicked:
            var layer = layers[0];
            mousedown = true;
    });
    canvas.on("mouseup", function() {
            mousedown = false;
    });

    canvas.on("mousemove", function() {
        if (mousedown)
            console.log("mouse move");
    });
}
