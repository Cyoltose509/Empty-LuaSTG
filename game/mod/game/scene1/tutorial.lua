local function _t(str)
    return Trans("tutorial", str) or ""
end


local class = {}
do
    class.enemy1 = Class(enemy, {
        init = function(self, x, y, mx, my)
            enemy.init(self, 9, 250, false, true, false, 40)
            self.x, self.y = x, y
            task.New(self, function()
                task.MoveTo(mx, my, 75, 2)
                task.New(self, function()
                    while true do
                        for a in sp.math.AngleIterator(ran:Float(0, 360), 20) do
                            Create.bullet_decel(self.x, self.y, ball_mid, 6, 2, 2, a)
                        end
                        PlaySound("tan00")
                        task.Wait(45)
                    end
                end)
            end)
        end,
    }, true)
    class.enemy2 = Class(enemy, {
        init = function(self, x, y, vx1, vy1)
            enemy.init(self, 23, 50, false, false, false, 1.5)
            self.x, self.y = x, y
            self.vx, self.vy = vx1, vy1
            task.New(self, function()
                for _ = 1, 4 do
                    Create.bullet_accel(self.x, self.y, ball_big, 2, 1, 2, Angle(self, player))
                    task.Wait(75)
                end
            end)
            task.New(self, function()
                task.Wait(200)
                for i = 1, 36 do
                    self.vx = vx1 + vx1 * (i / 36)
                    self.vy = vy1 + vy1 * (i / 36)
                    task.Wait()
                end
                task.Wait(450)
                Del(self)
            end)
        end,
    }, true)
    class.boss1 = boss.Define(Trans("bossname", "Daiyousei"), -200, 400, _editor_class.ice_bg, "Daiyousei")

    local non_sc = boss.card.New("", 1, 4, 999, 350)
    boss.card.add(class.boss1, non_sc)
    function non_sc:before()
        task.MoveTo(0, 120, 60, 2)
    end
    function non_sc:other_drop()
        item.dropItem(item.drop_card, 1, self.x, self.y + 30, 5)
    end
    function non_sc:init()
        task.New(self, function()
            Newcharge_in(self.x, self.y, 189, 252, 201)
            task.Wait(60)
            task.New(self, function()
                local d = 1
                while true do
                    task.New(self, function()
                        task.MoveTo(-120 * d, 90, 72, 2)
                    end)
                    local n = 9
                    for i = 1, 72 do
                        for a in sp.math.AngleIterator(-90 + i * 360 / n * d, 2) do
                            Create.bullet_dec_acc(self.x, self.y, arrow_big, 6, 5,
                                    (3 - i / 72 * 1.5), a, false, false)
                        end
                        PlaySound("tan00")
                        task.Wait()
                    end
                    task.New(self, function()
                        for _ = 1, 6 do
                            for a in sp.math.AngleIterator(ran:Float(0, 360), 10) do
                                NewSimpleBullet(ball_big, 2, self.x, self.y, 2.5, a)
                            end
                            PlaySound("tan00")
                            task.Wait(25)
                        end
                    end)

                    task.MoveTo(0, 120, 140, 3)
                    d = -d

                end
            end)


        end)
    end
end

