---=====================================
---achievement
---=====================================

----------------------------------------
---成就更新
---
local function _t(str)
    return Trans("ext", str) or ""
end

LoadSound("se_notice", "THlib\\UI\\se_notice.wav")
LoadSound("se_trophy", "THlib\\UI\\se_trophy.wav")
LoadTexture("trophy", "THlib\\UI\\trophy.png")
LoadImage("tr_black", "trophy", 0, 0, 384, 88)
LoadImage("tr_cup", "trophy", 0, 88, 96, 104)
SetImageState("tr_cup", "", 255, 255, 227, 132)
LoadImage("tr_gold", "trophy", 96, 96, 32, 32)

local achievement = {
    rank = {
        { 192, 192, 192 },
        { 150, 252, 180 },
        { 120, 180, 255 },
        { 228, 100, 234 },
        { 250, 118, 120 },
        { 255, 223, 120 }
    }
}
achievement.getcount = 0
function achievement:init()
    self.acetext = AchievementInfo
    self.list = {}
    self.achievement = {}
    self.gold = {}
    self.timer = 0

end
local rand = math.random
function achievement:frame()
    task.Do(self)
    self.timer = self.timer + 1
    local a
    if self.achievement[1] then
        a = self.achievement[1]
        if a.timer == 1 then
            PlaySound("se_trophy", 1)
        end
        if a.timer <= 10 then
            a.y = 620 - sin(a.timer * 9) * 120
        elseif a.timer % 3 == 0 then
            table.insert(self.gold, {
                x = a.x + (rand() - 0.5) * 80,
                y = a.y + (rand() - 0.5) * 40,
                v = rand() + 0.5,
                a = rand() * 360,
                rot = rand() * 360,
                omiga = ({ -1, 1 })[rand(2)] * 3,
                scale = 0,
                alpha = 0,
                timer = 1
            })
        end
        if a.timer % 60 >= 0 and a.timer % 60 <= 15 then
            a.cups = 0.3 + 0.2 * sin((a.timer % 60) * 12)
        end
        if a.timer % 20 < 10 then
            a.col = { 135, 206, 235 }
        else
            a.col = { 150, 150, 150 }
        end
        if a.timer >= 150 then
            a.y = 500 + 120 * task.SetMode[1](min(60, a.timer - 150) / 60)
        end--快1.5秒
        a.timer = a.timer + 1
        if a.timer > 150 + 60 then
            table.remove(self.achievement, 1)
        end
    end
    local g
    for i = #self.gold, 1, -1 do
        g = self.gold[i]
        g.x = g.x + cos(g.a) * g.v
        g.y = g.y + sin(g.a) * g.v
        g.rot = g.rot + g.omiga
        g.scale = min(0.3, g.scale + 0.03)
        if g.timer <= 10 then
            g.alpha = min(150, g.alpha + 150 / 10)
        end
        if g.timer >= 60 then
            g.alpha = max(0, g.alpha - 150 / 15)
        end
        if g.alpha == 0 and g.timer > 10 then
            table.remove(self.gold, i)
        end
        g.timer = g.timer + 1
    end
end
function achievement:render()
    local a
    SetViewMode("ui")
    local english = setting.language == 2
    local ttf = english and "pretty_title" or "title"
    if self.achievement[1] then
        a = self.achievement[1]
        if a.isachievement then
            Render("tr_black", a.x, a.y, 0, 0.7, 1)
            Render("tr_cup", a.x - 80, a.y, 180, a.cups)
            ui:RenderText("pretty_title", _t("getAchv"), a.x + 18, a.y + 26,
                    0.8, Color(255, unpack(a.col)), "center")
            ui:RenderText(ttf, self.acetext[a.co].name, a.x + 18, a.y + 6,
                    0.8, Color(255, unpack(a.color)), "center")
            local str = sp:SplitText(self.acetext[a.co].getway, "\n")
            ui:RenderTextWithCommand(ttf, str[1], a.x + 18, a.y - 17,
                    0.5, 180, "center")
        else
            local tool = a.tool
            local x, y = a.x - 80, a.y
            local m = mission_lib.MissionMap[tool.id]
            local size = 0.55 + a.cups * 0.2
            Render("tr_black", a.x, a.y, 0, 0.7, 1)
            SetImageState("bright", "mul+add", 255, tool.R, tool.G, tool.B)
            Render("bright", x, y, 0, size * 0.6)
            SetImageState("mission_unit_back", "add+alpha", 255, m.Rb, m.Gb, m.Bb)
            Render("mission_unit_back", x, y, 0, size)
            SetImageState("mission_unit_outline", "", 255, m.R, m.G, m.B)
            Render("mission_unit_outline", x, y, 0, size)--]]
            SetImageState(tool.pic, "", 255, 255, 255, 255)
            Render(tool.pic, x, y, 0, size * 0.25)
            ui:RenderText("pretty_title", _t("unlockItem"), a.x + 18, a.y + 26,
                    0.8, Color(255, unpack(a.col)), "center")
            ui:RenderText(ttf, tool.title2, a.x + 18, a.y + 6,
                    0.8, Color(255, unpack(a.color)), "center")
            ui:RenderTextWithCommand(ttf, tool.unlock_des, a.x + 18, a.y - 17,
                    0.5, 180, "center")
        end
    end
    for _, g in ipairs(self.gold) do
        SetImageState("tr_gold", "mul+add", g.alpha, 255, 227, 132)
        Render("tr_gold", g.x, g.y, g.rot, g.scale)
    end
    SetViewMode("world")
end

function achievement:get(id)
    if not GlobalAddAchievement then
        return
    end

    if not scoredata.Achievement[id] then
        self.acetext = AchievementInfo
        local flag = true
        if IsSpecialMode() then
            flag = not self.acetext[id].noget_insp
        end
        if flag then
            table.insert(self.achievement, {
                isachievement = true,
                x = 820, y = 620, co = id, timer = 1, cups = 0.3,
                col = { 135, 206, 235 }, color = self.rank[self.acetext[id].rank]
            })
            scoredata.Achievement[id] = true
            scoredata.AchievementGetTime[id] = os.time()
            self.getcount = self.getcount + 1
            if self.getcount >= #self.acetext - 1 then
                self:get(117)
            end
            if self.getcount >= 100 then
                self:get(112)
            end
            if self.getcount >= 75 then
                self:get(91)
            end
            if self.getcount >= 45 then
                self:get(60)
            end
            if self.getcount >= 18 then
                self:get(41)
            end
            if self.getcount >= 2 then
                self:get(27)
            end
        end
    else
        return true
    end
end

---任务的获得提示和成就放在一起，防止显示重叠
function achievement:getMission(toolid)
    if not GlobalAddAchievement then
        return
    end
    if not scoredata.UnlockAddition[toolid] then
        local tool = stg_levelUPlib.AdditionTotalList[toolid]
        table.insert(self.achievement, {
            x = 820, y = 620, tool = tool, timer = 1, cups = 0.3,
            col = { 135, 206, 235 }, color = { tool.R, tool.G, tool.B }
        })
        scoredata.UnlockAddition[toolid] = true
        scoredata.BookAddition[toolid] = true
        --AddMoney(getmoney[self.acetext[id][5]])
    else
        return true
    end
end

---@class ext.achievement @实时更新的成就
ext.achievement = achievement
ext.achievement:init()

