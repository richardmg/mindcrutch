<html>
<head>
<script>
    function WindowManager()
    {
        $.fn.centerHorizontallyIn = function (e) {
            return this.each(function(){
                var $this = $(this);
                var $e = $(e);
                var l = parseInt($this.css('margin-left'), 10);
                var ol = $e.offset() ? $e.offset().left : 0;
                $this.css("position","fixed");
                $this.css("left", Math.max(0, (($e.width() - $this.outerWidth()) / 2) + ol) + l + "px");
            });
        }
        $.fn.centerVerticallyIn = function (e) {
            return this.each(function(){
                var $this = $(this);
                var $e = $(e);
                var t = parseInt($this.css('margin-top'), 10);
                var ot = $e.offset() ? $e.offset().top : 0;
                $this.css("position","fixed");
                $this.css("top", Math.max(0, (($e.height() - $this.outerHeight()) / 2) + ot) + t + "px");
            });
        }

        $.fn.alignToBottom = function (e) {
            return this.each(function(){
                var $this = $(this);
                var $e = $(e);
                var t = parseInt($this.css('margin-top'), 10);
                var ot = $e.offset() ? $e.offset().top : 0;
                $this.css("position","fixed");
                $this.css("top", Math.max(0, $e.height() + t + ot - $this.outerHeight()) + "px");
            });
        }

        $.fn.fullscreen = function () {
            return this.each(function(){
                var $this = $(this);
                var w = $(window).width();
                var h = $(window).height();
                var l = parseInt($this.css('margin-left'), 10);
                var r = parseInt($this.css('margin-right'), 10);
                var t = parseInt($this.css('margin-top'), 10);
                var b = parseInt($this.css('margin-bottom'), 10);
                $this.css({'position':'fixed', 'left':l, 'width':w-l-r, 'top':t, 'height':h-t-b,
                    'margin-top':0, 'margin-bottom':0, 'margin-left':0, 'margin-right':0});
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

        $.fn.toggleModal = function(show) {
            return this.fullscreen().toggle(show);
        }

        $.fn.createWindow = function() {
            return this.each(function() {
                var $this = $(this);
                window.activeWindow = $this;
                $this.mousedown(function() { 
                    if ($this != window.activeWindow && $this.attr("autoraise") != "false") {
                        $("body").append($this);
                        window.activeWindow = $this;
                    }
                });

                var frame = $("<div class='frame'></div>");
                $this.append(frame);

                if ($(".titlebar", $this).length !== 0) {
                    // Create frame div in which we place a canvas. We need o extra div
                    // around the canvas so that the canvas gets clipped to the rounded corners:
                    var canvas = $("<canvas class='titlebarCanvas' height=30px width=" + $this.width() + "px</canvas>");
                    frame.append(canvas);
                    var context = canvas[0].getContext('2d');
                    var gradient = context.createLinearGradient(0, 0, 0, canvas.height());
                    gradient.addColorStop(0.0, "rgba(180, 180, 180, 0.3)");
                    gradient.addColorStop(0.4, "rgba(50, 50, 50, 0.3)");
                    gradient.addColorStop(1.0, "rgba(20, 20, 20, 0.0)");
                    context.fillStyle = gradient;
                    context.fillRect(0, 0, canvas.width(), canvas.height());
                }

                if ($this.attr("draggable") != "false") {
                    frame.css("cursor", "move");
                    $(".titlebar", $this).css("cursor", "move");
                    //$this.draggable({cancel:".contents"});
                }
                $(".titlebar, .contents", $this).redefineMargins();
            });
        }

        $(".modalWindow").fullscreen().mousedown(function(e) { 
            // Click on window canvas to close the window:
            if (e.target == this)
                $(this).toggle(false);
        });

        $(".normalWindow, .modalWindow")
            .createWindow()
            .disableSelection()
            .on("dragstart", function(e) { e.preventDefault(); })

        $(".horizontalCenter").each(function() {
            var $this = $(this);
            var $res = $this.parents(".normalWindow, .modalWindow");
            var parent = $res.length > 0 ? $res[0] : window;
            $(this).centerHorizontallyIn(parent);
        });

        $(".verticalCenter").each(function() {
            var $this = $(this);
            var $res = $this.parents(".normalWindow, .modalWindow");
            var parent = $res.length > 0 ? $res[0] : window;
            $(this).centerVerticallyIn(parent);
        });
    }
</script>

<style>
    .normalWindow {
        position: fixed;
        width: 320;
        height: 240;
    }

    .normalWindow .frame {
        width: 100%;
        height: 100%;
        overflow: hidden;
        border-radius: 5px;
        background-image: url("img/transparent95.png");
        box-shadow: -6px 6px 8px -5px #202020;
        -moz-box-shadow: -6px 6px 8px -5px #202020;
        -webkit-box-shadow: -6px 6px 8px -5px #202020;
    }

    .normalWindow .titlebar {
        position: absolute;
        width: 0px;
        height: 17px;
        margin-top:8;
        margin-right:10px;
        margin-left:10px;
        color: #b0b0b0;
        font: 12px verdana;
    }

    .normalWindow .contents {
        position: absolute;
        width: 0px;
        height: 0px;
        margin-top:13px;
        margin-bottom:13px;
        margin-right:13px;
        margin-left:10px;
        color: white;
    }

    .popup {
        z-index: 100;
        width: 200px;
        height: 400px;
        //background-image: -webkit-gradient(radial, 50% 50%, 30, 50% 50%, 20, from(rgba(0, 0, 0, 0.8)), to(rgba(80, 80, 90, 0.8)));
    }

    .modalWindow {
        display: none;
        background-image: -webkit-gradient(radial, 50% 20%, 30, 50% 20%, 600, from(rgba(80, 80, 90, 0.6)), to(rgba(0, 0, 0, 0.9)));
        border-radius: 0px;
        z-index: 90;
    }

    .modalWindow .contents {
        margin-top:8px;
    }
</style>
</head>
</html>
