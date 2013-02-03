<html>
    <head>
        <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js" type="text/javascript"></script>
        <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js"></script>

        <script>
            $(function() {
                app = {};

                app.windowManager = new WindowManager();
                app.menuManager = new MenuManager();
                app.canvas = new Canvas();
                app.palette = new Palette();
                app.tools = new Tools();

                app.canvas.callback = {
                    onClicked: function(layer) {
                        var tools = app.tools.$toolsWindow;
                        if (!layer) {
                            if (app.canvas.selectedLayers.length === 0) {
                                tools.fadeIn("fast");
                            } else  {
                                app.canvas.eachSelectedLayer(function(layer) { layer.select(false); });
                                app.canvas.repaint();
                            }
                        } else {
                            if (layer.selected) {
                                tools.fadeIn("fast");
                            } else {
                                app.canvas.eachSelectedLayer(function(layer) { layer.select(false); });
                                layer.select(true);
                                app.canvas.repaint();
                            }
                        }
                    }
                }

                app.palette.callback = {
                    onThumbnailPressed: function(result)
                    {
                        app.canvas.addLayer({url:result.url, rotation:Math.PI/8}).select(true);
                        app.palette.$paletteWindow.toggle(false);
                    },
                    onCursorChanged: function(cursor)
                    {
                        console.log("Search count: " + cursor.resultCount);
                    }
                };

                app.palette.updatePalette();
            });
        </script>

        <style>
            body {
                background: -webkit-gradient(radial, 50% 50%, 0, 50% 50%, 600, from(#505050), to(#303030));
            }
        </style>
    </head>

    <body>
        <%@ include file="windowmanager.jsp" %>
        <%@ include file="menumanager.jsp" %>
        <%@ include file="canvas.jsp" %>
        <%@ include file="palette.jsp" %>
        <%@ include file="tools.jsp" %>
    </body>
</html>
