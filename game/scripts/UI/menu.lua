menu = { noflag = false, yesflag = false, stopcheck = false, stagename = "" }
function menu:Updatekey()

    ext.mouse:frame()
    self.key = GetLastKey()
    self.xkey = Input.xGetLastKey()
end
function menu:keyYes()
    if self.yesflag then
        self.yesflag = false
        return true
    end
    return self.key == setting.keys.shoot or
            self.key == KEY.ENTER or
            self.key == KEY.NUMPADENTER or
            self.xkey == setting.xkeysys.confirm
end
function menu:keyNo()
    local flag = false
    if self.noflag then
        self.noflag = false
        flag = true
    else
        flag = self.key == setting.keys.spell or
                self.key == setting.keysys.menu or
                self.key == KEY.ESCAPE or
                self.xkey == setting.xkeysys.menu
    end
    if flag then
        lstg.tmpvar.EscIsOccupied = true
    end
    return flag
end
function menu:keyLeft(nopad)
    return self.key == setting.keys.left
            or self.xkey == setting.xkeys.left
            or (not nopad and (self.key == KEY.NUMPAD4 or self.key == KEY.NUMPAD1 or self.key == KEY.NUMPAD7))
end
function menu:keyRight(nopad)
    return self.key == setting.keys.right
            or self.xkey == setting.xkeys.right
            or (not nopad and (self.key == KEY.NUMPAD6 or self.key == KEY.NUMPAD3 or self.key == KEY.NUMPAD9))
end
function menu:keyUp(nopad)
    return self.key == setting.keys.up
            or self.xkey == setting.xkeys.up
            or (not nopad and (self.key == KEY.NUMPAD8 or self.key == KEY.NUMPAD7 or self.key == KEY.NUMPAD9))
end
function menu:keyDown(nopad)
    return self.key == setting.keys.down
            or self.xkey == setting.xkeys.down
            or (not nopad and (self.key == KEY.NUMPAD2 or self.key == KEY.NUMPAD1 or self.key == KEY.NUMPAD3))
end

function menu:keyReset()
    return self.key == setting.keysys.retry or self.xkey == setting.xkeysys.retry
end

function menu:ControlExit(x1, x2, y1, y2, action)
    local mouse = ext.mouse
    if sp.math.PointBoundCheck(mouse.x, mouse.y, x1, x2, y1, y2) and mouse:isUp(1) then
        if action then
            action()
        else
            self.noflag = true
        end
    end
end
function menu:RenderExit(x1, x2, y1, y2, alpha)
    alpha = alpha * 255
    SetImageState("white", "", alpha * 0.6, 0, 0, 0)
    RenderRect("white", x1, x2, y1, y2)
    ui:RenderText("big_text", "×", (x1 + x2) / 2, (y1 + y2) / 2 + 3,
            abs(x2 - x1) / 45, Color(alpha, 255, 255, 255), "centerpoint")
end

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
            PlaySound("ok")
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
    local x1, y1, x2, y2 = self.x - self.w * s, self.x + self.w * s, self.y - self.h * s, self.y + self.h * s
    SetImageState("white", "", A * 200, 0, 0, 0)
    misc.RenderRoundedRect(x1, y1, x2, y2, self.h * s)
    SetImageState("white", "", A * 200, 200 - k * 50, 200, 200 - k * 50)
    misc.RenderRoundedRectOutline(x1, y1, x2, y2, self.h * s, 2)
    --SetImageState("menu_button", "", A * 200, 200 - k * 50, 200, 200 - k * 50)
    -- Render("menu_button", x, y, 0, s * self.w / 230, s * self.h / 48)

    ui:RenderText("title", self.text, x, y + 0.5,
            1 + k * 0.05, Color(A * 200, blk - k * 50, blk, blk - k * 50), "centerpoint")
end
menu.general_buttonFrame = general_buttonFrame
menu.general_buttonRender = general_buttonRender

