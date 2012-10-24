
function WooCanvas(canvas)
{
    var $canvas = $(canvas);
    var layers = new Array;
    canvas.width = $canvas.width();
    canvas.height = $canvas.height();
    var context = $canvas[0].getContext('2d');
    var mousedown = false;

    $canvas.on("mousedown", function() {
        // Find which layer clicked:
        var layer = layers[0];
        mousedown = true;
    });

    $canvas.on("mouseup", function() {
        mousedown = false;
    });

    $canvas.on("mousemove", function() {
        if (mousedown)
            console.log("mouse move");
    });

    this.drawLayers = function()
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

    this.addLayer = function(url) {
        var layer = new Object();
        layers.push(layer);
        layer.url = url;
        layer.x = 300;
        layer.y = 200;
        layer.rotation = 0;
        layer.scale = 1;
        layer.image = new Image();
        layer.image.onload = this.drawLayers;
        layer.image.src = url;
    }
}

$.fn.createWooCanvas = function() {
    return this.each(function() {
        $.data(this, "wooCanvas", new WooCanvas(this));
    });
}

