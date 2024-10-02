---------------------------------------
---启动器
---------------------------------------

Include 'THlib\\THlib.lua'

---------------------------------------
local Resolution = { { 960, 540 }, { 1200, 675 }, { 1440, 810 }, { 1680, 945 }, { 1920, 1080 } }
---------------------------------------
local key_state = {}
---@type table<string, boolean>
local last_key_state = {}
---@type table<string, number>
local key_map = {
    ["enter"] = 0x0D,
    ["esc"] = 0x1B,
    ["z"] = 0x5A,
    ["x"] = 0x58,
    ["F1"] = 0x70,
    ["F2"] = 0x71,
    ["F3"] = 0x72,
    ["F4"] = 0x73,
    ["F5"] = 0x74,
    ["TAB"] = 0x09,
}

local function UpdateInput()
    for k, v in pairs(key_map) do
        last_key_state[k] = key_state[k]
        key_state[k] = GetKeyState(v)
    end
end

---@param k string
---@return boolean
local function KeyPressing(k)
    return key_state[k]
end

---@param k string
---@return boolean
local function KeyUp(k)
    return last_key_state[k] and (not key_state[k])
end

local CurResolutions = {}
for _, res in ipairs(lstg.EnumResolutions()) do
    if res[2] / res[1] == 0.5625 then
        table.insert(CurResolutions, res)
    end
end

local curresx, curresy
function ChangeVideoMode2(set)
    return ChangeVideoMode(set.resx, set.resy, set.windowed, set.vsync)

end

local function start_game()
    setting.mod = "Touhou Roguelike"
    save_setting()
    curresx = setting.resx
    curresy = setting.resy
    if not ChangeVideoMode2(setting) then
        error(setting.windowed and "Invalid Resolution" or "Failed to FullScreen")
        --stage.QuitGame()
        --return
    end
    SetSEVolume(setting.sevolume / 100)
    SetBGMVolume2(setting.bgmvolume / 100)
    ResetScreen()--Lscreen
    SetResourceStatus 'global'
    ResetUI()
    Include("mod\\root.lua")
    --SetResourceStatus 'stage'
    InitAllClass()--Lobject
    stage.Set('none', 'init')
end

local Sign = Class(object)
function Sign:init(boss, x, y, h, v, text, func, onFrame, keyfunc, otherkey)
    self.boss = boss
    self.x = x
    self.y = y
    self.func = func
    self.bound = false
    self.blk = 0
    self.d_r, self.d_g, self.d_b = 0, 0, 0
    self.layer = LAYER.TOP + 1000
    self.text = text
    self.scale = 1
    self.alpha = 0
    self.select = false
    self.h, self.v = h, v
    if onFrame then
        self.onFrame = onFrame
    end
    if keyfunc then
        self.keyfunc = keyfunc
    end
    if otherkey then
        self.otherkey = otherkey
    else
        self.otherkey = function()
            return false
        end
    end
    task.New(self, function()
        for i = 1, 30 do
            self.alpha = sin(i * 3)
            task.Wait()
        end
    end)
end
function Sign:frame()
    task.Do(self)

    if self.onFrame then
        self.onFrame(self)
    end
    if sp.math.PointBoundCheck(ext.mouse.x, ext.mouse.y, self.x - self.h, self.x + self.h, self.y - self.v, self.y + self.v) or self.otherkey() then
        if not self.select then
            PlaySound('select00', 0.3)
            task.New(self, function()
                for i = 1, 9 do
                    self.scale = 1 + 0.2 * sin(i * 10)
                    self.blk = 100 * sin(i * 10)
                    task.Wait()
                end
            end)
        end
        self.select = true
    else
        if self.select then
            task.New(self, function()
                for i = 8, 0, -1 do
                    self.scale = 1 + 0.2 * sin(i * 10)
                    self.blk = 100 * sin(i * 10)
                    task.Wait()
                end
            end)
        end
        self.select = false
    end
    if self.select then
        if ext.mouse:isUp(1) and self.func then
            self.func(self.boss)
            PlaySound('ok00', 0.3)
        end
    end
    if self.keyfunc then
        if self.keyfunc() then
            self.func(self.boss)
            PlaySound('ok00', 0.3)
        end
    end
