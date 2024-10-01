---STG基础教程

local function _t(str)
    return Trans("tutorial", str) or ""
end

local class = {}
do
    class.enemy1 = Class(enemy, {
        init = function(self, x, y, vx1, vy1, vx2, vy2)
            enemy.init(self, 3, 10, false, false, false, 0)
            self.x, self.y = x, y
            self.vx, self.vy = vx1, vy1
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
    class.enemy2 = Class(enemy, {
        init = function(self, x, y, mx, my, vx, vy)
            enemy.init(self, 9, 250, false, true, false, 0)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 60, 2)
                task.New(self, function()
                    for _ = 1, 3 do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 18) do
                            Create.bullet_decel(self.x, self.y, ball_mid, 2, 3, 1.5, a)
                        end
                        PlaySound("tan00")
                        task.Wait(120)
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
    class.enemy3 = Class(enemy, {
        init = function(self, x, y, mx, my, vx, vy)
            enemy.init(self, 15, 45, false, true, false, 10)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 60, 2)
                while true do
                    for a in sp.math.AngleIterator(Angle(self, player), 8) do
                        Create.bullet_decel(self.x, self.y, ellipse, 6, 3, 1.5, a)
                    end
                    PlaySound("tan00")
                    task.Wait(150)
                end
            end)
        end,
    }, true)
    class.boss = boss.Define(Trans("bossname", "Whitelily"), 0, 400, _editor_class.spring_bg, "Whitelily")

    local non_sc = boss.card.New("", 1, 4, 40, 600)
    boss.card.add(class.boss, non_sc)
    function non_sc:before()
    end
    function non_sc:init()
        task.New(self, function()
            local tutorial = ext.tutorial
            task.Wait(120)
            tutorial:event(function(self)
                local n1 = self:addtext(_t("接下来让我们看看boss"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n1.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n2 = self:addtext(_t("boss的攻击分两种形式，§-\"非符\"§d和§g\"符卡\""), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n1.y = 270 + 20 * i
                    n2.y = 270 - 20 * i
                    n2.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n3 = self:addtext(_t("§-\"非符\"§d就是§-\"不是符卡\"§d，一般发射普通的弹幕"), 480, 210, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n3.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n4 = self:addtext(_t("§-\"非符\"§d阶段被§g\"击破\"§d后，可能会进入§g\"符卡\"§d阶段"), 480, 170, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n4.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n5 = self:addtext(_t("boss的每个攻击阶段有§r倒计时§d，在右上角显示"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n3.alpha = 1 - i
                    n2.alpha = 1 - i
                    n1.alpha = 1 - i
                    n4.alpha = 1 - i
                    n5.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n6 = self:addtext(_t("§r倒计时§d结束后，boss会直接离开，或者直接进入§-下个阶段"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n5.y = 270 + 20 * i
                    n6.y = 270 - 20 * i
                    n6.alpha = i
                    task.Wait()
                end
                self:waitforpress()
            end)
        end)
        task.New(self, function()
            local function teleport(ix, iy, x, y)
                Newcharge_in(ix, iy, 135, 206, 235)
                task.Wait(50)
                for i = 1, 10 do
                    i = sin(i * 9)
                    self.hscale = 1 - i
                    self.vscale = 1 + i
                    task.Wait()
                end
                self.x, self.y = x, y
                task.New(self, function()
                    for i = 1, 10 do
                        i = sin(i * 9)
                        self.hscale = i
                        self.vscale = 2 - i
                        task.Wait()
                    end
                end)
            end
            teleport(0, 100, 0, 100)
            task.Wait(25)
            task.init_left_wait(self)
            while true do
                local d = 1
                for k = 1, 4 do
                    local rot = ran:Float(0, 360)
                    for n = 1, 5 do
                        for a in sp.math.AngleIterator(rot, 6 * 3) do
                            local v = 1.5 + n
                            local tv = 2
                            Create.bullet_dec_setangle(self.x, self.y, arrow_big, 2, false,
                                    { v = v, a = a, time = 60 }, { func = function(self)
                                        object.SetV(self, tv, Angle(self, player), true)
                                    end })
                        end
                        rot = rot + 6 * d
                    end
                    PlaySound("tan00")
                    task.Wait(60)

                    local x, y = task.MoveToPlayer(0, -200, 200, 100, 160,
                            50, 60, 20, 40, 2, 1)
                    if k == 4 then
                        x = 0
                        y = -30
                    end
                    teleport(self.x, self.y, x, y)
                    task.Wait(50)
                    d = -d
                end
                task.New(self, function()
                    task.MoveTo(0, 120, 150, 3)
                end)
                local t = 20
                for i = 1, t do
                    local r = ran:Float(0.2, 0.7)
                    local v = ran:Float(1, 2)
                    local k = 4
                    local c = (k - 1) / 2
                    for n = -c, c do
                        local rot = 90 + d * (10 + 250 / t * i) + n * 60 / c
                        Create.bullet_changeangle(self.x, self.y, ball_mid, 4 - d * 2,
                                v, rot, { r = d * r, time = 60 })
                    end
                    d = -d
                    PlaySound("tan00")
                    task.Wait2(self, 150 / t)
                end
                task.Wait(80)
            end


        end)
    end
    function non_sc:del()
        self.hscale, self.vscale = 1, 1
    end

    local sc = boss.card.New("春符「春天的昭示」", 3, 5, 40, 700)
    boss.card.add(class.boss, sc)
    function sc:before()
        task.MoveTo(0, 100, 60, 2)
    end
    function sc:init()
        task.New(self, function()
            local tutorial = ext.tutorial
            task.Wait(150)
            tutorial:event(function(self)
                local n1 = self:addtext(_t("§g\"符卡\"§d开启时，游戏的背景会发生变化，变化后的背景叫做§-\"符卡背景\""), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n1.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n2 = self:addtext(_t("同时右上角会出现boss释放的§g\"符卡\"§d的名称"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n1.y = 270 + 20 * i
                    n2.y = 270 - 20 * i
                    n2.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n3 = self:addtext(_t("在符卡中，弹幕一般比较有个性"), 480, 210, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n3.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n4 = self:addtext(_t("击破符卡后，如果在符卡期间，自机§r没有释放符卡§d并且自机没有§r受伤"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n3.alpha = 1 - i
                    n2.alpha = 1 - i
                    n1.alpha = 1 - i
                    n4.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n5 = self:addtext(_t("则会获得额外的符卡奖励，即§y\"收卡奖励\""), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n4.y = 270 + 20 * i
                    n5.y = 270 - 20 * i
                    n5.alpha = i
                    task.Wait()
                end
                self:waitforpress()
            end)
        end)
        task.New(self, function()
            task.Wait(60)
            Newcharge_in(self.x, self.y, 250, 128, 114)
            task.Wait(60)
            local d = 1
            local t = 1
            while true do
                local r = ran:Float(0.2, 0.7)
                local v = 1.5
                local k = 7
                local c = (k - 1) / 2
                for n = -c, c do
                    local rot = 90 + d * (10 + t * 14) + n * 80 / c
                    Create.bullet_changeangle(self.x, self.y, ball_mid, 4 - d * 2,
                            v, rot, { r = d * r, time = 60 })
                end
                d = -d
                t = t + 1
                PlaySound("tan00")
                task.Wait(10)
            end


        end)
    end
end

stage.group.New('scene_select', {}, "Tutorial0", false)
local SimpleStage1 = stage.group.AddStage("Tutorial0", "Tutorial0@1", false)
function SimpleStage1:init()
    LoadBossTex()
    self.is_tutorial = true
    mask_fader:Do("open")
    local var = lstg.var
    var.difficulty = 0
    var.scene_id = 1
    New(player_list[var.player_select].class)
    --强行1级
    local ps = var.player_select
    local ss = var.spell_select
    player_lib.SetPlayerAttribute(player, ps, 1)
    player.spell_sys = player.class.spells[ss](player, player_lib.GetSpellAttribute(ps, ss, 1))

    background.Create(BG_14)
    var.level = 61
    var.wave = 0
    var.maxwave = 3
    var.chaos = 0
    var.energy = 0
    var.energy_efficiency = 0.05

    task.New(self, function()
        task.Wait(60)
        PlayMusic2("1_1")
        local tutorial = ext.tutorial
        tutorial:event(function(self)
            local n0 = self:addtext(_t("东方STG，Shooting Game，射击游戏"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n0.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n1 = self:addtext(_t("在这个教程中，我将为您介绍"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n0.alpha = 1 - i
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("§y基本游戏操作§d和§y基本游戏术语"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.y = 270 + 20 * i
                n2.y = 270 - 20 * i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = 1 - i
                n2.alpha = 1 - i
                task.Wait()
            end
            self:deltext(n1)
            self:deltext(n2)
        end)
        task.Wait(120)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("首先，我们使用§g[↑] [↓] [←] [→]§d操控屏幕玩家的移动"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("在STG里，我们一般称§b\"玩家\"§d为§b\"自机\""), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.y = 270 + 20 * i
                n2.y = 270 - 20 * i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n3 = self:addtext(_t("其次，按住§g[LShift]§-(键盘左边的shift)"), 480, 210, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("可以让自机移速变低，简称§-\"低速\""), 480, 170, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n5 = self:addtext(_t("§-\"低速\"§d时，自机身上会出现一个小圆圈，就是§r\"判定点\""), 480, 130, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n5.alpha = 1 - i
                n4.alpha = 1 - i
                n3.alpha = 1 - i
                n2.alpha = 1 - i
                n1.alpha = 1 - i
                task.Wait()
            end
        end)
        task.Wait(180)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("按住§g[z]§d键，自机将进行射击，发射子弹"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("同时，§g[z]§d键也是东方游戏里的§-\"确认键\""), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.y = 270 + 20 * i
                n2.y = 270 - 20 * i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("现在我们正处于§b\"道中\"§d阶段，简单理解就是boss前阶段"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n2.alpha = 1 - i
                n1.alpha = 1 - i
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n5 = self:addtext(_t("在道中会出现§b小怪§d，我们可以称之为§b\"杂鱼\"§d"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.y = 270 + 20 * i
                n5.y = 270 - 20 * i
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
        end)
        task.Wait(60)
        var.wave = 1
        SetWave(1, 40, _t("这就是道中"))
        for _ = 1, 16 do
            New(class.enemy1, 356, ran:Float(140, 180), -1, -0.2, ran:Float(-1.9, -2.2), ran:Float(-0.1, -0.2))
            task.Wait(12)
        end
        task.Wait(30)
        New(class.enemy2, 0, 300, 0, 150, 0, -1)
        task.Wait(80)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("敌人也会发射子弹，我们称为§-\"弹幕\""), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("我们要做的就是操控自机§b打败敌人§d，同时§b躲避弹幕"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.y = 270 + 20 * i
                n2.y = 270 - 20 * i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n3 = self:addtext(_t("不要让弹幕击中自机的§r\"判定点\"§d位置即可§-(即使是高速状态也是有判定点的，只是不显示而已)"), 480, 210, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n3_ = self:addtext(_t("提醒一下，§-有些弹幕的判定位置并没有实际上那么大)"), 480, 170, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3_.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("同时，自机比较靠近弹幕的时候，会判定为§g\"擦弹\"§d，伴随着一种特定音效和粒子效果"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3_.alpha = 1 - i
                n3.alpha = 1 - i
                n2.alpha = 1 - i
                n1.alpha = 1 - i
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n5 = self:addtext(_t("§g擦弹§d能够§g增加分数§d等，是一种额外的奖励"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.y = 270 + 20 * i
                n5.y = 270 - 20 * i
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
        end)
        task.Wait(100)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("如果被弹幕击中了，自机会§rmiss§d，伴随着*尖锐的爆鸣声*"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("我们称之为§r\"被弹\"§d，也可以叫做§r\"撞弹\""), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.y = 270 + 20 * i
                n2.y = 270 - 20 * i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n3 = self:addtext(_t("§r\"被弹\"§d会使自机§r失去生命值"), 480, 210, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("同时，大部分敌人撞到自机也会造成伤害"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = 1 - i
                n2.alpha = 1 - i
                n1.alpha = 1 - i
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n5 = self:addtext(_t("就是§r\"体术\"§d伤害，§r\"体术\"§d也会使自机§r失去生命值"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.y = 270 + 20 * i
                n5.y = 270 - 20 * i
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n6 = self:addtext(_t("§r\"被弹\"\"体术\"§d可以统称为§r\"受击\"§-(仅限于此游戏)"), 480, 210, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n6.alpha = i
                task.Wait()
            end
            self:waitforpress()
        end)
        while true do
            local flag
            for _ in ObjList(GROUP.ENEMY) do
                flag = true
                break
            end
            if not flag then
                break
            end
            task.Wait()
        end
        task.Wait(60)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("在我方，除了§g\"自机\"§d外，还有§-\"子机\"§d"), 480, 270, 1, 230, 230, 230)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("§-\"子机\"§d可以简单理解成一个小物件，一般时刻跟随自机"), 480, 270, 1, 255, 227, 132)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.y = 270 + 20 * i
                n2.y = 270 - 20 * i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n3 = self:addtext(_t("有的子机能够§g发射子弹攻击敌人§d，有的则会帮忙§g消除弹幕"), 480, 210, 1, 230, 200, 200)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("比如，我们现在将获得一个可以§g攻击敌人的子机"), 480, 270, 1, 230, 230, 230)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = 1 - i
                n2.alpha = 1 - i
                n1.alpha = 1 - i
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
        end)
        task.Wait()
        stg_levelUPlib.SetAddition(stg_levelUPlib.AdditionTotalList[24])
        PlaySound("lgods2")
        task.Wait(60)
        var.wave = 2
        SetWave(2, 40,  _t("这就是道中"))
        for x = -2, 2 do
            New(class.enemy2, x * 100, 300, x * 100, 140 - abs(x) * 25, 0, -1)
        end
        task.Wait(120)
        lstg.var.energy = 100
        tutorial:event(function(self)
            local n1 = self:addtext(_t("感觉很§r危险§-(弹幕过多，敌人压迫)时"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("我们可以按§b[x]§d键释放§y炸弹§-(大招)，也可称为§y\"B\" \"自机符卡\""), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.y = 270 + 20 * i
                n2.y = 270 - 20 * i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n3 = self:addtext(_t("自机符卡会使自机§g无敌一段时间§d，并进行§g具有自机特色的攻击"), 480, 210, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("§-本作品中的详细符卡机制将在游戏内的具体教程做介绍"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = 1 - i
                n2.alpha = 1 - i
                n1.alpha = 1 - i
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n5 = self:addtext(_t("值得注意的是，§b[x]§d键也是东方游戏里的§-\"取消键\""), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.y = 270 + 20 * i
                n5.y = 270 - 20 * i
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n6 = self:addtext(_t("没有特殊情况的话，在菜单界面中§b[x]§d键等同于§b[Esc]§d键"), 480, 210, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n6.alpha = i
                task.Wait()
            end
            self:waitforpress()
        end)
        stage_lib.PassCheck()
        task.Wait(60)
        for x = -1, 1 do
            New(class.enemy3, x * 100, 300, x * 100, 120 + abs(x) * 25)
        end
        task.New(self, function()
            while true do
                local c = 0
                for _ in ObjList(GROUP.ENEMY) do
                    c = c + 1
                end
                if c < 3 then
                    break
                end
                task.Wait()
            end
            task.Wait(45)
            tutorial:event(function(self)
                local n1 = self:addtext(_t("我们注意到，敌人死亡后§g有掉落物生成"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n1.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n2 = self:addtext(_t("我们可以靠近掉落物以吸取掉落物，§y获得其中的奖励"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n1.y = 270 + 20 * i
                    n2.y = 270 - 20 * i
                    n2.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n3 = self:addtext(_t("但是掉落物会§r落出屏幕下方，导致再也不可获得"), 480, 210, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n3.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n4 = self:addtext(_t("我们可以将自机移动到屏幕的§y稍微上方"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n3.alpha = 1 - i
                    n2.alpha = 1 - i
                    n1.alpha = 1 - i
                    n4.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n5 = self:addtext(_t("当自机处于一定高度时，全屏的掉落物都将§y自动收集"), 480, 270, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n4.y = 270 + 20 * i
                    n5.y = 270 - 20 * i
                    n5.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n6 = self:addtext(_t("我们称这种操作为§g\"上线收集\""), 480, 210, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n6.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n7 = self:addtext(_t("实际上，自机释放符卡时，一般也能§g自动收集全屏的掉落物"), 480, 170, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n7.alpha = i
                    task.Wait()
                end
                self:waitforpress()
            end)
        end)
        stage_lib.PassCheck()
        task.Wait(120)
        var.wave = 3
        SetWave(3, 40, "", nil, nil, true)
        boss.Create(class.boss)
        stage_lib.PassCheck()
        task.Wait(60)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("除此之外，游玩过程中可能会遇到§r无法\"击破\"§d的符卡"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("§p必须要等待其倒计时结束才能结束战斗"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.y = 270 + 20 * i
                n2.y = 270 - 20 * i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n3 = self:addtext(_t("这样的符卡我们称之为§-\"时符\""), 480, 210, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("§-\"时符\"§d结束后，自动判定§g\"击破\"§d，检测是否收卡"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = 1 - i
                n2.alpha = 1 - i
                n1.alpha = 1 - i
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n5 = self:addtext(_t("但如果是正常符卡，倒计时结束后将判定为§r收卡失败"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.y = 270 + 20 * i
                n5.y = 270 - 20 * i
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n6 = self:addtext(_t("§r不会获得收卡奖励"), 480, 210, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n6.alpha = i
                task.Wait()
            end
            self:waitforpress()
        end)
        task.Wait(60)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("东方STG的基础教程大概就这样了"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("在接下来的游玩中，你将会§r不可避免地遇到更多陌生的术语"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = 1 - i
                n2.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n3 = self:addtext(_t("一方面可以询问身边了解东方的人"), 480, 230, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("另一方面可以主动接触官作，体会原初的滋味"), 480, 190, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n5 = self:addtext(_t("§y祝您游玩愉快！"), 480, 270, 2)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.alpha = 1 - i
                n3.alpha = 1 - i
                n2.alpha = 1 - i
                n1.alpha = 1 - i
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
        end)
        task.Wait(60)
        lstg.tmpvar.noPause = true
        --stage.RefreshHiscore(false)
        New(stage.stage_clear_object, 500000)
        task.Wait(120)
        stage.group.ActionDo("直接结束游玩")


    end)
end