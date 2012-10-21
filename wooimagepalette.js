
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