end
function Sign:render()
    SetViewMode "ui"
    for p = 0, 7 do
        SetImageState("white", "", (80 - p * 10) * self.alpha, 0, 0, 0)
        RenderRect("white", self.x - self.h + p, self.x + self.h + p, self.y - self.v - p, self.y + self.v - p)
    end
    local rgb = 230 - self.blk
    SetImageState("white", "mul+add", 140 * self.alpha, rgb - self.d_r, rgb - self.d_g, rgb - self.d_b)
    RenderRect("white", self.x - self.h, self.x + self.h, self.y - self.v, self.y + self.v)

    RenderTTF("title", self.text, self.x, self.y, Color(255 * self.alpha, self.blk * 2, self.blk * 2, self.blk * 2), "centerpoint")
    SetViewMode("world")
end

stage_launcher = stage.New('settings', true, true)

function stage_launcher:init()
    if setting and setting.auto_hide_title_bar then
        local Window = require("lstg.Window")
        local main_window = Window.getMain()
        local window_win11_ext = main_window:queryInterface("lstg.Window.Windows11Extension")
        if window_win11_ext then
            window_win11_ext:setTitleBarAutoHidePreference(true)
        end
    end

    self.rot = ran:Float(-85, 85)
    self.x, self.y = 198 + ran:Float(-120, 120), 264 + ran:Float(-120, 120)
    self.smear = {}
    --
    local f, msg
    f, msg = io.open(settingfile, 'r')
    if f == nil then
        setting = DeSerialize(Serialize(default_setting))
    else
        setting = DeSerialize(f:read('*a'))
        f:close()
    end
    local function ExitGame()
        task.New(self, function()
            task.Wait(30)
            stage.QuitGame()
        end)
    end
    --
    New(Sign, self, 98, 204, 50, 18, "开启(Z,Enter)", start_game, nil,
            function()
                return (KeyUp("enter") or KeyUp("z"))
            end,
            function()
                return (KeyPressing("enter") or KeyPressing("z"))
            end)
    New(Sign, self, 298, 204, 50, 18, "退出(X,Esc)", ExitGame, nil,
            function()
                return (KeyUp("esc") or KeyUp("x"))
            end,
            function()
                return (KeyPressing("esc") or KeyPressing("x"))
            end)
    for i = 1, #Resolution do
        New(Sign, self, 198, 464 - (i - 1) * 30, 57, 10, ("%d*%d(F%d)"):format(Resolution[i][1], Resolution[i][2], i),
                function()
                    setting.resID = i
                    setting.resx = Resolution[i][1]
                    setting.resy = Resolution[i][2]
                    save_setting()
                end,
                function(self)
                    if setting.resID == i then
                        self.d_r, self.d_g, self.d_b = 40, 70, 40
                    else
                        self.d_r, self.d_g, self.d_b = 0, 0, 0
                    end
                end,
                function()
                    return (KeyUp("F" .. i))
                end,
                function()
                    return (KeyPressing("F" .. i))
                end)
    end
    New(Sign, self, 198, 300, 55, 14, "全屏模式(Tab)",
            function()
                setting['windowed'] = not setting['windowed']
                save_setting()
            end,
            function(self)
                if not setting['windowed'] then
                    self.d_r, self.d_g, self.d_b = 40, 70, 40
                else
                    self.d_r, self.d_g, self.d_b = 0, 0, 0
                end
            end,
            function()
                return (KeyUp("TAB"))
            end,
            function()
                return (KeyPressing("TAB"))
            end)


end
function stage_launcher:frame()
    task.Do(self)
    UpdateInput()
    ext.mouse:frame()
end
function stage_launcher:render()
    SetViewMode "ui"
    if CheckRes("img", 'menu_bg2') then
        SetImageState("menu_bg2", "", 255, 90, 90, 90)
        Render("menu_bg2", 0, screen.height / 2, 0)
    end
    SetFontState("Score", "", 255, 255, 255, 255)
    if GetChargeCost() then
        RenderText("Score", ("$%d"):format(GetChargeCost()),
                392, 19, 0.25, "right", "bottom")
    end
    RenderText("Score", ui.version,
            392, 10, 0.25, "right", "bottom")
    RenderText("Score",
            string.format("%.1ffps", GetFPS()),
            392, 1, 0.25, "right", "bottom")
    SetViewMode "ui"
    ui:RenderText("title", "请选择分辨率", 198, 492, 1, Color(255, 255, 255, 255), "centerpoint")
    if setting.resID and setting.resID > 5 and setting.reso_value then
        ui:RenderText("title", ("当前分辨率：%d*%d"):format(setting.reso_value * 16 / 9, setting.reso_value),
                198, 250, 1, Color(150, 255, 255, 255), "centerpoint")
    end
    SetViewMode "world"
end