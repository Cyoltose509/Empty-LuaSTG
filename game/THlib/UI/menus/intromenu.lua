loadLanguageModule("intro")
local function i18(str)
    return Trans("intro", str) or str
end

intromenu = stage.New("intro", false, true)
function intromenu:init()
    mask_fader:Do("open")
    self.title = ""
    self.title_a = 0.8
    self.move_speed = 0.5
    self.move_c = 0
    self.start_link = false
    self.R, self.G, self.B = 200, 200, 200
    self.tR, self.tG, self.tB = 200, 200, 200
    self.cirlcle_r = 0
    self.cirlcle_a = 1
    Game:initGame()
    local errorCode = "Æłƒ∂Ω≈ç√∫˜µ≤≥÷æ«»πø®ßþü©∑œ∑®†¥Ω™ªº≠§¶•ªº–≠√∫œæ¡™£¢∞§¶•ªªºπæøßµ≤≥‰π†¥∑∞Ω≠©˙∆˚∫˙∆œ∑∑®œ†¥˙∂ƒ©˙√µ˜ç∂ƒ¥Ω∫√∑≈¨ÆΩ†"
    local errShow = function(time, interval, nochangetitle)
        for i = 1, time do
            local flag = (i % interval == 1)
            if flag and not nochangetitle then
                local tl = ran:Int(7, 10)
                local ti = ran:Int(1, #errorCode - tl)
                self.title = errorCode:sub(ti, ti + tl)
            end
            ext.OldScreenEff:Open(5, 111, true, false, not flag)
            task.Wait()
        end
    end
    local stackInTitle = function(str, time)
        local title = sp.string(str)
        local L = title:GetTextLength()
        local t = time / L
        for i = 1, L do
            self.title = title:sub(1, i)
            task.Wait2(self, t)
        end
    end
    local clearTitle = function(nowtitle)
        self.title = nowtitle or ""
    end
    local fadeoutTitle = function(time)
        local v = self.title_a
        for _ = 1, time do
            self.title_a = self.title_a - v / time
            task.Wait()
        end
    end
    local fadeinTitle = function(time, v)
        v = v or 0.8
        for _ = 1, time do
            self.title_a = self.title_a + v / time
            task.Wait()
        end
    end
    task.New(self, function()
        task.Wait(150)
        task.init_left_wait(self)
        stackInTitle(i18("say1"), 40)
        task.Wait(45)
        errShow(30, 4)
        clearTitle()
        self.start_link = true
        for _ = 1, 65 do
            self.move_speed = self.move_speed + 0.5 / 65
            task.Wait()
        end
        task.New(self, function()
            task.Wait(30)
            for _ = 1, 2 do
                errShow(5, 5)
                task.Wait(15)
            end
        end)
        stackInTitle(i18("say2"), 85)
        task.Wait(60)
        for _ = 1, 60 do
            self.R = self.R - 75 / 60
            self.B = self.B - 75 / 60
            self.move_speed = self.move_speed + 2 / 60
            task.Wait()
        end
        errShow(40, 7)
        clearTitle()
        task.Wait(75)
        stackInTitle(i18("say3"), 45)
        task.Wait(75)
        errShow(10, 2)
        task.New(self, function()
            for i = 1, 460 do
                if self.move_speed == 0 then
                    break
                end
                self.move_speed = self.move_speed + 20 / 460
                local s = task.SetMode[1](i / 460)
                for _, p in ipairs(Game.PointList) do
                    Game:rotatePoint(p, p._z / 200 * s, 0, 0)
                end

                task.Wait()
            end
        end)

        stackInTitle(i18("say4"), 150)
        misc.ShakeScreen(130, 1.2, 3, 1.5)
        task.Wait(50)
        for i = 1, 80 do
            i = task.SetMode[1](i / 80)
            self.cirlcle_r = 15 * i
            task.Wait()
        end
        self.move_speed = 0
        clearTitle(i18("say5"))
        self.R, self.G, self.B = 135, 206, 235
        self.tR, self.tG, self.tB = 189, 252, 201
        for i = 1, 80 do
            i = task.SetMode[2](i / 80)
            self.cirlcle_a = 1 - 1 * i
            task.Wait()
        end
        errShow(40, 5, true)
        fadeoutTitle(20)
        task.Wait(20)
        clearTitle(i18("say6"))
        fadeinTitle(20)
    end)

end
function intromenu:frame()
    self.move_c = self.move_c + self.move_speed / 3
    while self.move_c > 0 do
        Game:createDecorativePoints(1, self.R, self.G, self.B)
        self.move_c = self.move_c - 1
    end
    sp:UnitListUpdate(Game.PointList)
    for _, p in ipairs(Game.PointList) do
        p._z = p._z - self.move_speed
        p.R, p.G, p.B = self.R, self.G, self.B
        if p._z < Game.camera_z0 then
            Del(p)
        end
    end
end
function intromenu:render()
    SetViewMode "world"
    RenderTTF3("big_text", self.title, 0, 0, 0, 0.4, 0.4,
            "mul+add", Color(self.title_a * 255, self.tR, self.tG, self.tB), "centerpoint")
    SetImageState("bright", "mul+add", 255 * self.cirlcle_a, 255, 255, 255)
    for _ = 1, 5 do
        Render("bright", 0, 0, 0, self.cirlcle_r)
    end
end
