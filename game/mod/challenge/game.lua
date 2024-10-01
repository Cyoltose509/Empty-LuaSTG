local module = "challenge"
loadLanguageModule(module, "mod\\challenge\\lang")
local function _t(str)
    return Trans(module, str) or ""
end

local C7Mouse = Class(object, {
    init = function(self)
        self.bound = false
        self.layer = LAYER.PLAYER
        self.group = GROUP.PLAYER
        self.colli = false
        self.alpha = 0.5
        self._r, self._g, self._b = player.colorR, player.colorG, player.colorB
    end,
    frame = function(self)
        task.Do(self)
        local mouse = ext.mouse
        mouse:frame()
        self.R = sqrt(player_lib.GetPlayerDmg()) * 28
        self.x, self.y = UIToWorld(mouse.x, mouse.y)
        if IsValid(player) then
            player.x, player.y = self.x, self.y
            local w = lstg.world
            local off = player.borderless_offset
            player.x = Forbid(player.x, w.pl + 8 - off, w.pr - 8 + off)
            player.y = Forbid(player.y, w.pb + 16 - off, w.pt - 32 + off)
        end
        self.dmg = player_lib.GetPlayerDmg() * 5
        if mouse:isDown(1) then
            PlaySound("explode")
            NewWave(self.x, self.y, 2, self.R * 2, 15, self._r, self._g, self._b, self.R)
            NewBon(self.x, self.y, 15, self.R, self._r, self._g, self._b)
            object.EnemyNontjtDo(function(e)
                if Dist(e, self) < self.R then
                    if e.class.base.take_damage then
                        e.class.base.take_damage(e, self.dmg)
                    end
                end
            end)
            object.BulletDo(function(b)
                if Dist(b, self) < self.R then
                    Del(b)
                end
            end)
            cutLasersByCircle(self.x, self.y, self.R)
        end
    end,
    render = function(self)
        local R, G, B = self._r, self._g, self._b
        SetImageState("bright_circleOutline", "mul+add", self.alpha * 145, R, G, B)
        Render("bright_circleOutline", self.x, self.y, 0, self.R / 200)
        SetImageState("white", "mul+add", self.alpha * 80, R, G, B)
        misc.SectorRender(self.x, self.y, 0, self.R, 0, 360, 25)
    end
}, true)
local C8Mouse = Class(object, {
    init = function(self)
        self.bound = false
        self.layer = LAYER.PLAYER
        self.group = GROUP.PLAYER
        self.colli = false
    end,
    frame = function(self)
        task.Do(self)
        local mouse = ext.mouse
        mouse:frame()
        self.x, self.y = UIToWorld(mouse.x, mouse.y)
        if IsValid(player) then
            player.x, player.y = self.x, self.y
            local w = lstg.world
            local off = player.borderless_offset
            player.x = Forbid(player.x, w.pl + 8 - off, w.pr - 8 + off)
            player.y = Forbid(player.y, w.pb + 16 - off, w.pt - 32 + off)
        end
    end
}, true)

local NewChallenge = challenge_lib.NewChallenge

NewChallenge(1, BG_7, { "challenge1" }, 10, 1, _t("正体不明的X"), _t("des1"),
        function()
            local v = lstg.var
            v.chaos = 12.5
            v.challenge_addchaos = 2.3
            v._season_system = true
            local w = lstg.weather
            w.Xtool = 10
            w.season_last[5] = 10
            w.next_season = 5
            w.next_weather = 76
            lstg.tmpvar.stop_reset_inside_pro = true
            lstg.var.level_up_func = function()
                player_lib.AddMaxLife(5)
            end
        end, function()
            local w = lstg.weather
            w.next_weather = 76
        end, 5554, {
            NewLockFunction("AfterWeather"),
            NewLockFunction("After5Season"),
            NewLockFunction("bookweather:76"),
            NewLockFunction("scene:2"),
        }, function()
            ext.achievement:get(140)
        end)
