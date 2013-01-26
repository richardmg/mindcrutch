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
            });
        </script>
    </head>

    <body>
        <%@ include file="canvas.jsp" %>
        <%@ include file="palette.jsp" %>
    </body>
</html>
