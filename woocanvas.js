
function WooCanvas(canvas)
{
    var canvas_this = this;
    var $canvas = $(canvas);
    this.layers = new Array;
    canvas.width = $canvas.width();
    canvas.height = $canvas.height();
    var context = $canvas[0].getContext('2d');
    var mousedown = false;

    $canvas.on("mousedown", function() {
        // Find which layer clicked:
        var layer = canvas_this.layers[0];
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
        for (var i in canvas_this.layers) {
            var layer = canvas_this.layers[i];
            context.translate(layer.x, layer.y);
            context.rotate(10);
            context.drawImage(layer.image, 0, 0);
            context.translate(-layer.x, -layer.y);
        }
    }

    this.addLayer = function(layer) {
        layer.x = layer.x || 300;
        layer.y = layer.y || 200;
        layer.z = layer.z || this.layers.length;
        layer.rotation = layer.rotation || 0;
        layer.scale = layer.scale || 1;

        canvas_this.layers.push(layer);
        if (layer.url) {
            layer.image = new Image();
            layer.image.onload = this.drawLayers;
            layer.image.src = layer.url;
        }
        return layer;
    }
}

$.fn.createWooCanvas = function() {
    return this.each(function() {
        $.data(this, "wooCanvas", new WooCanvas(this));
    });
}

