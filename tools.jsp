<html>
    <head>
    <script>
        function Tools()
        {
            this.$toolsWindow = $("#toolsWindow");
            this.$contents = $(".contents", this.$toolsWindow);
            this.$contents.css("left", app.canvas.$canvasWindow.offset().left - 30);
        }

        function removeSelectedLayers()
        {
            app.canvas.eachLayerReverse(function(layer) {
                if (layer.selected)
                    layer.remove();
            });
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
        <div id="toolsWindow" class="modalWindow">
            <div class="contents">
                <p class="menuitem" onmousedown="app.tools.$toolsWindow.toggle(false); app.palette.$paletteWindow.toggleModal();">Search for images...</p>
                <p class="menuitem" onmousedown="removeSelectedLayers()">Remove image</p>
                <p class="menuitem" onmousedown="removeSelectedLayers()">Edit image...</p>
                <p class="menuitem" onmousedown="removeSelectedLayers()">Copy...</p>
                <p class="menuitem" onmousedown="removeSelectedLayers()">Level up</p>
                <p class="menuitem" onmousedown="removeSelectedLayers()">Level down</p>
            </div>
        </div>
    </body>
</html>