---@return number, number@返回文本宽度和高度
function menu:GetTXTlen(ttf, size, txt)
    local fr = lstg.FontRenderer
    fr.SetFontProvider(ttf)
    fr.SetScale(size / 2, size / 2)
    local _l, _r, _b, _t = fr.MeasureTextBoundary(txt)
    return (_r - _l), (_t - _b)
end
function menu:PlayBackGroundMusic(time)
    if not menu.background_music then
        local music = "menu"
        menu.background_music = StreamMusic(music)
    end
    if menu.background_music:GetState() ~= "playing" then
        menu.background_music:FadePlay(time or 120)
    end
end

function menu:StopBackGroundMusic(time)
    if menu.background_music then
        menu.background_music:FadeStop(time or 60)
        menu.background_music = nil
    end
end

local ExitRenderer = plus.Class()
menu.ExitRenderer = ExitRenderer
function ExitRenderer:init(func)
    self.index = 0
    self.cindex = 0
    self.x = 0
    self.y = screen.height * 0.95
    self.h = 25
    self.func = func
    self.locked = false
end
function ExitRenderer:frame()
    self.y = screen.height * 0.95
    local mouse = ext.mouse
    local mx, my = mouse:get()
    local _index = 0
    local lh = self.h + 10 * self.index
    local w = 20 + lh * 0.5 + self.cindex * 10
    local cx, cy = self.x + w, self.y
    local nd = lh / 2
    if abs(my - cy) < self.h and mx < cx + nd then
        _index = 1
        if mouse:isDown(1) and not self.locked then
            self.func()
            self.locked = true
            self.cindex = 1
        end
    end
    self.index = self.index + (-self.index + _index) * 0.1
    self.cindex = self.cindex + (-self.cindex) * 0.1
    return _index == 1
end
function ExitRenderer:render(A)
    local lh = self.h + 10 * self.index
    local ol = 2
    local w = 20 + lh * 0.5 + self.cindex * 10
    local cx, cy = self.x + w, self.y
    local nd = lh / 2
    local oR, oG, oB = 255 - self.cindex * 100, 255, 255 - self.cindex * 100
    local bR, bG, bB = 0, 0, 0
    local cR, cG, cB = 200 - self.cindex * 100, 200, 200 - self.cindex * 100
    local alpha = 0.8 * (A or 1)
    SetImageState("white", "", alpha * 255, bR, bG, bB)
    RenderRect("white", cx - w, cx, cy - lh / 2, cy + lh / 2)
    Render4V("white", cx, cy + lh / 2, 0.5, cx + nd, cy, 0.5,
            cx + nd, cy, 0.5, cx, cy - lh / 2, 0.5)
    SetImageState("white", "", alpha * 255, oR, oG, oB)
    RenderRect("white", cx - w, cx, cy + lh / 2 - ol / 2, cy + lh / 2 + ol / 2)
    RenderRect("white", cx - w, cx, cy - lh / 2 - ol / 2, cy - lh / 2 + ol / 2)
    Render4V("white", cx - ol, cy + lh / 2 + ol / 2, 0.5, cx, cy + lh / 2 + ol / 2, 0.5,
            cx + nd, cy, 0.5, cx + nd - ol - 1, cy, 0.5)
    Render4V("white", cx - ol, cy - lh / 2 - ol / 2, 0.5, cx, cy - lh / 2 - ol / 2, 0.5,
            cx + nd, cy, 0.5, cx + nd - ol - 1, cy, 0.5)
    SetImageState("return_icon", "", alpha * 255, cR, cG, cB)
    Render("return_icon", cx - 15, cy, 0, 0.4 + self.index * 0.1)
end

DoFile("scripts\\UI\\loading.lua")

local function LoadMenuFile()
    local path = "assets\\UI\\menus\\"
    local spath = "scripts\\UI\\menus\\"
    DoFile(spath .. "music_stream.lua")
    DoFile(spath .. "menu_obj.lua")
    DoFile(spath .. "mainmenu.lua")
end
if GlobalLoading then
    LoadMenuFile()
else
    table.insert(LoadRes, LoadMenuFile)
