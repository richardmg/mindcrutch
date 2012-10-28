
function WooCanvas(canvas)
{
    var this_canvas = this;
    var $canvas = $(canvas);
    this.layers = new Array;
    canvas.width = $canvas.width();
    canvas.height = $canvas.height();
    var context = $canvas[0].getContext('2d');
    var mousedown = false;
    var dragOffset = {x:0, y:0};
    var selectedLayer = undefined;

    function getLayerAt(p)
    {
        for (var i=this_canvas.layers.length-1; i>=0; --i) {
            var layer = this_canvas.layers[i];
            var dx = p.x - layer.x;
            var dy = layer.y - p.y;
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

    function eventPosInCanvas(e)
    {
        var parentOffset = $canvas.parent().offset();
        return {
            x: e.pageX - canvas.offsetLeft - parentOffset.left,
            y: e.pageY - canvas.offsetTop - parentOffset.top
        };
    }

    $canvas.on("mousedown", function(e) {
        mousedown = true;
        var pos = eventPosInCanvas(e);
        var layer = getLayerAt(pos);

        if (layer) {
            selectedLayer = layer;
            dragOffset = {x:pos.x - layer.x, y:pos.y-layer.y};
            console.log(dragOffset.x, dragOffset.y);
        } else {
            // Something else other than layer clikced.
            // Normally unselect, but also rotate/scale.
            selectedLayer = undefined;
        }
    }).on("mouseup", function() {
        mousedown = false;
    }).on("mousemove", function(e) {
        if (mousedown) {
            if (selectedLayer) {
                pos = eventPosInCanvas(e);
                todo: convert layer.x to layer.pos
                selectedLayer.x = pos.x - dragOffset.x;
                selectedLayer.y = pos.y - dragOffset.y;
                this_canvas.drawLayers();

                console.log("move layer");
            }
        }
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

