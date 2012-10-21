//
// Usage:
// <div class="WooWindow" style="top:150px;left:500px;width:640px;height:400px;">
//    <div class="header">Your header</div>
//    <div class="contents">Your contents</div>
// </div>
//

function redefineMargins(element)
{
    // Since adding margins and paddings to an element makes it bigger
    // than 100%, this helper code makes the element fill the size
    // of the parent including its margins (if width/height is set to 0):
    var o = $(element);
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

function createWooWindow(element) {
    var win = $(element);
    window.activeWindow = win;
    // Make window draggable, and
    // let it pop to top on click':
    win.mousedown(function() { 
        if (win != window.activeWindow && win.attr("autoraise") != "false") {
            $("body").append(win);
            window.activeWindow = win;
        }
    });

    // Create frame div in which we place a canvas. We need this extra
    // div around the canvas so that the canvas gets clipped to the
    // rounded corners:
    var frame = $("<div class='frame'></div>");
    var canvas = $("<canvas class='headerCanvas' height=30px width=" + win.width() + "px</canvas>");
    win.append(frame);
    frame.append(canvas);

    if (win.attr("draggable") != "false") {
        frame.css("cursor", "move");
        $(".header", win).css("cursor", "move");
        win.draggable({cancel:".contents"});
    }

    // Draw the background as a gradient:
    var context = canvas[0].getContext('2d');
    var gradient = context.createLinearGradient(0, 0, 0, canvas.height());
    gradient.addColorStop(0.0, "rgba(180, 180, 180, 0.3)");
    gradient.addColorStop(0.4, "rgba(50, 50, 50, 0.3)");
    gradient.addColorStop(1.0, "rgba(20, 20, 20, 0.0)");
    context.fillStyle = gradient;
    context.fillRect(0, 0, canvas.width(), canvas.height());

    $(".header, .contents", win).each(function() { redefineMargins(this); });
}

// Register all windows at startup:
$(function() {
    $(".WooWindow").each(function() { createWooWindow(this); });
});
