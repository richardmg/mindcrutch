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
            //background-image: url("img/transparent80brown.png");
            //background: -webkit-gradient(radial, 50% 50%, 0, 50% 50%, 600, from(#707075), to(#303030));
            //background-image: -webkit-gradient(radial, upper left, 100, upper left, 1000, from(rgba(255, 255, 255, 1.0)), to(rgba(100, 100, 100, 1.0));
            background-image: -webkit-gradient(radial, 50% 50%, 300, 50% 50%, 20, from(rgba(0, 0, 0, 0.8)), to(rgba(80, 80, 90, 0.8)));
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
