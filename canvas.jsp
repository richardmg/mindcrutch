<html>
    <head>
    <script>
        function Canvas()
        {
            this.$canvasWindow = $("#canvasWindow");
            $canvas = $("#canvas", this.$canvasWindow);
            this.layers = new Array;

            var this_canvas = this;
            var canvas = $canvas[0];
            canvas.width = $canvas.width();
            canvas.height = $canvas.height();
            var context = canvas.getContext('2d');
            var mousedown = false;
            var touchStartDate = new Date();
            var clickDate = new Date();
            var clickPos = {x:-1, y:-1};
            var currentAction = undefined;
            var activeLayer = undefined;

            function getAngleAndRadius(p1, p2)
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
                var lpos = activeLayer.canvasToLayer(pos);
                return (lpos.x >= activeLayer.x-30 && lpos.x <= activeLayer.x+30
                        && lpos.y >= activeLayer.y-30 && lpos.y <= activeLayer.y+30);
            }

            $canvas.on("mousedown", function(e) {
                pressStart(canvasPos(e));
            }).on("mousemove", function(e) {
                pressDrag(canvasPos(e));
            }).on("mouseup", function(e) {
                pressEnd(canvasPos(e));
            }).on("touchstart", function(e) {
                e.preventDefault();
                pressStart(canvasPos(e.originalEvent.changedTouches[0]));
            }).on("touchmove", function(e) {
                e.preventDefault();
                pressDrag(canvasPos(e.originalEvent.changedTouches[0]));
            }).on("touchend", function(e) {
                e.preventDefault();
                pressEnd(canvasPos(e.originalEvent.changedTouches[0]));
            });

            function pressStart(pos)
            {
                // start new layer operation, drag or rotate:
                mousedown = true;
                touchStartDate = new Date();

                if (activeLayer) {
                    if (overlapsHandle(pos)) {
                        // start drag
                        currentAction = {
                            dragging: true,
                            x: pos.x - activeLayer.x,
                            y:pos.y-activeLayer.y
                        };
                    } else {
                        // Start rotation
                        var center = { x: activeLayer.x, y: activeLayer.y };
                        var lpos = activeLayer.layerToCanvas(center);
                        currentAction = getAngleAndRadius(lpos, pos);
                        currentAction.rotating = true
                        currentAction.angle -= activeLayer.rotation;
                        currentAction.scale = activeLayer.scale;
                    }
                }
            }

            function pressDrag(pos)
            {
                // drag or rotate current layer:
                if (mousedown && activeLayer) {
                    if (currentAction.dragging) {
                        // continue drag
                        activeLayer.x = pos.x - currentAction.x;
                        activeLayer.y = pos.y - currentAction.y;
                    } else if (currentAction.rotating) {
                        // continue rotate
                        var center = { x: activeLayer.x, y: activeLayer.y };
                        var lpos = activeLayer.layerToCanvas(center);
                        var aar = getAngleAndRadius(lpos, pos);
                        activeLayer.rotation = aar.angle - currentAction.angle;
                        activeLayer.scale = currentAction.scale * aar.radius / currentAction.radius;
                    }
                    this_canvas.repaint();
                }
            }

            function pressEnd(pos)
            {
                mousedown = false;
                var now = new Date();
                var click = (now.getTime() - touchStartDate.getTime()) < 100;

                if (click) {
                    var doubleClick = (now.getTime() - clickDate.getTime()) < 500
                        && Math.abs(clickPos.x - pos.x) < 40
                        && Math.abs(clickPos.y - pos.y) < 40;

                    clickDate = now;
                    clickPos = pos;
                    if (doubleClick) {
                        this_canvas.callback.onDoubleClick();
                    } else {
                        var prevLayer = activeLayer;
                        activeLayer = getLayerAt(pos);
                        if (!activeLayer || activeLayer === prevLayer){
                            activeLayer = undefined;
                            currentAction = {};
                        }
                        this_canvas.callback.onActiveLayerChanged(activeLayer, prevLayer);
                    }
                }
                this_canvas.repaint();
            }

            function drawFocus(layer)
            {
                var size = 10;
                var widthScaled = layer.scale * layer.width;
                var heightScaled = layer.scale * layer.height;

                context.save();
                context.translate(layer.x, layer.y);
                context.rotate(layer.rotation);

                if (layer == activeLayer) {
                    context.fillStyle = "rgba(0, 0, 155, 0.6)";
                    context.strokeStyle = "rgba(0, 0, 155, 0.6)";
                } else {
                    context.fillStyle = "rgba(0, 0, 0, 0.6)";
                    context.strokeStyle = "rgba(0, 0, 0, 0.6)";
                }
                context.lineWidth = 2;

                context.beginPath();
                context.moveTo(-size, 0)
                context.lineTo(size, 0);
                context.stroke();
                context.closePath();

                context.beginPath();
                context.moveTo(0, -size)
                context.lineTo(0, size);
                context.stroke();
                context.closePath();

                context.translate(-widthScaled/2, -heightScaled/2);

                context.beginPath();
                context.moveTo(0, size);
                context.lineTo(0, 0);
                context.lineTo(size, 0);
                context.stroke();
                context.closePath();

                context.beginPath();
                context.moveTo(widthScaled-size, 0);
                context.lineTo(widthScaled, 0);
                context.lineTo(widthScaled, size);
                context.stroke();
                context.closePath();

                context.beginPath();
                context.moveTo(widthScaled-size, heightScaled);
                context.lineTo(widthScaled, heightScaled);
                context.lineTo(widthScaled, heightScaled-size);
                context.stroke();
                context.closePath();

                context.beginPath();
                context.moveTo(0, heightScaled-size);
                context.lineTo(0, heightScaled);
                context.lineTo(size, heightScaled);
                context.stroke();
                context.closePath();

                context.restore();
            }

            this.repaint = function()
            {
                context.canvas.width = context.canvas.width;
                for (var i in this_canvas.layers) {
                    var layer = this_canvas.layers[i];
                    context.save();
                    context.translate(layer.x, layer.y);
                    context.rotate(layer.rotation);
                    context.scale(layer.scale, layer.scale);
                    context.translate(-layer.width/2, -layer.height/2);
                    context.drawImage(layer.image, 0, 0);
                    context.restore();
                }
                for (var i in this_canvas.layers) {
                    var layer = this_canvas.layers[i];
                    if (layer.selected || layer == activeLayer)
                        drawFocus(layer);
                }
            }

            this.clearSelections = function()
            {
                for (var i in this_canvas.layers) {
                    this_canvas.layers[i].selected = false;
                }
            }

            this.addLayer = function(layer)
            {
                layer.x = layer.x || 200;
                layer.y = layer.y || 200;
                layer.z = layer.z || this.layers.length;
                layer.rotation = layer.rotation || 0;
                layer.scale = layer.scale || 1;
                layer.selected  = false;

                layer.index = this_canvas.layers.length;
                this_canvas.layers.push(layer);
                var prevLayer = activeLayer;
                activeLayer = layer;
                this_canvas.callback.onActiveLayerChanged(activeLayer, prevLayer);

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

                layer.canvasToLayer = function(p)
                {
                    var g = getAngleAndRadius({x:layer.x, y:layer.y}, p);
                    var angleNorm = g.angle - layer.rotation;
                    return {
                        x: layer.x + (Math.cos(angleNorm) * g.radius),
                        y: layer.y + (Math.sin(angleNorm) * g.radius)
                    }
                }

                layer.layerToCanvas = function(p)
                {
                    var g = getAngleAndRadius({x:layer.x, y:layer.y}, p);
                    var angleNorm = g.angle + layer.rotation;
                    return {
                        x: layer.x + (Math.cos(angleNorm) * g.radius),
                        y: layer.y + (Math.sin(angleNorm) * g.radius)
                    }
                }

                layer.containsPos = function(p, checkOpacity)
                {
                    p = layer.canvasToLayer(p);
                    var dx = layer.scale * layer.width/2;
                    var dy = layer.scale * layer.height/2;
                    if ((p.x >= layer.x-dx && p.x <= layer.x + dx)
                            && (p.y >= layer.y-dy && p.y <= layer.y+dy)) {
                        // todo: get pixel, check for opacity
                        if (checkOpacity === true)
                            return true
                        else
                            return true;
                    }
                    return false;
                }

                layer.remove = function()
                {
                    this_canvas.layers.splice(layer.index, 1);
                }
                
                return layer;
            }

            this.eachLayer = function(f)
            {
                for (var i in this_canvas.layers)
                    f(this_canvas.layers[i]);
            }
        }
    </script>

    <style>
        #canvasWindow {
            margin-top:5px;
            margin-bottom:5px;
            margin-right:5px;
            margin-left:5px;
        }

        #canvasWindow .frame {
            border-radius: 5px;
            background-color: rgba(255, 255, 255, 1);
            background-image: none;
        }
    </style>

    </head>

    <body>
        <div id="canvasWindow" class="normalWindow horizontalCenter" style="width:840px;height:480px" autoraise="false" draggable="true">
            <canvas id="canvas" class="contents canvas" style="background-color:#ffffff"></canvas>
        </div>
    </body>
</html>
