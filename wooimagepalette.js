
$.fn.fillWithGoogleImages = function(props, callback)
{
    var $plugin_this = this;
    var rsz = 8
    props.imgsz = props.imgsz || "?";
    props.imgcolor = props.imgcolor || "?";
    props.imgtype = props.imgtype || "?";
    props.imgc = props.imgc || "?";

    for (var start=0; start<(7*rsz); start+=rsz) {
        var url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0" +
            "&rsz=" + rsz + "&q=" + props.searchString + "&start=" + start + "&callback=?" +
            "&imgsz=" + props.imgsz + "&imgtype=" + props.imgtype + "&imgcolor=" + props.imgcolor + "&imgc=" + props.imgc +
            "&userip=84.208.230.46";

        $.getJSON(url, function(json) {
                //console.log("Return:" + JSON.stringify(json));
                $plugin_this.each(function() {
                    var view = $(this);
                    console.log(json);
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
    return this;
}
