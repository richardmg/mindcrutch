
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
    var handleRadius = 20;
    var selectedLayer = undefined;

    function getLayerAt(p)
    {
        for (var i=this_canvas.layers.length-1; i>=0; --i) {
            var layer = this_canvas.layers[i];
            if (layer.containsPos(p, true))
                return layer;
        }
    }

    function canvasPos(e)
    {
        var parentOffset = $canvas.parent().offset();
        return {
            x: e.pageX - canvas.offsetLeft - parentOffset.left,
            y: e.pageY - canvas.offsetTop - parentOffset.top
        };
    }

    function overlapsHandle(pos)
    {
        if (!selectedLayer)
            return false;
        var npos = selectedLayer.convertPosCanvasToLayer(pos);
        var hx = selectedLayer.x + selectedLayer.width;
        var hy = selectedLayer.y + selectedLayer.height;
        return (npos.x >= hx-handleRadius && npos.x <= hx+handleRadius
                && npos.y >= hy-handleRadius && npos.y <= hy+handleRadius);
    }


    $canvas.on("mousedown", function(e) {
        mousedown = true;
        var pos = canvasPos(e);
        if (overlapsHandle(pos)) {
            console.log("onHandle");
        } else {
            var layer = getLayerAt(pos);

            if (layer) {
                selectedLayer = layer;
                dragOffset = {x:pos.x - layer.x, y:pos.y-layer.y};
            } else {
                // Something else other than layer clikced.
                // Normally unselect, but also rotate/scale.
                selectedLayer = undefined;
            }
            this_canvas.repaint();
        }
    }).on("mouseup", function() {
        mousedown = false;
    }).on("mousemove", function(e) {
        if (selectedLayer) {
            if (mousedown) {
                pos = canvasPos(e);
                selectedLayer.x = pos.x - dragOffset.x;
                selectedLayer.y = pos.y - dragOffset.y;
                this_canvas.repaint();
            }
        }
    });

    function drawHandle()
    {
        if (!selectedLayer)
            return;
        context.save();
        context.translate(selectedLayer.x, selectedLayer.y);
        context.rotate(selectedLayer.rotation);
        context.translate(selectedLayer.width, selectedLayer.height);
        context.fillStyle = "rgba(200, 0, 0, 0.3)";
        context.strokeStyle = "rgba(200, 0, 0, 0.5)";
        context.lineWidth = 2;
        context.beginPath();
        context.arc(0, 0, handleRadius, 0, 2 * Math.PI, false);
        context.fill();
        context.stroke();
        context.closePath();
        context.restore();
    }

    function drawLayers()
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

    this.repaint = function() {
        drawLayers();
        drawHandle();
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
                this_canvas.repaint();
            };
            layer.image.src = layer.url;
        } else if (layer.image) {
            layer.width = layer.image.width;
            layer.height = layer.image.height;
        } else {
            layer.width = 0;
            layer.height = 0;
        }

        layer.convertPosCanvasToLayer = function(p)
        {
            var dx = p.x - layer.x;
            var dy = layer.y - p.y;
            var angle = Math.atan2(dx, dy) - Math.PI/2;
            var radius = Math.sqrt(dx*dx + dy*dy); 
            var angleNorm = angle - layer.rotation;
            return {
                x: layer.x + (Math.cos(angleNorm) * radius),
                y: layer.y + (Math.sin(angleNorm) * radius)
            }
        }

        layer.containsPos = function(p, checkOpacity)
        {
            p = layer.convertPosCanvasToLayer(p);
            if ((p.x >= layer.x && p.x <= layer.x + layer.width) 
                    && (p.y >= layer.y && p.y <= layer.y + layer.height)) {
                // todo: get pixel, check for opacity
                if (checkOpacity === true)
                    return true
                else
                    return true;
            }
            return false;
        }
        
        return layer;
    }
}

$.fn.createWooCanvas = function() {
    return this.each(function() {
        $.data(this, "wooCanvas", new WooCanvas(this));
    });
}

