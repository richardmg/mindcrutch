<html>
    <script>
        $(function() {
            setupPalette(app.canvas);
            app.canvas.doubleClickCallback = function() { $("#paletteWindow").toggleModal(); };
        });
    </script>

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