end

function menu:RenderBar(x, y, length, width, progress, alpha, r, g, b)
    r, g, b = r or 100, g or 255, b or 100
    local x1, x2, y1, y2 = x - length / 2, x + length / 2, y - width / 2, y + width / 2
    local rr = (y2 - y1) / 2
    local co = clamp(progress / 100, 0, 1)
    local gox = x1 + max(rr * 2, (x2 - x1) * co)
    SetImageState("white", "", 100 * alpha, r, g, b)
    misc.RenderRoundedRect(x1, gox, y1, y2, rr, 6)
    SetImageState("white", "", 150 * alpha, 255, 255, 255)
    --misc.RenderRoundedRectOutline(x1 - 1, gox + 1, y1 - 1, y2 + 1, rr + 1, 1, 6)
    misc.RenderRoundedRectOutline(x1 - 2, x2 + 2, y1 - 2, y2 + 2, rr + 2, 2, 6)
end


local valid
local info = Class(object, { frame = task.Do })
function info:init(text, x, y)
    if IsValid(valid) then
        if text == valid.text then
            object.RawDel(self)
            --return
        else
            object.Del(valid)
        end
    end
    valid = self
    self.bound = false
    self.colli = false
    x = x or 480
    y = y or 270
    object.init(self, x, y, GROUP.GHOST, 0)
    self.text = text
    self.alpha = 255
    task.New(self, function()
        task.Wait(60)
        if valid == self then
            valid = nil
        end
        for i = 1, 60 do
            self.alpha = 255 - 255 * sin(i * 1.5)
            task.Wait()
        end
        Del(self)
    end)
end
function info:del()
    valid = nil
end
function info:render()
    SetImageState("white", "", self.alpha / 2, 0, 0, 0)
    local w, h = menu:GetTXTlen("huge", 0.5, self.text)
    w = w / 2 + 5
    h = h / 2 + 5
    RenderRect("white", self.x - w, self.x + w, self.y - h, self.y + h)
    ui:RenderText("huge", self.text, self.x, self.y, 0.5,
            Color(self.alpha, 255, 255, 255), "centerpoint")
end
menu.info = info

menu.FlyInTexts = {}
function menu:HandleFlyInText(mainmenu, updatekey)
    mainmenu.locked = true
    while #menu.FlyInTexts > 0 do
        local text = table.remove(menu.FlyInTexts, 1)
        local m = New(menu.FlyInNotice, nil, text)
        while IsValid(m) and not m.dk do
            if updatekey then
                menu:Updatekey()
            end
            task.Wait()
        end
    end
    mainmenu.locked = false
end
function menu:InsertFlyInText(text)
    table.insert(menu.FlyInTexts, text)
end

local chief_unlock = Class(object)
menu.ChiefUnlock = chief_unlock
function chief_unlock:init()
    self.group = GROUP.GHOST
    self.bound = false
    self.colli = false
    self.white = 0
    self.alpha = 0
    self.set = 0
    self.alphas = { 0, 0, 0 }
    self.cards = {
        i18n("menu-diy-mode"),
        i18n("menu-daily-challenge"),
    }
    task.New(self, function()
        PlaySound("chief_unlock")
        for i = 1, 60 do
            self.white = i / 60
            task.Wait()
        end
        self.alpha = 1

        task.New(self, function()
            for i = 1, 90 do
                self.set = task.SetMode[10](i / 90)
                task.Wait()
            end
        end)
        for i = 1, 30 do
            self.white = 1 - i / 30
            task.Wait()
        end
        for m = 1, 3 do
            task.New(self, function()
                for i = 1, 60 do
                    self.alphas[m] = task.SetMode[10](i / 60)
                    task.Wait()
                end
            end)
            task.Wait(20)
        end
        while not (menu:keyYes() or menu:keyNo() or ext.mouse:isUp(1)) do
            task.Wait()
        end
        self.dk = true
        PlaySound("ok")
        for i = 1, 25 do
            self.alpha = 1 - i / 25
            task.Wait()
        end
        Del(self)
    end)
