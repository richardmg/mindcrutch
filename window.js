$.fn.centerIn = function (e) {
    // Center each div on the page:
    // E.g $("Div").centerIn(window);
    return this.each(function(){
        var $this = $(this);
        var $e = $(e);
        $this.css("position","absolute");
        $this.css("top", Math.max(0, (($e.height() - $this.outerHeight()) / 2) + $e.scrollTop()) + "px");
        $this.css("left", Math.max(0, (($e.width() - $this.outerWidth()) / 2) + $e.scrollLeft()) + "px");
    });
}

$.fn.fullscreen = function () {
    // Center each div on the page:
    return this.each(function(){
        var $this = $(this);
        $this.css("position","absolute");
        $this.css("x", 0);
        $this.css("y", 0);
        $this.css("width", $(window).width());
        $this.css("height", $(window).height());
    });
}

$.fn.redefineMargins = function() {
    // Since adding margins and paddings to an element makes it bigger
    // than 100%, this helper code makes the element fill the size
    // of the parent including its margins (if width/height is set to 0):
    return this.each(function() {
        var $this = $(this);
        if ($this.width() == 0) {
            var w = $this.parent().width();
            var l = parseInt($this.css('margin-left'), 10);
            var r = parseInt($this.css('margin-right'), 10);
            $this.css({'left':l, 'width':w-l-r, 'margin-left':0, 'margin-right':0});
        }
        if ($this.height() == 0) {
            var h = $this.parent().height();
            var t = parseInt($this.css('margin-top'), 10);
            var b = parseInt($this.css('margin-bottom'), 10);
            $this.css({'top':t, 'height':h-t-b, 'margin-top':0, 'margin-bottom':0});
        }
    });
}

$.fn.createWooWindow = function() {
    return this.each(function() {
        var $this = $(this);
        window.activeWindow = $this;
        $this.mousedown(function() { 
            if ($this != window.activeWindow && $this.attr("autoraise") != "false") {
                $("body").append($this);
                window.activeWindow = $this;
            }
        });

        // Create frame div in which we place a canvas. We need o extra div
        // around the canvas so that the canvas gets clipped to the rounded corners:
        var frame = $("<div class='frame'></div>");
        var canvas = $("<canvas class='headerCanvas' height=30px width=" + $this.width() + "px</canvas>");
        $this.append(frame);
        frame.append(canvas);

        if ($this.attr("draggable") != "false") {
            frame.css("cursor", "move");
            $(".header", $this).css("cursor", "move");
            //$this.draggable({cancel:".contents"});
        }

        // Draw the header background:
        var context = canvas[0].getContext('2d');
        var gradient = context.createLinearGradient(0, 0, 0, canvas.height());
        gradient.addColorStop(0.0, "rgba(180, 180, 180, 0.3)");
        gradient.addColorStop(0.4, "rgba(50, 50, 50, 0.3)");
        gradient.addColorStop(1.0, "rgba(20, 20, 20, 0.0)");
        context.fillStyle = gradient;
        context.fillRect(0, 0, canvas.width(), canvas.height());

        $(".header, .contents", $this).redefineMargins();
    });
}
