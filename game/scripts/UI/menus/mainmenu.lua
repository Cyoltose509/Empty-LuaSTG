---主菜单设计

mainmenu = stage.New("main", false, true)
function mainmenu:init()
    lastmenu = self

    FUNDAMENTAL_MENU = self
    mask_fader:Do("open")
end
function mainmenu:frame()

end
function mainmenu:render()

    SetViewMode "ui"
    ui:RenderText("big_text", "这是标题画面",
            480, 270, 1, Color(255, 255, 255, 255),"centerpoint")
end