end
function chief_unlock:frame()
    task.Do(self)
end
function chief_unlock:render()
    local w, h = screen.width, screen.height
    local cx, cy = w / 2, h / 2
    local A = self.alpha
    local S = self.set * A
    local t = self.timer
    SetImageState("chief_unlock_bg", "", A * 255, 255, 255, 255)
    Render("chief_unlock_bg", cx, cy, 0, 0.5)
    for i = 1, 6 do
        local st = t + i * 60
        SetImageState("menu_widget", "mul+add", A * 100, 200, 100 - sin(st / 2) * 50, 235)
        Render("menu_widget", 0, 0, st * (0.3 - i / 6 * 0.2), i * 0.3)
    end
    for k = 1, 20 * setting.render_quality do
        local R, G, B = 135, 206, 235
        local st = t + k * 600
        local fall = 125 + k * 3
        local p = (st % fall) / fall
        local sx, sy = 960 - 500 * p, 270 + (sin(int(st / fall) * 38) * 270)
        SetImageState("circle_par", "mul+add", A * sin(p * 180) * 20, R, G, B)
        Render("circle_par", sx, sy, -90, (0.1 + 0.02 * sin(p * 180)) * (sin(int(st / fall) * 70) * 0.2 + 0.4))
    end
    ui:RenderText("huge", i18n("menu-chief-unlock"), cx - 150 * (1 - S), cy + 120,
            0.7, Color(200 * A, 255, 255, 255), "centerpoint")
    do
        local cw, ch = 180, 40
        local rr = ch / 2
        for i, name in ipairs(self.cards) do
            local ccx, ccy = cx + 100 * (1 - self.alphas[i]), cy - ch * (i - 1.5) * 1.25
            local x1, x2 = ccx - cw / 2, ccx + cw / 2
            local y1, y2 = ccy - ch / 2, ccy + ch / 2
            local _a = A * 0.8 * self.alphas[i]
            SetImageState("white", "", _a * 100, 0, 0, 0)
            misc.RenderRoundedRect(x1, x2, y1, y2, rr)
            SetImageState("white", "", _a * 200, 250, 128, 114)
            misc.RenderRoundedRectOutline(x1, x2, y1, y2, rr, 2)
            SetImageState("white", "", _a * 50, 0, 0, 0)
            misc.RenderRoundedRect(x1, x2, y1, y2, rr)
            local kT = 2
            for k = -kT, kT do
                local ak = abs(k) / kT
                SetImageState("bright_line", "mul+add", _a * 100 * ak ^ 2, 250, 128, 114)
                local _y = (y1 + y2) / 2 + k / kT * ch / 2
                Render("bright_line", (x1 + x2) / 2, _y, 0, cw / 300, 1)
            end
            local bssize = 0.5
            local size = bssize
            local tlen = menu:GetTXTlen("huge", size, name)
            size = size / max(1, (tlen) / (x2 - x1 - ch - 5))
            ui:RenderText("huge", name, (x1 + x2) / 2, (y1 + y2) / 2, size,
                    Color(_a * 200, 255, 255, 255), "centerpoint")
        end
    end
    local A3 = A * self.alphas[3]
    ui:RenderTextItalic("huge", i18n("menu-chief-unlock-desc"), cx, cy - 100 - 150 * (1 - A3),
            1, Color(200 * A3, 255, 227, 132), "centerpoint")
    local wa = self.white
    SetImageState("white", "mul+add", wa * 255, 255, 255, 255)
    RenderRect("white", 0, w, 0, h)


end

function menu:CheckChallengeModeUnlock(mainmenu, updatekey)
    if scoredata.challenge_unlock then
        ext.achievement:get(31)
        return
    end
    local flag = not DEMO
    for i = 1, 9 do
        local day = DayClass[i]
        if day then
            for _, e in ipairs(day.scenes) do
                if not e.nodata then
                    flag = flag and e.data.total > 0
                    if not flag then
                        break
                    end
                end
            end
        end
    end
    if flag then
        if not scoredata.challenge_unlock then
            ext.achievement:get(31)
            scoredata.challenge_unlock = true
            ---解锁演示
            mainmenu.locked = true
            local m = New(menu.ChiefUnlock)
            while IsValid(m) and not m.dk do
                if updatekey then
                    menu:Updatekey()
                end
                task.Wait()
            end
            mainmenu.locked = false
        end
    end
