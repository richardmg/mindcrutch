
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
    var handleRadius = 6;
    var selectedLayer = undefined;

    function getAngle(p1, p2)
    {
        var dx = p2.x - p1.x;
        var dy = p1.y - p2.y;
        return {
            angle: Math.atan2(dx, dy) - Math.PI/2,
            radius: Math.sqrt(dx*dx + dy*dy)
        }; 
    }

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
        var hx = selectedLayer.x + (selectedLayer.width/2);
        var hy = selectedLayer.y + (selectedLayer.height/2);
        return (npos.x >= hx-handleRadius && npos.x <= hx+handleRadius
                && npos.y >= hy-handleRadius && npos.y <= hy+handleRadius);
    }


    $canvas.on("mousedown", function(e) {
        mousedown = true;
        var pos = canvasPos(e);
        if (overlapsHandle(pos)) {
            console.log("onHandle");
        } else if (selectedLayer) {
            var angle = getAngle(selectedLayer.centerPos, pos);
            console.log("angle:", angle.angle);
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
        var size = 10;
        context.save();
        context.translate(selectedLayer.x, selectedLayer.y);
        context.rotate(selectedLayer.rotation);
        context.fillStyle = "rgba(250, 0, 0, 0.6)";
        context.strokeStyle = "rgba(250, 0, 0, 0.6)";
        context.lineWidth = 2;

        context.beginPath();
        context.arc(selectedLayer.width/2, selectedLayer.height/2,
                size/2, 0, 2 * Math.PI, false);
        context.fill();
        context.closePath();

        context.beginPath();
        context.moveTo(0, size);
        context.lineTo(0, 0);
        context.lineTo(size, 0);
        context.stroke();
        context.closePath();

        context.beginPath();
        context.moveTo(selectedLayer.width-size, 0);
        context.lineTo(selectedLayer.width, 0);
        context.lineTo(selectedLayer.width, size);
        context.stroke();
        context.closePath();

        context.beginPath();
        context.moveTo(selectedLayer.width-size, selectedLayer.height);
        context.lineTo(selectedLayer.width, selectedLayer.height);
        context.lineTo(selectedLayer.width, selectedLayer.height-size);
        context.stroke();
        context.closePath();

        context.beginPath();
        context.moveTo(0, selectedLayer.height-size);
        context.lineTo(0, selectedLayer.height);
        context.lineTo(size, selectedLayer.height);
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
            var g = getAngle({x:layer.x, y:layer.y}, p);
            var angleNorm = g.angle - layer.rotation;
            return {
                x: layer.x + (Math.cos(angleNorm) * g.radius),
                y: layer.y + (Math.sin(angleNorm) * g.radius)
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

