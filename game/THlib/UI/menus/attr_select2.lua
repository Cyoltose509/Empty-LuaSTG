local PlayerSelect = {}
local SpellSelect = {}
local PlayerSelect_Submenu = {}
local SpellSelect_Submenu = {}

local function general_buttonFrame(self)
    local mouse = ext.mouse
    local x1, y1, x2, y2 = self.x - self.w * self.scale, self.x + self.w * self.scale, self.y - self.h * self.scale, self.y + self.h * self.scale
    if sp.math.PointBoundCheck(mouse.x, mouse.y, x1, y1, x2, y2) then
        self.index = self.index + (-self.index + 1) * 0.1
        if not self.selected then
            self.selected = true
        end
    else
        self.index = self.index - self.index * 0.1
        self.selected = false
    end
    if self.selected then
        if mouse:isUp(1) then
            self.index = self.index + 0.5
            PlaySound("ok00")
            self.func()
        end
    end
end
local function general_buttonRender(self, A)
    A = A or 1
    local k = self.index
    local blk = k * 40 + 200
    local x, y = self.x, self.y
    local s = (self.scale + k * 0.01)
    SetImageState("menu_button", "", A * 200, 200 - k * 50, 200, 200 - k * 50)
    Render("menu_button", x, y, 0, s * self.w / 230, s * self.h / 48)

    ui:RenderText("pretty_title", self.text, x, y + 0.5,
            1 + k * 0.05, Color(A * 200, blk - k * 50, blk, blk - k * 50), "centerpoint")
end

local function _t(str)
    return Trans("sth", str) or ""
end

attributeselectmenu2 = stage.New("attr_select2", false, true)

attributeselectmenu2.general_buttonFrame = general_buttonFrame
attributeselectmenu2.general_buttonRender = general_buttonRender
function attributeselectmenu2:init()
    self.top_bar = top_bar_Class(self, challenge_lib.class[lstg.var.challenge_select].title)
    self.top_bar:addReturnButton(function()
        self.exit_func()
    end)
    mainmenu:MusicInit()
    mask_fader:Do("open")
    PlayerSelect:init()
    SpellSelect:init()

    PlayerSelect_Submenu:init()
    SpellSelect_Submenu:init()
    self.exit_func = function()
        PlaySound("cancel00")
        task.New(self, function()
            self.locked = true
            mask_fader:Do("close")
            task.Wait(15)
            stage.Set("none", "challenge")
        end)
    end
    self.locked = true
    self.start_button = {
        x = 480, y = 45, index = 0,
        w = 230, h = 48,
        scale = 0.3,
        selected = false,
        text = _t("start"),
        func = function()
            task.New(self, function()
                self.locked = true
                lstg.var.player_select = stagedata.player_pos
                FUNDAMENTAL_MENU.music:FadeStop(15)
                mask_fader:Do("close")
                task.Wait(15)
                local ID = challenge_lib.class[lstg.var.challenge_select].inStageID
                stage.group.Start(stage.groups["Challenge" .. ID])
            end)
        end,
        frame = general_buttonFrame,
        render = general_buttonRender
    }
    task.New(self, function()
        task.Wait(30)
        while GetKeyState(KEY.Z) do
            task.Wait()
        end
        self.locked = false
    end)
end
function attributeselectmenu2:frame()
    PlayerSelect_Submenu:frame()
    SpellSelect_Submenu:frame()

    if self.locked then
        return
    end
    self.top_bar:frame()
    menu:Updatekey()
    if menu:keyYes() then
        self.start_button.func()
    end
    if menu:keyNo() then
        self.exit_func()
    end
    PlayerSelect:frame()
    SpellSelect:frame()
    self.start_button:frame()


end
function attributeselectmenu2:render()
    ui:DrawBack(1, self.timer)
    PlayerSelect:render()
    SpellSelect:render()
    self.start_button:render()
    self.top_bar:render()
    PlayerSelect_Submenu:render()
    SpellSelect_Submenu:render()

end

function PlayerSelect:init()
    self.x, self.y = 480, 270
    self.func = function()
        self.locked = true
        attributeselectmenu2.locked = true
        PlayerSelect_Submenu:In()
    end

    self.index = 0
    self.timer = 0
    self.r = 145
    self.selected = false
    self.list = player_list
    self.pos = stagedata.player_pos
    self.locked = false
    self.text = _t("selCharacter")
    self.show_alpha = 1
    self.back = "th08_13_n"
