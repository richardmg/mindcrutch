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
            app.canvas.eachLayer(function(layer) {
                layer.remove();
            });
            app.canvas.repaint();
        }
    </script>

    <style>
        #toolsWindow .frame {
            background-image: url("img/transparent80.png");
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
