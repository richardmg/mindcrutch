<html>
    <head>
    <script>
        function Canvas()
        {
            this.$canvasWindow = $("#canvasWindow");
            this.layers = new Array;
            this.selectedLayers = new Array;

            $canvas = $("#canvas", this.$canvasWindow);
            var this_canvas = this;
            var canvas = $canvas[0];
            canvas.width = $canvas.width();
            canvas.height = $canvas.height();
            var context = canvas.getContext('2d');
            var mousedown = false;
            var pressStartTime = 0;
            var pressStartPos = undefined;
            var currentAction = {};

            function getAngleAndRadius(p1, p2)
            {
                var dx = p2.x - p1.x;
                var dy = p1.y - p2.y;
                return {
                    angle: Math.atan2(dx, dy) - Math.PI/2,
                    radius: Math.sqrt(dx*dx + dy*dy)
                }; 
            }

            this.getLayerAt = function(p)
            {
                for (var i=this_canvas.layers.length-1; i>=0; --i) {
                    var layer = this_canvas.layers[i];
                    if (layer.containsPos(p, true))
                        return layer;
                }
            }

            this.canvasPos = function(e)
            {
                var parentOffset = $canvas.parent().offset();
                return {
                    x: e.pageX - canvas.offsetLeft - parentOffset.left,
                    y: e.pageY - canvas.offsetTop - parentOffset.top
                };
            }

            function overlapsHandle(pos)
            {
                for (var i in this_canvas.selectedLayers) {
                    var layer = this_canvas.selectedLayers[i];
                    var lpos = layer.canvasToLayer(pos);
                    if (lpos.x >= layer.x-30 && lpos.x <= layer.x+30
                            && lpos.y >= layer.y-30 && lpos.y <= layer.y+30)
                        return layer;
                }
                return null;
            }

            $canvas.on("mousedown", function(e) {
                pressStart(this_canvas.canvasPos(e));
            }).on("mousemove", function(e) {
                pressDrag(this_canvas.canvasPos(e));
            }).on("mouseup", function(e) {
                pressEnd(this_canvas.canvasPos(e));
            }).on("touchstart", function(e) {
                e.preventDefault();
                pressStart(this_canvas.canvasPos(e.originalEvent.changedTouches[0]));
            }).on("touchmove", function(e) {
                e.preventDefault();
                pressDrag(this_canvas.canvasPos(e.originalEvent.changedTouches[0]));
            }).on("touchend", function(e) {
                e.preventDefault();
                pressEnd(this_canvas.canvasPos(e.originalEvent.changedTouches[0]));
            });

            function pressStart(pos)
            {
                // start new layer operation, drag or rotate:
                mousedown = true;
                pressStartTime = new Date().getTime();
                pressStartPos = pos;

                if (this_canvas.selectedLayers.length !== 0) {
                    var layer = overlapsHandle(pos);
                    if (layer) {
                        // start drag
                        currentAction = {
                            layer: layer, 
                            dragging: true,
                            x: pos.x,
                            y:pos.y,
                        };
                    } else {
                        // Start rotation
                        var layer = this_canvas.selectedLayers[0];
                        var center = { x: layer.x, y: layer.y };
                        var lpos = layer.layerToCanvas(center);
                        currentAction = getAngleAndRadius(lpos, pos);
                        currentAction.rotating = true
                    }
                }
            }

            function pressDrag(pos)
            {
                // drag or rotate current layer:
                if (mousedown) {
                    if (currentAction.selecting) {
                        var layer = this_canvas.getLayerAt(pos);
                        if (layer && !layer.selected) {
                            layer.select(true);
                            this_canvas.repaint();
                        }
                    } else if (this_canvas.selectedLayers.length !== 0) {
                        if (currentAction.dragging) {
                            // continue drag
                            for (var i in this_canvas.selectedLayers) {
                                var layer = this_canvas.selectedLayers[i];
                                layer.x += pos.x - currentAction.x;
                                layer.y += pos.y - currentAction.y;
                            }
                            currentAction.x = pos.x;
                            currentAction.y = pos.y;
                        } else if (currentAction.rotating) {
                            // continue rotate
                            var layer = this_canvas.selectedLayers[0];
                            var center = { x: layer.x, y: layer.y };
                            var lpos = layer.layerToCanvas(center);
                            var aar = getAngleAndRadius(lpos, pos);
                            for (var i in this_canvas.selectedLayers) {
                                var layer = this_canvas.selectedLayers[i];
                                layer.rotation += aar.angle - currentAction.angle;
                                layer.scale *= aar.radius / currentAction.radius;
                            }
                            currentAction.angle = aar.angle;
                            currentAction.radius = aar.radius;
                        }
                        this_canvas.repaint();
                    } else {
                        var startSelect = (Math.abs(pos.x - pressStartPos.x) < 10 || Math.abs(pos.y - pressStartPos.y) < 10);
                        currentAction.selecting = true;
                    }
                }
            }

            function pressEnd(pos)
            {
                mousedown = false;

                var click = (new Date().getTime() - pressStartTime) < 300 
                    && Math.abs(pos.x - pressStartPos.x) < 10
                    && Math.abs(pos.y - pressStartPos.y) < 10;

                if (click) {
                    var layer = this_canvas.getLayerAt(pos);
                    if (!layer || !layer.selected)
                        currentAction = {};
                    this_canvas.callback.onClicked(layer);
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
                context.fillStyle = "rgba(0, 0, 155, 0.6)";
                context.strokeStyle = "rgba(0, 0, 155, 0.6)";
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
                    if (layer.selected)
                        drawFocus(layer);
                }
            }

            this.addLayer = function(layer)
            {
                layer.x = layer.x || 200;
                layer.y = layer.y || 200;
                layer.rotation = layer.rotation || 0;
                layer.scale = layer.scale || 1;
                layer.selected  = layer.selected || false;

                this_canvas.layers.push(layer);

                if (layer.image) {
                    layer.width = layer.image.width;
                    layer.height = layer.image.height;
                } else if (layer.url) {
                    layer.image = new Image();
                    layer.image.onload = function() {
                        layer.width = layer.image.width;
                        layer.height = layer.image.height;
                        this_canvas.repaint();
                    };
                    layer.image.src = layer.url;
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

                layer.select = function(select)
                {
                    if (select === layer.selected)
                        return;
                    layer.selected = select;

                    if (select) {
                        this_canvas.selectedLayers.push(layer);
                    } else {
                        var index = this_canvas.selectedLayers.indexOf(layer);
                        this_canvas.selectedLayers.splice(index, 1);
                    }
                }

                layer.remove = function()
                {
                    this_canvas.layers.splice(layer.getZ(), 1);
                    if (layer.selected) {
                        var i = this_canvas.selectedLayers.indexOf(layer);
                        this_canvas.selectedLayers.splice(i, 1);
                    }
                    this_canvas.repaint();
                }

                layer.setZ = function(z)
                {
                    z = Math.max(0, Math.min(this_canvas.layers.length - 1, z));
                    var currentZ = layer.getZ();
                    if (z === currentZ)
                        return;
                    this_canvas.layers.splice(currentZ, 1);
                    this_canvas.layers.splice(z, 0, layer);
                }

                layer.getZ = function()
                {
                    return this_canvas.layers.indexOf(layer);
                }

                return layer;
            }

            this.eachLayer = function(f)
            {
                for (var i in this_canvas.layers)
                    f(this_canvas.layers[i]);
                this_canvas.repaint();
            }

            this.eachLayerReverse = function(f)
            {
                for (var i = this_canvas.layers.length - 1; i>=0; --i)
                    f(this_canvas.layers[i]);
                this_canvas.repaint();
            }

            this.eachSelectedLayer = function(f)
            {
                for (var i in this_canvas.selectedLayers)
                    f(this_canvas.selectedLayers[i]);
                this_canvas.repaint();
            }

            this.eachSelectedLayerReverse = function(f)
            {
                for (var i = this_canvas.selectedLayers.length - 1; i>=0; --i)
                    f(this_canvas.selectedLayers[i]);
                this_canvas.repaint();
            }

            this.eachLayerReverse = function(f)
            {
                for (var i = this_canvas.layers.length - 1; i>=0; --i)
                    f(this_canvas.layers[i]);
                this_canvas.repaint();
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
