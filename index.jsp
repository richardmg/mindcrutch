<html>
    <head>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js" type="text/javascript"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js"></script>

        <script src="window.js"></script>

        <link rel="stylesheet" type="text/css" href="window.css">
        <link rel="stylesheet" type="text/css" href="components.css">

        <script>
            $(function() {
                app = {};
                setupWindows();
                setupMenus();

                app.canvas = new Canvas();
                app.palette = new Palette();
                app.tools = new Tools();

                app.canvas.onDoubleClick = function() { app.tools.$toolsWindow.toggle(true); };
                app.palette.callback = {
                    thumbnailPressed: function(result)
                    {
                        app.canvas.addLayer({url:result.url, rotation:Math.PI/8});
                        app.palette.$paletteWindow.toggle(false);
                    },
                    cursor: function(cursor)
                    {
                        console.log("Search count: " + cursor.resultCount);
                    }
                };

                app.palette.updatePalette();
            });
        </script>

        <style>
            body {
                //background: -webkit-gradient(linear, left top, left bottom, from(#505050), to(#303030));
                background: -webkit-gradient(radial, 50% 50%, 0, 50% 50%, 600, from(#505050), to(#303030));
                //background: url(http://blog.carbonfive.com/wp-content/themes/carbonfive/images/background.gif);
                //background-color: #606060;
            }
        </style>
    </head>

    <body>
        <%@ include file="canvas.jsp" %>
        <%@ include file="palette.jsp" %>
        <%@ include file="tools.jsp" %>
    </body>
</html>
