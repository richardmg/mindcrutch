<html>
    <head>
    <script>
        function Tools()
        {
            this_tools = this;
            this.$toolsWindow = $("#toolsWindow");
            this.$contents = $(".contents", this.$toolsWindow);
            this.$contents.css("left", app.canvas.$canvasWindow.offset().left - 30);

            this.removeSelectedLayers = function()
            {
                app.canvas.eachSelectedLayerReverse(function(layer) { layer.remove(); });
                app.canvas.repaint();
            }

            this.copySelectedLayers = function()
            {
                app.canvas.eachSelectedLayer(function(layer) {
                    var newLayer = app.canvas.addLayer({
                        x: layer.x + (layer.width * layer.scale), 
                        y: layer.y, 
                        rotation: layer.rotation, 
                        scale: layer.scale, 
                        image: layer.image,
                        url: layer.url
                    });
                    newLayer.select(true);
                    layer.select(false);
                });
                app.canvas.repaint();
            }

            this.selectLayerAfterModal = function(e)
            {
                if (e.target != this_tools.$toolsWindow[0])
                    return;
                app.canvas.eachSelectedLayer(function(layer) { layer.select(false); });
                var p = app.canvas.canvasPos(e);
                var layer = app.canvas.getLayerAt(p);
                if (layer) {
                    layer.select(true);
                    app.canvas.repaint();
                }
            }
            
            this.searchForImages = function()
            {
                app.canvas.eachSelectedLayerReverse(function(layer) { layer.select(false); });
                app.tools.$toolsWindow.toggle(false);
                app.palette.showPalette();
            }

            this.levelUpDown = function(direction)
            {
                app.canvas.eachSelectedLayerReverse(function(layer) { layer.setZ(layer.getZ() + direction); });
                app.canvas.repaint();
            }
        }
    </script>

    <style>
        #toolsWindow .contents {
            position: fixed;
            margin-top:50px;
            height: 300px;
            width: 200px;
        }
    </style>
    </head>

    <body>
        <div id="toolsWindow" class="modalWindow" onmousedown="app.tools.selectLayerAfterModal(event);">
            <div class="contents">
                <p class="menuitem" onmousedown="app.tools.searchForImages()">Search for images...</p>
                <p class="menuitem" onmousedown="app.tools.removeSelectedLayers()">Remove image</p>
                <p class="menuitem" onmousedown="app.tools.editImage()">Edit image...</p>
                <p class="menuitem" onmousedown="app.tools.copySelectedLayers()">Copy...</p>
                <p class="menuitem" onmousedown="app.tools.levelUpDown(1)">Level up</p>
                <p class="menuitem" onmousedown="app.tools.levelUpDown(-1)">Level down</p>
            </div>
        </div>
    </body>
</html>
