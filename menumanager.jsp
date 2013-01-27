<html>
<head>
    <script>
        function MenuManager()
        {
            function Menu(rootNode, props)
            {
                var this_menu = this;
                var props = props || {relX:0, relY:0, fadeout:150, delay:300};
                var openMenus = new Array();

                $(".menuItem", rootNode).each(function() { setupMenuItem(this, $(rootNode)); });

                function setupMenuItem(menuItem, $parentSubMenu) {
                    var $menuItem = $(menuItem);
                    var url = $menuItem.attr("url");
                    if (url)
                        $menuItem.click(function() { window.location.href = url; });

                    var subMenuSel = $menuItem.attr("subMenu");
                    if (subMenuSel) {
                        // This menu item has a sub menu. Make
                        // the item open the sub menu on hover:
                        // inside the sub menu:
                        var $subMenu = $(subMenuSel);
                        $subMenu.css("display", "none")
                        $menuItem.hover(
                            function() { openMenu($menuItem, $subMenu, $parentSubMenu) },
                            function() { closeMenu($menuItem, $subMenu) }
                        );
                        $subMenu.hover(
                            function() { openMenu($menuItem, $subMenu, $parentSubMenu) },
                            function() { closeMenu($menuItem, $subMenu) }
                        );

                        // Recursively traverse all items in the sub menu:
                        $(".menuItem", $subMenu).each(function() { setupMenuItem(this, $subMenu); });
                    }
                }

                function openMenu($menuItem, $subMenu, $parentSubMenu)
                {
                    clearTimeout(this_menu.menuTimer);

                    var level = 0;
                    if ($parentSubMenu) {
                        var parentInfo = $parentSubMenu.data("subMenuInfo");
                        if (parentInfo)
                            level = parentInfo.level + 1;
                    }
                    
                    var topMenu = openMenus[openMenus.length - 1];
                    if (topMenu) {
                        var prevLevel = topMenu.level;
                        if (level == prevLevel) {
                            // close sibling sub menu;
                            topMenu.$subMenu.hide();
                            topMenu.$subMenu.data("subMenuInfo", undefined);
                            topMenu.$menuItem.removeClass("subMenuOpen");
                            openMenus.pop();
                        } else if (level < prevLevel) {
                            // open other root menu, close all sub menus:
                            for (var i in openMenus) {
                                var m = openMenus[i];
                                m.$subMenu.hide();
                                m.$subMenu.data("subMenuInfo", undefined);
                                m.$menuItem.removeClass("subMenuOpen");
                            }
                            openMenus = [];
                        }
                    }

                    var p = eval ("(" + $subMenu.attr('props') + ")");
                    if (p) {
                        if (p.hasOwnProperty("relX")) {
                            var x = $menuItem.offset().left + p.relX;
                            x = Math.min(x, $(document).width() - $subMenu.width());
                            $subMenu.css("left", x);
                        }
                        if (p.hasOwnProperty("relY")) {
                            var y = $menuItem.offset().top + p.relY;
                            y = Math.min(y, $(document).height() - $subMenu.height());
                            $subMenu.css("top", y);
                        }
                    }

                    var info ={
                        $subMenu: $subMenu,
                        $menuItem: $menuItem,
                        closeRequest: false,
                        level:level
                    };
                    openMenus.push(info);
                    $subMenu.data("subMenuInfo", info);

                    $menuItem.addClass("subMenuOpen");
                    $subMenu.stop(true, true);
                    $("body").append($subMenu);
                    $subMenu.show();
                }

                function closeMenu($menuItem, $subMenu)
                { 
                    $subMenu.data("subMenuInfo").closeRequest = true;

                    clearTimeout(this_menu.menuTimer);
                    this_menu.menuTimer = setTimeout(function() {
                        var m = openMenus.pop();
                        while (m && m.closeRequest) {
                            m.$subMenu.hide(props.fadeout);
                            m.$subMenu.data("subMenuInfo", undefined);
                            m.$menuItem.removeClass("subMenuOpen");
                            m = openMenus.pop();
                        }
                    }, props.delay);
                }
            }

            $(".menu").each(function() {
                var p = eval ("(" + $(this).attr('props') + ")");
                $.data(this, "menu", new Menu(this, p));
            });
        }
    </script>

    <style>
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
</html>
