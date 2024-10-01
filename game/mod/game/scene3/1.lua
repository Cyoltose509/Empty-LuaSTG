local lib = stage_lib
local servant = _editor_class.SimpleServant
local GetNumByInverse = sp.math.GetNumByInverse
local class = SceneClass[3]
local HP = lib.GetHP
local function _t(str)
    return Trans("scene3", str) or ""
end
local function name(str)
    return Trans("bossname", str)
end

lib.NewNodeEvent(class, 1, 1, 0, 0, 1, function(var)
    local enemy1 = Class(enemy, {
        init = function(self, x, y, vx1, vy1)
            enemy.init(self, 28, HP(10), false, true, false, 1)
            self.x, self.y = x, y
            self.vx, self.vy = vx1, vy1
            PlaySound("boon00")
            Create.bullet_create_eff(self.x, self.y, ball_big, 5)
            task.New(self, function()
                task.Wait(ran:Int(35, 125))
                for _ = 1, 7 do
                    local v = stage_lib.GetValue(2, 3, 4, 15)
                    local b = NewSimpleBullet(ball_mid, 5, self.x, self.y, v, 90)
                    b.ag = v / 100
                    PlaySound("tan00")
                    task.Wait(stage_lib.GetValue(125, 40, 12, 2))
                end
            end)
        end,
    }, true)
    local enemy2 = Class(enemy, {
        init = function(self, x, y, mx, my, vx, vy)
            enemy.init(self, 1, HP(11), false, true, false, 1.2)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 75, 2)
                local v = stage_lib.GetValue(3, 4, 5, 10)
                for a in sp.math.AngleIterator(Angle(self, player), 8) do
                    Create.bullet_decel(self.x, self.y, ball_huge, 2, v * 2, v, a)
                end
                PlaySound("tan00")
                for i = 1, 60 do
                    self.vx = i / 60 * vx
                    self.vy = i / 60 * vy
                    task.Wait()
                end
            end)
        end,
    }, true)
    local D = 1
    for _ = 1, 2 do
        for _ = 1, 2 do
            for _ = 1, 3 do
                for k = 0, 6 do
                    for d = -1, 1, 2 do
                        New(enemy1, d * k * 50 + ran:Float(-30, 30), 140 + ran:Float(-k * 8, k * 8), 0, -2.5)
                    end
                    task.Wait(5)
                end
                task.Wait(12)
            end
            task.Wait(60)
        end
        for _ = 1, 9 do
            local y = ran:Float(100, 180)
            New(enemy2, -360 * D, y + 80, ran:Float(-220, -280) * D, y, 3 * D, 0)
            task.Wait(5)
            D = -D
        end

    end
    task.Wait(30)
end, _t("阴魂探测器"))
lib.NewNodeEvent(class, 2, 1, 0, 0, 1, function(var)
    local ranFrot = {}
    for _ = 1, 25 do
        table.insert(ranFrot, ran:Float(25, 50))
    end
    local ball = Class(enemy, {
        init = function(self, x, y, v, ka, ki, d)
            enemy.init(self, 25, HP(25), false, true, false,
                    stage_lib.GetValue(3, 2.4, 1.5, 1))
            self.x, self.y = x, y
            task.New(self, function()
                for i = ki, ki + 3 do
                    local A = ka + d * ranFrot[i]
                    object.ChangingV(self, v, 0, A, 36, false)
                    if self.y > 0 then
                        local bv = stage_lib.GetValue(3, 4, 5, 18)
                        for a in sp.math.AngleIterator(-90, int(stage_lib.GetValue(10, 13, 16, 35))) do
                            for cv = 1, 6 do
                                Create.bullet_accel(self.x, self.y, grain_a, 8, bv * 0.6 + cv * 0.1, bv + cv * 0.1, a)
                            end
                        end
                        PlaySound("tan00")
                    end

                    d = -d
                end
                object.SetV(self, v, ka + d * ranFrot[ki + 3])
            end)
        end,
    }, true)
    local enemy2 = Class(enemy, {
        init = function(self, x, y, mx, my, vx, vy)
            enemy.init(self, 9, HP(80), false, true, false, 12)
            self.x, self.y = x, y
            task.New(self, function()
                task.New(self, function()
                    task.MoveTo(mx, my, 75, 2)
                end)
                task.Wait(35)
                local v = stage_lib.GetValue(3, 4, 5, 10)
                for _ = 1, int(stage_lib.GetValue(3, 4, 6, 12)) do
                    for a in sp.math.AngleIterator(Angle(self, player), 8) do
                        for z = -5, 5 do
                            Create.bullet_decel(self.x, self.y, arrow_big_b, 2, v * 2, v - abs(z) * v / 15, a + z * 2)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(stage_lib.GetValue(35, 25, 20, 9))
                end
                task.Wait(45)
                for i = 1, 60 do
                    self.vx = i / 60 * vx
                    self.vy = i / 60 * vy
                    task.Wait()
                end
            end)
        end,
    }, true)
    local d = 1
    for p = -1.5, 1.5 do
        local x = p * 120 + ran:Float(-30, 30)
        local ki = ran:Int(1, 16)

        local N = int(stage_lib.GetValue(4, 5, 7, 12))
        for t = 1, N do
            New(ball, x, 260, 7, -90, ki, d * (1 + t / N * 0.3))
            task.Wait(96 / N)
        end
        d = -d
        task.Wait(50)
    end
    New(enemy2, 0, 300, 0, 120, -3, 0)
    task.Wait(90)
    for p = 1.5, -1.5, -1 do
        local x = p * 120 + ran:Float(-30, 30)
        local ki = ran:Int(1, 16)

        local N = int(stage_lib.GetValue(4, 5, 7, 12))
        for t = 1, N do
            New(ball, x, 260, 7, -90, ki, d * (1 + t / N * 0.3))
            task.Wait(96 / N)
        end
        d = -d
        task.Wait(50)
    end
    New(enemy2, 0, 300, 0, 120, 3, 0)
end, _t("六国互丧，率赂秦耶？"))
lib.NewNodeEvent(class, 3, 1, 0, 0, 1, function(var)
    local throwing_ball = Class(enemy, {
        init = function(self, x, y, my, tx)
            enemy.init(self, 24, HP(55), false, true, false, 6)
            self.x, self.y = x, y
            task.New(self, function()
                while true do
                    Create.bullet_accel(self.x, self.y, ball_small, 16, 0.5, stage_lib.GetValue(2, 3.5, 5, 19), 90)
                    PlaySound("tan00")
                    task.Wait(stage_lib.GetValue(8, 6, 4, 1))
                end
            end)
            task.New(self, function()
                local mH = my - y
                local h = y + 240
                local g = 0.05
                local t = sqrt(2 * mH / g) + sqrt(2 * (mH + h) / g)
                local vx = (tx - x) / t
                local vy = sqrt(2 * g * mH)
                self.vx, self.vy = vx, vy
                self.ag = g
                while self.y > -240 do
                    task.Wait()
                end
                for a in sp.math.AngleIterator(Angle(self, player), int(stage_lib.GetValue(15, 24, 30, 120))) do
                    for v = 1, 4 do
                        NewSimpleBullet(diamond, 10, self.x, self.y,
                                (1 + v * 0.3) * stage_lib.GetValue(1, 1.3, 1.6, 6), a)
                    end
                end
                NewBon(self.x, self.y, 60, 128, 189, 252, 201)
                PlaySound("explode")
                Del(self)
            end)
        end,
    }, true)
    local d = -1
    for k = 1, 28 do
        New(throwing_ball, d * 350, ran:Float(60, 170), ran:Float(180, 200), player.x)
        task.Wait(32 - k)
        d = -d
    end
    task.Wait(60)
    for k = 1, 15 do
        New(throwing_ball, -350, 160, 200, -250 + 500 * (k - 1) / 14)
        task.Wait(3)
    end
    task.Wait(60)
    for k = 1, 15 do
        New(throwing_ball, 350, 160, 200, 250 - 500 * (k - 1) / 14)
        task.Wait(3)
    end
    task.Wait(50)
end, _t("魔法炸弹与...阴阳玉？"))
lib.NewNodeEvent(class, 4, 1, 0, 0, 1, function(var)
    local diff = var.difficulty
    local stg = stage.current_stage
    local enemy1 = Class(enemy, {
        init = function(self, x, y, vx1, vy1, vx2, vy2)
            enemy.init(self, 32, HP(6), false, false, false, 1)
            self.x, self.y = x, y
            self.vx, self.vy = vx1, vy1
            task.New(self, function()
                if var.chaos >= 50 then
                    task.Wait(ran:Int(35, 125))
                    while true do
                        Create.bullet_decel(self.x, self.y, ball_mid_c, 6, 4, min(8, 2 + var.chaos / 38), Angle(self, player))
                        PlaySound("tan00")
                        task.Wait(stage_lib.GetValue(125, 32, 10, 1))
                    end
                end
            end)
            task.New(self, function()
                task.Wait(25)
                for i = 1, 36 do
                    self.vx = vx1 + (vx2 - vx1) * (i / 36)
                    self.vy = vy1 + (vy2 - vy1) * (i / 36)
                    task.Wait()
                end
                task.Wait(352)
                Del(self)
            end)
        end,
    }, true)
    local enemy2 = Class(enemy, {
        init = function(self, x, y, mx, my, vx, vy)
            enemy.init(self, 14, HP(120), false, true, false, 20)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 60, 2)
                task.New(self, function()
                    for _ = 1, 3 do
                        for _ = 1, 3 do
                            for a in sp.math.AngleIterator(Angle(self, player), int(stage_lib.GetValue(14, 18, 22, 60))) do
                                Create.bullet_decel(self.x, self.y, ball_big, 2, 3 + var.chaos / 20, 2 + var.chaos / 30, a)
                            end
                            PlaySound("tan00")
                            task.Wait(stage_lib.GetValue(20, 12, 8, 2))
                        end
                        for a in sp.math.AngleIterator(Angle(self, player), 20 + diff * 8) do
                            Create.bullet_decel(self.x, self.y, ball_mid, 4,
                                    3 + var.chaos / 45 * 2, min(10, 1 + var.chaos / 50 * 1.5), a)
                        end
                        PlaySound("tan00")
                        task.Wait(stage_lib.GetValue(90, 55, 38, 10))
                    end
                end)
                task.Wait(180)
                for i = 1, 60 do
                    self.vx = i / 60 * vx
                    self.vy = i / 60 * vy
                    task.Wait()
                end
            end)
        end,
    }, true)
    local d = 1
    for _ = 1, 3 do
        task.New(stg, function()
            for _ = 1, 15 do
                New(enemy1, 356 * d, ran:Float(-100, -180), -4 * d, 0.2, ran:Float(-0.5, 0.5), ran:Float(2, 3))
                task.Wait(7)
            end
            for _ = 1, 15 do
                New(enemy1, -356 * d, ran:Float(-100, -180), 4 * d, 0.2, ran:Float(-0.5, 0.5), ran:Float(2, 3))
                task.Wait(7)
            end
        end)
        task.Wait(60)
        New(enemy2, 120 * d, 300, 120 * d, 150, -1.5 * d, 0)
        task.Wait(180)
        task.Wait(75)
        d = -d
    end
    task.Wait(60)
    New(enemy2, -100, 300, -100, 120, -0.78, 0)
    New(enemy2, 100, 300, 100, 120, 0.78, 0)