end

local SteamAddtoWishlist = plus.Class()
menu.SteamAddToWishlist = SteamAddtoWishlist
function SteamAddtoWishlist:init(offy)
    self.index = 0
    self.cindex = 0
    self.start = 0
    self.h = 25
    self.locked = false
    local scr = screen
    self.x = -30
    self.offy = offy or 0
    self.y = scr.height * 0.05 + self.offy
end
function SteamAddtoWishlist:frame()
    if not DEMO then
        return
    end
    self.start = self.start + (-self.start + 1) * 0.1
    local scr = screen
    self.x = -30 + 50 * self.start
    self.y = scr.height * 0.05 + self.offy
    local mouse = ext.mouse
    local _index = 0
    if sp.math.PointBoundCheck(mouse.x, mouse.y, self.x - 30, self.x + 30 + self.index * 80, self.y - 15, self.y + 15) then
        _index = 1
        if mouse:isDown(1) and not self.locked then
            luaSteam.OpenSteamStore()
            self.cindex = 1
            PlaySound("ok")
        end
    end
    self.index = self.index + (-self.index + _index) * 0.1
    self.cindex = self.cindex + (-self.cindex) * 0.1
end
function SteamAddtoWishlist:render(A)
    if not DEMO then
        return
    end
    local alpha = 0.8 * (A or 1)
    local k = self.index
    local text = i18n("add-to-wishlist")
    SetImageState("steam_icon", "", alpha * 180, 255, 255, 255)
    Render("steam_icon", self.x, self.y, 0, 0.25 + 0.05 * k + 0.05 * self.cindex)
    ui:RenderText("title", text, self.x + k * 20, self.y + 8,
            0.73 + 0.03 * self.cindex, Color(alpha * 180 * k, 255, 255, 255), "left")

end

local LinkButton = plus.Class()
menu.LinkButton = LinkButton
function LinkButton:init(img, img2, link, show_des, offx, offy)
    self.index = 0
    self.cindex = 0
    self.start = 0
    self.h = 25
    self.locked = false
    local scr = screen
    self.link = link
    self.img = img
    self.img2 = img2
    self.show_des = show_des or ""
    self.offx = offx or 0
    self.offy = offy or 0
    self.x = scr.width + self.offx
    self.y = scr.height * 0.05 + self.offy
    self.init_show = 1
end
function LinkButton:frame()
    self.init_show = self.init_show + (-self.init_show) * 0.04
    self.start = self.start + (-self.start + 1) * 0.1
    local scr = screen
    self.x = scr.width + (self.offx - 30 * self.start)
    self.y = scr.height * 0.05 + self.offy
    local mouse = ext.mouse
    local _index = 0
    if Dist(self.x, self.y, mouse.x, mouse.y) < 22 then
        _index = 1
        if mouse:isDown(1) and not self.locked then
            if self.link then
                if self.img:find("qq") then
                    os.execute("explorer " .. self.link)
                else
                    luaSteam.OpenWebPage(self.link)
                end
            end
            self.cindex = 1
            PlaySound("ok")
        end
    end
    self.index = self.index + (-self.index + _index) * 0.1
    self.cindex = self.cindex + (-self.cindex) * 0.1
