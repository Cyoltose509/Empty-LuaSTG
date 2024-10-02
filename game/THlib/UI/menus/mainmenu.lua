---主菜单设计

mainmenu = stage.New("main", false, true)
function mainmenu:init()
    lastmenu = self

    FUNDAMENTAL_MENU = self
    mask_fader:Do("open")
    if scoredata.version ~= ui.version then
        --更新版本初始化
        scoredata.version = ui.version
    end
    do
        local d = os.date("*t")
        local date = os.time({ day = d.day, month = d.month, year = d.year })
        if date - scoredata.LastLoginDate >= 172800 then
            scoredata.ContinuousLogin = 1
        elseif date - scoredata.LastLoginDate >= 86400 then
            scoredata.ContinuousLogin = scoredata.ContinuousLogin + 1
        end
        scoredata.LastLoginDate = date
    end--登录天数计算


end
function mainmenu:frame()

end
function mainmenu:render()

    SetViewMode "ui"
end

