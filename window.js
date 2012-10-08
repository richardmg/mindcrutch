
function registerToolWindow(divtag) {
    var win = $(divtag);
    window.activeWindow = win;
    // Make window draggable, and
    // let it pop to top on click':
    win.draggable();
    win.mousedown(function() { 
        if (win != window.activeWindow && win.attr("autoraise") != "false") {
            $("body").append(win);
            window.activeWindow = win;
        }
    });

    // Create frame div in which we place a canvas. We need this extra
    // div around the canvas so that the canvas gets clipped to the
    // rounded corners:
    win.append("<div class='frame'></div>");
    $(".frame", win).append("<canvas class='headerCanvas' height=30px width="
            + win.width() + "px</canvas>");

    // Draw the background as a gradient:
    var canvas = $(".frame .headerCanvas", win).get(0);
    var context = canvas.getContext('2d');
    var gradient = context.createLinearGradient(0, 0, 0, canvas.height);
    gradient.addColorStop(0.0, "rgba(180, 180, 180, 0.3)");
    gradient.addColorStop(0.4, "rgba(50, 50, 50, 0.3)");
    gradient.addColorStop(1.0, "rgba(20, 20, 20, 0.3)");
    context.fillStyle = gradient;
    context.fillRect(0, 0, canvas.width, canvas.height);

    // Since adding margins and paddings to a div makes it bigger
    // that 100%, we need this extra fixup code to make
    // the contents fit inside the window with the margins:
    var contents = $(".contents", win);
    var w = win.width();
    var h = win.height();
    var l = parseInt(contents.css('margin-left'), 10);
    var r = parseInt(contents.css('margin-right'), 10);
    var t = parseInt(contents.css('margin-top'), 10);
    var b = parseInt(contents.css('margin-bottom'), 10);
    contents.css( {'width':w - l - r, 'height':h - t - b, 'left':l, 'top':t,
            'margin-left':0, 'margin-right':0, 'margin-top':0, 'margin-bottom':0});
}

// Register all windows at startup:
$(function() {
    $(".toolWindow").each(function() { registerToolWindow(this); });
});