end, _t("乘虚而入"))
lib.NewNodeEvent(class, 5, 1, 0, 0, 1, function(var)
    if lstg.weather.GanYao then
        ext.achievement:get(83)
    elseif lstg.weather.QingLan then
        ext.achievement:get(90)
    elseif lstg.weather.LiuXingYu then
        ext.achievement:get(148)
    end
    local stg = stage.current_stage
    local chain = function()
        task.New(stg, function()
            local x, y = ran:Float(-320, 320), ran:Float(180, 240)
            local t = 7
            local w = {}
            task.init_left_wait(w)
            for i = 1, t do
                local v = stage_lib.GetValue(4, 5.5, 7, 25)
                local b = NewSimpleBullet(grain_a, 6, x, y + w.task_left_wait * v, 0, -90)
                b.vy = -v
                b.stay = false
                b.fogtime = int(11 * 4 / v)
                bullet.SetLayer(b, LAYER.ENEMY_BULLET - i * 0.001)
                function b:frame_other()
                    self.vy = -stage_lib.GetValue(4, 5.5, 7, 25)
                end
                PlaySound("tan00")
                task.Wait2(w, 7 / v)
            end
        end)
    end
    local w = {}
    task.init_left_wait(w)
    local time = 15 * 60
    local offk = 12
    local interval = stage_lib.GetValue(6, 4, 2, 0)
    for _ = 1, time / interval do
        if offk == 1 then
            local x, y = ran:Float(-320, 320), ran:Float(180, 240)
            local v = stage_lib.GetValue(3, 6, 8, 25)
            local b = NewSimpleBullet(star_small, 2, x, y, v, Angle(x, y, player))
            b.stay = false
            b.omiga = ran:Float(2, 3) * ran:Sign()
            b.fogtime = int(11 * 4 / v)
        end
        chain()
        offk = max(1, offk * 0.9)
        task.Wait2(w, interval * offk)
    end
end, _t("这就是流星雨"))
lib.NewNodeEvent(class, 6, 1, 0, 0, 2, function(var)
    local bclass = boss.Define(name("Kogasa"), 0, 400, _editor_class.kogasa_bg, "Kogasa")
    local sc = boss.card.New("恐吓「针里插缝」", 1, 5, 40, HP(900))
    boss.card.add(bclass, sc)
    function sc:before()
        task.MoveToForce(0, 135, 60, 2)
    end
    function sc:init()
        task.New(self, function()
            while true do
                Newcharge_in(self.x, self.y, 250, 128, 114)
                task.Wait(60)
                boss.cast(self, 240)
                local L = int(stage_lib.GetValue(27, 35, 55, 200))
                local v = 7
                local bv = stage_lib.GetValue(4, 3, 2, 0.3)
                local A = ran:Float(0, 360)
                local c = 240 / L + 0.2
                local n = int(stage_lib.GetValue(12, 16, 20, 72))
                local nkindex = 1.5
                for l = 1, L do
                    for a in sp.math.AngleIterator(A, n) do
                        for j = -1, 1, 2 do
                            local _a = a + j * 180 / n * nkindex
                            Create.bullet_accel(self.x + cos(_a) * sin(l * c) * 150, self.y + sin(_a) * sin(l * c) * 150,
                                    water_drop, 4, 0.5, v, _a)
                            if l % math.ceil(L / 20) == 0 then
                                Create.bullet_accel(self.x + cos(a) * sin(l * c) * 150, self.y + sin(a) * sin(l * c) * 150,
                                        ball_mid, 3, 0, bv, a + j * 360 / n * nkindex, true, false)
                            end
                        end

                    end
                    PlaySound("tan00")
                    task.Wait(240 / L)
                end
                task.Wait(stage_lib.GetValue(60, 50, 45, 12))
                task.MoveToPlayer(30, -200, 200, 125, 145,
                        40, 60, 8, 10, 2, 1)
            end
        end)
    end
    function sc:other_drop()
        if ran:Float(0, 1) < (0.25 + player_lib.GetLuck()  / 100 * 0.75) then
            item.dropItem(item.drop_card, 1, self.x, self.y + 30, 159)
        end
        mission_lib.GoMission(53)
    end
    boss.Create(bclass)
end, _t("墙打鬼"))
lib.NewNodeEvent(class, 7, 1, 0, 0, 2, function(var)

    local bclass = boss.Define(name("Yamame"), 0, 400, _editor_class.yamame_bg, "Yamame")

    local non_sc = boss.card.New("", 3, 6, 35, HP(1000))
    boss.card.add(bclass, non_sc)
    function non_sc:before()
        task.MoveToForce(0, 120, 60, 2)
    end
    function non_sc:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 135, 206, 235)
            task.Wait(60)
            task.init_left_wait(self)
            PlaySound("boon01")
            local function spider(x, y, v, a, col1, col2, wait, reb_flag)
                local self = NewObject(bullet)
                bullet.init(self, ball_mid, col1, false, true)
                self.x, self.y = x, y
                object.SetV(self, v / 100, a, true)
                self.reb_flag = reb_flag
                local t = { "l", "r", "t" }
                PlaySound("tan00")
                task.New(self, function()
                    while self.reb_flag > 0 do
                        object.ReBound(self, t, nil, self.reb_flag > 0, function()
                            self.reb_flag = self.reb_flag - 1
                        end)
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    task.Wait(wait)
                    bullet.ChangeImage(self, self.imgclass, col2)
                    PlaySound("kira00")
                    Create.bullet_create_eff(self)
                    local dv = v - v / 100
                    for i = 1, 75 do
                        object.SetV(self, v / 100 + dv * (i / 75), self.rot)
                        task.Wait()
                    end
                end)
            end
            local d = 1
            while true do
                boss.cast(self, 55)
                local N = int(stage_lib.GetValue(5, 7, 10, 30))
                local V = stage_lib.GetValue(5, 6, 7, 12)
                local W = stage_lib.GetValue(0.7, 0.8, 1, 1.3)

                for a in sp.math.AngleIterator(0, N) do
                    servant.init(NewObject(servant), self.x, self.y, 0, 135, 206, 235, 1.5, function(unit)
                        object.Connect(self, unit, 0.3, true)
                        task.New(unit, function()
                            unit:FadeIn(15)
                            object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                        end)
                        local D = d
                        unit.angle = a
                        unit.reb_flag = 1
                        local t = { "l", "r", "t" }
                        task.New(unit, function()
                            object.SetV(unit, V, unit.angle)
                            while IsValid(self) do
                                unit.angle = Angle(0, 0, unit.vx, unit.vy)
                                object.SetA(unit, V * W / 180 * PI, unit.angle + 90 * D)
                                object.ReBound(unit, t, nil, unit.reb_flag > 0, function()
                                    unit.reb_flag = unit.reb_flag - 1
                                end)
                                task.Wait()
                            end
                            Del(unit)
                        end)
                        task.New(unit, function()

                            while true do
                                if Dist(unit, player) > 40 then
                                    local w = int(stage_lib.GetValue(120, 110, 100, 45))
                                    spider(unit.x, unit.y, stage_lib.GetValue(3, 4, 5, 12), unit.angle + 180,
                                            4, 6, w, 1 - unit.reb_flag)
                                end
                                task.Wait(stage_lib.GetValue(5, 4, 3, 1))
                            end
                        end)
                    end)
                end
                task.Wait(stage_lib.GetValue(160, 140, 130, 45))
                d = -d
                task.MoveToPlayer(60, -180, 180, 100, 150,
                        30, 40, 10, 20, 2, 1)
                task.Wait(80)
            end

        end)
    end

    local sc = boss.card.New("蛛符「虫网之束缚」", 2, 7, 40, HP(1000))
    boss.card.add(bclass, sc)
    function sc:before()
        task.Wait(60)
    end
    function sc:init()
        task.New(self, function()
            task.MoveToForce(0, 120, 60, 2)
            Newcharge_in(self.x, self.y, 135, 206, 235)
            task.Wait(60)
            task.init_left_wait(self)
            PlaySound("boon01")
            local accel_laser = function(x, y, v, a, bv, time)
                local self = Create.laser_line(x, y, 10, v, a, 35, 8)
                task.New(self, function()
                    task.Wait(35)
                    local kv = 0
                    local dv = bv - v
                    for i = 1, time do
                        local _v = dv / time * i
                        self.l1 = self.l1 + _v / 2
                        self.l3 = self.l3 + _v / 2
                        task.Wait()
                    end
                    object.SetV(self, bv, a)
                end)
            end
            local function spider(x, y, v, a, col1, col2, wait, reb_flag)
                local self = NewObject(bullet)
                bullet.init(self, ball_mid, col1, false, true)
                self.x, self.y = x, y
                object.SetV(self, v / 100, a, true)
                self.reb_flag = reb_flag
                local t = { "l", "r", "t" }
                PlaySound("tan00")
                task.New(self, function()
                    while self.reb_flag > 0 do
                        object.ReBound(self, t, nil, self.reb_flag > 0, function()
                            self.reb_flag = self.reb_flag - 1
                        end)
                        task.Wait()
                    end
                end)
                task.New(self, function()
                    task.Wait(wait)
                    bullet.ChangeImage(self, self.imgclass, col2)
                    PlaySound("kira00")
                    Create.bullet_create_eff(self)
                    local dv = v - v / 100
                    for i = 1, 75 do
                        object.SetV(self, v / 100 + dv * (i / 75), self.rot)
                        task.Wait()
                    end
                end)
            end
            local d = 1
            while true do
                boss.cast(self, 55)
                local N = int(stage_lib.GetValue(3, 4, 6, 12))
                local V = stage_lib.GetValue(5, 6, 7, 12)
                local G = stage_lib.GetValue(0.04, 0.05, 0.07, 0.15)

                for a in sp.math.AngleIterator(-90 + 90 / N, N * 2) do
                    servant.init(NewObject(servant), self.x, self.y, 0, 189, 252, 201, 1.5, function(unit)
                        object.Connect(self, unit, 0.3, true)
                        task.New(unit, function()
                            unit:FadeIn(15)
                            object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                        end)
                        unit.angle = a
                        unit.reb_flag = 1
                        local t = { "l", "r", "t" }
                        task.New(unit, function()
                            object.SetV(unit, V, unit.angle)
                            unit.ag = G
                            while IsValid(self) do
                                unit.angle = Angle(0, 0, unit.vx, unit.vy)
                                object.ReBound(unit, t, nil, unit.reb_flag > 0, function()
                                    local v = stage_lib.GetValue(2, 3, 4, 9)
                                    for la in sp.math.AngleIterator(Angle(unit, player), 15) do
                                        accel_laser(unit.x, unit.y, v, la, v * 2, 25)
                                    end
                                    unit.reb_flag = unit.reb_flag - 1
                                end)
                                task.Wait()
                            end
                            Del(unit)
                        end)
                        task.New(unit, function()

                            while true do
                                if Dist(unit, player) > 40 then
                                    local w = int(stage_lib.GetValue(120, 110, 100, 45))
                                    spider(unit.x, unit.y, stage_lib.GetValue(3, 4, 5, 12), unit.angle + 180,
                                            10, 2, w, 1 - unit.reb_flag)
                                end
                                task.Wait(stage_lib.GetValue(5, 4, 3, 1))
                            end
                        end)
                    end)
                end
                task.Wait(stage_lib.GetValue(100, 90, 80, 40))
                d = -d
                task.MoveToPlayer(60, -180, 180, 100, 150,
                        30, 40, 10, 20, 2, 1)
                task.Wait(80)
            end

        end)
    end
    boss.Create(bclass)