end
function LinkButton:render(A)
    local alpha = 0.8 * (A or 1)
    local k = self.index
    local size = 1
    local tk = min(1, self.init_show + self.index)
    ui:RenderText("title", self.show_des, self.x - 15 - 10 * tk, self.y + 5,
            0.73, Color(alpha * 180 * tk, 255, 255, 255), "right")
    SetImageState(self.img, "", alpha * 150, 255, 255, 255)
    Render(self.img, self.x, self.y, 0, size * (0.25 + 0.05 * k + 0.05 * self.cindex))
    if self.img2 then
        SetImageState(self.img2, "", alpha * 150, 255, 255, 255)
        Render(self.img2, self.x + size * 13, self.y - size * 13, 0, 0.4 * size * (0.25 + 0.05 * k + 0.05 * self.cindex))
    end

end

local utf8 = require("utf8")
local function sub(s, i, j)
    i = i or 1
    j = j or -1
    if i < 0 or j < 0 then
        local len = utf8.len(s)
        if not len then
            return ""
        end
        if i < 0 then
            i = len + 1 + i
        end
        if j < 0 then
            j = len + 1 + j
        end
    end
    local start_pos = utf8.offset(s, i)
    local end_pos = utf8.offset(s, j + 1)
    if start_pos and end_pos then
        return s:sub(start_pos, end_pos - 1)
    elseif start_pos then
        return s:sub(start_pos)
    else
        return ""
    end
end

---@param text_input_ext lstg.Window.TextInputExtension
---@param input_method_ext lstg.Window.InputMethodExtension
function menu:InputControl(text_input_ext, name, ttf, size, max_len, cx, cy, height, input_method_ext)
    local str = text_input_ext:toString()
    local input_name = name or ""
    if utf8.len(str) <= max_len then
        input_name = text_input_ext:toString()
    else
        text_input_ext:backspace()
    end
    local cursor_pos = text_input_ext:getCursorPosition()
    local last_key = GetLastKey()
    if last_key == KEY.BACKSPACE then
        text_input_ext:backspace()
    end
    if last_key == KEY.DELETE then
        text_input_ext:remove()
    end
    local len = menu:GetTXTlen(ttf, size, input_name)
    local mouse = ext.mouse
    if sp.math.PointBoundCheck(mouse.x, mouse.y, cx, cx + len, cy, cy + height) then
        if mouse:isDown(1) then
            for i = 0, #input_name do
                local _len = menu:GetTXTlen(ttf, size, sub(input_name, 1, i))
                if cx + _len + 3 * size > mouse.x then
                    text_input_ext:setCursorPosition(i)
                    break
                end
            end
        end
    end
    if menu:keyLeft(true) then
        text_input_ext:addCursorPosition(-1)
    end
    if menu:keyRight(true) then
        text_input_ext:addCursorPosition(1)
    end
    if menu:keyUp(true) then
        text_input_ext:setCursorPosition(0)
    end
    if menu:keyDown(true) then
        text_input_ext:setCursorPosition(#input_name)
    end
    if input_method_ext then
        local mx, my = cx + menu:GetTXTlen(ttf, size, sub(input_name, 1, text_input_ext:getCursorPosition())), cy + height / 2
        input_method_ext:setInputMethodPosition(UIToScreen(mx, my))
    end
    return input_name, cursor_pos
end

function menu:RenderLoading(x, y, r, alpha, time, text)
    text = text or ""
    local point = 40
    local a1, a2 = sin(time) * 120 + 150 + time * 2.5, time * 2.5
    local ang = (a2 - a1) / point
    local r1, r2 = r * 0.6, r * 1.4
    local angle
    for i = 1, point do
        local k = sin(i / point * 180)
        SetImageState("white_bright", "mul+add", k * 150 * alpha,
                sp:HSVtoRGB(k * 36 + time, 0.5, 1))
        angle = a1 + ang * i
        Render4V('white_bright',
                x + r1 * cos(angle), y + r1 * sin(angle), 0.5,
                x + r2 * cos(angle), y + r2 * sin(angle), 0.5,
                x + r2 * cos(angle - ang), y + r2 * sin(angle - ang), 0.5,
                x + r1 * cos(angle - ang), y + r1 * sin(angle - ang), 0.5)
    end
    ui:RenderText("title", text, x, y - r2 * 1.5, 1,
            Color(180 * alpha, 255, 255, 255), "centerpoint")
end

