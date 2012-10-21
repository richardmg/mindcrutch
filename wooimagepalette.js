function drawLayers()
{
    context.canvas.width = context.canvas.width;
    for (var i in layers) {
        var layer = layers[i];
        context.translate(layer.x, layer.y);
        context.rotate(10);
        context.drawImage(layer.image, 0, 0);
        context.translate(-layer.x, -layer.y);
    }
}

function WooLayer(url) {
    layers.push(this);
    this.url = url;
    this.x = 300;
    this.y = 200;
    this.rotation = 0;
    this.scale = 1;
    this.image = new Image();
    this.image.onload = drawLayers;
    this.image.src = url;
}

function initImagePalette()
{
    layers = new Array;

    canvas = $(".WooCanvas");
    canvas[0].width = canvas.width();
    canvas[0].height = canvas.height();
    context = canvas[0].getContext('2d');
    var mousedown = false;

    canvas.on("mousedown", function() {
            // Find which layer clicked:
            var layer = layers[0];
            mousedown = true;
    });
    canvas.on("mouseup", function() {
            mousedown = false;
    });

    canvas.on("mousemove", function() {
        if (mousedown)
            console.log("mouse move");
    });
}

function loadImagesFromGoogle(searchString, targetSel, callback)
{
    var rsz = 8
    for (var start=0; start<(5*rsz); start+=rsz) {
        //https://developers.google.com/image-search/v1/jsondevguide#basic
        //var url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgtype=clipart&imgsz=small&rsz=8&q=" + searchString + "&callback=?";
        var url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgsz=small&rsz="
            + rsz + "&q=" + searchString + "&start=" + start + "&callback=?";

        //var url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&imgtype=clipart&imgcolor=brown&rsz=8&q=" + searchString + "&callback=?";
        $.getJSON(url, function(json) {
                //console.log("Return:" + JSON.stringify(json));
                $(targetSel).each(function() {
                    var view = $(this);
                    for (var i in json.responseData.results) {
                        var r = json.responseData.results[i];
                        var e = $("<div class='thumbnail'><img src='" + r.tbUrl + "'></img></div>");
                        view.append(e);
                        (function(){
                            var r2 = r;
                            $(e).on("mousedown", function() {callback.thumbnailPressed(r2)});
                        })();
                    }
                    callback.cursor(json.responseData.cursor);
                });
        });
    }
}
