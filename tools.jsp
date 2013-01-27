<html>
    <head>
    <script>
        function Tools()
        {
            this.$toolsWindow = $("#toolsWindow");
        }
    </script>

    <style>
        #toolsWindow {
            margin-top:80px;
        }
    </style>
    </head>

    <body>
        <div id="toolsWindow" class="normalWindow horizontalCenter" style="width:500px;height:300px;display:none">
            <div class="contents">
                <img src="img/search.png" onmousedown="app.palette.$paletteWindow.toggleModal();"></img>
                <img src="img/trashcan.png"></img>
            </div>
        </div>
    </body>
</html>
