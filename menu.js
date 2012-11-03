
function Menu(rootNode, props)
{
    var this_menu = this;
    var props = props || {relX:0, relY:0, fadeout:150, delay:300};
    var openMenus = new Array();
    setupMenuItem($(rootNode));

    function setupMenuItem(menuItem) {
        var url = menuItem.attr("url");
        if (url)
            menuItem.click(function() { window.location.href = url; });

        var subMenuSel = menuItem.attr("subMenu");
        if (subMenuSel) {
            // This menu item has a sub menu. Make
            // the item open the sub menu on hover:
            // inside the sub menu:
            var subMenu = $(subMenuSel);
            subMenu.css("display", "none")
            menuItem.hover(
                function() { openMenu(menuItem, subMenu) },
                function() { closeMenu(menuItem, subMenu) }
            );
            subMenu.hover(
                function() { openMenu(menuItem, subMenu) },
                function() { closeMenu(menuItem, subMenu) }
            );

            // Recursively traverse all items in the sub menu:
            $("div", subMenu).each(function(index, innerItemNode) {
                    setupMenuItem($(innerItemNode));
            });
        }
    }

    function openMenu(menuItem, subMenu)
    {
        subMenu.data("hover", true);
        if (subMenu.data("menuOpen") === true)
            return;
        subMenu.data("menuOpen", true);

        var parentSub = menuItem.closest(".subMenu");
        var level = parentSub.length > 0 ? parentSub.data("level") + 1 : 0;
        subMenu.data("level", level);
        
        var topMenu = openMenus[openMenus.length - 1];
        if (topMenu && topMenu.data("level") === level) {
            topMenu.hide();
            topMenu.data("menuOpen", false);
            openMenus.pop();
        }

        openMenus.push(subMenu);
        var p = eval ("(" + subMenu.attr('props') + ")");
        if (p) {
            if (p.hasOwnProperty("relX")) {
                var x = menuItem.offset().left + p.relX;
                x = Math.min(x, $(document).width() - subMenu.width());
                subMenu.css("left", x);
            }
            if (p.hasOwnProperty("relY")) {
                var y = menuItem.offset().top + p.relY;
                y = Math.min(y, $(document).height() - subMenu.height());
                subMenu.css("top", y);
            }
        }
        subMenu.stop(true, true);
        $("body").append(subMenu);
        subMenu.show();
    }

    function closeMenu(menuItem, subMenu)
    { 
        subMenu.data("hover", false);
        clearTimeout(this_menu.menuTimer);
        this_menu.menuTimer = setTimeout(function() {
            var last = openMenus.pop();
            while (last && last.data("hover") === false) {
                last.hide(props.fadeout);
                last.data("menuOpen", false);
                last = openMenus.pop();
            }
            if (last && last.data("hover")) {
                openMenus.push(last);
                last.data("menuOpen", true);
            }
        }, props.delay);
    }
}

$.fn.createMenu = function()
{
    return this.each(function() {
        var p = eval ("(" + $(this).attr('props') + ")");
        $.data(this, "menu", new Menu(this, p));
    });
}