end, _t("勇敢蛛蛛，不怕困难"))
lib.NewNodeEvent(class, 8, 1, 0, 0, 2, function(var)

    local bclass = boss.Define(name("Murasa"), 0, 400, _editor_class.murasa_bg, "Murasa")

    local non_sc = boss.card.New("", 4, 6, 35, HP(1000))
    boss.card.add(bclass, non_sc)
    function non_sc:before()
        self.tp = function(x, y)
            self._wisys:SetImageInList("Murasa2")
            PlaySound("boon01")
            local j = 1
            for i = 1, 40 do
                self._wisys:SetFloat(sin(i * 2.25) * 30 * j, 0)
                j = -j
                task.Wait()
            end
            self.x, self.y = x, y
            PlaySound("boon01")
            for i = 39, 0, -1 do
                self._wisys:SetFloat(sin(i * 2.25) * 30 * j, 0)
                j = -j
                task.Wait()
            end
            self._wisys:SetImageInList("Murasa")
            self._wisys:SetFloat(function(ani)
                return 0, 4 * sin(ani * 4)
            end)
        end
        self.tp(0, 120)
    end
    function non_sc:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 135, 206, 235)
            task.Wait(60)
            task.init_left_wait(self)

            while true do
                local x, y
                local d = -1
                local beat = 3600 / stage_lib.GetValue(145, 180, 250, 1456)
                for _ = 1, 2 do
                    boss.cast(self, 60)
                    local ck = int(stage_lib.GetValue(6, 9, 12, 45))
                    local k = (ck - 1) / 2
                    for i = -k, k do
                        i = i * d
                        i = -90 + i * 15
                        x, y = self.x + cos(i) * 120, self.y + sin(i) * 30
                        for a, c in sp.math.AngleIterator(Angle(x, y, player), int(stage_lib.GetValue(14, 17, 22, 50))) do
                            NewSimpleBullet(arrow_big, 6 + c % 2 * 2, x, y,
                                    (2 + c % 2 + ran:Float(-0.5, 0.5)) * stage_lib.GetValue(0.7, 1, 1.3, 3), a)
                        end
                        PlaySound("tan00", 0.1, 0, true)
                        task.Wait2(self, beat / 4)
                    end
                    d = -d
                    self._wisys.hscale = -self._wisys.hscale
                end
                for _ = 1, 2 do
                    local N = int(stage_lib.GetValue(7, 12, 15, 35))
                    for a, i in sp.math.AngleIterator(0, N * 5) do
                        i = i % 5 - 2
                        Create.bullet_changeangle(self.x, self.y, water_drop, 6, 1.5, a,
                                { r = -i / 20, time = 60, wait = 30, v = (2.5 - abs(i) * 0.2) * stage_lib.GetValue(1, 1.2, 1.4, 2.3) })
                    end
                    PlaySound("kira00", 0.1, 0, true)
                    task.New(self, function()
                        task.MoveToPlayer(40, -200, 200, 80, 120,
                                20, 40, 10, 20, 2, 1)
                    end)
                    task.Wait2(self, beat * 2)
                end
            end
        end)
    end

    local sc = boss.card.New("幽灵「俄勒冈漩涡」", 2, 7, 40, HP(1000))
    boss.card.add(bclass, sc)
    function sc:before()
        task.Wait(60)
    end
    function sc:init()
        task.New(self, function()
            Newcharge_in(0, 120, 135, 206, 235)
            task.MoveTo(0, 120, 60, 2)
            task.init_left_wait(self)
            local d
            local x, y
            local beat = 3600 / stage_lib.GetValue(145, 180, 250, 1456)
            d = -sign(self.dx)
            if d == 0 then
                d = 1
            end
            while true do
                for _ = 1, 2 do
                    boss.cast(self, 30)
                    task.New(self, function()
                        task.Wait(beat)
                        local index = { 0, 0.25, 0.5, 0.75, 1, 1.5 }
                        for a in sp.math.AngleIterator(ran:Float(0, 360), int(stage_lib.GetValue(18, 21, 28, 55))) do
                            for c = 1, 6 do
                                Create.bullet_dec_setangle(self.x, self.y, ellipse, 8, false,
                                        { v = 3 + c * 0.3, a = a, time = beat + beat * index[c] },
                                        { v = stage_lib.GetValue(3, 3.8, 4.3, 9), a = a + (c % 2 * 2 - 1) * 150 })
                            end
                        end
                    end)
                    local px, py = player.x, player.y
                    for i = -7.5 * d, 7.5 * d, d do

                        x, y = self.x + cos(-90 + i * 8) * 120, self.y + sin(-90 + i * 8) * 30 + i * 7 - 50
                        if i == -7.5 * d then
                            NewBon(x, y, 60, 128, 250, 128, 114)
                        end

                        for a, c in sp.math.AngleIterator(Angle(x, y, px, py), int(stage_lib.GetValue(15, 20, 25, 60))) do
                            Create.bullet_decel(x, y, grain_a, 4 + c % 2 * 2, 4,
                                    stage_lib.GetValue(2, 3, 4, 8) + c % 2 * 0.3 + i / 12, a)
                        end
                        PlaySound("tan00")
                        task.Wait2(self, beat / 8)
                    end
                    task.MoveToPlayer(40, -200, 200, 80, 120,
                            20, 40, 10, 20, 2, 1)
                    d = -sign(self.dx)
                    task.Wait2(self, beat * 2 - 40)
                    boss.cast(self, 30)
                    task.New(self, function()
                        task.Wait(beat)
                        NewBon(self.x, self.y, 60, 128, 135, 206, 235)
                        local index = { 0, 0.25, 0.5, 0.75, 1 }
                        for a in sp.math.AngleIterator(ran:Float(0, 360), int(stage_lib.GetValue(12, 15, 20, 50))) do
                            for c = 1, 5 do
                                Create.bullet_dec_setangle(self.x, self.y, ellipse, 8, false,
                                        { v = 3 + c * 0.3, a = a, time = beat + beat * index[c] },
                                        { v = stage_lib.GetValue(3, 3.8, 4.3, 9), a = a + (c % 2 * 2 - 1) * 150 })
                            end
                        end
                    end)
                    for i = -7.5 * d, 7.5 * d, d do
                        x, y = self.x + cos(-90 + i * 8) * 120, self.y + sin(-90 + i * 8) * 30 + i * 7 - 50
                        if i == -7.5 * d then
                            NewBon(x, y, 60, 128, 250, 128, 114)
                        end
                        for a, c in sp.math.AngleIterator(Angle(x, y, px, py), int(stage_lib.GetValue(13, 18, 22, 55))) do
                            Create.bullet_decel(x, y, grain_a, 4 + c % 2 * 2, 4,
                                    stage_lib.GetValue(2, 3, 4, 8) + c % 2 * 0.3 + i / 12, a)
                        end

                        PlaySound("tan00")
                        task.Wait2(self, beat / 8)
                    end
                    task.Wait2(self, beat * 2)
                    for i = 1, 4 do
                        i = i % 2 * 2 - 1
                        for a in sp.math.AngleIterator(ran:Float(0, 360), int(stage_lib.GetValue(8, 10, 13, 30))) do
                            for v = 0, stage_lib.GetValue(2, 3, 4, 10) do
                                Create.bullet_changeangle(self.x, self.y, water_drop, 4,
                                        stage_lib.GetValue(2, 3, 4, 9) + v * 0.3,
                                        a + v * 3 * i, { r = -i - v * 0.1 * i, time = 60, wait = 30 })
                            end
                        end
                        if i % 2 == 0 then
                            task.New(self, function()
                                task.MoveToPlayer(40, -200, 200, 80, 120,
                                        20, 40, 10, 20, 2, 1)
                                d = -sign(self.dx)
                            end)
                        end

                        task.Wait2(self, beat)
                    end
                    task.Wait2(self, beat * 1.3)
                end
            end
        end)
    end
    function sc:other_bonus_drop()
    end
    boss.Create(bclass)
