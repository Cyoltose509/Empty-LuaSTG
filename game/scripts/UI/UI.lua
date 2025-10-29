Include "scripts\\UI\\font.lua"
ui = {}
ui.version = "v0.1.0"

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

function lstg_ui:init()
    self.type = 2
    self.alpha = 1
    self.alpha2 = 1
    self.rotate = 0
    self.lifeleft = 0
    self.acalpha = { 0, 0, 0 }
    self.season_alpha = 0
end
function lstg_ui:drawFrame()
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