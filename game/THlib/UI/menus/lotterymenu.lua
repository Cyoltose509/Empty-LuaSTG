local function _t(str)
    return Trans("sth", str) or ""
end

local lib = lottery_lib

local lottery_menu = stage.New("lottery", false, true)

local colors = {
    { 135, 206, 235 },
    { 218, 112, 214 },
    { 255, 227, 132 }
}

local Lottery_Ball_Show = plus.Class()
local CheckRecord = {}
local CheckRecord_Submenu = {}
local informationRead = {}
local Detail_Submenu = {}
local SetOrbit = {}
local SetOrbit_Submenu = {}
local function GetLottery()
    local Have_chara, Have_tool
    local chara = {}
    local tool = {}
    local data = scoredata
    for _, p in ipairs(lib.currentPool) do
        if p.state == 3 then
            Have_chara = true
            table.insert(chara, p)
        end
        if p.state == 2 then
            Have_tool = true
            table.insert(tool, p)
        end
    end
    local p = ran:Int(1, #lib.currentPool)
    local reward = lib.currentPool[p]
    if reward.state ~= 3 and Have_chara and data.baodi_chara >= 39 then
        reward = chara[ran:Int(1, #chara)]
        data.baodi_chara = 0
    elseif reward.state ~= 2 and Have_tool and data.baodi_tool >= 9 then
        reward = tool[ran:Int(1, #tool)]
        data.baodi_tool = 0
    end
    if reward.state == 3 then
        data.baodi_chara = 0
        data.baodi_tool = data.baodi_tool + 1
        data._total_gongfeng_chara = data._total_gongfeng_chara + 1
        ext.achievement:get(67)
    elseif reward.state == 2 then
        data.baodi_tool = 0
        data.baodi_chara = data.baodi_chara + 1
        data._total_gongfeng_tool = data._total_gongfeng_tool + 1
        if not data.Achievement[97] then
            ext.achievement:get(48)
            if data._total_gongfeng_tool >= 10 then
                ext.achievement:get(68)
            end
            if data._total_gongfeng_tool == lib.ToolCount then
                ext.achievement:get(97)
            end
        end
    else
        data.baodi_tool = data.baodi_tool + 1
        data.baodi_chara = data.baodi_chara + 1
    end
    lib.GetReward(reward)
    lib.InitRewardPool()
    do
        data._total_gongfeng = data._total_gongfeng + 1
        if not data.Achievement[47] then
            ext.achievement:get(28)
            if data._total_gongfeng >= 2 then
                ext.achievement:get(29)
            end
            if data._total_gongfeng >= 3 then
                ext.achievement:get(30)
            end
            if data._total_gongfeng >= 10 then
                ext.achievement:get(47)
            end
        end
    end
    return reward

end

function Lottery_Ball_Show:init(x, y, lotteryid)
    self.id = lotteryid
    self.reward = lib.totalPool[self.id]
    self.maxqual = self.reward.quality

    self.x, self.y = x - 960, y
    self.index = 0
    self.timer = 0
    self.r = 80
    self.alpha = 1
    self.selected = false
    self.locked = true
    task.New(self, function()
        for i = 1, 30 do
            i = task.SetMode[2](i / 30)
            self.x = x - 960 + 960 * i
            task.Wait()
        end
        if not self.showing then
            self.locked = false
        end
    end)
    self.state = 1

    self.R, self.G, self.B = unpack(colors[1])
    self.bR = 1.4
    self.mR = 0
    self.mR2 = 0
    self.alpha2 = 0
    self.alpha3 = 1
    self.alpha4 = 0
    self.particle = {}
    self.offi = 0
    self.offai = 0
    self.circlea = 0
    self.circlea2 = 1
    self.particleFlag = false
    self.pass = false
    self.func = function()
        self.showing = true
        self.locked = true
        task.New(self, function()
            for i = 1, 15 do
                self.alpha2 = i / 15
                if not self.pass then
                    task.Wait()
                end
            end
        end)
        task.New(self, function()
            lottery_menu.R, lottery_menu.G, lottery_menu.B = self.R, self.G, self.B
            if self.maxqual >= 2 then
                local cR, cG, cB = unpack(colors[1])
                local tR, tG, tB = unpack(colors[2])
                for i = 1, 50 do
                    i = task.SetMode[3](i / 50)
                    self.R = cR + (-cR + tR) * i
                    self.G = cG + (-cG + tG) * i
                    self.B = cB + (-cB + tB) * i
                    lottery_menu.R, lottery_menu.G, lottery_menu.B = self.R, self.G, self.B
                    if not self.pass then
                        task.Wait()
                    end
                end
            end
            if self.maxqual >= 3 then
                local cR, cG, cB = unpack(colors[2])
                local tR, tG, tB = unpack(colors[3])

                for i = 1, 50 do
                    i = task.SetMode[3](i / 50)
                    self.R = cR + (-cR + tR) * i
                    self.G = cG + (-cG + tG) * i
                    self.B = cB + (-cB + tB) * i
                    lottery_menu.R, lottery_menu.G, lottery_menu.B = self.R, self.G, self.B
                    self.bR = 1.4 + 2.6 * i
                    if not self.pass then
                        task.Wait()

                    end
                end
                for i = 1, 50 do
                    i = task.SetMode[3](i / 50)
                    self.bR = 4 - 2 * i
                    if not self.pass then
                        task.Wait()

                    end
                end
            end
        end)
        task.New(self, function()
            for i = 1, 40 do
                self.mR = task.SetMode[3](i / 40)
                if not self.pass then
                    task.Wait()

                end
            end
            for i = 1, 60 do
                self.mR2 = task.SetMode[3](i / 60)
                if not self.pass then
                    task.Wait()
                end
            end
            self.index = 0
            if self.maxqual == 1 then
                PlaySound("bonus")
            elseif self.maxqual == 2 then
                PlaySound("bonus2")
                PlaySound("pin00")
            elseif self.maxqual == 3 then
                PlaySound("lgods3")
                PlaySound("bonus")
                PlaySound("piyo")
            end
            self.particleFlag = true
            self.circlea = 1
            task.New(self, function()
                for i = 1, 60 do
                    i = task.SetMode[2](i / 60)
                    self.offai = 9 - 5 * i
                    task.Wait()
                end
                for i = 1, 60 do
                    i = task.SetMode[2](i / 60)
                    self.circlea = 1 - i
                    task.Wait()
                end
                self.particleFlag = false
            end)
            if self.maxqual == 3 then
                task.New(self, function()
                    local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
                    local w, h = screen.width, screen.height
                    uv1[4], uv1[5] = UIToScreen(0, h)
                    uv2[4], uv2[5] = UIToScreen(w, h)
                    uv3[4], uv3[5] = UIToScreen(w, 0)
                    uv4[4], uv4[5] = UIToScreen(0, 0)
                    local cx = w / 2
                    local cy = h / 2
                    local w1, w2 = cx, w - cx
                    local h1, h2 = cy, h - cy
                    local color = Color(255, 255, 255, 255)
                    for i = 1, 45 do
                        local _cx, _cy = cx, cy
                        local range = 55
                        local l = 4 * task.SetMode[1](1 - i / 45)
                        _cx = _cx + cos(i * range) * l
                        _cy = _cy + sin(i * range) * l
                        ext.OtherScreenEff:Open(function(scr)
                            uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
                            uv1[1], uv1[2] = _cx - w1, _cy + h2
                            uv2[1], uv2[2] = _cx + w2, _cy + h2
                            uv3[1], uv3[2] = _cx + w2, _cy - h1
                            uv4[1], uv4[2] = _cx - w1, _cy - h1
                            RenderTexture(scr.name, "", uv1, uv2, uv3, uv4)
                        end, false)
                        task.Wait()
                    end
                end)
            end

            self.state = 2
            self.locked = false
            for i = 1, 25 do
                self.alpha4 = i / 25
                self.alpha3 = 1 - i / 25
                task.Wait()
            end
        end)

    end

end
function Lottery_Ball_Show:frame()
    task.Do(self)
    self.timer = self.timer + 1
    self.offi = self.offi + self.offai
    if self.particleFlag then
        for _ = 1, 3 do
            local R = self.offi * 2
            local a = ran:Float(0, 360)
            table.insert(self.particle, {
                alpha = 15, maxalpha = ran:Float(40, 70),
                size = ran:Float(4, 9),
                rindex = 0.8,
                x = cos(a) * R, y = sin(a) * R,
                vx = ran:Float(-0.5, 0.5), vy = ran:Float(-0.5, 0.5),
                timer = 0, lifetime = ran:Int(30, 60),
                rot = ran:Float(0, 360), omiga = ran:Float(1, 2) * ran:Sign()
            })
        end
    end
    if self.state == 2 then
        local R = self.r
        local a = ran:Float(0, 360)
        table.insert(self.particle, {
            alpha = 0, maxalpha = ran:Float(40, 70),
            size = ran:Float(1, 2),
            rindex = 0,
            x = cos(a) * R, y = sin(a) * R,
            vx = cos(a), vy = sin(a),
            timer = 0, lifetime = ran:Int(30, 60),
            rot = ran:Float(0, 360), omiga = ran:Float(1, 2) * ran:Sign()
        })
    end
    local p
    for i = #self.particle, 1, -1 do
        p = self.particle[i]
        p.x = p.x + p.vx
        p.y = p.y + p.vy
        p.rot = p.rot + p.omiga
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
    if self.locked then
        self.index = self.index + (-self.index + 1) * 0.1
        return
    end
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
        if self.state == 2 then

            if mouse:isUp(1) then
                self.index = self.index + 0.5
                local rew = self.reward
                if rew.state == 2 then
                    Detail_Submenu:In(stg_levelUPlib.AdditionTotalList[rew.data])
                    PlaySound("ok00")
                end
            end
        else
            if mouse:isPress(1) then
                self.index = self.index + 0.5
                PlaySound("ok00")
                self.func()
            end
        end

    end


end
function Lottery_Ball_Show:render(A)
    local k = self.index
    local R, G, B = self.R, self.G, self.B
    local ax, ay = self.x, self.y
    local adsize = self.r + k * 10
    local t = self.timer
    local a2 = self.alpha2
    local Ac = 160 * a2 * (sin(t * 4) * 0.2 + 0.7) * self.alpha2
    SetImageState("white", "mul+add", 666, 0, 0, 0)--刷新存储列表
    OriginalSetImageState("white", "mul+add",
            Color(0, R, G, B),
            Color(Ac, R, G, B),
            Color(Ac, R, G, B),
            Color(0, R, G, B))
    misc.SectorRender(ax, ay, adsize, adsize * self.bR, 0, 360, 40, 0)
    SetImageState("menu_circle", "", (200 + k * 50) * A * self.alpha, 200, 200, 200)
    Render("menu_circle", ax, ay, 0, (adsize + 4) / 192)

    for _, p in ipairs(self.particle) do
        SetImageState("white", "mul+add", p.alpha, R, G, B)
        misc.SectorRender(self.x + p.x, self.y + p.y, p.size * p.rindex, p.size, 0, 360, 5, p.rot)
    end
    if self.circlea * self.circlea2 > 0 then
        for i = 1, 60 do
            local offi = self.offi
            local n = min(30, 5 + int(offi + i) * 3)
            local r1, r2 = (i - 1 + offi) * 2, (i + offi) * 2
            if self.maxqual == 3 then
                r1, r2 = (i * 2 - 2 + offi) * 2, (i * 2 + offi) * 2
            end
            local _x, _y = self.x, self.y

            for m = 1, n do
                local ang = 360 / n
                local angle = 360 / n * m + 210
                local alpha = A * 120 * sin(i * 3) * self.circlea2 * self.circlea
                if self.maxqual == 3 then
                    SetImageState("white", "mul+add", alpha, sp:HSVtoRGB(i * 6, 0.4, 1))
                else
                    SetImageState("white", "mul+add", alpha, R, G, B)

                end
                Render4V('white',
                        _x + r2 * cos(angle - ang), _y + r2 * sin(angle - ang), 0.5,
                        _x + r1 * cos(angle - ang), _y + r1 * sin(angle - ang), 0.5,
                        _x + r1 * cos(angle), _y + r1 * sin(angle), 0.5,
                        _x + r2 * cos(angle), _y + r2 * sin(angle), 0.5)

            end
        end
    end
    local lA = self.alpha4 * 255
    if lA > 0 then
        local rew = self.reward
        if rew.state == 1 then
            local img = "menu_lottery_money"
            SetImageState(img, "mul+add", lA, 255, 255, 255)
            Render(img, self.x, self.y, 0, adsize / 256)
            ui:RenderText("pretty", ("%s+%d"):format(_t("money"), rew.data), self.x, self.y - adsize * 1.14,
                    0.4, Color(lA, R, G, B), "centerpoint")
        elseif rew.state == 2 then
            local tool = stg_levelUPlib.AdditionTotalList[rew.data]
            local img = tool.pic

            SetImageState(img, "", lA, 255, 255, 255)
            Render(img, self.x, self.y, 0, adsize / 200)
            SetImageState("bright", "mul+add", lA * 0.7, tool.R, tool.G, tool.B)
            Render("bright", self.x, self.y, 0, adsize / 120)
            ui:RenderText("pretty", tool.title2, self.x, self.y - adsize * 1.14,
                    0.42, Color(lA, R, G, B), "centerpoint")
        elseif rew.state == 3 then
            local p = player_list[rew.data]
            misc.RenderTexInCircle(p.picture, self.x, self.y, p.renderx, p.rendery,
                    adsize * 0.965, 0, p.renderscale * (0.6 + self.index * 0.2), "",
                    Color(lA, 255, 255, 255), 75)

            ui:RenderText("pretty", p.display_name, self.x, self.y - adsize * 1.15,
                    0.45, Color(lA, R, G, B), "centerpoint")
        end
    end

    local kalpha = self.mR2 * 255
    local wA = self.alpha2 * self.alpha3
    SetImageState("white", "mul+add", 666, 0, 0, 0)--刷新存储列表
    OriginalSetImageState("white", "mul+add",
            Color(kalpha * wA, 255, 255, 255),
            Color(255 * wA, 255, 255, 255),
            Color(255 * wA, 255, 255, 255),
            Color(kalpha * wA, 255, 255, 255))
    misc.SectorRender(ax, ay, adsize, adsize * (1 - self.mR), 0, 360, 40, 0)

end

function lottery_menu:init()
    mask_fader:Do("open")
    self.exit_func = function()
        task.New(self, function()
            self.locked = true
            mask_fader:Do("close")
            task.Wait(15)
            stage.Set("none", lastmenu.stage_name)
        end)
    end
    self.top_bar = top_bar_Class(self, _t("consecrate"))
    self.top_bar:addReturnButton(self.exit_func)
    self.lotterying = false
    self.get10_button = {
        x = 640, y = 60, index = 0,
        w = 230, h = 48,
        scale = 0.3,
        selected = false,
        text = ("%s 10 %s"):format(_t("consecrate"), _t("times")),
        func = function()
            local count = #lib.currentPool
            count = min(10, count)
            if count > 0 then
                local nowPearls = scoredata.nowPearls
                if nowPearls >= count then
                    AddPearl(-count)
                    self.refreshcount = false
                    task.New(self, function()
                        task.New(self, function()
                            for i = 1, 15 do
                                i = i / 15
                                self.alpha = 1 - i
                                task.Wait()
                            end
                        end)
                        self.lotterying = true
                        self.top_bar:flyOut(true)
                        local tmp = {}
                        local j = 1
                        for _ = 1, count do
                            table.insert(tmp, GetLottery())
                        end
                        do
                            if j <= count then
                                for x = -1, 1 do
                                    table.insert(self.balls, Lottery_Ball_Show(x * 230 + 480, 425, tmp[j].id))
                                    j = j + 1
                                    if j > count then
                                        break
                                    end
                                end
                            end
                            if j <= count then
                                for x = -1.5, 1.5 do
                                    table.insert(self.balls, Lottery_Ball_Show(x * 230 + 480, 270, tmp[j].id))
                                    j = j + 1
                                    if j > count then
                                        break
                                    end
                                end
                            end
                            if j <= count then
                                for x = -1, 1 do
                                    table.insert(self.balls, Lottery_Ball_Show(x * 230 + 480, 115, tmp[j].id))
                                    j = j + 1
                                    if j > count then
                                        break
                                    end
                                end
                            end
                        end
                        table.sort(self.balls, function(a, b)
                            return a.maxqual < b.maxqual
                        end)
                        task.Wait(30)
                        self.pass_click = true
                        task.New(self, function()
                            for i = 1, 15 do
                                i = i / 15
                                self.pass_alpha = i
                                task.Wait()
                            end
                        end)
                    end)
                else
                    New(info, _t("notEnoughPearl"), 150, 20)
                    PlaySound("invalid")
                end
            else
                New(info, _t("notEnoughLottery"), 150, 20)
                PlaySound("invalid")
            end
        end,
        frame = attributeselectmenu.general_buttonFrame,
        render = attributeselectmenu.general_buttonRender
    }
    self.get1_button = {
        x = 320, y = 60, index = 0,
        w = 230, h = 48,
        scale = 0.3,
        selected = false,
        text = ("%s 1 %s"):format(_t("consecrate"), _t("times")),
        func = function()
            if #lib.currentPool > 0 then
                local nowPearls = scoredata.nowPearls
                if nowPearls >= 1 then
                    AddPearl(-1)
                    self.refreshcount = false
                    task.New(self, function()
                        task.New(self, function()
                            for i = 1, 15 do
                                i = i / 15
                                self.alpha = 1 - i
                                task.Wait()
                            end
                        end)
                        self.lotterying = true
                        self.pass_click = true
                        self.top_bar:flyOut(true)
                        local p = GetLottery()
                        local ball = Lottery_Ball_Show(480, 270, p.id)
                        table.insert(self.balls, ball)
                        ball.func()
                        task.Wait(30)
                        self.pass_click = true
                        task.New(self, function()
                            for i = 1, 15 do
                                i = i / 15
                                self.pass_alpha = i
                                task.Wait()
                            end
                        end)
                    end)
                else
                    New(info, _t("notEnoughPearl"), 150, 20)
                    PlaySound("invalid")
                end
            else
                New(info, _t("notEnoughLottery"), 150, 20)
                PlaySound("invalid")
            end
        end,
        frame = attributeselectmenu.general_buttonFrame,
        render = attributeselectmenu.general_buttonRender
    }
    self.show_count_button = {
        x = 480, y = 330, index = 0,
        w = 230, h = 48,
        scale = 0.25,
        img = "wishing_ball",
        selected = false,
        func = function()
        end,
        frame = attributeselectmenu.general_buttonFrame,
        render = function(self, A)
            A = A or 1
            local k = self.index
            local x, y = self.x, self.y
            local s = (self.scale + k * 0.01)
            SetImageState("menu_button", "", A * 200, 200 - k * 50, 200, 200 - k * 50)
            Render("menu_button", x, y, 0, s * self.w / 230, s * self.h / 48)

            SetImageState(self.img, "", A * 200, 255, 255, 255)
            Render(self.img, x - 20 + 14 * s, y, 0, 0.15 * s)
            ui:RenderText("pretty_title", _t("curPearl"), x - 50, y + 1,
                    3 * s, Color(A * 200, 255, 227, 132), "left", "vcenter")
            ui:RenderText("pretty_title", ("%d"):format(scoredata.nowPearls), x + 50, y + 1,
                    3 * s, Color(A * 200, 255, 200, 200), "right", "vcenter")

        end
    }
    self.pass_button = {
        x = 906, y = 500, index = 0,
        w = 150, h = 50,
        scale = 0.2,
        selected = false,
        text = _t("skip"),
        func = function()
            task.New(self, function()
                for _, b in ipairs(self.balls) do
                    if not b.showing then
                        b.func()
                    end
                    b.pass = true
                end
                self.pass_click = false
                for i = 1, 15 do
                    i = i / 15
                    self.pass_alpha = 1 - i
                    task.Wait()
                end
                self.return_click = true
                for i = 1, 15 do
                    i = i / 15
                    self.return_alpha = i
                    task.Wait()
                end
            end)
        end,
        frame = attributeselectmenu.general_buttonFrame,
        render = attributeselectmenu.general_buttonRender
    }
    self.return_button = {
        x = 906, y = 500, index = 0,
        w = 150, h = 50,
        scale = 0.2,
        selected = false,
        text = _t("returnBack"),
        func = function()
            task.New(self, function()
                self.refreshcount = true
                for i, b in ipairs(self.balls) do
                    b.locked = true
                    b.particleFlag = false
                    b.state = 1
                    task.New(b, function()
                        for k = 1, 60 do
                            b.circlea2 = 1 - k / 60
                            task.Wait()
                        end
                    end)
                    task.New(b, function()
                        task.MoveToForce(b.x, b.y - 570, 60 - i * 3, 3)
                    end)
                end
                self.return_click = false
                task.Wait(60)
                self.balls = {}

                self.lotterying = false
                self.top_bar:flyIn()
                for i = 1, 15 do
                    i = i / 15
                    self.return_alpha = 1 - i
                    self.alpha = i
                    task.Wait()
                end
            end)
        end,
        frame = attributeselectmenu.general_buttonFrame,
        render = attributeselectmenu.general_buttonRender
    }
    self.refreshcount = true
    self.balls = {}
    self.alpha = 1
    self.pass_click = false
    self.pass_alpha = 0
    self.return_click = false
    self.return_alpha = 0
    self.star = {}
    self.star_vx = 1
    self.star_vy = -4
    self.R, self.G, self.B = 135, 206, 235
    lib.InitRewardPool()
    task.New(self, function()
        task.Wait(30)
        while GetKeyState(KEY.Z) do
            task.Wait()
        end
        self.locked = false
    end)
    CheckRecord:init(self, 200, 270)
    CheckRecord_Submenu:init(self)
    informationRead:init(self, 480, 60)
    Detail_Submenu:init(self)
    self.update_list = { player_list[5], player_list[6], player_list[7] }
    self.update_pos = 1
    self.update_alpha = 1
    if #self.update_list > 1 then
        task.New(self, function()
            while true do
                task.Wait(180)
                for i = 1, 60 do
                    self.update_alpha = 1 - i / 60
                    task.Wait()
                end
                self.update_pos = sp:TweakValue(self.update_pos + 1, #self.update_list, 1)
                for i = 1, 60 do
                    self.update_alpha = i / 60
                    task.Wait()
                end
            end
        end)
    end
end
function lottery_menu:NewStar(lx, rx, by, ty)
    local alpha = ran:Float(0.6, 1)
    table.insert(self.star, {
        x = ran:Float(lx, rx), y = ran:Float(by, ty),
        omiga = ran:Float(3, 7) * ran:Sign(), rot = ran:Float(0, 360),
        scale = ran:Float(8, 20), alpha = alpha,
        vindex = alpha / 2 + 0.5
    })
end
function lottery_menu:frame()
    self.timer = self.timer + 1
    self.star_vx = sin(self.timer / 2)
    if self.star_vy ~= 0 then
        if self.timer % int(30 / -self.star_vy) == 0 then
            self:NewStar(-10, 970, 560, 580)
        end
    end
    local s
    for i = #self.star, 1, -1 do
        s = self.star[i]
        s.x = s.x + self.star_vx * s.vindex
        s.y = s.y + self.star_vy * s.vindex
        s.rot = s.rot + s.omiga
        if s.y < -40 then
            table.remove(self.star, i)
        end
    end
    if self.locked then
        return
    end
    menu:Updatekey()
    if Detail_Submenu.locked then
        for _, b in ipairs(self.balls) do
            b:frame()
        end
    end
    if not self.stopclick then
        self.top_bar:frame()
    end

    if self.refreshcount then
        self.count = { 0, 0, 0, 0, 0, 0 }
        self.count[1] = #lib.currentPool
        for _, p in ipairs(lib.currentPool) do
            local m = p.quality + 1
            self.count[m] = self.count[m] + 1
        end
        self.count[5] = scoredata.baodi_tool
        self.count[6] = scoredata.baodi_chara
    else
        ---停止刷新count的显示
    end
    if not self.lotterying then
        if not self.stopclick then
            local count = #lib.currentPool
            count = Forbid(count, 1, 10)
            self.get10_button.text = ("%s %d %s"):format(_t("consecrate"), count, _t("times"))
            self.get1_button:frame()
            self.get10_button:frame()
            self.show_count_button:frame()
            informationRead:frame()
            if menu:keyNo() then
                PlaySound("cancel00")
                self.exit_func()
            end
        end

        CheckRecord:frame()
        CheckRecord_Submenu:frame()


    else
        if Detail_Submenu.locked then
            if self.pass_click then
                self.pass_button:frame()
                local flag = true
                for _, b in ipairs(self.balls) do
                    flag = flag and (b.state == 2)
                end
                if flag then
                    self.pass_button:func()
                end
            end
            if self.return_click then
                self.return_button:frame()
            end
        end
        Detail_Submenu:frame()
    end

end
function lottery_menu:render()
    SetViewMode "ui"
    ui:DrawBack(1, self.timer)
    SetImageState("white", "", 150, 0, 0, 0)
    RenderRect("white", 0, 960, 0, 540)
    for _, s in ipairs(self.star) do
        SetImageState("star_45", "mul+add", 80 * s.alpha, self.R, self.G, self.B)
        Render("star_45", s.x, s.y, s.rot, s.scale / 300)
    end
    self.show_count_button:render(self.alpha)
    self.get1_button:render(self.alpha)
    self.get10_button:render(self.alpha)

    self.pass_button:render(self.pass_alpha)
    self.return_button:render(self.return_alpha)
    if self.alpha > 0 then
        local A = self.alpha
        local x, y = 480, 200
        local w, h = 220, 140
        local x1, x2, y1, y2 = x - w / 2, x + w / 2, y - h / 2, y + h / 2
        SetImageState("white", "", A * 180, 0, 0, 0)
        RenderRect("white", x1, x2, y1, y2)
        SetImageState("white", "", A * 255, 255, 255, 255)
        misc.RenderOutLine("white", x1, x2, y2, y1, 0, 2)
        local Y = y2
        local line_h = 20

        ui:RenderText("title", ("「%s」：%d"):format(_t("goodOmen"), self.count[1]),
                x1 + 4, Y - 3, 0.9, Color(A * 255, 230, 250, 230), "left", "top")
        Y = Y - line_h
        ui:RenderText("title", ("「%s」：%d"):format(_t("regularOmen"), self.count[2]),
                x1 + 4, Y - 3, 0.9, Color(A * 255, 135, 206, 235), "left", "top")
        Y = Y - line_h
        ui:RenderText("title", ("「%s」：%d"):format(_t("luckyOmen"), self.count[3]),
                x1 + 4, Y - 3, 0.9, Color(A * 255, 218, 112, 214), "left", "top")
        Y = Y - line_h
        ui:RenderText("title", ("「%s」：%d"):format(_t("greatOmen"), self.count[4]),
                x1 + 4, Y - 3, 0.9, Color(A * 255, 255, 227, 132), "left", "top")
        Y = Y - line_h * 1.5
        ui:RenderTextWithCommand("title", _t("baoditool"):format(max(1, 10 - self.count[5])),
                x1 + 4, Y - 3, 0.8, A * 255, "left", "top")
        Y = Y - line_h
        ui:RenderTextWithCommand("title", _t("baodichara"):format(max(1, 40 - self.count[6])),
                x1 + 4, Y - 3, 0.8, A * 255, "left", "top")
        local cx, cy = 800, 390
        local offy2 = -40 + sin(self.timer / 1.7) * 3

        local m = self.update_list[self.update_pos]
        local sizex,sizey = GetTextureSize(m.picture)
        local scale = m.renderscale
        local offx, offy = (sizex / 2 - m.renderx) * scale, (m.rendery - sizey / 2) * scale
        misc.RenderTexInSize(m.picture, cx + offx, cy + offy + offy2,
                0, scale, scale, "", Color(self.update_alpha * A * 200, 255, 255, 255))
        ui:RenderText("pretty", _t("newestGreatOmen"), cx, cy + offy2 + 95,
                0.6 + sin(self.timer / 2) * 0.05, Color(A * 255, 255, 227, 132), "centerpoint")
    end
    self.top_bar:render()

    for _, b in ipairs(self.balls) do
        b:render(1)
    end
    informationRead:render(self.alpha)
    CheckRecord:render(self.alpha)
    CheckRecord_Submenu:render()
    Detail_Submenu:render()
end

function CheckRecord:init(mainmenu, x, y)
    self.x, self.y = x, y
    self.func = function()
        self.locked = true
        self.mainmenu.stopclick = true
        CheckRecord_Submenu:In()
    end
    self.index = 0
    self.timer = 0
    self.r = 75
    self.selected = false
    self.locked = false
    self.mainmenu = mainmenu
    self.keyname = KeyCodeToName()
end
function CheckRecord:frame()
    task.Do(self)
    self.timer = self.timer + 1
    if self.locked then
        return
    end
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
        if mouse:isUp(1) then
            self.index = self.index + 0.5
            PlaySound("ok00")
            self.func()
        end
    end
end
function CheckRecord:render(A)
    local k = self.index
    local _alpha = (150 + k * 50) * A
    local ax, ay = self.x, self.y
    local adsize = self.r + k * 10
    SetImageState("menu_circle", "", _alpha, 200, 200, 200)
    Render("menu_circle", ax, ay, 0, adsize / 192)
    local wpimg = "wishing_ball"
    SetImageState(wpimg, "", _alpha, 200, 200, 200)
    Render(wpimg, ax, ay, 0, adsize / 240)
    ui:RenderText("pretty_title", _t("checkRecord"), ax, ay - adsize / 2,
            0.8, Color(_alpha, 255, 255, 255), "centerpoint")
end

function CheckRecord_Submenu:In()
    PlaySound("select00")
    self.locked = false
    self:refresh()
    task.New(self, function()
        for i = 1, 16 do
            self.alpha = task.SetMode[2](i / 16)
            task.Wait()
        end
    end)

end
function CheckRecord_Submenu:Out()
    task.New(self, function()
        self.locked = true
        CheckRecord.locked = false
        self.mainmenu.stopclick = false
        for i = 1, 16 do
            self.alpha = 1 - i / 16
            task.Wait()
        end

    end)
end
function CheckRecord_Submenu:init(mainmenu)
    self.x, self.y = 480, 270
    self.w, self.h = 250, 220
    self.alpha = 0
    self.locked = true
    self.offy1 = 0
    self._offy1 = 0
    self.line_h_1 = 75
    self.timer = 0
    self:refresh()
    self.exit_button = ExitButton(810, 480, function()
        self:Out()
        PlaySound("cancel00")
    end)
    self.mainmenu = mainmenu
end
function CheckRecord_Submenu:refresh()
    self.infodata = scoredata.rewardedRecord
    self._offy1 = self.line_h_1 * #self.infodata
end
function CheckRecord_Submenu:frame()
    self.timer = self.timer + 1
    task.Do(self)
    if self.locked then
        return
    end
    local mouse = ext.mouse
    local alpha = self.alpha
    local x1, x2, y1, y2, h
    x1, x2, y1, y2 = self.x - self.w * alpha, self.x + self.w * alpha, self.y - self.h, self.y + self.h
    h = y2 - y1
    self._offy1 = self._offy1 + (-self._offy1 + Forbid(self._offy1, 0, max(self.line_h_1 * #self.infodata - h, 0))) * 0.3
    self.offy1 = self.offy1 + (-self.offy1 + self._offy1) * 0.3
    if sp.math.PointBoundCheck(mouse.x, mouse.y, x1, x2, y1, y2) then
        if mouse._wheel ~= 0 then
            self._offy1 = self._offy1 - sign(mouse._wheel) * self.line_h_1 * 2.5
            PlaySound("select00")
        end
    end
    if menu:keyUp() then
        self._offy1 = self._offy1 - self.line_h_1 * 2.5
        PlaySound("select00")
    end
    if menu:keyDown() then
        self._offy1 = self._offy1 + self.line_h_1 * 2.5
        PlaySound("select00")
    end
    self.exit_button:frame()
    if menu:keyYes() or menu:keyNo() then
        self.exit_button.func()
    end
end
function CheckRecord_Submenu:render()
    local A = self.alpha
    if A == 0 then
        return
    end
    do

        local alpha = self.alpha
        local x1, x2, y1, y2, Y

        x1, x2, y1, y2 = self.x - self.w * alpha, self.x + self.w * alpha, self.y - self.h, self.y + self.h
        SetImageState("white", "", alpha * 180, 0, 0, 0)
        RenderRect("white", 0, 960, 0, 540)
        SetImageState("white", "", alpha * 180, 10, 10, 10)
        RenderRect("white", x1, x2, y1, y2)
        SetImageState("white", "", alpha * 255, 255, 255, 255)
        misc.RenderOutLine("white", x1, x2, y2, y1, 0, 2)
        SetRenderRect(x1, x2, y1 - self.offy1, y2 - self.offy1, x1, x2, y1, y2)
        Y = y2
        RenderRect("white", x1, x2, Y - 0.5, Y + 0.5)
        local _h = self.line_h_1
        for i, t in ipairs(self.infodata) do
            if Y < y1 - self.offy1 then
                break
            end
            Y = Y - _h
            if Y < y2 - self.offy1 then
                local p = lib.totalPool[t[1]]
                local time = t[2]
                ---@type addition_unit
                local index = 1
                SetImageState("white", "", index * A * 75, p.R, p.G, p.B)
                RenderRect("white", x1 + 6, x1 + _h - 6, Y + _h - 6, Y + 6)
                RenderRect("white", x1 + _h + 3, x2 - 3, Y + _h - 3, Y + 3)

                SetImageState("white", "", index * A * 255, 200, 200, 200)
                misc.RenderOutLine("white", x1 + 6, x1 + _h - 6, Y + _h - 6, Y + 6, 0, 2)
                RenderRect("white", x1 + _h + 1, x1 + _h - 1, Y + _h, Y)
                local R, G, B = unpack(colors[p.quality])
                if p.state == 1 then
                    local img = "menu_lottery_money"
                    SetImageState(img, "mul+add", index * A * 200, 255, 255, 255)
                    RenderRect(img, x1 + 6, x1 + _h - 6, Y + 6, Y + _h - 6)
                    ui:RenderText("big_text", ("%d. %s+%d"):format(i, Trans("sth", "money"), p.data), x1 + _h + 6, Y + _h - 4,
                            0.45, Color(index * A * 255, R, G, B), "left", "top")
                elseif p.state == 2 then
                    local tool = stg_levelUPlib.AdditionTotalList[p.data]

                    SetImageState(tool.pic, "", index * A * 200, 255, 255, 255)
                    Render(tool.pic, x1 + _h / 2, Y + _h / 2, 0, (_h - 12 - 6) / 256)
                    --RenderRect(tool.pic, x1 + 6, x1 + _h - 6, Y + 6, Y + _h - 6)
                    SetImageState("bright", "mul+add", index * A * 200, tool.R, tool.G, tool.B)
                    Render("bright", x1 + _h / 2, Y + _h / 2, 0, 60 / 120)
                    ui:RenderText("big_text", ("%d. %s"):format(i, tool.title), x1 + _h + 6, Y + _h - 4,
                            0.45, Color(index * A * 255, R, G, B), "left", "top")
                elseif p.state == 3 then
                    local punit = player_list[p.data]
                    local sizex,sizey = GetTextureSize(punit.picture)
                    local scale = punit.renderscale * 0.3
                    local offx, offy = (-punit.renderx + sizex / 2), (punit.rendery - sizey / 2)
                    misc.RenderTexInRect(punit.picture, x1 + 6, x1 + _h - 6, Y + 6, Y + _h - 6, offx, offy,
                            0, scale, scale, "", Color(index * A * 200, 255, 255, 255))
                    ui:RenderText("big_text", ("%d. %s"):format(i, punit.display_name), x1 + _h + 6, Y + _h - 4,
                            0.45, Color(index * A * 255, R, G, B), "left", "top")
                end

                local str = os.date("!%Y/%m/%d %H:%M:%S", time + setting.timezone * 3600)
                ui:RenderTextInWidth("title", ("%s%s"):format(_t("getTime"), str), x1 + _h + 8, Y + _h - 35,
                        0.8, self.w * 2 - 150, Color(index * A * 255, R, G, B), "left", "top")
                SetImageState("white", "", index * A * 255, 255, 255, 255)
                RenderRect("white", x1, x2, Y - 1, Y + 1)
                misc.RenderBrightOutline(x1, x2, Y, Y + _h,
                        25, A * (sin(self.timer * 4 + i * 120) * 30 + 60), R, G, B)
            end

        end
        SetViewMode("ui")
    end
    self.exit_button:render(A)
end

function informationRead:init(mainmenu, x, y)
    self.x, self.y = x, y
    self.func = function()
        New(SimpleNotice, self.mainmenu, _t("aboutConsecrate"), _t("consecrateInformation"), 260)
    end
    self.index = 0
    self.timer = 0
    self.r = 20
    self.selected = false
    self.locked = false
    self.mainmenu = mainmenu
end
function informationRead:frame()
    task.Do(self)
    self.timer = self.timer + 1
    if self.locked then
        return
    end
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
        if mouse:isUp(1) then
            self.index = self.index + 0.5
            PlaySound("ok00")
            self.func()
        end
    end
    if scoredata.guide_flag == 3 then
        self.func()
        scoredata.guide_flag = 4
    end
end
function informationRead:render(A)
    local k = self.index
    local _alpha = (150 + k * 50) * A
    local ax, ay = self.x, self.y
    local adsize = self.r + k * 10
    SetImageState("menu_questionicon", "", _alpha, 200, 200, 200)
    Render("menu_questionicon", ax, ay, 0, adsize / 64)
end

function Detail_Submenu:init(mainmenu)
    self.x, self.y = 480, 270
    self.w, self.h = 420, 445
    self.alpha = 0
    self.locked = true
    self.timer = 0
    self.exit_button = ExitButton(750, 480, function()
        self:Out()
        PlaySound("cancel00")
    end)
    self.mainmenu = mainmenu
    self.offy1 = 0
    self._offy1 = 0
    self.line_h_1 = 18
    self.linecount1 = 1
end
function Detail_Submenu:In(tool)
    self.english = setting.language == 2
    self.w = self.english and 480 or 420
    PlaySound("select00")

    self.tool = tool
    self._offy1 = 0
    task.New(self, function()
        for i = 1, 16 do
            self.alpha = task.SetMode[2](i / 16)
            task.Wait()
        end
        self.locked = false
    end)

end
function Detail_Submenu:Out()
    task.New(self, function()
        self.locked = true
        self.mainmenu.lock = false
        for i = 1, 16 do
            self.alpha = 1 - i / 16
            task.Wait()
        end
    end)
end
function Detail_Submenu:frame()
    self.timer = self.timer + 1
    task.Do(self)
    if self.locked then
        return
    end
    local mouse = ext.mouse
    self.exit_button:frame()
    if menu:keyYes() or menu:keyNo() or mouse:isUp(1) then
        self.exit_button.func()
    end
    self._offy1 = self._offy1 + (-self._offy1 + Forbid(self._offy1, 0, self.line_h_1 * max(0, self.linecount1 - 14.5))) * 0.3
    self.offy1 = self.offy1 + (-self.offy1 + self._offy1) * 0.3
    if menu:keyUp() then
        self._offy1 = self._offy1 - self.line_h_1
        PlaySound("select00")
    end
    if menu:keyDown() then
        self._offy1 = self._offy1 + self.line_h_1
        PlaySound("select00")
    end
    if mouse._wheel ~= 0 then
        self._offy1 = self._offy1 - mouse._wheel / 120 * self.line_h_1
        PlaySound("select00")
    end
end
function Detail_Submenu:render()
    local A = self.alpha
    if A == 0 then
        return
    end
    do
        SetImageState("white", "", A * 180, 0, 0, 0)
        RenderRect("white", 0, 960, 0, 540)
        local x, y = self.x, self.y
        local x1, x2, y1, y2
        local w = self.w
        local h = self.h
        local T = 0.7 + 0.3 * A
        x1, x2, y1, y2 = x - w / 2 * T, x + w / 2 * T, y - h / 2 * T, y + h / 2 * T
        self.linecount1 = menu:RenderToolDescribe(self.tool, x1, x2, y1, y2,
                80 * T, self.offy1, self.line_h_1, A, A, self.timer)
    end
    self.exit_button:render(A)
end

function SetOrbit:init(mainmenu, x, y)
    self.x, self.y = x, y
    self.func = function()
        self.locked = true
        self.mainmenu.stopclick = true
        SetOrbit_Submenu:In()
    end
    self.index = 0
    self.timer = 0
    self.r = 75
    self.selected = false
    self.locked = false
    self.mainmenu = mainmenu
end
function SetOrbit:frame()
    task.Do(self)
    self.timer = self.timer + 1
    if self.locked then
        return
    end
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
        if mouse:isUp(1) then
            self.index = self.index + 0.5
            PlaySound("ok00")
            self.func()
        end
    end
end
function SetOrbit:render(A)
    local k = self.index
    local _alpha = (150 + k * 50) * A
    local ax, ay = self.x, self.y
    local adsize = self.r + k * 10
    SetImageState("menu_circle", "", _alpha, 200, 200, 200)
    Render("menu_circle", ax, ay, 0, adsize / 192)
    ui:RenderText("pretty_title", "吉兆定轨", ax, ay - adsize / 2,
            0.8, Color(_alpha, 255, 255, 255), "centerpoint")
end
