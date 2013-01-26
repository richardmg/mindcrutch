<html>
    <head>
    <script src="menu.js"></script>
    <script>
        function setupPalette()
        {
            searchProps = {searchString:"zombies", imgtype:"clipart", imgsz:"medium"};
            $(".searchMenu").createMenu();

            paletteCallback = {
                thumbnailPressed: function(result)
                {
                    app.canvas.addLayer({url:result.url, rotation:Math.PI/8});
                    $("#paletteWindow").toggle(false);
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

            updatePalette();
        }

        $(function() {
            setupPalette();
            app.canvas.doubleClickCallback = function() { $("#paletteWindow").toggleModal(); };
        });
    </script>
    </head>

<body>
    <div id="paletteWindow" class="modalWindow">
        <div class="contents horizontalCenter" style="width:640px;height:480px;">
            <table style="width:100%;height:100%">
                <tr><td><input id="imageSearchInput" type="text" value="zombies" onchange="setSearchString(this.value)" style="display:block;width:100%"></input></td></tr>
                <tr><td class="searchMenu">
                    <div id="imageSize" class="menuItem" subMenu="#imageSizeMenu">medium</div>
                    <div id="imageType" class="menuItem" subMenu="#clipartMenu">clipart</div>
                    <div id="imageColor" class="menuItem" subMenu="#colorsMenu">all colors</div>

                    <div id="imageSizeMenu" class="normalWindow popup" props="{relX:0, relY:25}">
                        <div class="contents">
                            <div class="menuItem" onmousedown="setImageSize('?')">all sizes</div>
                            <div class="menuItem" onmousedown="setImageSize('icon')">icon</div>
                            <div class="menuItem" onmousedown="setImageSize('small')">small</div>
                            <div class="menuItem" onmousedown="setImageSize('medium')">medium</div>
                            <div class="menuItem" onmousedown="setImageSize('large')">large</div>
                            <div class="menuItem" onmousedown="setImageSize('xlarge')">xlarge</div>
                            <div class="menuItem" onmousedown="setImageSize('xxlarge')">xxlarge</div>
                            <div class="menuItem" onmousedown="setImageSize('huge')">huge</div>
                        </div>
                    </div>

                    <div id="clipartMenu" class="normalWindow popup" props="{relX:0, relY:25}">
                        <div class="contents">
                            <div class="menuItem" onmousedown="setImageType('?')">all images</div>
                            <div class="menuItem" onmousedown="setImageType('faces')">faces</div>
                            <div class="menuItem" onmousedown="setImageType('photo')">photo</div>
                            <div class="menuItem" onmousedown="setImageType('clipart')">clipart</div>
                            <div class="menuItem" onmousedown="setImageType('lineart')">lineart</div>
                        </div>
                    </div>

                    <div id="colorsMenu" class="normalWindow popup" props="{relX:0, relY:25}">
                        <div class="contents">
                            <div class="menuItem" onmousedown="setImageColor('?')">all colors</div>
                            <div class="menuItem" onmousedown="setImageColor('black/white')">black/white</div>
                            <div class="menuItem" onmousedown="setImageColor('black')">black</div>
                            <div class="menuItem" onmousedown="setImageColor('white')">white</div>
                            <div class="menuItem" onmousedown="setImageColor('blue')">blue</div>
                            <div class="menuItem" onmousedown="setImageColor('gray')">gray</div>
                            <div class="menuItem" onmousedown="setImageColor('green')">green</div>
                            <div class="menuItem" onmousedown="setImageColor('orange')">orange</div>
                            <div class="menuItem" onmousedown="setImageColor('pink')">pink</div>
                            <div class="menuItem" onmousedown="setImageColor('purple')">purple</div>
                            <div class="menuItem" onmousedown="setImageColor('red')">red</div>
                            <div class="menuItem" onmousedown="setImageColor('teal')">teal</div>
                            <div class="menuItem" onmousedown="setImageColor('yellow')">yellow</div>
                        </div>
                    </div>
                </td></tr>
                </tr><tr><td style="height:100%">
                    <div id="searchResult" style="height:100%;overflow:auto"></div>
                </td></tr>
            </table>
        </div>
    </div>
</body>
</html>