NewChallenge(2, BG_5, { "challenge2" }, 15, 1, _t("测测你的"), _t("des2"),
        function()
            local slib = stg_levelUPlib
            slib.SetAddition(slib.AdditionTotalList[78])
            slib.SetAddition(slib.AdditionTotalList[126])
            lstg.var.level_up_func = function()
                if lstg.var.level % 2 == 1 then
                    slib.SetAddition(slib.AdditionTotalList[78])
                end
            end
            lstg.var.stop_shoot = true
            local self = stage.current_stage
            for i = #self.wave_events, 1, -1 do
                local w = self.wave_events[i]
                if w.isboss then
                    table.remove(self.wave_events, i)
                end
            end
        end, function()
        end, 5655, {
            NewLockFunction("booktool:78"),
            NewLockFunction("booktool:126"),
        }, function()
            ext.achievement:get(141)
            mission_lib.GoMission(54, nil, true)
        end)
NewChallenge(3, BG_20, { "challenge3_1", "challenge3_2" }, 20, 1, _t("贪吃蛇"), _t("des3"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 2.89
            local slib = stg_levelUPlib
            for _ = 1, 3 do
                slib.SetAddition(slib.AdditionTotalList[143])
            end
            slib.SetAddition(slib.AdditionTotalList[131])
            lstg.var.othercondition = function(tool)
                return not slib.SearchToolTag(tool, "baby") and tool.id ~= 17
            end
            lstg.var.level_up_func = function(otherevent)
                slib.SetAddition(slib.AdditionTotalList[143])
                slib.SelectAddition(otherevent)
            end
        end, function()
        end, 5356, {
            NewLockFunction("booktool:143"),
            NewLockFunction("booktool:131"),
        }, function()
            ext.achievement:get(144)
            mission_lib.GoMission(55, nil, true)
        end)
NewChallenge(4, BG_19, { "challenge4_1", "challenge4_2" }, 20, 1, _t("好了知道你是0了"), _t("des4"),
        function()
            local v = lstg.var
            v._season_system = true
            lstg.tmpvar.stop_reset_inside_pro = true
            v.challenge_addchaos = 2.3
            local w = lstg.weather
            local slib = stg_levelUPlib
            for _, p in ipairs(slib.ListByQual[1]) do
                if p.id ~= 134 then
                    for _ = 1, p.maxcount do
                        slib.SetAddition(p, true)
                    end
                end
            end
        end, function()
        end, 5589, {
            NewLockFunction(function()
                return scoredata.stop_0_tool
            end, "获得过【道具】休止符")
        }, function()
            ext.achievement:get(145)
            mission_lib.GoMission(56, nil, true)
        end)
NewChallenge(5, BG_16, { "challenge5" }, 20, 1, _t("尘肺病"), _t("des5"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 2.5
            v._season_system = true
            local w = lstg.weather
            w.season_last[4] = 20
            w.next_season = 4
            w.next_weather = 37
        end, function()
            local w = lstg.weather
            w.next_weather = 37
        end, 5000, {
            NewLockFunction("bookweather:37"),
        }, function()
            if player.name == "Chiruno" then
                ext.achievement:get(139)
            end
            ext.achievement:get(142)
            mission_lib.GoMission(57, nil, true)
        end)
NewChallenge(6, BG_25, { "challenge6_1", "challenge6_2" }, 20, 1, _t("我是地质学家，这就是神金"), _t("des6"),
        function()
            local slib = stg_levelUPlib
            for _ = 1, 3 do
                slib.SetAddition(slib.AdditionTotalList[38])
            end
            local v = lstg.var
            v.challenge_addchaos = 2.5
            v._season_system = true
            v.forbid_slow = true--禁止低速
            local w = lstg.weather
            w.season_last[5] = 20
            w.next_season = 5
            w.next_weather = 29
        end, function()
            local w = lstg.weather
            w.next_weather = 29
        end, 5353, {
            NewLockFunction("booktool:38"),
            NewLockFunction("bookweather:29")
        }, function()
            if player.name == "Aya" then
                ext.achievement:get(138)
            end
            ext.achievement:get(143)
            mission_lib.GoMission(58, nil, true)
        end)
NewChallenge(7, BG_22, { "challenge7" }, 15, 1, _t("打妖精"), _t("des7"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 15
            v._season_system = true

            local slib = stg_levelUPlib
            slib.SetAddition(slib.AdditionTotalList[64])
            lstg.tmpvar.C7Mouse = New(C7Mouse)
        end, function()
            if IsValid(player) and not IsValid(lstg.tmpvar.C7Mouse) then
                lstg.tmpvar.C7Mouse = New(C7Mouse)
            end
            player._playersys.stopUpdateKey = true
        end, 10000, nil, function()
        end)
NewChallenge(8, BG_8, { "challenge8_1", "challenge8_2" }, 19, 1, _t("东方游戏手机版"), _t("des8"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 3
            v._season_system = true
            lstg.tmpvar.C8Mouse = New(C8Mouse)
        end, function()
            if IsValid(player) and not IsValid(lstg.tmpvar.C8Mouse) then
                lstg.tmpvar.C8Mouse = New(C8Mouse)
            end
        end, 10000, {
            NewLockFunction("passChallenge:7")
        }, function()
        end)
NewChallenge(9, BG_24, { "challenge9" }, 10, 1, _t("蓬莱之药"), _t("des9"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 10
            v._season_system = true
        end, function()
            local t = stage.current_stage.timer
            local koff = 42500
            lstg.var.CYFPS = 15 + 105 * (koff / (t + koff)) ^ 5
        end, 6666, {
            NewLockFunction("tool:97"),
            NewLockFunction("tool:117"),
            NewLockFunction("tool:99"),
            NewLockFunction("tool:114"),
            NewLockFunction("tool:101"),
        }, function()
        end)
NewChallenge(10, BG_12, { "challenge10" }, 12, 1, _t("诶，我有一年之计"), _t("des10"),
        function()
            local v = lstg.var
            v.chaos = 36.5
            v.challenge_addchaos = 3
            v._season_system = true
            lstg.var.CYFPS = 120
        end, function()
            local kfps = 0
            if IsValid(player) then
                if player.dx ~= 0 or player.dy ~= 0 or stage.current_stage.timer < 60 or lstg.var.lost then
                    kfps = 365
                end
                lstg.var.CYFPS = lstg.var.CYFPS + (-lstg.var.CYFPS + kfps) * 0.04365
            else
                lstg.var.CYFPS = 60
            end
        end, 3650, {
            NewLockFunction("passChallenge:9")
        }, function()
        end)
NewChallenge(11, BG_21, { "challenge11" }, 7, 1, _t("收起你的小霁霁"), _t("des11"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 2.5
            v._season_system = true
        end, function()
            if not IsValid(lstg.tmpvar.Challenge11Eff) then
                lstg.tmpvar.Challenge11Eff = SmearScreen("Challenge11", 12, 1e308,
                        LAYER.BG + 10, LAYER.TOP, "mul+add")
            end
        end, 5000, {
        }, function()
        end)
NewChallenge(12, BG_23, { "challenge12_1", "challenge12_2" }, 10, 1, _t("注意力不集中"), _t("des12"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 5
            v._season_system = true
            lstg.tmpvar.RotateWorld = misc.RotateWorld("challenge12_RT", LAYER.BG - 11, 0)
        end, function()
            if not IsValid(lstg.tmpvar.RotateWorld) then
                lstg.tmpvar.RotateWorld = misc.RotateWorld("challenge12_RT", LAYER.BG - 11, 0)
            end
            local world = lstg.tmpvar.RotateWorld
            local function SetCameraScale(scale)
                world.hscale = scale
                world.vscale = scale
            end
            local timer = stage.current_stage.timer
            local size = sin(timer / 2) * 0.1 + 1.6
            SetCameraScale(size)
            local sw, sh = 320, 240
            local x = player.x
            local y = player.y
            local num = 0
            local tx = 0
            local ty = 0
            object.BulletIndesDo(function(b)
                num = num + 1
                tx = tx + b.x
                ty = ty + b.y
            end)
            local ax, ay = tx / num, ty / num
            local Realnum = 0
            object.BulletIndesDo(function(b)
                if BoxCheck(b, ax - sw * size, ax + sw * size, ay - sh * size, ay + sh * size) then
                    Realnum = Realnum + 1
                end
            end)
            if Realnum > 0 then
                x, y = ax, ay
            end
            x = Forbid(x, sw * (1 - size), -sw * (1 - size))
            y = Forbid(y, sh * (1 - size), -sh * (1 - size))
            world.x = world.x + (-x - world.x) * 0.1
            world.y = world.y + (-y - world.y) * 0.1
        end, 7580, {
        }, function()
        end)
NewChallenge(13, BG_3, { "challenge13_1", "challenge13_2" }, 10, 1, _t("注意力集中"), _t("des13"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 5
            v._season_system = true
            lstg.tmpvar.RotateWorld = misc.RotateWorld("challenge13_RT", LAYER.BG - 11, 0)
        end, function()
            if not IsValid(lstg.tmpvar.RotateWorld) then
                lstg.tmpvar.RotateWorld = misc.RotateWorld("challenge13_RT", LAYER.BG - 11, 0)
            end
            local world = lstg.tmpvar.RotateWorld
            local function SetCameraScale(scale)
                world.hscale = scale
                world.vscale = scale
            end
            local timer = stage.current_stage.timer
            local size = sin(timer / 2) * 0.1 + 1.6
            SetCameraScale(size)
            local sw, sh = 320, 240
            local x = Forbid(player.x, sw * (1 - size), -sw * (1 - size))
            local y = Forbid(player.y, sh * (1 - size), -sh * (1 - size))
            world.x = world.x + (-x - world.x) * 0.1
            world.y = world.y + (-y - world.y) * 0.1
        end, 7580, {
        }, function()
        end)
NewChallenge(14, BG_10, { "challenge14" }, 15, 1, _t("引力超大的(魔理沙)"), _t("des14"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 1
            v._season_system = true
            local slib = stg_levelUPlib
            for _ = 1, 6 do
                slib.SetAddition(slib.AdditionTotalList[22])
            end
        end, function()
            local f = function(b, p)
                if not (b.__not_XuanWo or b.not_move) then
                    local r = max(Dist(b, p), 25)
                    local ang = Angle(b, p)
                    local G = 6.674e-11
                    local pA = player.a * 10e12
                    local A = b.a * pA * G / r / r
                    b._c13_vx = b._c13_vx or 0
                    b._c13_vy = b._c13_vy or 0
                    b._c13_vx = b._c13_vx + A * cos(ang)
                    b._c13_vy = b._c13_vy + A * sin(ang)
                    b.x = b.x + b._c13_vx
                    b.y = b.y + b._c13_vy
                end
            end
            object.BulletIndesDo(function(b)
                f(b, player)
                if IsValid(lstg.tmpvar.fake_player) then
                    f(b, lstg.tmpvar.fake_player)
                end
            end)
            for _, i in ObjList(GROUP.ITEM) do
                f(i, player)
                if IsValid(lstg.tmpvar.fake_player) then
                    f(i, lstg.tmpvar.fake_player)
                end
            end

        end, 6626, {
        }, function()
        end)
NewChallenge(15, BG_10, { "challenge15" }, 16, 1, _t("东方弹幕风"), _t("des15"),
        function()
            local v = lstg.var
            v.challenge_addchaos = 4
            v._season_system = true
        end, function()
            local fps = 60
            local tvar = lstg.tmpvar
            tvar._last_objn = tvar._now_objn or 0
            tvar._now_objn = GetnObj()

            fps = min(61, 677 / ((tvar._now_objn + 1) ^ 0.376))
            local ct = tvar._now_objn - tvar._last_objn
            fps = fps - ct * 0.1
            if GetKeyState(setting.keys.pass) then
                fps = fps * ran:Float(1.56,1.69)
            end
            lstg.var.CYFPS = abs(fps)
        end, 3600, {
        }, function()
        end)