stage.group.New('attr_select', {}, "Tutorial1", false)
local SimpleStage1 = stage.group.AddStage("Tutorial1", "Tutorial1@1", false)
function SimpleStage1:init()
    LoadBossTex()
    self.is_tutorial = true
    mask_fader:Do("open")
    local var = lstg.var
    local tvar = lstg.tmpvar
    local lib = stg_levelUPlib
    New(player_list[var.player_select].class)

    ---@type scene_class
    local scene_class = SceneClass[lstg.var.scene_id]
    self.scene_class = scene_class
    background.Create(scene_class._bg)
    var.wave = 0
    var.maxwave = 3
    var.chaos = 0
    var.energy = 0
    var.energy_efficiency = 0.05

    task.New(self, function()
        task.Wait(60)
        PlayMusic2(scene_class._bgmlist[1])
        local tutorial = ext.tutorial
        tutorial:event(function(self)
            local n1 = self:addtext(_t("欢迎游玩§yTouhou Roguelike"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("我们先来简单熟悉一下§b游戏机制"), 480, 270, 1)
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
            local n1 = self:addtext(_t("本作和一般STG不同，玩家是§b血量制"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local x, y = WorldToUI(player.x, player.y - 120)
            local n2 = self:addtext(_t("§r←血量的显示在这里"), 400, 440, 1)
            local n3 = self:addtext(_t("§r↑也在玩家底部"), x + 50, y, 1)
            for i = 1, 25 do
                i = task.SetMode[2](i / 25)
                n1.alpha = 1 - i
                n2.x = 400 - 180 * i
                n2.alpha = i
                task.Wait()
            end
            for i = 1, 25 do
                i = task.SetMode[2](i / 25)
                n3.y = y + 75 * i
                n3.alpha = i
                task.Wait()
            end
            self:deltext(n1)
            self:waitforpress()
            local n4 = self:addtext(_t("玩家§r受到伤害§d时，会根据攻击的对象不同而§r减少不同的血量"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.alpha = i
                n2.alpha = 1 - i
                n3.alpha = 1 - i
                task.Wait()
            end
            self:deltext(n2)
            self:deltext(n3)
            self:waitforpress()
            local n5 = self:addtext(_t("同时我们注意到，右下方有 §rChaos：0.0%"), 480, 270, 1)
            local n6 = self:addtext(_t("→ → →"), 800, 90, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n5.alpha = i
                n6.alpha = i
                n4.alpha = 1 - i
                task.Wait()
            end
            self:waitforpress()
            local n7 = self:addtext(_t("顾名思义，§r混沌值§d，也可以理解成§r熵§d。随着游戏的进行，§rChaos§d会逐渐增大"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n7.alpha = i
                n5.y = 270 + 15 * i
                n7.y = 270 - 15 * i
                task.Wait()
            end
            self:waitforpress()
            local n8 = self:addtext(_t("玩家受击时，也会使§rChaos§d主动增加"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n8.alpha = i
                n5.y = 285 + 15 * i
                n7.y = 255 + 15 * i
                n8.y = 270 - 30 * i
                task.Wait()
            end
            self:waitforpress()
            local n9 = self:addtext(_t("敌方的强度随着§rChaos§d增大而增大，游玩起来也会随之变得困难"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n9.alpha = i
                n5.alpha = 1 - i
                n6.alpha = 1 - i
                n7.alpha = 1 - i
                n8.alpha = 1 - i
                task.Wait()
            end
            self:deltext(n5)
            self:deltext(n6)
            self:deltext(n7)
            self:deltext(n8)
            self:waitforpress()
            local n10 = self:addtext(_t("值得警惕的是，§rChaos没有上限"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n10.alpha = i
                n9.y = 270 + 15 * i
                n10.y = 270 - 15 * i
                task.Wait()
            end
            self:waitforpress()
            local n11 = self:addtext(_t("§-让我们先进行一个杂鱼的消灭"), 480, 270, 1.2)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n11.alpha = i
                n9.alpha = 1 - i
                n10.alpha = 1 - i
                task.Wait()
            end
            self:deltext(n9)
            self:deltext(n10)
            self:waitforpress()
        end)
        task.Wait()
        player_lib.AddChaos(1)
        var.wave = 1
        SetWave(1, 60, "")
        local e1 = New(class.enemy1, 0, 350, 0, 120)
        while IsValid(e1) do
            task.Wait()
        end
        tvar.next_additionList = {
            lib.AdditionTotalList[3],
            lib.AdditionTotalList[33],
            lib.AdditionTotalList[59],
        }
        tvar.levelUp_event = function()
            local lm = ext.level_menu
            lm._nextlock = true
            task.New(lm, function()

                task.Wait(50)
                tutorial:event(function(self)
                    local n1 = self:addtext(_t("升级后，游戏会暂停，然后出现§y\"选择加成\"§d窗口"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n1.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n2 = self:addtext(_t("每次升级会提供随机的加成列表，有§g【裨益】【交易】【道具】§d3种"), 480, 270, 1)
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
                    lm.pos = 1
                    local n3 = self:addtext(_t("§g裨益§d会给予玩家§g小幅度数值型加成§d，如攻击力，生命值上限等"), 480, 100, 0.5)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        self.mask = 120 - i * 50
                        n3.size = 0.5 + 0.5 * i
                        n3.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    lm.pos = 2
                    local n4 = self:addtext(_t("§b交易§d会使玩家的数值进行§b交换增减§d，可简单理解为1正面+1负面"), 480, 100, 0.5)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n4.size = 0.5 + 0.5 * i
                        n4.alpha = i
                        n3.alpha = 1 - i
                        task.Wait()
                    end
                    self:deltext(n3)
                    self:waitforpress()
                    lm.pos = 3
                    local n5 = self:addtext(_t("§y道具§d会使玩家获得§y新特性、新玩法、新技能§d"), 480, 100, 0.5)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n5.size = 0.5 + 0.5 * i
                        n5.alpha = i
                        n4.alpha = 1 - i
                        task.Wait()
                    end
                    self:deltext(n4)
                    self:waitforpress()
                    local n6 = self:addtext(_t("【道具】分等级高低，有"), 480, 350, 1)
                    local n7 = self:addtext(_t("§-0级(白色)"), 310, 320, 1.2)
                    local n8 = self:addtext(_t("§g1级(绿色)"), 395, 320, 1.2)
                    local n9 = self:addtext(_t("§b2级(蓝色)"), 480, 320, 1.2)
                    local n10 = self:addtext(_t("§p3级(紫色)"), 565, 320, 1.2)
                    local n11 = self:addtext(_t("§y4级(金色)"), 650, 320, 1.2)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        self.mask = 70 + i * 100
                        n5.y = 100 + 100 * i
                        n6.alpha = i
                        n7.alpha = i
                        n8.alpha = i
                        n9.alpha = i
                        n10.alpha = i
                        n11.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n12 = self:addtext(_t("道具等级越§y高§d，出现的可能性越§r低§d"), 480, 200, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n5.alpha = 1 - i
                        n12.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n13 = self:addtext(_t("但是我们有幸运值机制，§g幸运值越高会更有概率出现高级道具"), 480, 287, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n13.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n14 = self:addtext(_t("对于§g【道具】§d，我们还可以§-鼠标左击道具图标§d/§-点击Tab键§d查看其详细介绍哦"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n6.alpha = 1 - i
                        n7.alpha = 1 - i
                        n8.alpha = 1 - i
                        n9.alpha = 1 - i
                        n10.alpha = 1 - i
                        n11.alpha = 1 - i
                        n12.alpha = 1 - i
                        n13.alpha = 1 - i
                        n14.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n15 = self:addtext(_t("接下来选择一个加成吧！"), 480, 250, 1.2)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n15.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                end)
                --task.Wait()
                lm._nextlock = false
                lm.lock = false
            end)
        end
        task.Wait(60)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("在游戏的正常流程中，我们可以§g拾取怪物掉落的经验点以获取经验值§d，然后§y升级"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("在关卡内的升级与自机角色的等级无关，我们称之为§p游玩等级§d"), 480, 270, 1)
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
            local n3 = self:addtext(_t("§p游玩等级§d的相关显示在这里→"), 600, 70, 1)
            for i = 1, 25 do
                i = task.SetMode[2](i / 25)
                n3.x = 600 + 120 * i
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = 1 - i
                task.Wait()
            end
            self:deltext(n3)
        end)
        task.Wait(120)

        while var.level <= 1 do
            local e2 = New(class.enemy1, 0, 350, 0, 120)
            while IsValid(e2) do
                task.Wait()
            end
            for _ = 1, 300 do
                if var.level >= 2 then
                    break
                end
                task.Wait()
            end
        end
        task.Wait(120)
        var.chaos = var.chaos + 10
        var.wave = 2
        SetWave(2, 60, "", nil, true)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("也许你已经注意到了，这游戏有§bwave§d设定"), 480, 270, 1, 230, 230, 230)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("除§-普通Wave§d外，还有§gLucky Wave§d和§pHard Wave§d，还有§rBoss Wave"),
                    480, 270, 1, 230, 230, 230)
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
            local n3 = self:addtext(_t("§gLucky Wave§d极小概率触发，幸运值越高越有可能出现"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("§pHard Wave§d相比普通的Wave要困难很多，§rChaos§d越高越有可能出现"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.y = 270 + 20 * i
                n4.y = 270 - 20 * i
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = 1 - i
                n4.alpha = 1 - i
                task.Wait()
            end
            self:deltext(n3)
            self:deltext(n4)
            local n5 = self:addtext(_t("§rBoss Wave§d除了extra难度，会在特定的wave出现"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n5.alpha = 1 - i
                task.Wait()
            end
            self:deltext(n5)
        end)
        for _ = 1, 4 do
            for i = -8, 8 do
                local a = 90 + i * 90 / 8
                New(class.enemy2, cos(a) * 500, sin(a) * 500, cos(a + 180) * 1, sin(a + 180) * 1)
            end
            task.Wait(100)
        end
        task.Wait(20)
        lstg.var.energy = 100
        tvar.next_additionList = {
            lib.AdditionTotalList[20],
            lib.AdditionTotalList[22],
            lib.AdditionTotalList[72],
        }
        tvar.levelUp_event = function()
            local lm = ext.level_menu
            lm._nextlock = true
            task.New(lm, function()
                task.Wait(50)
                tutorial:event(function(self)
                    local n1 = self:addtext(_t("在升级后出现§p3级§d或§y4级§d道具时，屏幕上会出现特殊的§g泛光效果§d以表祝贺哦！"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n1.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n2 = self:addtext(_t("等级越高，升级所需的经验也就越多，§-这个应该很好理解啦"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n1.y = 270 + 20 * i
                        n2.y = 270 - 20 * i
                        n2.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n3 = self:addtext(_t("道具选择的右上角的意思就是§-(已拥有个数/最高可拥有个数)"), 480, 300, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        self.mask = 100 + 50 * i
                        n1.alpha = 1 - i
                        n2.alpha = 1 - i
                        n3.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n3.alpha = 1 - i
                        task.Wait()
                    end
                    self:deltext(n1)
                    self:deltext(n2)
                    self:deltext(n3)
                end)
                task.Wait()
                lm._nextlock = false
                lm.lock = false
            end)
        end
        tutorial:event(function(self)
            local n1 = self:addtext(_t("看起来就很§p\"Hard\"§d的战斗！"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("但是我们还有§y符卡！"), 480, 270, 1)
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
            local n3 = self:addtext(_t("←本作的符卡具有能量设定，在满能量时符卡图标会§y发光"), 480, 90, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.x = 480 - 160 * i
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("符卡图标发光说明此时可以§y释放符卡§-(按X键)，释放后能量清零"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = 1 - i
                n4.alpha = 1 - i
                task.Wait()
            end
            self:deltext(n3)
            self:deltext(n4)
            local n5 = self:addtext(_t("玩家击败敌人时便会掉落§p能量点§d进行充能，并且自动收集"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n6 = self:addtext(_t("好，接下来快释放符卡消灭§p棘手的敌人§d吧！"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n5.y = 270 + 20 * i
                n6.y = 270 - 20 * i
                n6.alpha = i
                task.Wait()
            end
            self:waitforpress()
            for i = 1, 25 do
                i = task.SetMode[2](i / 25)
                n5.alpha = 1 - i
                n6.alpha = 1 - i
                n6.size = 1 + i * 2
                task.Wait()
            end
            self:deltext(n5)
            self:deltext(n6)
        end)
        task.Wait(480)
        if var.level <= 2 then
            tutorial:event(function(self)
                local n1 = self:addtext(_t("你是不是偷偷没用§y符卡§d...?"), 480, 270, 2)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n1.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n2 = self:addtext(_t("厉害是厉害，但是你没获得足够的经验升级了"), 480, 240, 1)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n2.alpha = i
                    task.Wait()
                end
                self:waitforpress()
                local n3 = self:addtext(_t("那为了教程的完整性，§y我不得不让你升级了！"), 480, 270, 1.5)
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n1.size = 1 - i
                    n2.size = 1 - i
                    n3.alpha = i
                    task.Wait()
                end
                self:deltext(n1)
                self:deltext(n2)
                self:waitforpress()
                for i = 1, 15 do
                    i = task.SetMode[2](i / 15)
                    n3.alpha = 1 - i
                    task.Wait()
                end
            end)
            task.Wait()
            AddExp(lib.GetCurMaxEXP(2) - var.now_exp + 1)
        end
        task.Wait(60)
        var.chaos = var.chaos + 5
        var.wave = 3
        SetWave(3, 60, "", nil, nil, true)
        tvar.ToolItemGet_event = function()
            local lm = ext.level_menu
            task.New(lm, function()
                lm._nextlock = true
                task.Wait(50)
                tutorial:event(function(self)
                    local n1 = self:addtext(_t("boss在击破时，一般也会掉落§g道具"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n1.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n2 = self:addtext(_t("拾起道具时也会弹出§y\"选择加成\"§d窗口"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n1.y = 270 + 20 * i
                        n2.y = 270 - 20 * i
                        n2.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    self:deltext(n1)
                    self:deltext(n2)
                    local n3 = self:addtext(_t("要注意的是这里有特殊§b【交易】§d，里面有§r【侵害】§d字样"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n3.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n4 = self:addtext(_t("§r【侵害】就是纯负面效果§d，会通过特殊途径获得，做这类选择题要§r谨慎§d哦"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n3.y = 270 + 20 * i
                        n4.y = 270 - 20 * i
                        n4.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                end)
                task.Wait()
                lm._nextlock = false
                lm.lock = false
            end)
        end
        local b = boss.Create(class.boss1)
        while IsValid(b) do
            task.Wait()
        end
        task.Wait(265)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("教程就到此结束了！"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("现在开始充满未知的旅途吧！"), 480, 270, 1.2)
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
        lstg.tmpvar.noPause = true
        ext.achievement:get(17)
        stage.RefreshHiscore(false)
        New(stage.stage_clear_object, 500000)
        task.Wait(120)
        stage.group.ActionDo("直接结束游玩")


    end)
end