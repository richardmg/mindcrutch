<html>
    <head>
    <script>
        function Tools()
        {
            this.$toolsWindow = $("#toolsWindow");
        }
    </script>

    <style>
        #toolsWindow .contents {
            margin-top:80px;
            border: 2px solid white;
            border-radius: 10;
        }
    </style>
    </head>

    <body>
        <div id="toolsWindow" class="normalWindow horizontalCenter">
            <div class="contents">
                <img src="img/search.png" onmousedown="app.tools.$toolsWindow.toggle(false); app.palette.$paletteWindow.toggleModal();"></img>
                <img src="img/trashcan.png"></img>
            </div>
        </div>
    </body>
</html>
