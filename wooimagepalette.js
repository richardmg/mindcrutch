function setupPalette()
{
    searchProps = {searchString:"zombies", imgtype:"clipart", imgsz:"medium"};

    paletteCallback = {
        thumbnailPressed: function(result)
        {
            canvas.addLayer({url:result.url, rotation:Math.PI/8});
        },
        cursor: function(cursor)
        {
            console.log("Search count: " + cursor.resultCount);
        }
    };

    updatePalette = function()
    {
        $("#searchResult")
        .empty()
        .fillWithGoogleImages(searchProps, paletteCallback);
    }

    setSearchString = function(value)
    {
        searchProps.searchString = value;
        updatePalette();
    }

    setImageType = function(value)
    {
        searchProps.imgtype = value;
        updatePalette();
        $(".menuItem#imageType").text(value == "?" ? "all images" : value);
    }

    setImageSize = function(value)
    {
        searchProps.imgsz = value;
        updatePalette();
        $(".menuItem#imageSize").text(value == "?" ? "all sizes" : value);
    }

    setImageColor = function(value)
    {
        if (value == "black/white") {
            searchProps.imgc = "gray";
            searchProps.imgcolor = "?";
            $(".menuItem#imageColor").text(value);
        } else {
            searchProps.imgc = "color";
            searchProps.imgcolor = value;
            $(".menuItem#imageColor").text(value == "?" ? "all colors" : value);
        }
        updatePalette();
    }

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
}
