Include "THlib\\UI\\font.lua"
ui = {}
ui.version = "v1.0.0"
ui.menu = {
    font_size = 0.625,
    line_height = 24,
    char_width = 20,
    num_width = 12.5,
    title_color = { 255, 255, 255 },
    unfocused_color = { 190, 190, 190 },
    unfocused_color2 = { 90, 90, 90 },
    focused_color1 = { 255, 255, 255 },
    focused_color2 = { 250, 128, 114 },
    blink_speed = 2,
    shake_time = 9,
    shake_speed = 40,
    shake_range = 3,
    sc_pr_line_per_page = 14,
    sc_pr_line_height = 22,
    sc_pr_width = 600,
    sc_pr_margin = 8,
    rep_font_size = 0.6,
    rep_line_height = 20
}

local cos, sin, screen, abs, int, lstg, table, string, tostring = cos, sin, screen, abs, int, lstg, table, string, tostring
local task, misc = task, misc
local min, max = min, max
local sign = sign
local Color = Color
local SetViewMode = SetViewMode
local SetImageState = SetImageState
local SetFontState = SetFontState
local unpack = unpack
local Render = Render
local RenderTTF2 = RenderTTF2
local RenderRect = RenderRect
local RenderText = RenderText

function ui:RenderText(ttfname, text, x, y, size, color, ...)
    local a = (color:ARGB())
    local s = size / 0.6 * _TTF_SIZES[ttfname] / 80
    for i = 1, 4 do
        RenderTTF2(ttfname, text, x + i * 0.7 * s, y - i * 0.5 * s, size, Color(a * (1 - i / 5), 0, 0, 0), ...)
    end
    RenderTTF2(ttfname, text, x, y, size, color, ...)

end

---最大宽度渲染字体
function ui:RenderTextInWidth(ttfname, text, x, y, size, maxw, color, ...)
    local a = (color:ARGB())
    local s = size / 0.6 * _TTF_SIZES[ttfname] / 80
    for i = 1, 4 do
        RenderTTF4(ttfname, text, x + i * 0.7 * s, y - i * 0.5 * s, size, maxw, Color(a * (1 - i / 5), 0, 0, 0), ...)
    end
    RenderTTF4(ttfname, text, x, y, size, maxw, color, ...)
end

function ui:RenderTextWithCommand(ttfname, text, x, y, size, alpha, ...)
    local s = size / 0.6 * _TTF_SIZES[ttfname] / 80
    for i = 1, 4 do
        RenderTTF5(ttfname, text, x + i * 0.7 * s, y - i * 0.5 * s, size, alpha * (1 - i / 5), true, ...)
    end
    RenderTTF5(ttfname, text, x, y, size, alpha, false, ...)

end

