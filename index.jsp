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

                app.canvas.doubleClickCallback = function() { $("#paletteWindow").toggleModal(); };
            });
        </script>

        <style>
            body {
                background: -webkit-gradient(linear, left top, left bottom, from(#505050), to(#303030));
                //background: url(http://blog.carbonfive.com/wp-content/themes/carbonfive/images/background.gif);
                //background-color: #606060;
            }
        </style>
    </head>

    <body>
        <%@ include file="canvas.jsp" %>
        <%@ include file="palette.jsp" %>
    </body>
</html>
