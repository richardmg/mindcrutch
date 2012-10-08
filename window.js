
function redefineMargins(node)
{
    // Since adding margins and paddings to a node makes it bigger
    // than 100%, this helper code makes the node fill the size
    // of the parent including its margins (if width/height is set to 0):
    var o = $(node);
    if (o.width() == 0) {
        var w = o.parent().width();
        var l = parseInt(o.css('margin-left'), 10);
        var r = parseInt(o.css('margin-right'), 10);
        o.css({'left':l, 'width':w-l-r, 'margin-left':0, 'margin-right':0});
    }
    if (o.height() == 0) {
        var h = o.parent().height();
        var t = parseInt(o.css('margin-top'), 10);
        var b = parseInt(o.css('margin-bottom'), 10);
        o.css({'top':t, 'height':h-t-b, 'margin-top':0, 'margin-bottom':0});
    }
}

function createToolWindow(node) {
    var win = $(node);
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
    gradient.addColorStop(1.0, "rgba(20, 20, 20, 0.0)");
    context.fillStyle = gradient;
    context.fillRect(0, 0, canvas.width, canvas.height);

    $(".header, .contents", win).each(function() { redefineMargins(this); });
}

// Register all windows at startup:
$(function() {
    $(".toolWindow").each(function() { createToolWindow(this); });
});
