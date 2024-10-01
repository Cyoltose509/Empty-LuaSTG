local lib = stage_lib
local servant = _editor_class.SimpleServant
local class = SceneClass[2]
local HP = lib.GetHP
local function _t(str)
    return Trans("scene2", str) or ""
end
local function name(str)
    return Trans("bossname", str)
end

lib.NewWaveEventInWaves(class, 34, { 11, 12, 13, 14 }, 0,
        -1, 2, 2, function(var)
            local enemy2 = Class(enemy, {
                drop = function(self)
                    New(bullet_cleaner, self.x, self.y, 111, 1, 2, true, false, 0)
                end,
                init = function(self, x, y, mx, my, v, A, d)
                    enemy.init(self, 15, HP(200), false, true, false, 25)
                    self.x, self.y = x, y
                    self.servant_back = true
                    task.New(self, function()
                        task.MoveTo(mx, my, 90, 2)
                        task.Wait(200)
                        object.ChangingV(self, 0, v, A, 80, false)
                    end)
                    task.New(self, function()
                        local N = int(stage_lib.GetValue(7, 9, 12, 48))
                        for a, ki in sp.math.AngleIterator(0, N) do
                            servant.init(NewObject(servant), self.x, self.y, 0, 135, 206, 235, 1.5, function(unit)
                                unit.bound = false
                                object.Connect(self, unit, 0.3, true)
                                task.New(unit, function()
                                    unit:FadeIn(15)
                                    object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                                end)
                                local R = 0
                                local o = 3 * d
                                unit.angle = a
                                task.New(unit, function()
                                    while IsValid(self) do
                                        unit.x = self.x + cos(unit.angle) * R
                                        unit.y = self.y + sin(unit.angle) * R
                                        unit.angle = unit.angle + o
                                        task.Wait()
                                    end
                                    Del(unit)
                                end)
                                task.New(unit, function()
                                    for i = 1, 35 do
                                        R = 75 * task.SetMode[2](i / 35)
                                        task.Wait()
                                    end

                                    unit.bound = true
                                    task.New(unit, function()
                                        for _ = 1, 40 do
                                            for z = -1.5, 1.5 do
                                                local b = NewSimpleBullet(ball_mid_c, 2, unit.x, unit.y,
                                                        stage_lib.GetValue(2, 2.3, 2.6, 9), unit.angle - 80 * d + 30 * z)
                                                b.fogtime = 0
                                            end

                                            PlaySound("tan00")
                                            task.Wait(abs(360 / N / o))
                                        end
                                    end)
                                    task.Wait(ki)
                                    for k = 1, 40 do
                                        local offa = ran:Float(30, 75)
                                        for ba in sp.math.AngleIterator(ran:Float(0, 360), 5) do
                                            Create.bullet_dec_setangle(unit.x, unit.y, grain_a, 2,
                                                    { v = 0.5, a = ba, time = 35 },
                                                    { wait = 5, v = stage_lib.GetValue(2.5, 2.8, 3.3, 9), a = ba + offa })
                                        end
                                        local b = NewSimpleBullet(ball_mid_c, 6, unit.x, unit.y,
                                                stage_lib.GetValue(1.4, 1.6, 1.8, 6), unit.angle + 165 * d + k * 2 * d)
                                        b.fogtime = 0
                                        PlaySound("tan00")
                                        task.Wait(12)
                                    end
                                end)
                            end)

                        end
                    end)
                end,
            }, true)
            New(enemy2, -500, 300, 0, 100, 1, -175, 1)
            task.Wait(310)
            New(enemy2, 500, 300, 0, 100, 1, -5, -1)
            task.Wait(310)
            New(enemy2, -500, 300, 75, 100, 1, -175, 1)
            task.Wait(30)
            New(enemy2, 500, 300, -75, 100, 1, -5, -1)
        end, _t("夜空珠，你可以藏公主"), nil, true)

