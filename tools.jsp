<html>
    <head>
    <script>
        function Tools()
        {
            this.$toolsWindow = $("#toolsWindow");
            this.$toolsWindow.css("width", app.canvas.$canvasWindow.width());
            this.$toolsWindow.centerHorizontallyIn(app.canvas.$canvasWindow[0]);
            this.$toolsWindow.alignToBottom(app.canvas.$canvasWindow[0]);
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
        #toolsWindow .frame {
            background-image: -webkit-gradient(radial, 50% 0%, 300, 50% 10%, 20, from(rgba(0, 0, 0, 0.8)), to(rgba(80, 80, 90, 0.8)));
            box-shadow: none;
            -moz-box-shadow: none;
            -webkit-box-shadow: none;
            border-radius: 5px;
            border: 1px solid black;
        }
        #toolsWindow .contents {
            margin-top:0px;
        }
    </style>
    </head>

    <body>
        <div id="toolsWindow" class="normalWindow" style="height:100px">
            <div class="contents">
                <img src="img/search.png" onmousedown="app.tools.$toolsWindow.toggle(false); app.palette.$paletteWindow.toggleModal();"></img>
                <img src="img/trashcan.png" onmousedown="removeSelectedLayers()"></img>
            </div>
        </div>
    </body>
</html>
