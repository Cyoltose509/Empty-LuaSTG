menu = { noflag = false, yesflag = false, stopcheck = false, stagename = "" }
function menu:FadeIn()
    task.Clear(self)
    task.New(self, function()
        for i = 1, 30 do
            self.alpha = task.SetMode[2](i / 30)
            task.Wait()
        end
        self.locked = false
    end)
end
function menu:FadeOut()
    task.Clear(self)
    if not self.locked then
        task.New(self, function()
            self.locked = true
            for i = 1, 30 do
                self.alpha = 1 - task.SetMode[2](i / 30)
                task.Wait()
            end
        end)
    end
end
function menu:Updatekey()

    ext.mouse:frame()
    self.key = GetLastKey()

end
function menu:keyYes()
    if self.yesflag then
        self.yesflag = false
        return true
    end
    return self.key == setting.keys.shoot or
            self.key == KEY.ENTER
end
function menu:keyNo()
    local flag = false
    if self.noflag then
        self.noflag = false
        flag = true
    else
        flag = self.key == setting.keys.spell or self.key == KEY.ESCAPE
    end
    if flag then
        lstg.tmpvar.EscIsOccupied = true
    end
    return flag
end
function menu:keyLeft()
    return self.key == setting.keys.left or
            self.key == KEY.NUMPAD4 or
            self.key == KEY.NUMPAD1 or
            self.key == KEY.NUMPAD7
end
function menu:keyRight()
    return self.key == setting.keys.right or
            self.key == KEY.NUMPAD6 or
            self.key == KEY.NUMPAD3 or
            self.key == KEY.NUMPAD9
end
function menu:keyUp()
    return self.key == setting.keys.up or
            self.key == KEY.NUMPAD8 or
            self.key == KEY.NUMPAD7 or
            self.key == KEY.NUMPAD9
end
function menu:keyDown()
    return self.key == setting.keys.down or
            self.key == KEY.NUMPAD2 or
            self.key == KEY.NUMPAD1 or
            self.key == KEY.NUMPAD3
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

local select_block = plus.Class()

---@param name_renderfunc string|fun(offx:number, offy:number, alpha:number)
---@param event fun
function select_block:init(x1, x2, y1, y2, name_renderfunc, event)
    self.x1, self.x2, self.y1, self.y2 = x1, x2, y1, y2
    if name_renderfunc == "function" then
        self.name_renderfunc = name_renderfunc
    else
        if name_renderfunc:find("\n") then
            self.name, self.subname = name_renderfunc:match("^(.+)\n(.+)$")
            self.namelen = sp.string(self.name):GetLength() / 2
            self.subnamelen = sp.string(self.subname):GetLength() / 2
        else
            self.name = name_renderfunc
            self.namelen = sp.string(self.name):GetLength() / 2
        end
    end
    self.event = event
    self.choosing = false
    self.bcol = 255
end
function select_block:frame(locked, offx, offy)
    if not locked then
        local mouse = ext.mouse
        if sp.math.PointBoundCheck(mouse.x, mouse.y, self.x1 + offx, self.x2 + offx, self.y1 + offy, self.y2 + offy) then
            self.bcol = self.bcol + (-self.bcol + 120) * 0.2
            if mouse:isUp(1) then
                self.event()
                PlaySound("ok00")
            end
        else
            self.bcol = self.bcol + (-self.bcol + 255) * 0.2
        end--鼠标
        if self.choosing and menu:keyYes() then
            self.event()
            PlaySound("ok00")
        end--键盘
    end
end
function select_block:render(alpha, offx, offy)
    if alpha > 0 then
        local x1, x2, y1, y2 = self.x1 + offx, self.x2 + offx, self.y1 + offy, self.y2 + offy
        local x, y = (x1 + x2) / 2, (y1 + y2) / 2

        for i = 1, 10 do
            SetImageState("white", "", 70 - i * 7, 0, 0, 0)
            RenderRect("white", x1 + i, x2 + i, y1 - i, y2 - i)
        end
        SetImageState("white", "", alpha * 220, self.bcol, self.bcol, self.bcol)
        RenderRect("white", x1, x2, y1, y2)
        SetImageState("white", "", alpha * 100, 255, 255, 255)
        misc.RenderOutLine("white", x1, x2, y2, y1, 1, 0)
        if self.name_renderfunc then
            self.name_renderfunc(x, y, alpha)
        elseif self.name then
            local ttf = "big_text"
            local size = 80 / 2
            if self.subname then
                local h = y2 - y1
                local sw = (x2 - x1) / size / self.namelen
                local sh = h / 3 * 2 / size
                RenderTTF2(ttf, self.name, x, y + h / 6, min(sw, sh) * 0.87,
                        Color(alpha * 255, 0, 0, 0), "centerpoint")
                local sw2 = (x2 - x1) / size / self.subnamelen
                local sh2 = h / 3 * 1 / size
                RenderTTF2(ttf, self.subname, x, y - h / 3, min(sw2, sh2) * 0.87,
                        Color(alpha * 255, 0, 0, 0), "centerpoint")
            else
                local sw = (x2 - x1) / size / self.namelen
                local sh = (y2 - y1) / size
                RenderTTF2(ttf, self.name, x, y, min(sw, sh) * 0.87,
                        Color(alpha * 255, 0, 0, 0), "centerpoint")
            end

        end
        if self.choosing then
            SetImageState("white", "", alpha * 255, 255, 227, 132)
            misc.RenderOutLine("white", x1 - 4, x2 + 4, y2 + 4, y1 - 4, 0, 2)
        end
    end
end

---@param name_renderfunc fun(offx:number, offy:number, alpha:number)
---@param event fun
local function Newselect_block(x1, x2, y1, y2, name_renderfunc, event)
    return select_block(x1, x2, y1, y2, name_renderfunc, event)
