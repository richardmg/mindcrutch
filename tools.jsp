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
                app.canvas.eachLayerReverse(function(layer) {
                    if (layer.selected)
                        layer.remove();
                });
            }

            this.selectLayerAfterModal = function(e)
            {
                if (e.target != this_tools.$toolsWindow[0])
                    return;
                app.canvas.eachLayer(function(layer) { layer.selected = false; });
                var p = app.canvas.canvasPos(e);
                var layer = app.canvas.getLayerAt(p);
                if (layer)
                    layer.activate();
            }
            
            this.searchForImages = function()
            {
                app.tools.$toolsWindow.toggle(false);
                app.palette.showPalette();
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
                <p class="menuitem" onmousedown="app.tools.removeSelectedLayers()">Edit image...</p>
                <p class="menuitem" onmousedown="app.tools.removeSelectedLayers()">Copy...</p>
                <p class="menuitem" onmousedown="app.tools.removeSelectedLayers()">Level up</p>
                <p class="menuitem" onmousedown="app.tools.removeSelectedLayers()">Level down</p>
            </div>
        </div>
    </body>
</html>