local particle = {}
local particle2 = {}
local checkContinuingPress_time = 0
function ui:DrawBack(alpha, t)
    if t % (7 + 5 - setting.rdQual) == 0 then
        local va = ran:Float(0, 360)
        local v = 0.4

        table.insert(particle, {
            alpha = 0, maxalpha = 150,
            size = ran:Float(250, 400),
            x = ran:Float(0, 960), y = ran:Float(0, 540),
            vx = cos(va) * v, vy = sin(va) * v,
            timer = 0, lifetime = ran:Int(120, 180),
        })
        table.insert(particle, {
            alpha = 0, maxalpha = 250,
            size = ran:Float(40, 60),
            x = ran:Float(0, 960), y = ran:Float(0, 540),
            vx = cos(va) * v, vy = sin(va) * v,
            timer = 0, lifetime = ran:Int(75, 120),
        })
        table.insert(particle2, {
            alpha = 0, maxalpha = 255,
            size = ran:Float(1, 2) * ran:Int(1, 4),
            x = ran:Float(0, 960), y = ran:Float(0, 540),
            v = v, rotate = ran:Float(0, 360), o = ran:Float(1, 2) * ran:Sign(),
            timer = 0, lifetime = ran:Int(75, 120),
        })
        table.insert(particle2, {
            alpha = 0, maxalpha = 255,
            size = ran:Float(3, 4),
            x = ran:Float(0, 960), y = ran:Float(0, 540),
            v = v * 0.2, rotate = ran:Float(0, 360), o = ran:Float(1, 2) * ran:Sign(),
            timer = 0, lifetime = ran:Int(240, 480),
        })
    end
    local mouse = ext.mouse
    if mouse:isPress(1) then
        for _ = 1, setting.rdQual * 3.5 do
            local x, y = mouse.x, mouse.y
            local v = ran:Float(1, 7)
            table.insert(particle2, {
                alpha = 200, maxalpha = 200,
                size = ran:Float(1, 2) * ran:Int(1, 4),
                x = x, y = y,
                v = v, rotate = ran:Float(0, 360), o = 0,
                timer = 0, lifetime = ran:Int(20, 40),
                slow = true
            })
        end
        checkContinuingPress_time = checkContinuingPress_time + 1
        if checkContinuingPress_time >= 60 * 10 then
        end
    else
        checkContinuingPress_time = 0

    end

    local p
    for i = #particle, 1, -1 do
        p = particle[i]

        p.x = p.x + p.vx
        p.y = p.y + p.vy

        p.timer = p.timer + 1
        if p.timer <= 10 then
            p.alpha = min(p.maxalpha, p.alpha + p.maxalpha / 10)
        elseif p.timer > p.lifetime - 10 then
            p.alpha = max(p.alpha - p.maxalpha / 10, 0)
            if p.alpha == 0 then
                table.remove(particle, i)
            end
        end

    end
    for i = #particle2, 1, -1 do
        p = particle2[i]
        p.rotate = p.rotate + p.o
        local vx = p.v * cos(p.rotate)
        local vy = p.v * sin(p.rotate)
        p.x = p.x + vx
        p.y = p.y + vy
        if p.slow then
            p.v = p.v - p.v * 0.05
        end

        p.timer = p.timer + 1
        if p.timer <= 10 then
            p.alpha = min(p.maxalpha, p.alpha + p.maxalpha / 10)
        elseif p.timer > p.lifetime - 10 then
            p.alpha = max(p.alpha - p.maxalpha / 10, 0)
            if p.alpha == 0 then
                table.remove(particle2, i)
            end
        end

    end
    SetViewMode('ui')
    local scale = 1 + sin(t / 3) * 0.1
    local rot = -90
    local v = 3
    misc.RenderTexInRect("menu_bg_2", 0, screen.width, 0, screen.height, v * cos(rot), v * sin(rot), rot,
            scale / 2, scale / 2, "mul+add",
            Color(alpha * 150, 128 + 64 * sin(t / 2), 128 + 64 * sin(t / 4), 128 + 64 * sin(t / 6)))
    local R, G, B = sp:HSVtoRGB(t * 0.2, 0.5, 0.3)
    for _, c in ipairs(particle) do
        SetImageState("bright", "mul+add", c.alpha * alpha, R, G, B)
        Render("bright", c.x, c.y, 0, c.size / 130)
    end
    for _, c in ipairs(particle2) do
        SetImageState("bright", "mul+add", c.alpha * alpha, 255, 255, 255)
        Render("bright", c.x, c.y, 0, c.size / 130)
    end

    SetImageState("menu_bg", "mul+rev", 255, 255, 255, 255)
    Render("menu_bg", 480, 270)


end