end
_G.Newselect_block = Newselect_block

function menu:mouseCheck(main_y, offy, height, list_count)
    local mouse = ext.mouse
    local y
    local selected
    for i = 1, list_count do
        y = main_y - i * height
        if abs(mouse.y - y) + offy < height / 2 then
            selected = i
            break
        end
    end
    return selected
end

function menu:GetTXTlen(ttf, size, txt)
    local fr = lstg.FontRenderer
    fr.SetFontProvider(ttf)
    fr.SetScale(size, size)
    local _l, _r = fr.MeasureTextBoundary(txt)
    return (_r - _l) / 2
end

---根本菜单，用来播放bgm的
FUNDAMENTAL_MENU = nil
DoFile("THlib\\UI\\loading.lua")
------------------------------------------------------------
local function LoadMenuFile()
    local path = "THlib\\UI\\menus\\"
    DoFile(path .. "menu_obj.lua")
    DoFile(path .. "mainmenu.lua")
    DoFile(path .. "music_stream.lua")
    DoFile(path .. "intromenu.lua")
end
if GlobalLoading then
    LoadMenuFile()
else
    table.insert(LoadRes, LoadMenuFile)
end

function menu:RenderBar(x, y, length, width, progress, alpha, r, g, b)
    progress = progress / 100
    local size = width / 15
    local px = 8 * size
    length = length + px * 2
    local FillblendMode = ""
    local FillColor = Color(150 * alpha, r or 100, g or 255, b or 100)
    local l2 = length / 2
    local w2 = width / 2
    local tx = progress * length
    if tx <= px then
        RenderTexture("menu_bar", FillblendMode,
                { x - l2, y + w2, 0.5, 12, 143, FillColor },
                { x - l2 + tx, y + w2, 0.5, 12 + 6 * tx / px, 143, FillColor },
                { x - l2 + tx, y - w2, 0.5, 12 + 6 * tx / px, 159, FillColor },
                { x - l2, y - w2, 0.5, 12, 159, FillColor })
    elseif length - tx <= px then
        local l = tx - (length - px)
        RenderTexture("menu_bar", FillblendMode,
                { x - l2, y + w2, 0.5, 12, 143, FillColor },
                { x - l2 + px, y + w2, 0.5, 12 + 6, 143, FillColor },
                { x - l2 + px, y - w2, 0.5, 12 + 6, 159, FillColor },
                { x - l2, y - w2, 0.5, 12, 159, FillColor })
        RenderTexture("menu_bar", FillblendMode,
                { x - l2 + px, y + w2, 0.5, 18, 143, FillColor },
                { x - l2 + length - px, y + w2, 0.5, 18 + 49, 143, FillColor },
                { x - l2 + length - px, y - w2, 0.5, 18 + 49, 159, FillColor },
                { x - l2 + px, y - w2, 0.5, 18, 159, FillColor })
        RenderTexture("menu_bar", FillblendMode,
                { x - l2 + length - px, y + w2, 0.5, 67, 143, FillColor },
                { x - l2 + length - px + l, y + w2, 0.5, 67 + 6 * l / px, 143, FillColor },
                { x - l2 + length - px + l, y - w2, 0.5, 67 + 6 * l / px, 159, FillColor },
                { x - l2 + length - px, y - w2, 0.5, 67, 159, FillColor })
    else
        local l = tx - px
        RenderTexture("menu_bar", FillblendMode,
                { x - l2, y + w2, 0.5, 12, 143, FillColor },
                { x - l2 + px, y + w2, 0.5, 12 + 6, 143, FillColor },
                { x - l2 + px, y - w2, 0.5, 12 + 6, 159, FillColor },
                { x - l2, y - w2, 0.5, 12, 159, FillColor })
        RenderTexture("menu_bar", FillblendMode,
                { x - l2 + px, y + w2, 0.5, 18, 143, FillColor },
                { x - l2 + px + l, y + w2, 0.5, 18 + 49 * progress, 143, FillColor },
                { x - l2 + px + l, y - w2, 0.5, 18 + 49 * progress, 159, FillColor },
                { x - l2 + px, y - w2, 0.5, 18, 159, FillColor })
    end

    SetImageState("menu_bar_outline_body", "", alpha * 255, 255, 255, 255)
    SetImageState("menu_bar_outline_terminal1", "", alpha * 255, 255, 255, 255)
    SetImageState("menu_bar_outline_terminal2", "", alpha * 255, 255, 255, 255)
    Render("menu_bar_outline_terminal1", x - l2 - 2 * size, y, 0, size)
    Render("menu_bar_outline_terminal2", x + l2 + 2 * size, y, 0, size)
    Render("menu_bar_outline_body", x, y, 0, (length - px * 2) / 45, size)


end


local valid
local info = Class(object, { frame = task.Do })
function info:init(text, w, h, ingame)
    if IsValid(valid) then
        if text == valid.text then
            object.RawDel(self)
            return
        else
            object.Del(valid)
        end
    end
    valid = self
    self.bound = false
    self.colli = false
    object.init(self, 480, 270, GROUP.GHOST, 0)
    self.text = text
    self.w = w or sp.string(text):GetLength() * 5 + 3
    self.h = h or 20
    self.alpha = 255
    self.ingame = ingame
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
    if self.ingame then
        SetViewMode("ui")
    end
    SetImageState("white", "", self.alpha / 2, 0, 0, 0)
    RenderRect("white", self.x - self.w, self.x + self.w, self.y - self.h, self.y + self.h)
    ui:RenderText("title", self.text, self.x, self.y, 1, Color(self.alpha, 255, 255, 255), "centerpoint")
    if self.ingame then
        SetViewMode("world")
    end
end
_G.info = info