local _w = lib.NewWaveEventInWaves(class, 35, { 15 }, 1,
        0, 0, 1, function(var)
            lstg.tmpvar.RingoNomiss = lstg.var.miss
            local bclass = boss.Define(name("Ringo"), 0, 400, _editor_class.ringo_bg, "Ringo")

            local non_sc1 = boss.card.New("", 1, 4, 40, HP(900))
            boss.card.add(bclass, non_sc1)
            function non_sc1:before()
                lstg.tmpvar.otherMusic = "2_boss2"
                --lstg.tmpvar.otherMusic_start_time = 82.5 - 140 / 60
                boss.show_aura(self, false)
                PlaySound("ch02")
                New(boss_cast_darkball, 0, 100, 60, 80, 360, 1, 270, 64, 64, 255, 2)
                New(boss_cast_darkball, 0, 100, 60, 80, 360, 1, 270, 255, 64, 64, -2)
                task.Wait(80)
                self.x, self.y = 0, 100
                boss.show_aura(self, true)
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
            end
            function non_sc1:init()
                task.New(self, function()
                    local d = 1
                    while true do
                        boss.cast(self, 150)
                        Newcharge_out(self.x, self.y, 250, 128, 114)
                        task.New(self, function()
                            task.Wait(210 - 60)
                            task.MoveToPlayer(60, -200, 200, 80, 120,
                                    20, 40, 10, 20, 2, 1)
                        end)
                        local v
                        local I = 1
                        local index = 2
                        local wait = 80
                        servant.init(NewObject(servant), self.x, self.y, 0, 135, 206, 235, 1.5, function(unit)
                            task.New(unit, function()
                                unit:FadeIn(15)
                                object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                            end)
                            task.New(unit, function()
                                object.SetA(unit, 0.012, Angle(unit, player), false)
                                for i = 1, 35 do
                                    v = stage_lib.GetValue(1.5, 2, 3, 10) + i / 35 * index
                                    for a in sp.math.AngleIterator(90 - 90 * d + i * 5 * d,
                                            int(stage_lib.GetValue(2, 3, 5, 32) + i * I)) do
                                        local x, y = unit.x + cos(a) * (60 - i) * 2, unit.y + sin(a) * (60 - i) * 2
                                        if Dist(x, y, player) > 48 then
                                            Create.bullet_decel(x, y, ball_mid, 6, 4 - i / 35 * index, v, a)
                                            PlaySound("tan00")
                                        end
                                    end

                                    task.Wait(6)
                                end
                                object.ChangingSizeColli(unit, -1, -1, 15)
                                Del(unit)
                            end)
                        end)
                        task.Wait(35 * 6 - stage_lib.GetValue(30, 45, 60, 100))
                        for a in sp.math.AngleIterator(ran:Float(0, 360), int(stage_lib.GetValue(30, 40, 50, 180))) do
                            for V = 4, 8 + int(stage_lib.GetValue(1, 2, 3, 12)) do
                                NewSimpleBullet(arrow_small, 2, self.x, self.y, 0.3 + V * 0.3, a + V * d)
                            end
                        end
                        task.Wait(wait)
                        d = -d
                    end
                end)
            end

            local sc1 = boss.card.New("团子「团子制作中心」", 2, 4, 40, HP(1400))
            boss.card.add(bclass, sc1)
            function sc1:before()
                task.Wait(60)
            end
            function sc1:init()
                task.New(self, function()
                    local dumpling_rotate = function(center, a, o, r)
                        local self = NewObject(bullet)
                        bullet.init(self, ball_small, 4, false, true)
                        self.x, self.y = center.x + cos(a) * r, center.y + sin(a) * r
                        task.New(self, function()
                            while IsValid(center) do
                                self.x, self.y = center.x + cos(a) * r, center.y + sin(a) * r
                                a = a + o
                                task.Wait()
                            end
                            self.vx, self.vy = self.dx, self.dy
                        end)
                    end
                    local dumpling_center = function(x, y, v, a, ra, ro, rr, rk)
                        local self = NewObject(bullet)
                        bullet.init(self, ball_small, 6, false, true)
                        self.x, self.y = x, y
                        object.SetV(self, v, a)
                        PlaySound("tan00")
                        for k = -rk, rk do
                            if k ~= 0 then
                                dumpling_rotate(self, ra, ro, rr * k)
                            end
                        end
                    end

                    task.MoveToForce(0, 100, 60, 2)
                    boss.cast(self, 3600)
                    Newcharge_in(self.x, self.y, 250, 128, 114)
                    task.Wait(60)
                    Newcharge_out(self.x, self.y, 250, 128, 114)
                    local d = 1
                    while true do
                        local rot = ran:Float(0, 360)
                        local N = int(stage_lib.GetValue(18, 20, 24, 75))
                        local cR = stage_lib.GetValue(10, 15, 20, 35)
                        local ro = stage_lib.GetValue(0.5, 1.14, 1.66, 6)
                        local v = stage_lib.GetValue(1.5, 2, 2.5, 9)
                        local wt = stage_lib.GetValue(10, 8, 7, 3)
                        for _ = 1, 9 do
                            for a in sp.math.AngleIterator(rot, N) do
                                dumpling_center(self.x, self.y, v, a, a + 180, ro * d, 10, 2)
                            end
                            rot = rot + cR * d
                            task.Wait(wt)
                        end
                        for _ = 1, 3 do
                            for a in sp.math.AngleIterator(rot, N) do
                                Create.bullet_accel(self.x, self.y, ball_big, 2, v, v * 1.3, a, true, false)
                            end
                            PlaySound("tan00")
                            task.Wait(wt * 3)
                            rot = rot - cR * d
                        end
                        d = -d

                    end

                end)
            end

            local non_sc2 = boss.card.New("", 1, 4, 40, HP(900))
            boss.card.add(bclass, non_sc2)
            function non_sc2:before()
                task.MoveToForce(0, 100, 60, 2)
            end
            function non_sc2:init()
                task.New(self, function()
                    local d = 1
                    self.cast_t = 0
                    task.Wait(60)
                    Newcharge_in(self.x, self.y, 250, 128, 114)
                    task.Wait(60)

                    while true do
                        boss.cast(self, 150)
                        Newcharge_out(self.x, self.y, 250, 128, 114)
                        task.New(self, function()
                            task.Wait(210 - 60)
                            task.MoveToPlayer(60, -200, 200, 80, 120,
                                    20, 40, 10, 20, 2, 1)
                        end)
                        local v
                        local index = 2
                        local wait = 80
                        local Rot = Angle(self, player)
                        for _ = 1, 3 do
                            servant.init(NewObject(servant), self.x, self.y, 0, 250, 128, 114, 1.5, function(unit)
                                task.New(unit, function()
                                    unit:FadeIn(15)
                                    object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                                end)
                                task.New(unit, function()
                                    object.SetA(unit, 0.0152, Rot, false)
                                    local A = Rot
                                    local N = int(stage_lib.GetValue(25, 33, 42, 100))
                                    for i = 1, 33 do
                                        v = stage_lib.GetValue(1.5, 2, 3, 10) + i / 35 * index
                                        for a in sp.math.AngleIterator(A + 180 / N, N) do
                                            local x, y = unit.x + cos(a) * (60 - i * 2) * 2, unit.y + sin(a) * (60 - i * 2) * 2
                                            if Dist(x, y, player) > 48 then
                                                Create.bullet_decel(x, y, ball_mid, 2, 4 - i / 35 * index, v, a)
                                                PlaySound("tan00")
                                            end
                                        end
                                        task.Wait(6)
                                    end
                                    object.ChangingSizeColli(unit, -1, -1, 15)
                                    Del(unit)
                                end)
                            end)
                            task.Wait(60)
                        end
                        task.Wait(60)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), int(stage_lib.GetValue(40, 50, 60, 200))) do
                            for V = 4, 6 do
                                NewSimpleBullet(arrow_small, 6, self.x, self.y, 0.3 + V * 0.3, a + V * d)
                            end
                        end
                        task.Wait(wait)
                        d = -d
                    end
                end)
            end

            local sc2 = boss.card.New("团子「团子加工厂」", 2, 4, 40, HP(1400))
            boss.card.add(bclass, sc2)
            function sc2:before()
                task.Wait(60)
            end
            function sc2:init()
                task.New(self, function()
                    local dumpling_rotate = function(center, a, o, r)
                        local self = NewObject(bullet)
                        bullet.init(self, ball_small, 10, false, true)
                        self.x, self.y = center.x + cos(a) * r, center.y + sin(a) * r
                        task.New(self, function()
                            while IsValid(center) do
                                self.x, self.y = center.x + cos(a) * r, center.y + sin(a) * r
                                a = a + o
                                task.Wait()
                            end
                            self.vx, self.vy = self.dx, self.dy
                        end)
                    end
                    local dumpling_center = function(x, y, v, a, ra, ro, rr, rk, d)
                        local self = NewObject(bullet)
                        bullet.init(self, ball_small, 8, false, true)
                        self.x, self.y = x, y
                        object.SetV(self, v, a)
                        PlaySound("tan00")
                        for k = -rk, rk do
                            if k ~= 0 then
                                dumpling_rotate(self, ra + abs(rr * k * ro * 2) * d, ro, rr * k)
                            end
                        end
                    end

                    task.MoveToForce(0, 100, 60, 2)
                    boss.cast(self, 3600)
                    Newcharge_in(self.x, self.y, 250, 128, 114)
                    task.Wait(60)
                    Newcharge_out(self.x, self.y, 250, 128, 114)
                    local d = 1
                    while true do
                        local rot = ran:Float(0, 360)
                        local N = int(stage_lib.GetValue(12, 13, 14, 40))
                        local v = stage_lib.GetValue(1.5, 1.7, 2, 9)
                        local wt = stage_lib.GetValue(50, 45, 40, 20)
                        local ro = stage_lib.GetValue(0.5, 0.5, 0.5, 1)
                        for _ = 1, 3 do
                            for a in sp.math.AngleIterator(rot, N) do
                                dumpling_center(self.x, self.y, v, a, a + 180, ro * d, 10, 15, d)
                            end
                            rot = rot + 10 * d
                            task.Wait(wt)
                        end
                        local zN = int(stage_lib.GetValue(2, 2, 3, 8))
                        for _ = 1, 6 do
                            for z = -zN, zN do
                                for cv = 0, stage_lib.GetValue(2, 3, 5, 16) do
                                    NewSimpleBullet(arrow_big, 2, self.x, self.y, (2.3 + cv * 0.6), Angle(self, player) + z / zN * 75)
                                end
                            end
                            PlaySound("tan00")
                            task.Wait(wt / 2)
                        end
                        d = -d

                    end

                end)
            end

            local non_sc3 = boss.card.New("", 1, 4, 40, HP(900))
            boss.card.add(bclass, non_sc3)
            function non_sc3:before()
                task.MoveToForce(0, 120, 60, 2)
            end
            function non_sc3:init()
                task.New(self, function()
                    local d = 1
                    self.cast_t = 0
                    task.Wait(60)
                    Newcharge_in(self.x, self.y, 250, 128, 114)
                    task.Wait(60)

                    while true do
                        boss.cast(self, 150)
                        Newcharge_out(self.x, self.y, 250, 128, 114)
                        task.New(self, function()
                            task.Wait(210 - 60)
                            task.MoveToPlayer(60, -200, 200, 80, 120,
                                    20, 40, 10, 20, 2, 1)
                        end)
                        local v
                        local index = 2.5
                        local wait = 80
                        local Rot = Angle(self, player)
                        servant.init(NewObject(servant), self.x, self.y, 0, 250, 128, 114, 1.5, function(unit)
                            task.New(unit, function()
                                unit:FadeIn(15)
                                object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                            end)
                            task.New(unit, function()
                                task.MoveTo(player.x, player.y, 60, 2)
                                local A = ran:Float(0, 360)
                                local N = int(stage_lib.GetValue(8, 10, 12, 20))
                                for i = 1, 50 do
                                    v = stage_lib.GetValue(1.5, 1.8, 2, 8) + i / 50 * index
                                    local drot = 0
                                    local R = (60 - i * 2) * 2
                                    if R < 0 then
                                        drot = drot + 180
                                    end
                                    for a in sp.math.AngleIterator(A + 180 / N + drot, N * 2 + 1) do
                                        local x, y = unit.x + cos(a) * R, unit.y + sin(a) * R
                                        Create.bullet_decel(x, y, ball_mid, 2, 4 - i / 35 * index, v, a)
                                    end
                                    PlaySound("tan00")
                                    task.Wait(3)
                                end
                                object.ChangingSizeColli(unit, -1, -1, 15)
                                Del(unit)
                            end)
                        end)
                        task.Wait(120)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), int(stage_lib.GetValue(25, 30, 40, 150))) do
                            for V = 4, 6 do
                                NewSimpleBullet(arrow_big, 8, self.x, self.y, 0.3 + V * 0.3, a + V * d)
                            end
                        end
                        task.Wait(wait)
                        d = -d
                    end
                end)
            end

            local sc3 = boss.card.New("中秋「佳期圆月，纵情无愁」", 2, 10, 60, HP(2800))
            boss.card.add(bclass, sc3)
            function sc3:before()
                task.Wait(60)
            end
            function sc3:init()
                task.New(self, function()
                    task.MoveToForce(0, 120, 60, 2)
                    Newcharge_in(self.x, self.y, 250, 128, 114)
                    task.Wait(60)
                    boss.cast(self, 33333)
                    local rotatelaser = function(x, y, a, d)
                        local l = Create.laser_changeangle(x, y, 13, 150, 7,
                                3.5, a, { r = 0.85 * d, time = 130, v = 5.5 })
                        l.bound = false
                        task.New(l, function()
                            local T = 150
                            local ROT = ran:Float(0, 360)
                            while T > 0 do
                                sakura_big.New(l.x, l.y, l.rot * 2 + ROT, 0, 0, 0, function(self)
                                    self._blend = "mul+alpha"
                                    task.New(self, function()
                                        task.Wait(T)
                                        local _a = self.rot
                                        local v = stage_lib.GetValue(1, 2, 3, 9)
                                        self.max = cos(_a) * v / 200
                                        self.may = sin(_a) * v / 200
                                        self.mmaxvx = abs(cos(_a) * v)
                                        self.mmaxvy = abs(sin(_a) * v)
                                    end)
                                end)
                                PlaySound("kira00")
                                local wt = stage_lib.GetValue(11, 8, 6, 3)
                                T = T - (wt - 2)
                                task.Wait(wt)
                            end
                            l.bound = true
                        end)
                    end
                    local dango = function(x, y, R, G, B, vy, size)
                        local self = NewObject(bullet)
                        bullet.init(self, ball_light, 15, false, true)
                        object.SetSizeColli(self, 0.1, 0.1)
                        self.x, self.y = x, y
                        self.fogtime = 0
                        self._blend = "add+add"
                        self._r, self._g, self._b = R, G, B
                        task.New(self, function()
                            for i = 1, 60 do
                                i = task.SetMode[2](i / 60)
                                object.SetSizeColli(self, 0.1 + 1.9 * i)
                                task.Wait()
                            end
                            local dsize = 2 - size
                            for i = 1, 60 do
                                i = task.SetMode[2](i / 60)
                                object.SetSizeColli(self, 2 - dsize * i)
                                self.vy = vy * i
                                task.Wait()
                            end
                        end)
                    end
                    local CreateDango = function(x, y, R, G, B, vy, isize, count, interval)
                        task.New(self, function()
                            for i = 1, count do
                                dango(x, y, R, G, B, vy, isize * (1 + 0.5 * abs(cos(i / count * 180))))
                                task.Wait(interval)
                            end
                        end)
                    end
                    local W = stage_lib.GetValue(560, 500, 480, 300)
                    task.New(self, function()
                        while true do
                            for z = -2, 1 do
                                rotatelaser(280 - z * 30, 255, -60 - z * 4, -1)
                            end
                            task.Wait(W)
                        end
                    end)
                    task.New(self, function()
                        while true do
                            task.Wait(W / 2)
                            for z = -2, 1 do
                                rotatelaser(-280 + z * 30, 255, -120 + z * 4, 1)
                            end
                            task.Wait(W / 2 + 40)
                        end
                    end)
                    task.Wait(80)
                    local t = 0
                    while true do
                        local c = stage_lib.GetValue(10, 14, 18, 40)
                        local vy = stage_lib.GetValue(3, 4, 5, 13)
                        local R, G, B = sp:HSVtoRGB(t * 25, 1, 1)
                        CreateDango(sin(t * 25) * 300 + ran:Float(-20, 20), 240, R, G, B,
                                -ran:Float(vy - 1, vy + 1), ran:Float(0.4, 0.6), ran:Int(c - 6, c + 6), 50 / vy)
                        PlaySound("water", 0.3)
                        t = t + 1
                        task.Wait(stage_lib.GetValue(50, 40, 30, 6))
                    end
                end)
            end
            function sc3:del()
                if var.wave ~= var.maxwave then
                    lstg.tmpvar.otherMusic = nil
                end
            end
            function sc3:other_drop()
                mission_lib.GoMission(51)
                mission_lib.GoMission(59)
                mission_lib.GoMission(60)
                mission_lib.GoMission(61)
                mission_lib.GoMission(62)
                if var.wave ~= var.maxwave then
                    item.dropItem(item.drop_card, 1, self.x, self.y + 30, 161)
                end
            end
            boss.Create(bclass)
        end, _t("你也是团子"), nil, true, true)
function _w.final()
    if lstg.tmpvar.RingoNomiss == lstg.var.miss then
        ext.achievement:get(146)
    end
end