end, _t("Pretty Pretty Spark"))
lib.NewNodeEvent(class, 9, 1, 0, 0, 2, function(var)

    local bclass = boss.Define(name("Neet"), 0, 400, _editor_class.neet_bg, "Neet")

    local non_sc = boss.card.New("", 3, 7, 40, HP(1000))
    boss.card.add(bclass, non_sc)
    function non_sc:before()
        task.MoveToForce(0, 120, 60, 2)
    end
    function non_sc:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 135, 206, 235)
            task.Wait(60)
            task.init_left_wait(self)
            local rot = 90
            local rf = 0
            while true do
                local beat = 3600 / stage_lib.GetValue(100, 250, 350, 1200)
                local iv = stage_lib.GetValue(2.5, 3, 4, 9)
                local tv = stage_lib.GetValue(6, 7, 8, 20)
                local ov = ran:Float(0.7, 1.2) * stage_lib.GetValue(1, 1.2, 1.4, 5)

                for a in sp.math.AngleIterator(rot + ran:Float(-rf, rf), 6) do
                    local b = Create.bullet_dec_setangle(self.x, self.y, ellipse, 6, false,
                            { v = iv, a = a, time = int(90 / iv) },
                            { v = tv, a = a, time = int((155 + abs((a % 360) - 270)) * 6 / tv) },
                            { func = function(self)
                                bullet.ChangeImage(self, self.imgclass, 2)
                                Create.bullet_create_eff(self)
                            end, v = ov, a = a + 180 + ran:Float(-90, 90) })
                    b.fogtime = int(90 / iv)
                    b._fogsize = 1
                end
                rot = rot + 20
                rf = min(5, rf + 0.3 / (beat / 4))
                PlaySound("tan00")
                task.Wait2(self, beat / 4)
            end

        end)
    end
    local sc = boss.card.New("神宝「无限的生命之泉」", 2, 7, 40, HP(1000))
    boss.card.add(bclass, sc)
    function sc:before()
        task.MoveToForce(0, 150, 60, 2)
        Newcharge_in(self.x, self.y, 120, 152, 255)
        task.Wait(60)
    end
    function sc:init()
        task.New(self, function()
            task.Wait(60)
            local shoot_laser = Class(laser, { init = function(self, x, y, col, a, w, l, node, wait, life)
                laser.init(self, col, x, y, a, 0, l * 0.4, l * 0.6, w, node, 0)
                laser._TurnHalfOn(self, 0, false)
                self.line = 0
                self.Isradial = true
                self.group = GROUP.INDES
                task.New(self, function()
                    task.Wait(wait)
                    laser._TurnOn(self, 8, true, false)
                    task.Wait(life * 0.8)
                    laser._TurnOff(self, int(life * 0.2), true)
                    object.Del(self)
                end)
            end }, true)
            local spring = function(x, y, n, v, wait, time)
                servant.init(NewObject(servant), x, y, 0, 100, 100, 255, 1.5, function(unit)
                    unit.omiga = ran:Sign() * ran:Float(3, 4)
                    unit.colli = false

                    task.New(unit, function()
                        unit:FadeIn(15)
                        object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                    end)
                    task.New(unit, function()
                        task.MoveTo(player.x + ran:Float(-40, 40), ran:Float(-100, -144), 60, 2)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), n) do
                            for d = -1, 1, 2 do
                                --真激光
                                local L = 450
                                New(shoot_laser, unit.x + cos(a) * 30, unit.y + sin(a) * 30, 6 + d * 2,
                                        a + d * 90, 4, L, 0, wait, time)
                                --特效
                                New(shoot_laser, unit.x + cos(a) * 70, unit.y + sin(a) * 70, 6 + d * 2,
                                        a + d * 15, 4, 0, 4, wait, time)
                            end

                        end
                        task.Wait(wait)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), n) do
                            for d = -1, 1, 2 do
                                local b = Create.bullet_dec_setangle(unit.x, unit.y, star_small, 2, false,
                                        { v = 2.5, a = a, time = 60, },
                                        { v = v, a = a + 90 * d })
                                b.omiga = 3 * ran:Sign()
                            end
                        end
                        PlaySound("tan00")
                        task.Wait(time)
                        Del(unit)
                    end)
                end)
            end
            while true do
                PlaySound("option")
                local n = int(stage_lib.GetValue(19, 25, 35, 120))
                local bv = stage_lib.GetValue(1, 1.4, 1.8, 6.5)
                local wait = int(stage_lib.GetValue(50, 35, 20, 39))
                spring(self.x, self.y, n, bv, wait * 0.6, wait * 2.8)
                for i = -80, 80 do
                    for v = 0, 1 do
                        NewSimpleBullet(ball_mid_c, 2, self.x, self.y, 3 + v, 90 + i / 80 * 135)
                    end
                end
                task.MoveToPlayer(40, -200, 200, 144, 160,
                        40, 60, 10, 12, 2, 1)
                task.Wait(wait * 2)
            end

        end)
    end
    function sc:other_bonus_drop()
        if ran:Float(0, 1) < (0.25 +player_lib.GetLuck()  / 100 * 0.75) then
            item.dropItem(item.drop_card, 1, self.x, self.y + 30, 114)
        end
        mission_lib.GoMission(27)
        if not scoredata.Achievement[102] and not IsSpecialMode() then
            scoredata.NeetQuestions[4] = 1
            if table.concat(scoredata.NeetQuestions) == "111111" then
                ext.achievement:get(102)
            end
        end
    end
    boss.Create(bclass)
