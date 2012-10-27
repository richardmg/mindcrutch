
function WooCanvas(canvas)
{
    var this_canvas = this;
    var $canvas = $(canvas);
    this.layers = new Array;
    canvas.width = $canvas.width();
    canvas.height = $canvas.height();
    var context = $canvas[0].getContext('2d');
    var mousedown = false;

    function getLayerAt(x, y)
    {
        for (var i=this_canvas.layers.length-1; i>=0; --i) {
            var layer = this_canvas.layers[i];
            var dx = x - layer.x;
            var dy = layer.y - y;
            var angle = Math.atan2(dx, dy) - Math.PI/2;
            var radius = Math.sqrt(dx*dx + dy*dy); 

            var angleNorm = angle - layer.rotation;
            var xNorm = layer.x + (Math.cos(angleNorm) * radius);
            var yNorm = layer.y + (Math.sin(angleNorm) * radius);

            if ((xNorm >= layer.x && xNorm <= layer.x + layer.width) 
                    && (yNorm >= layer.y && yNorm <= layer.y + layer.height)) {
                // todo: get pixel, check for opacity
                return layer;
            }
        }
    }

    $canvas.on("mousedown", function(e) {
        // Find which layer clicked:
        var parentOffset = $canvas.parent().offset();
        var x = e.pageX - canvas.offsetLeft - parentOffset.left;
        var y = e.pageY - canvas.offsetTop - parentOffset.top;
        var layer = getLayerAt(x, y);
        if (layer) {
            console.log("You clicked on:", layer.url);
        }
        mousedown = true;
    }).on("mouseup", function() {
        mousedown = false;
    }).on("mousemove", function() {
        if (mousedown)
            console.log("mouse move");
    });

    this.drawLayers = function()
    {
        context.canvas.width = context.canvas.width;
        for (var i in this_canvas.layers) {
            var layer = this_canvas.layers[i];
            context.save();
            context.translate(layer.x, layer.y);
            context.rotate(layer.rotation);
            context.drawImage(layer.image, 0, 0);
            context.restore();
        }
    }

    this.addLayer = function(layer) {
        layer.x = layer.x || 200;
        layer.y = layer.y || 200;
        layer.z = layer.z || this.layers.length;
        layer.rotation = layer.rotation || 0;
        layer.scale = layer.scale || 1;

        this_canvas.layers.push(layer);
        if (layer.url) {
            layer.image = new Image();
            layer.image.onload = function() {
                layer.width = layer.image.width;
                layer.height = layer.image.height;
                this_canvas.drawLayers();
            };
            layer.image.src = layer.url;
        } else if (layer.image) {
            layer.width = layer.image.width;
            layer.height = layer.image.height;
        } else {
            layer.width = 0;
            layer.height = 0;
        }
        
        return layer;
    }
}

$.fn.createWooCanvas = function() {
    return this.each(function() {
        $.data(this, "wooCanvas", new WooCanvas(this));
    });
}