end
function PlayerSelect:SetPos(pos)
    pos = sp:TweakValue(pos, #self.list, 1)
    self.pos = pos
    stagedata.player_pos = pos
    SpellSelect:SetPos()

    task.New(self, function()
        self.show_alpha = 0
        for i = 1, 16 do
            self.show_alpha = task.SetMode[2](i / 16)
            task.Wait()
        end
    end)
end
function PlayerSelect:frame()
    task.Do(self)
    self.timer = self.timer + 1
    if self.locked then
        return
    end
    local mouse = ext.mouse
    if Dist(self.x, self.y, mouse.x, mouse.y) < self.r and not SpellSelect.selected then
        self.index = self.index + (-self.index + 1) * 0.1
        if not self.selected then
            self.selected = true
            PlaySound("select00")
        end
    else
        self.index = self.index - self.index * 0.1
        self.selected = false
    end
    if self.selected then
        local _wheel = mouse:getWheel()
        if _wheel ~= 0 then
            self.index = self.index + 0.5
            local t = -sign(_wheel)
            local pos = self.pos + t
            while true do
                local spos = sp:TweakValue(pos, #self.list, 1)
                if playerdata[player_list[spos].name].unlock_c then
                    self:SetPos(pos)
                    PlaySound("select00")
                    break
                end
                pos = pos + t
            end
        end
        if mouse:isUp(1) then
            self.index = self.index + 0.5
            PlaySound("ok00")
            self.func()
        end
    end
end
function PlayerSelect:render()
    local k = self.index
    local blk = k * 40 + 200
    local x, y = self.x, self.y
    local R = self.r + k * 6
    SetImageState("menu_circle", "", 255, 200 - k * 15, 200, 200 - k * 15)
    Render("menu_circle", x, y, 0, R / 192)
    ui:RenderText("pretty_title", self.text, x, y + R + 15,
            1.2, Color(200, blk - k * 15, blk, blk - k * 15), "centerpoint")
    ---@type PlayerUnit
    local punit = self.list[self.pos]
    local size = GetTextureSize(self.back)
    misc.RenderTexInCircle(self.back, x, y, size / 2, size / 2,
            R * 0.913, 0, 0.4, "",
            Color(self.show_alpha * (170 + k * 40), blk, blk, blk), 75)
    misc.RenderTexInCircle(punit.picture, x, y, punit.renderx, punit.rendery,
            R * 0.913, 0, punit.renderscale, "",
            Color(self.show_alpha * (200 + k * 40), blk, blk, blk), 75)
    ui:RenderText("title", ("Lv.%d"):format(playerdata[punit.name].level), x, y - R * 0.8,
            1.2, Color(255, 230, 230, 230), "centerpoint")
    local unlock_c = playerdata[punit.name].unlock_c or 0
    local t = (unlock_c - 1) / 2
    local star_num = 1
    for c = -t, t do
        local starscale = 0.2
        local _x, _y = x + c * 24, y - R * 0.65
        local img = "menu_player_star1"
        if playerdata[punit.name].choose_skill[star_num] then
            img = "menu_player_star3"
        end
        SetImageState(img, "mul+add", self.show_alpha * (180 + k * 40), 255, 255, 255)
        Render(img, _x, _y, 0, starscale * (0.9 + k * 0.1))
        star_num = star_num + 1
    end

end

function SpellSelect:init()
    self.x, self.y = 480 + 100, 270 - 125
    self.func = function()
        self.locked = true
        attributeselectmenu2.locked = true
        SpellSelect_Submenu:In()
    end
    self.index = 0
    self.timer = 0
    self.r = 50
    self.selected = false
    self.text = _t("selSpell")
    self.show_alpha = 1
    self:SetPos()
end
function SpellSelect:SetPos(pos)

    local pSelectPos = stagedata.player_pos
    ---@type PlayerUnit
    local p = player_list[pSelectPos]
    pos = pos or stagedata.spell_pos[pSelectPos]
    pos = sp:TweakValue(pos, #p.spells, 1)
    self.pos = pos
    stagedata.spell_pos[pSelectPos] = pos
    task.New(self, function()
        self.show_alpha = 0
        for i = 1, 16 do
            self.show_alpha = task.SetMode[2](i / 16)
            task.Wait()
        end
    end)
end
function SpellSelect:frame()
    self.timer = self.timer + 1
    local mouse = ext.mouse
    if Dist(self.x, self.y, mouse.x, mouse.y) < self.r then
        self.index = self.index + (-self.index + 1) * 0.1
        if not self.selected then
            self.selected = true
            PlaySound("select00")
        end
    else
        self.index = self.index - self.index * 0.1
        self.selected = false
    end
    if self.selected then
        local _wheel = mouse:getWheel()
        if _wheel ~= 0 then
            self.index = self.index + 0.5
            self:SetPos(self.pos - sign(_wheel))
            PlaySound("select00")
        end
        if mouse:isUp(1) then
            self.index = self.index + 0.5
            PlaySound("ok00")
            self.func()
        end
    end
end
function SpellSelect:render()
    local k = self.index
    local blk = k * 40 + 200
    local x, y = self.x, self.y
    local R = self.r + k * 6
    SetImageState("menu_circle", "", 255, 200 - k * 15, 200, 200 - k * 15)
    Render("menu_circle", x, y, 0, R / 192)

    local pSelectPos = stagedata.player_pos
    local p = player_list[pSelectPos]
    ---@type SpellUnit
    local sp = p.spells[self.pos]
    local img = sp.picture
    SetImageState(img, "", 255, 200, 200, 200)
    Render(img, x, y, 0, R / 192)

    ui:RenderText("pretty_title", self.text, x, y - R - 10,
            1, Color(200, blk - k * 15, blk, blk - k * 15), "centerpoint")
    ui:RenderText("title", ("Lv.%d"):format(playerdata[p.name].spells[self.pos]), x, y - R * 0.71,
            0.9, Color(255, 200, 200, 200), "centerpoint")
end

function PlayerSelect_Submenu:init()
    self.x, self.y = 300, 275
    self.w, self.h = 180, 200
    self.left_index = 0
    self.right_index = 0
    self.locked = true
    self.alpha = 0
    self.timer = 0
    self.list = player_list
    self.pos = stagedata.player_pos
    self.show_alpha = 1
    self.ok_button = {
        x = 480, y = 27, index = 0,
        w = 230, h = 48,
        scale = 0.3,
        selected = false,
        text = _t("yes"),
        func = function()

            if playerdata[player_list[self.pos].name].unlock_c then
                PlaySound("ok00")
                PlayerSelect:SetPos(self.pos)
                SpellSelect:SetPos()
                self:Out()
            else
                PlaySound("invalid")
                New(info, _t("unlockedCharacterWarning"), 90, 20)
            end

        end,
        frame = general_buttonFrame,
        render = general_buttonRender
    }
    self.upgrade_button = {
        x = 760, y = 147, index = 0,
        w = 230, h = 48,
        scale = 0.3,
        selected = false,
        text = _t("upgrade"),
        func = function()
            local punit = self.list[self.pos]
            local data = playerdata[punit.name]
            local level = data.level
            local money = self.upgrade_money[level]
            if scoredata.money >= money then
                PlaySound("extend")
                data.level = data.level + 1
                AddMoney(-money)
                attributeselectmenu2.top_bar:SetShowAddMoney(-money)
                PlayerAchievementCheck(punit)

            else
                New(info, _t("failUpgrade"), 90, 20)
            end
        end,
        frame = general_buttonFrame,
        render = general_buttonRender
    }
    self.upgrade_money = {
        300, 350, 380, 400, 500, 520, 540, 560, 600,
        750, 750, 850, 850, 950, 950, 1100, 1200, 1300, 1400
    }
    self.page = 1
    self.p_alpha1 = 1
    self.p_alpha2 = 0
    self.tri = { 0, 0, 0 }
    self.tri_index = { 0, 0, 0 }
    self.top_bar = top_bar_Class(self, _t("characterDetail"), true)
    self.top_bar:addReturnButton(function()
        self:Out()
    end)
end
function PlayerSelect_Submenu:In()
    PlaySound("select00")
    self.locked = false
    self.pos = stagedata.player_pos
    self.top_bar:flyIn()
    task.New(self, function()
        for i = 1, 16 do
            self.alpha = i / 16
            task.Wait()
        end
    end)

end
function PlayerSelect_Submenu:Out()

    task.New(self, function()
        self.top_bar:flyOut()
        self.locked = true
        PlayerSelect.locked = false
        attributeselectmenu2.locked = false
        for i = 1, 16 do
            self.alpha = 1 - i / 16
            task.Wait()
        end

    end)
end
function PlayerSelect_Submenu:SetPos(pos)
    pos = sp:TweakValue(pos, #self.list, 1)
    self.pos = pos
    task.New(self, function()
        self.show_alpha = 0
        for i = 1, 16 do
            self.show_alpha = task.SetMode[2](i / 16)
            task.Wait()
        end
    end)
end
function PlayerSelect_Submenu:frame()
    task.Do(self)
    self.timer = self.timer + 1
    self.top_bar:frame()
    if self.locked then
        return
    end

    menu:Updatekey()
    local mouse = ext.mouse
    if menu:keyNo() then
        PlaySound("cancel00")
        self:Out()
    end
    local _wheel = mouse:getWheel()
    local punit = self.list[self.pos]
    local level = playerdata[punit.name].level
    local data = playerdata[punit.name]
    local unlock = data.unlock_c
    if _wheel ~= 0 then
        local k = -sign(_wheel)
        self:SetPos(self.pos + k)
        if k > 0 then
            self.right_index = 1
        else
            self.left_index = 1
        end
        PlaySound("select00")
    end
    if mouse:isUp(1) then
        if mouse.y < 540 - 46 then
            if mouse.x > 960 - self.x + self.w then
                self.right_index = 1
                self:SetPos(self.pos + 1)
                PlaySound("select00")
            elseif mouse.x < self.x - self.w then
                self.left_index = 1
                self:SetPos(self.pos - 1)
                PlaySound("select00")
            end

            local x, y = self.x, self.y
            local w, h = self.w, self.h
            local x1, x2, y1, y2 = x - w, x + w, y - h, y + h
            local x3 = 960 - x + w
            local _x = (x2 + x3) / 2
            local y3 = y2 - 60
            local y6 = y1 + 45
            if sp.math.PointBoundCheck(mouse.x, mouse.y, x2, _x, y1, y6) then
                self.page = 1
                PlaySound("select00")
            elseif sp.math.PointBoundCheck(mouse.x, mouse.y, _x, x3, y1, y6) then
                self.page = 2
                PlaySound("select00")
            end
            local Y = y3 - 25
            if self.page == 2 and unlock then
                for i = 1, 3 do
                    if sp.math.PointBoundCheck(mouse.x, mouse.y, x2, x3, Y - 50, Y + 25) then
                        ---@type PlayerUnit
                        if data.unlock_c and data.unlock_c >= i then
                            data.choose_skill[i] = not data.choose_skill[i]

                            PlaySound("select00")
                        else
                            PlaySound("invalid")
                            New(info, _t("unlockedTalentWarning"), 90, 20)
                        end
                        self.tri_index[i] = 1
                        break

                    end
                    Y = Y - 75
                end
            end
        end
    end
    local p_alpha1 = (self.page == 1) and 1 or 0
    local p_alpha2 = (self.page == 2) and 1 or 0
    self.p_alpha1 = self.p_alpha1 + (-self.p_alpha1 + p_alpha1) * 0.3
    self.p_alpha2 = self.p_alpha2 + (-self.p_alpha2 + p_alpha2) * 0.3
    self.left_index = self.left_index - self.left_index * 0.1
    self.right_index = self.right_index - self.right_index * 0.1
    for i = 1, 3 do

        local tri = 0
        if data.choose_skill[i] then
            tri = 1
        end
        self.tri[i] = self.tri[i] + (-self.tri[i] + tri) * 0.3
        self.tri_index[i] = self.tri_index[i] - self.tri_index[i] * 0.1
    end
    self.ok_button:frame()

    if self.upgrade_money[level] and self.page == 1 and unlock then
        self.upgrade_button:frame()
    end
end
function PlayerSelect_Submenu:render()
    local A = self.alpha
    local A2 = self.show_alpha
    if A == 0 then
        return
    end
    local t = self.timer
    SetImageState("white", "", A * 240, 0, 0, 0)
    RenderRect("white", 0, 960, 0, 540)

    local x, y = self.x, self.y
    local w, h = self.w, self.h
    local x1, x2, y1, y2 = x - w, x + w, y - h, y + h
    local x3 = 960 - x + w
    local y3 = y2 - 60
    local y5 = y2 - 300
    SetImageState("white", "", A * 75, 0, 0, 0)
    RenderRect("white", x1, x2, y1, y2)

    ---@type PlayerUnit
    local punit = self.list[self.pos]
    local size = GetTextureSize(punit.picture)
    local unlock = playerdata[punit.name].unlock_c
    local scale = punit.renderscale
    local offx, offy = (-punit.renderx + size / 2), -60 + sin(t / 1.7) * 3
    misc.RenderTexInRect(punit.picture, x1, x2, y1, y2, offx, offy,
            0, scale, scale, "", Color(A * A2 * 200, 255, 255, 255))
    SetImageState("white", "", A * 180, 0, 0, 0)
    SetImageState("white", "", A * 255, 200, 200, 200)
    RenderRect("white", x2, x3, y3 - 1.5, y3 + 1.5)
    local mouse = ext.mouse

    do
        local english = setting.language == 2
        local ttf = english and "pretty" or "big_text"
        ui:RenderText(ttf, punit.display_name, (x2 + x3) / 2, (y2 + y3) / 2 - 2,
                0.8, Color(255 * A * A2, 189, 200 + sin(t / 2) * 20, 240), "centerpoint")
        ui:RenderText("pretty", punit.nickname, x3 - 7, y3 + 7,
                0.3, Color(255 * A * A2, 200, 200, 200), "right", "bottom")
    end

    do

        local pa1 = self.p_alpha1
        local pa2 = self.p_alpha2
        local _a1 = A * A2 * pa1
        local _a2 = A * A2 * pa2

        local level = playerdata[punit.name].level
        if level < 20 then
            local data1 = player_lib.GetAttributeByLevel(punit.class.attribute, level)
            level = level + 1
            local data2 = player_lib.GetAttributeByLevel(punit.class.attribute, level)
            for i, text in ipairs({
                { ("> %s"):format(_t("level")), ("§y§y§y%d / 20"):format(level - 1) },
                { ("> %s"):format(_t("maxlife")), ("§g%0.2f§d>§b%0.2f"):format(data1.hp, data2.hp) },
                { ("> %s"):format(_t("hitbox")), ("§g%0.2f§d>§b%0.2f"):format(data1.collisize, data2.collisize) },
                { ("> %s"):format(_t("luck")), ("§g%0.2f§d>§b%0.2f"):format(data1.luck, data2.luck) },
                { ("> %s"):format(_t("speed")), ("§g%0.2f / %0.2f§d>§b%0.2f / %0.2f"):format(data1.hspeed, data1.lspeed, data1.hspeed, data2.lspeed) },
                { ("> %s"):format(_t("atk")), ("§g%0.2f§d>§b%0.2f"):format(data1.dmg, data2.dmg) },
                { ("> %s"):format(_t("srange")), ("§g%d§d>§b%d"):format(data1.shoot_set_range, data2.shoot_set_range) },
                { ("> %s"):format(_t("sspeed")), ("§g%0.2f§d>§b%0.2f"):format(data1.shoot_set_speed, data2.shoot_set_speed) },
                { ("> %s"):format(_t("bvelocity")), ("§g%0.2f§d>§b%0.2f"):format(data1.shoot_set_bvelocity, data2.shoot_set_bvelocity) },
            }) do
                ui:RenderText("pretty_title", text[1], x2 + 5, y3 - 7 - (i - 1) * 26,
                        0.9, Color(_a1 * 255, 255, 255, 255), "left", "top")
                ui:RenderTextWithCommand("title", text[2], x3 + 7.5, y3 - 7 - (i - 1) * 26,
                        0.9, _a1 * 255, "right", "top")
            end
            level = level - 1
        else
            local data = player_lib.GetAttributeByLevel(punit.class.attribute, level)
            for i, text in ipairs({
                { ("> %s"):format(_t("level")), ("§y§y§y%d / 20"):format(level) },
                { ("> %s"):format(_t("maxlife")), ("§y§y§y%0.2f"):format(data.hp) },
                { ("> %s"):format(_t("hitbox")), ("§y§y§y%0.2f"):format(data.collisize) },
                { ("> %s"):format(_t("luck")), ("§y§y§y%0.2f"):format(data.luck) },
                { ("> %s"):format(_t("speed")), ("§y§y§y%0.2f / %0.2f"):format(data.hspeed, data.lspeed) },
                { ("> %s"):format(_t("atk")), ("§y§y§y%0.2f"):format(data.dmg) },
                { ("> %s"):format(_t("srange")), ("§y§y§y%d"):format(data.shoot_set_range) },
                { ("> %s"):format(_t("sspeed")), ("§y§y§y%0.2f"):format(data.shoot_set_speed) },
                { ("> %s"):format(_t("bvelocity")), ("§y§y§y%0.2f"):format(data.shoot_set_bvelocity) },
            }) do
                ui:RenderText("pretty_title", text[1], x2 + 5, y3 - 7 - (i - 1) * 26,
                        0.9, Color(_a1 * 255, 255, 255, 255), "left", "top")
                ui:RenderTextWithCommand("title", text[2], x3 + 7.5, y3 - 7 - (i - 1) * 26,
                        0.9, _a1 * 255, "right", "top")
            end
        end
        if self.upgrade_money[level] and unlock then
            ui:RenderText("pretty", ("%s %d"):format(_t("upgradeMoney"), self.upgrade_money[level]),
                    x2 + 7, self.upgrade_button.y + 3,
                    0.45, Color(230 * _a1, 255, 200, 200), "left", "vcenter")
            self.upgrade_button:render(_a1)
        end
        local Y = y3 - 25

        local kcharacters = { "1", "2", "3" }
        for i = 1, 3 do
            local des = punit.skill_describe[i]
            local unlock_c = playerdata[punit.name].unlock_c or 0
            local star_img = "menu_player_star1"
            local tR, tG, tB = 200, 200, 200
            local data2 = playerdata[punit.name]
            if unlock_c >= i then
                star_img = "menu_player_star3"
                tR, tG, tB = 255, 227, 132
                SetImageState("white", "mul+add", _a2 * 30, 255, 227, 132)
                RenderRect("white", x2, x3, Y - 50, Y + 25)
                for _i = -17, 17 do
                    for _j = -3, 3 do
                        local _x, _y = (x2 + x3) / 2 - 1.5 + _i * 10.1, Y - 12.5 + _j * 10
                        local s = min(1, (10 + self.tri[i] * 25) / Dist(_x, _y, mouse.x, mouse.y))

                        SetImageState("white", "mul+add", _a2 * (10 + s * 75), 255, 227, 132)
                        Render("white", _x, _y, 0, 0.3 + s * 0.1 + self.tri_index[i] * 0.2)
                    end
                end
            end

            ui:RenderText("pretty", ("%s%s  「%s」"):format(_t("talent"), _t(kcharacters[i]), des[1]), x2 + 40, Y + 5,
                    0.4, Color(_a2 * (200 + 55 * self.tri[i]), tR, tG, tB), "left", "vcenter")
            for k, str in ipairs(sp:SplitText(des[2], "\n")) do
                ui:RenderTextWithCommand("title", str, x2 + 40, Y - 10 - (k - 1) * 15,
                        0.7, _a2 * (155 + 55 * self.tri[i]), "left")
            end
            SetImageState("white", "", _a2 * 255, 200, 200, 200)
            RenderRect("white", x2, x3, Y - 50 - 1.5, Y - 50 + 1.5)
            SetImageState(star_img, "mul+add", _a2 * 200, 255, 255, 255)
            Render(star_img, x2 + 20, Y - 13, self.tri_index[i] * 90, 0.25)
            SetImageState("menu_circle", "", _a2 * 200, 200, 200, 200)
            Render("menu_circle", x3 - 50, Y - 13, 0, 0.16 + self.tri_index[i] * 0.02)
            if data2.choose_skill[i] then
                ui:RenderText("big_text", "●", x3 - 50, Y - 13 + 2,
                        self.tri[i], Color(_a2 * 185, 255, 227, 132), "centerpoint")
            end
            Y = Y - 75
        end
        SetImageState("white", "", _a1 * 255, 200, 200, 200)
        RenderRect("white", x2, x3, y5 - 1.5, y5 + 1.5)
        local y6 = y1 + 45
        SetImageState("white", "", A * 255, 200, 200, 200)
        RenderRect("white", x2, x3, y6 - 1, y6 + 1)
        RenderRect("white", (x2 + x3) / 2 - 1, (x2 + x3) / 2 + 1, y1, y6)
        local r, g, b = 255, 227, 132
        ui:RenderText("pretty", _t("attribute"),
                x2 * 3 / 4 + x3 * 1 / 4, (y1 + y6) / 2 + 2,
                0.5 + pa1 * 0.1, Color((150 + pa1 * 80) * A * A2, r, g, b), "centerpoint")
        ui:RenderText("pretty", _t("talent"),
                x2 * 1 / 4 + x3 * 3 / 4, (y1 + y6) / 2 + 2,
                0.5 + pa2 * 0.1, Color((150 + pa2 * 80) * A * A2, r, g, b), "centerpoint")
        misc.RenderBrightOutline(x2, (x2 + x3) / 2, y1, y6, 15,
                (sin(t * 3) * 30 + 60) * _a1, r, g, b)
        misc.RenderBrightOutline((x2 + x3) / 2, x3, y1, y6, 15,
                (sin(t * 3) * 30 + 60) * _a2, r, g, b)


    end--信息

    SetImageState("white", "", A * 255, 200, 200, 200)
    misc.RenderOutLine("white", x1, x2, y2, y1, 3, 0)
    misc.RenderOutLine("white", x2 - 3, x3, y2, y1, 3, 0)

    do
        local li, ri = self.left_index, self.right_index
        ui:RenderText("pretty", "<", x1 / 2 + sin(t * 3) * 5, 270,
                1.5 + li * 0.2, Color(A * 255, 255, 255 - li * 75, 255), "centerpoint")
        ui:RenderText("pretty", ">", (x3 + 960) / 2 - sin(t * 3) * 5, 270,
                1.5 + ri * 0.2, Color(A * 255, 255, 255 - ri * 75, 255), "centerpoint")
        local c = (#self.list - 1) / 2
        local k = 1
        for i = -c, c do
            local _unlock = playerdata[self.list[k].name].unlock_c
            local _size = _unlock and 1 or 0.6
            if self.pos == k then
                SetImageState("bright", "mul+add", A * A2 * 255, 255 - 30 * _size, 225 + 30 * _size, 225)
                Render("bright", 480 + i * 26, y1 - 16, 0, 0.07 * _size)
            end
            SetImageState("white", "", A * 150, 222, 222, 222)
            misc.SectorRender(480 + i * 26, y1 - 16, 6.7 * _size, 8.4 * _size, 0, 360, 6, t / 2)

            k = k + 1

        end
    end--选项渲染
    if not unlock then
        SetImageState("white", "", A * 85, 0, 0, 0)
        RenderRect("white", x1, x3, y1, y2)
    end
    self.ok_button:render(A)
    self.top_bar:render()
end

function SpellSelect_Submenu:init()
    self.x, self.y = 230, 270
    self.h = 120
    self.locked = true
    self.alpha = 0
    self.timer = 0
    local ppos = stagedata.player_pos
    self.list = player_list[ppos].spells
    self.pos = stagedata.spell_pos[ppos]
    self.indexs = {}
    for i in ipairs(self.list) do
        self.indexs[i] = 0
    end
    self.show_alpha = 1
    self.ok_button = {
        x = 480, y = 27, index = 0,
        w = 230, h = 48,
        scale = 0.3,
        selected = false,
        text = _t("yes"),
        func = function()
            PlaySound("ok00")
            SpellSelect:SetPos(self.pos)
            self:Out()
        end,
        frame = general_buttonFrame,
        render = general_buttonRender
    }
    self.upgrade_button = {
        x = 480, y = 141, index = 0,
        w = 230, h = 48,
        scale = 0.3,
        selected = false,
        text = _t("upgrade"),
        func = function()
            local spunit = self.list[self.pos]
            local name = spunit.belonging.name
            local sp = playerdata[name].spells
            local level = sp[self.pos]
            local money = self.upgrade_money[level]
            if scoredata.money >= money then
                PlaySound("extend")
                sp[self.pos] = sp[self.pos] + 1
                AddMoney(-money)
                attributeselectmenu2.top_bar:SetShowAddMoney(-money)
                SpellAchievementCheck(spunit)
            else
                New(info, _t("failUpgrade"), 90, 20)
            end
        end,
        frame = general_buttonFrame,
        render = general_buttonRender
    }
    self.upgrade_money = {
        200, 220, 240, 260, 300, 320, 340, 400, 600
    }
end
function SpellSelect_Submenu:In()
    PlaySound("select00")
    self.locked = false
    local ppos = stagedata.player_pos
    self.list = player_list[ppos].spells
    self.pos = stagedata.spell_pos[ppos]
    self.indexs = {}
    for i in ipairs(self.list) do
        self.indexs[i] = 0
    end
    task.New(self, function()
        for i = 1, 16 do
            self.alpha = i / 16
            task.Wait()
        end
    end)
end
function SpellSelect_Submenu:Out()
    task.New(self, function()
        self.locked = true
        SpellSelect.locked = false
        attributeselectmenu2.locked = false
        for i = 1, 16 do
            self.alpha = 1 - i / 16
            task.Wait()
        end
    end)
end
function SpellSelect_Submenu:SetPos(pos)
    pos = sp:TweakValue(pos, #self.list, 1)
    self.pos = pos
    task.New(self, function()
        self.show_alpha = 0
        for i = 1, 16 do
            self.show_alpha = task.SetMode[2](i / 16)
            task.Wait()
        end
    end)
end
function SpellSelect_Submenu:frame()
    task.Do(self)
    self.timer = self.timer + 1
    if self.locked then
        return
    end
    menu:Updatekey()
    local mouse = ext.mouse
    if menu:keyNo() then
        PlaySound("cancel00")
        self:Out()
    end
    local _wheel = mouse:getWheel()
    if _wheel ~= 0 then
        local k = -sign(_wheel)
        self:SetPos(self.pos + k)
        PlaySound("select00")
    end
    if mouse:isUp(1) then
        if mouse.x > self.x - self.h / 2 and mouse.x < self.x + self.h / 2 then
            local count = #self.list
            local k = (count - 1) / 2
            local j = 1
            for p = -k, k do
                if mouse.y < self.y + p * self.h + self.h / 2 and mouse.y > self.y + p * self.h - self.h / 2 then
                    if j ~= self.pos then
                        self:SetPos(j)
                        PlaySound("select00")
                    end
                    break
                end
                j = j + 1
            end
        end
    end
    for i = 1, #self.indexs do
        if i == self.pos then
            self.indexs[i] = self.indexs[i] + (-self.indexs[i] + 1) * 0.1
        else
            self.indexs[i] = self.indexs[i] - self.indexs[i] * 0.1
        end
    end
    self.ok_button:frame()

    local spunit = self.list[self.pos]
    local level = playerdata[spunit.belonging.name].spells[self.pos]
    if self.upgrade_money[level] then
        self.upgrade_button:frame()
    end
end
function SpellSelect_Submenu:render()
    local A = self.alpha
    local A2 = self.show_alpha
    if A == 0 then
        return
    end
    local t = self.timer
    SetImageState("white", "", A * 240, 0, 0, 0)
    RenderRect("white", 0, 960, 0, 540)

    local count = #self.list
    local k = (count - 1) / 2
    local j = 1
    for p = -k, k do
        local index = self.indexs[j]
        local R = index * 9 + self.h * 0.4
        local x, y = self.x, self.y + p * self.h
        local blk = 100 + index * 100
        ---@type SpellUnit
        local wp = self.list[j]
        local img = wp.picture
        SetImageState("menu_circle", "", 255 * A, blk, blk, blk)
        Render("menu_circle", x, y, 0, R / 192)
        SetImageState(img, "", 255 * A, blk, blk, blk)
        Render(img, x, y, 0, R / 192)
        ui:RenderText("title", ("Lv.%d"):format(playerdata[wp.belonging.name].spells[j]), x, y - R * 0.71,
                0.9, Color(255 * A, blk, blk, blk), "centerpoint")
        j = j + 1
    end

    local x1 = self.x + self.h * 0.6
    local x2 = 960 - x1
    local y1, y2 = 75, 475

    local y3 = 425
    local y4 = 210
    SetImageState("white", "", A * 75, 0, 0, 0)
    RenderRect("white", x1, x2, y1, y2)

    do
        ---@type SpellUnit
        local spunit = self.list[self.pos]
        ui:RenderText("big_text", spunit.display_name, (x1 + x2) / 2, (y2 + y3) / 2 - 2,
                0.6, Color(255 * A * A2, 189, 230, 220 + sin(t / 2) * 20), "centerpoint")
        local level = playerdata[spunit.belonging.name].spells[self.pos]
        local data = player_lib.GetAttributeByLevel(spunit.attribute_list, level)
        local str = spunit.belonging.class.spells[self.pos](nil, data):getDescribe()
        local strs = sp:SplitText(str, "\n")
        for i, text in ipairs(strs) do
            ui:RenderTextWithCommand("pretty_title", text, x1 + 5, y3 - 7 - (i - 1) * 26,
                    0.9, A * A2 * 255, "left", "top")
        end
        if level < 10 then
            ui:RenderText("big_text", "∨", (x1 + x2) / 2, (y1 + y2) / 2 + 44,
                    0.7, Color(A * A2 * 200, 255, 255, 255), "centerpoint")
            level = level + 1
            data = player_lib.GetAttributeByLevel(spunit.attribute_list, level)
            str = spunit.belonging.class.spells[self.pos](nil, data):getDescribe()
            strs = sp:SplitText(str, "\n")
            for i, text in ipairs(strs) do
                ui:RenderTextWithCommand("pretty_title", text, x1 + 5, y3 - 127 - (i - 1) * 26,
                        0.9, A * A2 * 150, "left", "top")
            end
            level = level - 1
        end

        ui:RenderText("big_text", ("Lv.%02d"):format(level), (x1 + x2) / 2, y4 - 1,
                0.9, Color(255 * A * A2, 230, 200, 200), "center", "top")
        if self.upgrade_money[level] then
            ui:RenderText("pretty", ("%s%d"):format(_t("upgradeMoney"), self.upgrade_money[level]), (x1 + x2) / 2, y1 + 17,
                    0.5, Color(230 * A * A2, 255, 255, 200), "center", "bottom")
            self.upgrade_button:render(A * A2)
        end
    end
    SetImageState("white", "", A * 255, 200, 200, 200)
    misc.RenderOutLine("white", x1, x2, y2, y1, 3, 0)
    RenderRect("white", x1, x2, y3 - 1.5, y3 + 1.5)
    RenderRect("white", x1, x2, y4 - 1.5, y4 + 1.5)
    self.ok_button:render(A)
end