end, _t("五难题之四"))
lib.NewNodeEvent(class, 10, 1, 0, 0, 2, function(var)

    local bclass = boss.Define(name("Neet"), -200, 400, _editor_class.neet_bg, "Neet")

    local sc = boss.card.New("神宝「蓬莱的玉枝　-梦色之乡-」", 2, 17, 65, HP(2500))
    boss.card.add(bclass, sc)
    function sc:before()
        task.MoveToForce(0, 144, 60, 2)
        Newcharge_in(self.x, self.y, 120, 152, 255)
        task.Wait(60)
    end
    function sc:init()
        task.New(self, function()
            task.Wait(60)
            local beat = 3600 / stage_lib.GetValue(100, 200, 300, 1200)
            task.New(self, function()
                while true do
                    beat = 3600 / stage_lib.GetValue(100, 200, 300, 1200)
                    task.Wait()
                end
            end)
            task.init_left_wait(self)
            local leaf = function(x, y, v, a, isty, col)
                local self = NewObject(bullet)
                bullet.init(self, isty, col, false, true)
                self.x, self.y = x, y
                object.SetV(self, v, a, true)
                task.New(self, function()
                    while true do
                        if self.x <= -320 or self.x >= 320 or self.y >= 240 then
                            break
                        end
                        task.Wait()
                    end
                    PlaySound("kira00")
                    bullet.ChangeImage(self, grain_a, self._index)
                    object.SetV(self, v, Angle(self, player), true)
                end)
            end
            local branch = function(x, y, mx, my, col)
                servant.init(NewObject(servant), x, y, 0, 250, 128, 114, 1.5, function(unit)
                    unit.omiga = ran:Sign() * ran:Float(3, 4)
                    task.New(unit, function()
                        unit:FadeIn(15)
                        object.ChangingSizeColli(unit, -0.5, -0.5, 15)
                    end)
                    task.New(unit, function()
                        task.init_left_wait(unit)
                        task.CRMoveTo(150, 1, ran:Float(-150, 150), ran:Float(100, 160), mx, my)
                        NewBon(unit.x, unit.y, 60, 78, unpack(ColorList[math.ceil(col / 2)]))
                        PlaySound("nice")
                        for a in sp.math.AngleIterator(Angle(unit, player), 42) do
                            leaf(unit.x, unit.y, stage_lib.GetValue(1.4, 2, 3, 15), a, grain_a, col)
                        end
                        task.Wait2(unit, beat * 16)
                        local d = 1
                        while true do
                            task.New(unit, function()
                                local n = int(stage_lib.GetValue(6, 8, 9, 33))
                                for i = 1, n do
                                    local index = stage_lib.GetValue(0.7, 1, 1.4, 6)
                                    for a in sp.math.AngleIterator((i - 1) * d * 3.5 * 6 / n, 2) do
                                        leaf(unit.x, unit.y, (3 + i / 6 * 1.7) * index, a, grain_c, col)
                                    end
                                    PlaySound("kira00")
                                    task.Wait(math.ceil(5 / index))
                                end
                            end)
                            d = -d
                            task.Wait2(unit, beat * 5.6)
                        end
                        object.ChangingSizeColli(unit, -1, -1, 15)
                        Del(unit)
                    end)
                end)
            end
            local colgroup = { 2, 4, 6, 8, 10, 12, 14 }
            PlaySound("option")
            for i = -3, 3 do
                local a = 90 + i * 8
                branch(self.x, self.y, cos(a) * 180, -140 + sin(a) * 180, colgroup[i + 4])
            end
            task.Wait2(self, 150)
            task.Wait2(self, beat * 16)
            local d = 1
            local i = 1
            while true do
                local col = colgroup[sp:TweakValue(i, 7, 1)]
                for a in sp.math.AngleIterator(90 + d * i * 0.9, 16) do
                    Create.bullet_changeangle(self.x, self.y, ball_mid, col, stage_lib.GetValue(2, 3, 4, 12), a)
                end
                PlaySound("tan00")
                d = -d
                i = i + 1
                task.Wait2(self, beat * 0.38)
            end
        end)
    end
    function sc:other_bonus_drop()
        if ran:Float(0, 1) < (0.25 + player_lib.GetLuck()  / 100 * 0.75) then
            item.dropItem(item.drop_card, 1, self.x, self.y + 30, 101)
        end
        mission_lib.GoMission(28)
        if not scoredata.Achievement[102] and not IsSpecialMode() then
            scoredata.NeetQuestions[5] = 1
            if table.concat(scoredata.NeetQuestions) == "111111" then
                ext.achievement:get(102)
            end
        end
    end
    boss.Create(bclass)
end, _t("五难题之五"))
lib.NewNodeEvent(class, 11, 1, 0, 0, 2, function(var)
    local White = Class(object, {
        init = function(self, _boss)
            self.colli = false
            self.boss = _boss
            self.layer = LAYER.TOP + 1
            self.group = GROUP.GHOST
        end,
        frame = function(self)
            if not IsValid(self.boss) then
                Del(self)
            end
        end,

        render = function(self)
            if IsValid(self.boss) then
                SetImageState("white", "add+rev", self.boss.white_a, 255, 255, 255)
                RenderRect("white", lstg.world.l, lstg.world.r, lstg.world.b, lstg.world.t)
            end
        end
    }, true)

    local bclass = boss.Define(name("Yagokoro"), -200, 400, _editor_class.yagokoro_bg, "Yagokoro")
    local sc = boss.card.New("药符「酒石酸唑吡坦」", 1, 4, 26, HP(1800))
    boss.card.add(bclass, sc)
    function sc:before()
        self.white_a = 0
        self.velocity_set = 1
        New(White, self)
        task.MoveToForce(0, 100, 60, 2)
        Newcharge_in(self.x, self.y, 120, 152, 255)
        task.Wait(60)
    end
    function sc:del()
        lstg.tmpvar.sc_name = nil
        self.white_a = 0
        lstg.var.timeslow = 1
        object.BulletIndesDo(function(b)
            sp:UnitClearVIndexSet(b, "_yagokoro_set_")
        end)
        sp:UnitClearVIndexSet(player, "_yagokoro_set_")
    end
    function sc:frame()
        local index = self.velocity_set - 1
        if index ~= 0 then
            object.BulletIndesDo(function(b)
                sp:UnitSetVIndex(b, index, "_yagokoro_set_")
            end)
            sp:UnitSetVIndex(player, index, "_yagokoro_set_")
        end
    end
    function sc:init()
        lstg.tmpvar.sc_name = "药符「酒石酸唑吡坦」"
        ext.achievement:get(43)
        task.New(self, function()
            task.Wait(60)
            task.init_left_wait(self)
            task.New(self, function()
                for _ = 1, 3 do
                    task.Wait(410)
                    self.white_a = self.white_a + 70
                    self.velocity_set = self.velocity_set - 0.25
                    PlaySound("nice")
                end
            end)
            local col = { 2, 6, COLOR.GREEN, COLOR.ORANGE, COLOR.CYAN }
            local d = 1
            local l, a1, a2, v, rot
            local n = 7
            for t = 1, #col do
                Newcharge_out(self.x, self.y, 255, 255, 100)
                l = 120
                boss.cast(self, 120)
                task.New(self, function()
                    local w = {}
                    task.init_left_wait(w)
                    a1 = ran:Float(0, 360)
                    a2 = ran:Float(0, 360)
                    local N = stage_lib.GetValue(120, 150, 180, 600)
                    local jindex = stage_lib.GetValue(0.4, 0.65, 0.85, 3)
                    for i = 1, N do
                        local sty = ({ grain_a, grain_b })[i % 2 + 1]
                        local iv = ({ 0.5, 1 })[i % 2 + 1]
                        iv = iv + stage_lib.GetValue(0, 1, 2, 6)
                        for j = 1, t do
                            Create.bullet_decel(self.x + cos(a1) * l, self.y + sin(a1) * l, sty, col[t],
                                    5, iv + j * jindex, a1 * (6 - t) * 0.6)
                            Create.bullet_decel(self.x + cos(a2) * l, self.y + sin(a2) * l, sty, col[t],
                                    5, iv + j * jindex, a2 * (6 - t) * 0.6)
                            PlaySound("tan00")
                        end
                        l = l - 1
                        task.Wait2(w, 200 / N / self.velocity_set)
                        a1 = a1 + 7
                        a2 = a2 - 7
                    end
                end)
                v = 1
                rot = Angle(self, player)
                local N = n + int(stage_lib.GetValue(0, 5, 8, 33))
                for _ = 1, 50 do
                    for a in sp.math.AngleIterator(rot, N) do
                        Create.bullet_accel(self.x + cos(a) * l, self.y + sin(a) * l,
                                butterfly, col[t], 0.5, v, a + 180, true)
                    end
                    PlaySound("tan00")
                    task.Wait2(self, 2 / self.velocity_set)
                    v = v + 0.1
                    rot = rot + (360 / N / 2 - 0.2) * d
                end
                task.New(self, function()
                    task.Wait(30)
                    task.MoveToPlayer(60, -250, 250, 90, 144,
                            40, 80, 20, 40, 2, 1)
                end)
                for _ = 1, 90 do
                    task.Wait2(self, 1 / self.velocity_set)
                end
                d = -d
                n = n + 1
            end
        end)

    end
    boss.Create(bclass)
end, _t("催眠大将"))
lib.NewNodeEvent(class, 12, 1, 0, 0, 2, function(var)

    local soul = Class(enemy, {
        init = function(self, x, y, vx1, vy1)
            enemy.init(self, 27, HP(15), false, true, false, 1)
            self.x, self.y = x, y
            PlaySound("boon00")
            Create.bullet_create_eff(self.x, self.y, ball_big, 2)
            task.New(self, function()

                local n = int(stage_lib.GetValue(1, 6, 10, 45))
                local vn = int(stage_lib.GetValue(-1, 0, 2, 9))
                for a in sp.math.AngleIterator(Angle(self, player), n) do
                    for v = 0, vn do
                        NewSimpleBullet(ball_mid, 1, self.x, self.y,
                                GetNumByInverse(var.chaos, 12, 1, 3) + v, a)
                    end
                end
                PlaySound("tan00")

                task.Wait(180)
                for i = 1, 60 do
                    i = i / 60
                    self.vx = vx1 * i
                    self.vy = vy1 * i
                    task.Wait()
                end

            end)
        end,
        kill = function(self)
            enemy.kill(self)
            local n = int(stage_lib.GetValue(4, 5, 6, 24))
            local vn = int(stage_lib.GetValue(1, 3, 5, 21))
            local iv = stage_lib.GetValue(2, 1.5, 0.9, 0.2)
            local vindex = stage_lib.GetValue(0.3, 0.4, 0.5, 1.8)
            for a in sp.math.AngleIterator(-90, n) do
                for v = 0, vn do
                    NewSimpleBullet(ball_big, 2, self.x, self.y, iv + v * vindex, a)
                end
            end
        end
    }, true)
    local d = 1
    for _ = 1, 4 do
        for k = 0, 25 do
            New(soul, d * (-300 + k / 25 * 600) + ran:Float(-45, 45), ran:Float(70, 181), ran:Sign(), 0)
            task.Wait(4)
        end
        d = -d
        task.Wait(150)
    end
end, _t("阴魂不散"))
lib.NewNodeEvent(class, 13, 1, 0, 0, 2, function(var)
    local particler = Class(object, {
        init = function(self, col, x, y, v, a, thickness)
            object.init(self, x, y, GROUP.INDES, LAYER.ENEMY_BULLET)
            self.particle = {}
            self.thickness = thickness or 6
            self.pcol = ColorList[math.ceil(col / 2)]
            object.SetV(self, v, a)
        end,
        frame = function(self)
            if self.timer < 90 then
                for _ = 1, self.thickness do
                    local a = ran:Float(0, 360)
                    local v = ran:Float(3, 6)
                    table.insert(self.particle, {
                        x = self.x, y = self.y,
                        vx = cos(a) * v, vy = sin(a) * v,
                        alpha = ran:Float(200, 250), timer = 0,
                        r = self.pcol[1], g = self.pcol[2], b = self.pcol[3]
                    })
                end
            end
            local p
            for i = #self.particle, 1, -1 do
                p = self.particle[i]
                p.x = p.x + p.vx
                p.y = p.y + p.vy
                p.vx = p.vx - p.vx * 0.04
                p.vy = p.vy - p.vy * 0.04
                if p.timer > 10 then
                    p.alpha = max(p.alpha - 5, 0)
                    if p.alpha == 0 then
                        table.remove(self.particle, i)
                    end
                end
                p.timer = p.timer + 1
            end
            self.bound = (#self.particle == 0) and (self.timer > 30)
        end,
        render = function(self)
            for _, p in ipairs(self.particle) do
                SetImageState("bright", "mul+add", p.alpha, p.r, p.g, p.b)
                Render("bright", p.x, p.y, 0, 10 / 150)
            end
        end
    }, true)
    local LASER = Class(laser, { init = function(self, col, x, y, rot, w, lifetime, event)
        New(particler, col, x, y, 20, rot)
        laser.init(self, col, x, y, rot, 0, 1000, 0, w, w / 1.5, 0)
        laser._TurnOn(self, 5, true)
        self.group = GROUP.INDES
        task.New(self, function()
            task.Wait(lifetime)
            laser._TurnOff(self, 15, true)
            Del(self)
        end)
        if event then
            event(self)
        end
    end }, true)
    local laser_small = Class(laser, {
        init = function(self, x, y, col, w, a, dr, time)
            laser.init(self, col, x, y, a, 0, 0, 0, w, w, 0)
            laser._TurnHalfOn(self, 0, false)
            self.line = 0
            self.Isradial = true
            self.radial_v = 16
            task.New(self, function()
                task.New(self, function()
                    for i = 1, 45 do
                        self.line = sin(i * 2) * 600
                        task.Wait()
                    end
                    task.Wait(15)
                end)
                local slast = 0
                task.New(self, function()
                    time = time + 20
                    for i = 1, time do
                        i = task.SetMode[2](i / time)
                        self.rot = self.rot + dr * i - slast
                        slast = dr * i
                        task.Wait()
                    end
                end)
                task.Wait(time)
                laser._TurnOn(self, 1, true, false)
                New(particler, col, x, y, 14, self.rot, 1)
                for _ = 1, 30 do
                    self.l3 = self.l3 + 16
                    task.Wait()
                end
                for _ = 1, 30 do
                    self.l1 = self.l1 + 16
                    task.Wait()
                end
                laser._TurnOff(self, 30, true)
                object.Del(self)
            end)
        end,
        render = function(self)
            SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
            Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
            laser.render(self)
        end
    }, true)
    local ShootLaser = function(self, a, col, w, lt, power, r)
        lt = int(lt)
        task.New(self, function()
            local slast = 0
            for i = 1, lt do
                i = sin(i / lt * 180)
                self.x = self.x - cos(a) * (i - slast) * power
                self.y = self.y - sin(a) * (i - slast) * power
                slast = i
                task.Wait()
            end
        end)
        misc.ShakeScreen(lt, 4, 1, 2.5, 1)
        New(LASER, col, self.x + cos(a) * w, self.y + sin(a) * w, a, w, lt, function(unit)
            task.New(unit, function()
                while true do
                    if r then
                        unit.rot = unit.rot + r
                    end
                    unit.x, unit.y = self.x + cos(unit.rot) * w, self.y + sin(unit.rot) * w
                    task.Wait()
                end
            end)
        end)
    end

    local bclass = boss.Define(name("Clownpiece"), -200, 400, _editor_class.clownpiece_bg, "Clownpiece")
    local sc = boss.card.New("「阿波罗11的捏造」", 1, 6, 40, HP(1000))
    boss.card.add(bclass, sc)
    function sc:before()
        task.MoveToForce(0, 100, 60, 2)
        Newcharge_in(self.x, self.y, 120, 152, 255)
        task.Wait(60)
    end
    function sc:init()
        ext.achievement:get(44)
        task.New(self, function()
            Newcharge_in(self.x, self.y, 30, 30, 255)
            local beat = 3600 / 100
            local bN = 25
            local rR = 13
            task.New(self, function()
                while true do
                    rR = stage_lib.GetValue(20, 15, 13, 4)
                    bN = int(stage_lib.GetValue(16, 22, 26, 90))
                    beat = 3600 / stage_lib.GetValue(100, 160, 220, 900)
                    task.Wait()
                end
            end)
            task.Wait(60)
            task.init_left_wait(self)

            local ball_turnaround = function(x, y, col, iv, v, a, r)
                local b = Create.bullet_changeangle(x, y, ball_big, col, iv, a,
                        { wait = 20, time = 120, r = r, v = v }, { v = 6, time = 180 })
                b.stay = false
                b._blend = "mul+add"
                return b
            end

            while true do
                do
                    Newcharge_out(self.x, self.y, 30, 30, 255)
                    for d = -1, 1, 2 do
                        ShootLaser(self, -90 + 45 * d, 6, 45, beat * 2, 25, -0.1 * d)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), bN) do
                            ball_turnaround(self.x, self.y, 6, 2, 7, a, 1 * d)
                        end
                        task.Wait2(self, beat * 2)
                    end
                    ShootLaser(self, -90 - 30, 6, 45, beat * 2.5, 25, 0.2)
                    ShootLaser(self, -90 + 30, 6, 45, beat * 2.5, 25, -0.2)
                    for d = -1, 1, 2 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), int(bN * 0.8)) do
                            for v = 0, 3 do
                                ball_turnaround(self.x, self.y, 6, 2, 2 + v * 2, a, 0.4 * d)
                            end
                        end
                    end
                    task.Wait2(self, beat * 2)
                    Newcharge_in(self.x, self.y, 30, 30, 255)
                    task.Wait2(self, beat * 2)
                end
                do
                    Newcharge_out(self.x, self.y, 255, 30, 30)
                    for d = -1, 1, 2 do
                        ShootLaser(self, -90 - 30 * d, 2, 45, beat * 2, 25, 0.1 * d)
                        for a in sp.math.AngleIterator(ran:Float(0, 360), bN) do
                            ball_turnaround(self.x, self.y, 2, 4, 1, a, 1 * d)
                        end
                        task.Wait2(self, beat * 2)
                    end
                    Newcharge_in(self.x, self.y, 255, 30, 30)
                    SmearScreen(nil, 3, int(beat * 2))
                    local A = -90
                    task.New(self, function()
                        local w = {}
                        task.init_left_wait(w)
                        local r = ran:Float(0, 360)
                        for i = 1, 16 do
                            for d = -1, 1, 2 do
                                for a in sp.math.AngleIterator(r + rR * i * d, 6) do
                                    ball_turnaround(self.x, self.y, 4, 1, 4, a, -0.25 * i * d)
                                end
                            end
                            task.Wait2(w, beat / 4)
                        end
                    end)
                    for z = -8, 8 do
                        New(laser_small, self.x, self.y, 4, 12, A, z * 360 / 17, int(beat * 2))
                    end
                    task.Wait2(self, beat * 2)
                    Newcharge_out(self.x, self.y, 255, 30, 255)
                    ShootLaser(self, A - 45, 4, 45, beat * 2.5, 25, -0.5)
                    ShootLaser(self, A + 45, 4, 45, beat * 2.5, 25, 0.5)
                    task.Wait2(self, beat * 2)
                    task.New(self, function()
                        task.MoveTo(0, 50, 60, 2)
                    end)
                    ShootLaser(self, A - 45, 4, 45, beat * 2.5, 25, 0.3)
                    ShootLaser(self, A + 45, 4, 45, beat * 2.5, 25, -0.3)
                    task.Wait2(self, beat * 2)
                end
                do
                    Newcharge_in(self.x, self.y, 30, 255, 30)
                    for i = 1, 3 do
                        local A = 90 + i * 120
                        for z = -3, 3 do
                            New(laser_small, self.x, self.y, 14, 12, A, z * 17, int(beat * (8 - 2 * i) / 3))
                        end
                        task.Wait2(self, beat * 2 / 3)
                    end
                    Newcharge_out(self.x, self.y, 30, 255, 30)
                    misc.ShakeScreen(30, 3, 1, 2.5, 1)
                    task.Wait2(self, beat * 2)
                    task.New(self, function()
                        task.MoveTo(0, 100, 60, 2)
                    end)
                    for i = 1, 3 do
                        ShootLaser(self, 90 + i * 120, 14, 45, beat * 1.5, 25, 0.5)
                        ShootLaser(self, 90 + i * 120, 14, 45, beat * 1.5, 25, -0.5)
                    end
                    task.Wait2(self, beat * 4)
                end
            end
        end)

    end
    function sc:other_bonus_drop()
        if ran:Float(0, 1) < (0.25 + player_lib.GetLuck()  / 100 * 0.75) then
            item.dropItem(item.drop_card, 1, self.x, self.y + 30, 116)
        end
        mission_lib.GoMission(41)
    end
    boss.Create(bclass)