function ui:DrawMenu(title, text, pos, x, y, alpha, timer, shake, align, tri, nopos)
    align = align or "center"
    local ttfname = "title"
    local yos
    if title == "" then
        yos = (#text + 1) * self.menu.line_height * 0.5
    else
        yos = (#text - 1) * self.menu.line_height * 0.5
        self:RenderText(ttfname, title, x, y + yos + self.menu.line_height, 1,
                Color(alpha * 255, unpack(self.menu.title_color)), "center", "vcenter")
    end
    local t, now, color, k, xos
    for i = 1, #text do
        if i == pos then
            if text[i] ~= "" then
                color = {}
                k = cos(timer * self.menu.blink_speed)
                k = k * k
                for j = 1, 3 do
                    color[j] = self.menu.focused_color1[j] * k + self.menu.focused_color2[j] * (1 - k)
                end
                xos = self.menu.shake_range * sin(self.menu.shake_speed * shake)
                t = text[i]
                now = t
                self:RenderText(ttfname, "♪" .. t, x + xos, y - i * self.menu.line_height + yos, 1 + 0.2 * tri * tri,
                        Color(alpha * 255, unpack(color)), align, "vcenter")
            end
        else
            t = text[i]
            self:RenderText(ttfname, t, x, y - i * self.menu.line_height + yos, 1,
                    Color(alpha * 255, unpack(self["menu"]["unfocused_color" .. ((nopos and nopos[i]) and "2" or "")])), align, "vcenter")
        end
    end
end

function ui:DrawMenuTTF(ttfname, title, text, pos, x, y, alpha, timer, align, tri)
    align = align or "center"
    local yos
    if title == "" then
        yos = (#text + 1) * self.menu.sc_pr_line_height * 0.5
    else
        yos = (#text - 1) * self.menu.sc_pr_line_height * 0.5
        self:RenderText(ttfname, title, x, y + yos + self.menu.sc_pr_line_height, 1, Color(alpha * 255, unpack(self.menu.title_color)), align, "vcenter", "noclip")
    end
    local color, k
    for i = 1, #text do
        if i == pos then
            color = {}
            k = cos(timer * self.menu.blink_speed)
            k = k * k
            for j = 1, 3 do
                color[j] = self.menu.focused_color1[j] * k + self.menu.focused_color2[j] * (1 - k)
            end
            self:RenderText("small_text", text[i], x, y - i * self.menu.sc_pr_line_height + yos, 1 + 0.1 * (tri or 0),
                    Color(alpha * 255, unpack(color)), align, "vcenter", "noclip")
        else
            self:RenderText("small_text", text[i], x, y - i * self.menu.sc_pr_line_height + yos, 1,
                    Color(alpha * 255, unpack(self.menu.unfocused_color)), align, "vcenter", "noclip")
        end
    end
end

local function formatnum(num)
    local S = sign(num)
    num = abs(num)
    local tmp = {}
    local var
    while num >= 1000 do
        var = num - int(num / 1000) * 1000
        table.insert(tmp, 1, string.format("%03d", var))
        num = int(num / 1000)
    end
    table.insert(tmp, 1, tostring(num))
    var = table.concat(tmp, ",")
    if S < 0 then
        var = string.format("-%s", var)
    end
    return var, #tmp - 1
end
_G.formatnum = formatnum
local function RenderScore(fontname, score, x, y, size, ...)
    if score < 10000000000000 then
        RenderText(fontname, formatnum(score), x, y, size, ...)
    else
        RenderText(fontname, "9,999,999,999,990", x, y, size, ...)
    end
end
_G.RenderScore = RenderScore

---@class lstg.lstg_ui
---@return lstg.lstg_ui
local lstg_ui = plus.Class()
lstg.lstg_ui = lstg_ui

local res_list = {
    ["tex"] = {
        "ui_bg",
        "ui_bg2",
        "menu_bg",
        "menu_bg2",
        integer = 1,
    },
    ["img"] = {
        "ui_bg",
        "ui_bg2",
        "menu_bg",
        "menu_bg2",
        integer = 2,
    },
}
function lstg_ui:reloadUI()
    for type, list in pairs(res_list) do
        for _, res in pairs(list) do
            if CheckRes(type, res) == "global" then
                RemoveResource("global", list.integer, res)
            end
        end
    end
    local pool = GetResourceStatus() or "global"
    SetResourceStatus("global")
    if self.type == 1 then
    elseif self.type == 2 then
    end
    SetResourceStatus(pool)
end
function lstg_ui:init()
    if setting.resx > setting.resy then
        self.type = 1
    else
        self.type = 2
    end
    self.alpha = 1
    self.alpha2 = 1
    self.rotate = 0
    self.lifeleft = 0
    self:reloadUI()
    self.acalpha = { 0, 0, 0 }
    self.season_alpha = 0
end
function lstg_ui:drawFrame()
    self["drawFrame" .. self.type](self)
end
function lstg_ui:drawFrame1()
    SetViewMode "ui"


    SetViewMode "world"
end
function lstg_ui:drawFrame2()
    SetViewMode "ui"
    SetViewMode "world"
end

function lstg_ui:ScoreRefresh()
    local cur_score = lstg.var.score
    local score = self.score or cur_score
    if score < cur_score then
        if cur_score - score <= 100 then
            score = score + 10
        elseif cur_score - score <= 1000 then
            score = score + 100
        else
            score = int(score / 10 + int((cur_score - score) / 600)) * 10 + cur_score % 10
        end
    end
    self.score = min(cur_score, score)
end

function lstg_ui:ScoreUpdate()
    self:ScoreRefresh()
end
function lstg_ui:drawScore()
    self:ScoreUpdate()
    self["drawScore" .. self.type](self)
end

CreateRenderTarget("player_avator")
function lstg_ui:drawScore1()
    SetViewMode "ui"


    SetViewMode "world"
end

function lstg_ui:drawScore2()

end

function ResetUI()
    lstg.ui = lstg.lstg_ui()
    function ui.DrawFrame()
        if lstg.ui then
            lstg.ui:drawFrame()
        end
    end
    function ui.DrawScore()
        if lstg.ui then
            lstg.ui:drawScore()
        end
    end
end

ResetUI()

ui.ChaosRenderObj = Class(object)
function ui.ChaosRenderObj:init()
    self.layer = 300
    self.group = GROUP.GHOST
    self.alpha = 0
    self._alpha = 0
    self.R, self.G, self.B = 218, 112, 214
    self.particle = {}
    self.turn_on = false
    self.turn_on2 = false
    local j = 0
    self.newpar = function(vx, life)
        j = j + setting.rdQual / 5
        if j >= 1 then
            table.insert(self.particle, {
                alpha = 0, maxalpha = ran:Float(40, 70),
                size = ran:Float(2, 5),
                rindex = 0,
                x = 960, y = ran:Float(0, 540),
                vx = ran:Float(vx - 1, vx + 1), vy = ran:Float(-1, 1),
                timer = 0, lifetime = ran:Int(life - 15, life + 15)
            })
            table.insert(self.particle, {
                alpha = 0, maxalpha = ran:Float(40, 70),
                size = ran:Float(2, 5),
                rindex = 0,
                x = 0, y = ran:Float(0, 540),
                vx = -ran:Float(vx - 1, vx + 1), vy = ran:Float(-1, 1),
                timer = 0, lifetime = ran:Int(life - 15, life + 15)
            })
            j = j - 1
        end
    end
    self.index = 0
end
function ui.ChaosRenderObj:frame()
    local c = lstg.var.chaos
    if c >= 50 then
        if not self.turn_on then
            self.turn_on = true
            for _ = 1, 100 do
                self.newpar(ran:Float(-2, -25), 45)
            end
            self.index = 1
            PlaySound("focusfix")
        end
        self._alpha = 1
        if c >= 100 then
            if not self.turn_on2 then
                self.turn_on2 = true
                for _ = 1, 150 do
                    self.newpar(ran:Float(-2, -40), 80)
                end
                self.index = 1
                PlaySound("focusfix")
            end
            self.R, self.G, self.B = 250, 100, 100
            self.newpar(ran:Float(-4, -7), 45)
        else
            self.R, self.G, self.B = 218, 112, 214
            if self.turn_on2 then
                self.turn_on2 = false
                self.index = 1
            end
            self.newpar(-4, 45)
        end

    else
        self.turn_on = false
        self._alpha = 0
    end
    self.index = self.index - self.index * 0.04
    self.alpha = self.alpha + (-self.alpha + self._alpha) * 0.1
    local p
    for i = #self.particle, 1, -1 do
        p = self.particle[i]
        p.x = p.x + p.vx
        p.y = p.y + p.vy
        p.vx = p.vx - p.vx * 0.06
        p.timer = p.timer + 1
        if p.timer <= 10 then
            p.alpha = p.timer / 10 * p.maxalpha
        elseif p.timer > p.lifetime - 10 then
            p.alpha = max(p.alpha - p.maxalpha / 10, 0)
            if p.alpha == 0 then
                table.remove(self.particle, i)
            end
        end

    end

end
function ui.ChaosRenderObj:render()
    SetViewMode("ui")
    local R, G, B = self.R, self.G, self.B
    R = self.R + (255 - self.R) * self.index
    G = self.G + (255 - self.G) * self.index
    B = self.B + (255 - self.B) * self.index
    for _, p in ipairs(self.particle) do
        SetImageState("white", "mul+add", p.alpha * self.alpha, R, G, B)
        misc.SectorRender(p.x, p.y, p.size * p.rindex, p.size, 0, 360, 2 + setting.rdQual, 0)
    end
    local col1 = Color(0, R, G, B)
    local col2 = Color(self.alpha * 75, R, G, B)
    SetImageState("white", "mul+add", 666, 0, 0, 0)--刷新存储列表
    OriginalSetImageState("white", "mul+add", col1, col2, col2, col1)
    RenderRect("white", 960 - (152 + self.index * 100) * self.alpha, 960 + 45 - 45 * self.alpha, 0, 540)
    RenderRect("white", (152 + self.index * 100) * self.alpha, -45 + 45 * self.alpha, 0, 540)
    SetViewMode("world")
end