<html>
    <head>
    <script src="menu.js"></script>
    <script>
        function Palette()
        {
            var this_palette = this;
            this.$result = $("#searchResult");
            this.$paletteWindow = $("#paletteWindow");
            this.searchProps = {searchString:"zombies", imgtype:"clipart", imgsz:"medium"};

            this.updatePalette = function()
            {
                this.$result.empty()
                this.executeSearch();
            }

            this.setSearchString = function(value)
            {
                this.searchProps.searchString = value;
                this.updatePalette();
            }

            this.setImageType = function(value)
            {
                this.searchProps.imgtype = value;
                this.updatePalette();
                $(".menuItem#imageType").text(value == "?" ? "all images" : value);
            }

            this.setImageSize = function(value)
            {
                this.searchProps.imgsz = value;
                this.updatePalette();
                $(".menuItem#imageSize").text(value == "?" ? "all sizes" : value);
            }

            this.setImageColor = function(value)
            {
                if (value == "black/white") {
                    this.searchProps.imgc = "gray";
                    this.searchProps.imgcolor = "?";
                    $(".menuItem#imageColor").text(value);
                } else {
                    this.searchProps.imgc = "color";
                    this.searchProps.imgcolor = value;
                    $(".menuItem#imageColor").text(value == "?" ? "all colors" : value);
                }
                this.updatePalette();
            }

            this.executeSearch = function()
            {
                var rsz = 8
                this.searchProps.imgsz = this.searchProps.imgsz || "?";
                this.searchProps.imgcolor = this.searchProps.imgcolor || "?";
                this.searchProps.imgtype = this.searchProps.imgtype || "?";
                this.searchProps.imgc = this.searchProps.imgc || "?";

                for (var start=0; start<(7*rsz); start+=rsz) {
                    var url = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0" +
                        "&rsz=" + rsz + "&q=" + this.searchProps.searchString + "&start=" + start + "&callback=?" +
                        "&imgsz=" + this.searchProps.imgsz + "&imgtype=" + this.searchProps.imgtype + "&imgcolor=" + this.searchProps.imgcolor + "&imgc=" + this.searchProps.imgc +
                        "&userip=84.208.230.46";

                    $.getJSON(url, function(json) {
                        //console.log("Return:" + JSON.stringify(json));
                        for (var i in json.responseData.results) {
                            var r = json.responseData.results[i];
                            var e = $("<div class='thumbnail'><img src='" + r.tbUrl + "'></img></div>");
                            this_palette.$result.append(e);
                            (function(){
                                var r2 = r;
                                $(e).on("mousedown", function() { this_palette.callback.thumbnailPressed(r2); });
                            })();
                        }
                        this_palette.callback.cursor(json.responseData.cursor);
                    });
                }
            }

            this.updatePalette();
        }
    </script>

    <style>
        #paletteWindow .contents {
            margin-top:20px;
        }
        .thumbnail {
            height: 60px;
            margin-right: 0px;
            margin-bottom: 0px;
            vertical-align: top;
            border: 2px solid #202020;
            display: inline-block;
            border-radius: 6px;
            overflow: hidden;
        }
        .thumbnail img {
            height: 60px;
        }
        .thumbnail:hover {
            border: 2px solid #ffffff;
        }
        .menuItem {
            padding: 5px;
            font: 15px verdana;
            color: #ffbb00;
            cursor: default;
        }
        .menuItem:hover, .subMenuOpen {
            color: #ffffff;
        }
    </style>
</head>

<body>
    <div id="paletteWindow" class="modalWindow">
        <div class="contents horizontalCenter" style="width:640px;height:480px;">
            <table class="menu" style="width:100%;height:100%;">
                <tr>
                    <td style="width:99%"><input id="imageSearchInput" type="text" value="zombies" onchange="app.palette.setSearchString(this.value)" style="width:100%"></input></td>
                    <td nowrap><div id="imageSize" class="menuItem" subMenu="#imageSizeMenu">medium</div></td>
                    <td nowrap><div id="imageType" class="menuItem" subMenu="#clipartMenu">clipart</div></td>
                    <td nowrap><div id="imageColor" class="menuItem" subMenu="#colorsMenu">all colors</div></td>
                </tr>
                <tr>
                    <td style="height:100%" colspan=4>
                        <div id="searchResult" style="height:100%;overflow:auto"></div>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <!-- sub menu windows -->

    <div id="imageSizeMenu" class="normalWindow popup" props="{relX:0, relY:25}">
        <div class="contents">
            <div class="menuItem" onmousedown="app.palette.setImageSize('?')">all sizes</div>
            <div class="menuItem" onmousedown="app.palette.setImageSize('icon')">icon</div>
            <div class="menuItem" onmousedown="app.palette.setImageSize('small')">small</div>
            <div class="menuItem" onmousedown="app.palette.setImageSize('medium')">medium</div>
            <div class="menuItem" onmousedown="app.palette.setImageSize('large')">large</div>
            <div class="menuItem" onmousedown="app.palette.setImageSize('xlarge')">xlarge</div>
            <div class="menuItem" onmousedown="app.palette.setImageSize('xxlarge')">xxlarge</div>
            <div class="menuItem" onmousedown="app.palette.setImageSize('huge')">huge</div>
        </div>
    </div>

    <div id="clipartMenu" class="normalWindow popup" props="{relX:0, relY:25}">
        <div class="contents">
            <div class="menuItem" onmousedown="app.palette.setImageType('?')">all images</div>
            <div class="menuItem" onmousedown="app.palette.setImageType('faces')">faces</div>
            <div class="menuItem" onmousedown="app.palette.setImageType('photo')">photo</div>
            <div class="menuItem" onmousedown="app.palette.setImageType('clipart')">clipart</div>
            <div class="menuItem" onmousedown="app.palette.setImageType('lineart')">lineart</div>
        </div>
    </div>

    <div id="colorsMenu" class="normalWindow popup" props="{relX:0, relY:25}">
        <div class="contents">
            <div class="menuItem" onmousedown="app.palette.setImageColor('?')">all colors</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('black/white')">black/white</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('black')">black</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('white')">white</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('blue')">blue</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('gray')">gray</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('green')">green</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('orange')">orange</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('pink')">pink</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('purple')">purple</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('red')">red</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('teal')">teal</div>
            <div class="menuItem" onmousedown="app.palette.setImageColor('yellow')">yellow</div>
        </div>
    </div>
</body>
</html>