end, _t("我知道，这是，这是那个"))
lib.NewNodeEvent(class, 14, 1, 0, 0, 2, function(var)
    if lstg.weather.QingLan then
        ext.achievement:get(121)
    end
    local bclass = boss.Define(name("Seiran"), 200, 400, _editor_class.seiran_bg, "Seiran")
    local sc = boss.card.New("弹符「风舂雨硙」", 2, 6, 40, HP(900))
    boss.card.add(bclass, sc)
    function sc:before()
        task.MoveToForce(0, 100, 60, 2)
        Newcharge_in(self.x, self.y, 120, 152, 255)
        task.Wait(60)
    end
    function sc:init()
        task.New(self, function()

            local lightbound = function(x, y, rot, accel)
                local b = NewSimpleBullet(ball_mid, 4, x, y, 0, 0)
                task.New(b, function()
                    task.Wait(20)
                    local v = accel
                    b.ax, b.ay = cos(rot + 180) * v, sin(rot + 180) * v
                    for i = 1, 20 do
                        object.SetSizeColli(b, 1 - i / 20 * 0.5)
                        task.Wait()
                    end
                    b.vx = -b.vx
                    b.vy = -b.vy
                    for i = 1, 20 do
                        object.SetSizeColli(b, 0.5 + i / 20 * 0.5)
                        task.Wait()
                    end
                    task.Wait(20)
                    for i = 1, 30 do

                        object.SetSizeColli(b, 1 - task.SetMode[1](i / 30))
                        task.Wait()
                    end
                    object.RawDel(b)
                end)
                b._blend = "mul+add"
                return b
            end
            local shoot = function(W, wait, A, da, color, v)
                local w
                return function()
                    for i = 1, W do
                        w = (i - 1) / 2
                        for a = -w, w do
                            a = A + a * task.SetMode[2](i / W) * da / i
                            bullet.SetLayer(NewSimpleBullet(gun_bullet, color, self.x + cos(a) * 10, self.y + sin(a) * 10, v, a,
                                    nil, nil, false), LAYER.ENEMY_BULLET - 100 - i * 0.001)
                        end
                        PlaySound("tan00", 0.1, 0, true)
                        task.Wait(wait)
                    end
                end
            end
            Newcharge_in(self.x, self.y, 135, 206, 235)
            task.Wait(60)
            while true do
                boss.cast(self, 120)
                Newcharge_in(self.x, self.y, 255, 30, 255)
                task.Wait(60)
                local px, py = player.x, player.y
                NewWave(px, py, 12, 500, 25, 218, 112, 214)
                Newcharge_out(px, py, 218, 112, 214)
                misc.ShakeScreen(60, 3, 1, 1.5, 1)
                object.BulletDo(function(b)
                    object.Del(b)
                end)
                local iR = stage_lib.GetValue(25, 10, 9, 3)
                for k = 1, 48 do
                    local l = iR + k * 16
                    for a in sp.math.AngleIterator(0, 10 + k * 4) do
                        local x, y = px + cos(a) * l, py + sin(a) * l
                        lightbound(x, y, a, 0.01 + k / 30 * 0.05)
                    end
                    task.Wait()
                end
                task.Wait(20)
                local beat = stage_lib.GetValue(27, 20, 15, 3)
                local N = int(stage_lib.GetValue(14, 20, 24, 75))
                local v = stage_lib.GetValue(3, 4, 5, 18)
                task.New(self, function()
                    task.Wait(25)
                    task.MoveToPlayer(60, -200, 200, 80, 120,
                            30, 40, 10, 20, 2, 1)
                end)
                task.New(self, function()
                    local A = Angle(self, player)
                    local u
                    for i = 1, 6 do
                        local t = ran:Float(-15, 15)
                        for a in sp.math.AngleIterator(A, N) do
                            object.SetA(NewSimpleBullet(ball_huge, 6, self.x, self.y, v, a + t), v / 88, A)
                        end
                        u = i % 2 / 2
                        for r = -u, u do
                            task.New(self, shoot(9, 2, Angle(self, player) + r * 50, 12, 2, v * 1.3))
                        end

                        task.Wait(beat)

                    end
                end)
                task.Wait(beat * 5)


            end
        end)

    end
    boss.Create(bclass)
end, _t("草莓酱"))
lib.NewNodeEvent(class, 15, 1, 0, 0, 3, function(var)
    if lstg.weather.GanYao then
        ext.achievement:get(99)
    end
    local bclass = boss.Define(name("Yagokoro"), 0, 400, _editor_class.yagokoro_bg, "Yagokoro")
    local sc = boss.card.New("「天网蛛网捕蝶之法」", 1, 12, 50, HP(1000))
    boss.card.add(bclass, sc)
    function sc:before()
        task.MoveToForce(0, 100, 60, 2)

    end
    function sc:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 120, 152, 255)
            task.Wait(60)
            local shoot_laser = Class(laser, {
                init = function(self, x, y, col, w, a, time, life)
                    laser.init(self, col, x, y, a, 0, 0, 0, w, w, 0)
                    laser._TurnHalfOn(self, 0, false)
                    self.line = 0
                    self.Isradial = true
                    local n1, n2 = life * 0.6, life * 0.4
                    local KL = 800 / life
                    self.radial_v = KL
                    task.New(self, function()
                        task.New(self, function()
                            for i = 1, 90 do
                                self.line = sin(i) * 1200
                                task.Wait()
                            end
                        end)
                        task.Wait(time)
                        laser._TurnOn(self, 1, true, false)
                        task.New(self, function()
                            for _ = 1, n1 do
                                self.l3 = self.l3 + KL
                                task.Wait()
                            end
                            for _ = 1, n2 do
                                self.l1 = self.l1 + KL
                                task.Wait()
                            end
                            laser._TurnOff(self, 30, true)
                            object.Del(self)
                        end)
                    end)
                end,
                render = function(self)
                    SetImageState("white", "mul+add", self.alpha * 180, unpack(ColorList[math.ceil(self.index / 2)]))
                    Render("white", self.x + cos(self.rot) * self.line / 2, self.y + sin(self.rot) * self.line / 2, self.rot, self.line / 16, 0.125)
                    laser.render(self)
                end
            }, true)
            local function tree(x, y, v, a, mt, da, time, ba, j)
                if time > 0 then
                    New(shoot_laser, x, y, 6, 8, a, 40, 80)
                    if j >= 1 then
                        task.New(self, function()
                            task.Wait(120)
                            NewSimpleBullet(ball_mid, 6, x, y,
                                    stage_lib.GetValue(1.5, 1, 0.8, 0.2), ba)
                            PlaySound("tan00")
                        end)
                    end
                    task.New(self, function()
                        local K = int(85 / v / mt)
                        for _ = 1, K do
                            Create.bullet_create_eff(x, y, ball_mid, 6)
                            x = x + cos(a) * v * mt
                            y = y + sin(a) * v * mt
                            task.Wait(mt)
                        end
                        for d = -1, 1, 2 do
                            tree(x, y, v, a + da * d, mt, da, time - 1, ba, j)
                        end
                    end)

                end
            end
            local j = 0
            while true do
                task.Wait()
                boss.cast(self, 120)
                local ba = Angle(self, player)
                local ra = stage_lib.GetValue(0, 15, 28, 100)
                tree(self.x, self.y, 5, ba, 3, ran:Float(60 - ra, 60 + ra), 8, ba, j)
                task.Wait(int(stage_lib.GetValue(256, 200, 160, 40)))
                task.MoveToPlayer(60, -200, 200, 100, 144,
                        40, 50, 20, 40, 2, 1)
                j = j + 1
            end
        end)

    end
    boss.Create(bclass)
end, _t("二叉树"))
lib.NewNodeEvent(class, 16, 1, 0, 0, 1, function(var)
    local soul = Class(enemy, {
        init = function(self, x, y, a, o, r)
            enemy.init(self, 29, HP(15), false, true, false, 1.5)

            self.x, self.y = x + cos(a) * r, y + sin(a) * r
            Create.bullet_create_eff(self.x, self.y, ball_big, 10)
            task.New(self, function()
                task.New(self, function()
                    task.Wait(120)
                    local t = 1
                    local R = r
                    self.bound = true
                    while true do
                        r = r + R / 100 * sin(min(t, 90))
                        t = t + 1
                        task.Wait()
                    end
                end)
                local t = 1
                local interval = 15

                while true do
                    self.x = x + cos(a) * r
                    self.y = y + sin(a) * r
                    if self.timer % interval == 0 and self.timer > 15 then
                        Create.bullet_accel(self.x, self.y, ball_mid, 10, 0.5,
                                stage_lib.GetValue(3, 3.6, 4.6, 18), a + 180)
                        PlaySound("tan00")
                    end
                    a = a + o * sin(min(t, 90))

                    t = t + 1
                    task.Wait()
                end

            end)
        end,
    }, true)
    for _ = 1, stage_lib.GetValue(4, 5, 5, 18) do
        local x, y = ran:Float(-250, 250), ran:Float(100, 200)
        local d = ran:Sign()
        local rot = ran:Float(0, 360)
        local N = int(stage_lib.GetValue(4, 8, 12, 48))
        for r = 1, N do
            local R = 30 + r * min(50, 400 / N)
            for a in sp.math.AngleIterator(rot, int(stage_lib.GetValue(6, 8, 8, 36))) do
                if Dist(player, x + cos(a) * R, y + sin(a) * R) > 40 then
                    New(soul, x, y, a, d * 0.4, R)

                end
            end
            d = -d
            task.Wait(stage_lib.GetValue(12, 10, 8, 2))
        end
        task.Wait(stage_lib.GetValue(300, 250, 230, 122))
    end
end, _t("四目相接"))
lib.NewNodeEvent(class, 17, 1, 0, 0, 1, function(var)
    local enemy1 = Class(enemy, {
        init = function(self, x, y, vx, vy, ay)
            enemy.init(self, 14, HP(75), false, true, false, 7)
            self.x, self.y = x, y
            self.vx, self.vy = vx, vy
            self.ay = ay
            task.New(self, function()
                local k = ran:Int(1, 12)
                while true do
                    local v = stage_lib.GetValue(7, 13, 18, 66)
                    local A = Angle(0, 0, self.dx, self.dy)
                    if k % 12 < 4 then
                        for a in sp.math.AngleIterator(A, 7) do

                            Create.bullet_accel(self.x, self.y, grain_b, 2, 0.2, v, a,
                                    false, false, 0, 150)
                        end
                        PlaySound("tan00")
                    end

                    task.Wait()
                    k = k + 1

                end
            end)
        end,
    }, true)
    local enemy2 = Class(enemy, {
        init = function(self, x, y, vx, vy, ay)
            enemy.init(self, 9, HP(75), false, true, false, 7)
            self.x, self.y = x, y
            self.vx, self.vy = vx, vy
            self.ay = ay
            task.New(self, function()
                local k = ran:Int(1, 12)
                while true do
                    local v = stage_lib.GetValue(7, 13, 18, 66)
                    local A = Angle(0, 0, self.dx, self.dy)
                    if k % 12 > 4 then
                        for a in sp.math.AngleIterator(A, 7) do

                            Create.bullet_accel(self.x, self.y, grain_b, 6, 0.2, v, a,
                                    false, false, 0, 150)

                        end
                        PlaySound("tan00")
                    end

                    task.Wait()
                    k = k + 1

                end
            end)
        end,
    }, true)
    local t = stage_lib.GetValue(100, 90, 86, 80)
    for _ = 1, 4 do
        for d = -1, 1, 2 do
            New(enemy1, d * 380, 250, -3 * d, -4, 0.04)
            task.Wait(t)

        end
        t = t - 20
    end
    t = stage_lib.GetValue(100, 90, 86, 80)
    task.Wait(70)
    for _ = 1, 4 do
        for d = -1, 1, 2 do
            New(enemy2, d * 380, -230, -2 * d, 6.5, -0.06)
            task.Wait(t)

        end
        t = t - 20
    end
end, _t("太钿飞行阵"))
lib.NewNodeEvent(class, 18, 1, 0, 0, 1, function(var)
    local enemy1 = Class(enemy, {
        init = function(self, x, y, vx, vy, ay)
            enemy.init(self, 14, HP(75), false, true, false, 7)
            self.x, self.y = x, y
            self.vx, self.vy = vx, vy
            self.ay = ay
            task.New(self, function()
                local k = 1
                while true do
                    local v = stage_lib.GetValue(7, 8, 9, 30)
                    local A = Angle(0, 0, self.dx, self.dy)
                    for a in sp.math.AngleIterator(A, 15) do
                        if k % 12 < int(stage_lib.GetValue(1, 2, 3, 12)) then
                            Create.bullet_accel(self.x, self.y, grain_b, 8, 0.2, v, a,
                                    false, false, 0, 150)
                        else
                            local b = Create.bullet_accel(self.x, self.y, grain_b, 6, 0.2, v, a,
                                    false, false, 0, 150)
                            object.Connect(self, b, 0, true)
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                    k = k + 1

                end
            end)
        end,
    }, true)
    local t = 50
    for _ = 1, 6 do
        for d = -1, 1, 2 do
            New(enemy1, d * 380, -230, -4 * d, stage_lib.GetValue(6, 6.5, 7, 21), -0.06)
            task.Wait(t)

        end
        t = t - 7
    end
end, _t("乘风破浪"))
lib.NewNodeEvent(class, 19, 1, 0, 0, 1, function(var)
    local enemy1 = Class(enemy, {
        init = function(self, x, y, vx, vy, ax, ay)
            enemy.init(self, 9, HP(75), false, true, false, 10)
            self.x, self.y = x, y
            self.vx, self.vy = vx, vy
            self.ay = ay or 0
            self.ax = ax or 0
            task.New(self, function()
                local k = ran:Int(1, 12)
                while true do
                    local v = stage_lib.GetValue(4, 5, 6, 21)
                    local A = Angle(0, 0, self.dx, self.dy)
                    for z = -1, 1 do
                        local b = NewSimpleBullet(grain_b, 10, self.x, self.y, v, A + 90 * sign(self.dx) + z * 20)
                        b.ag = stage_lib.GetValue(0.04, 0.06, 0.08, 0.3)
                        b.stay = false
                        b.navi = true
                    end
                    PlaySound("tan00")
                    task.Wait(3)
                    k = k + 1

                end
            end)
            task.New(self, function()
                task.Wait(40)
                for a in sp.math.AngleIterator(ran:Float(0, 360), int(stage_lib.GetValue(15, 20, 26, 100))) do
                    Create.bullet_decel(self.x, self.y, ball_huge, 4, stage_lib.GetValue(6, 8, 9, 33),
                            stage_lib.GetValue(3, 5, 6, 21), a)
                    Create.bullet_decel(self.x, self.y, ball_big, 6, stage_lib.GetValue(1, 2, 3, 12),
                            stage_lib.GetValue(3, 5, 6, 21), a)
                    PlaySound("tan00")
                end
            end)
        end,
    }, true)
    local t = stage_lib.GetValue(100, 90, 86, 80)
    for _ = 1, 4 do
        for d = -1, 1, 2 do
            New(enemy1, d * 300, 260, 0, -4, -0.06 * d, 0.02)
            task.Wait(t)
        end
        t = t - 20
    end
    t = stage_lib.GetValue(100, 90, 86, 80)
    for _ = 1, 2 do
        for d = -1, 1, 2 do
            New(enemy1, d * 360, 100, -1 * d, 3, -0.03 * d, -0.06)
            task.Wait(t)
        end
        t = t - 20
    end
end, _t("起舞弄清影"))
lib.NewNodeEvent(class, 20, 1, 0, 0, 5, function()
    local enemy = Class(enemy, {
        init = function(self, x, y, vx, vy)
            enemy.init(self, 21, HP(5), false, true, true, 1)
            self.x, self.y = x, y
            self.vx, self.vy = vx, vy
        end
    }, true)
    task.New(stage.current_stage, function()
        task.Wait(60)
        local othercond = function(tool)
            return tool.quality == 4 or tool.quality == 3
        end
        local addition = stg_levelUPlib.GetAdditionList(4, othercond)
        if #addition > 0 then
            for i = 1, #addition do
                item.dropItem(item.drop_addition_sp, 1, (i - 2.5) * 150, 240, addition[i].id, function()
                    for _, o in ObjList(GROUP.ITEM) do
                        if o.__otherflag == "is_item" then
                            object.Del(o)
                        end
                    end
                    object.EnemyNontjtDo(function(e)
                        if not e.pass_check then
                            e.hp = 0
                        end
                    end)
                end, "is_item")
            end
        end
    end)

    for _ = 1, 12 do
        for x = -1.5, 1.5 do
            New(enemy, x * 150, 270, 0, -2.2)
        end
        task.Wait(20)
    end
    task.Wait(60)
end, _t("毛茸茸的上供"))


