local function _t(str)
    return Trans("tutorial", str) or ""
end


local class = {}
local HP = stage_lib.GetHP
do
    class.soul = Class(enemy, {
        init = function(self, x, y, vx1, vy1)
            enemy.init(self, 28, HP(15), false, true, false, 2)
            self.x, self.y = x, y
            Create.bullet_create_eff(self.x, self.y, ball_big, 6)
            task.New(self, function()
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
            local n = int(stage_lib.GetValue(5, 7, 9, 13))
            local vn = int(stage_lib.GetValue(1, 3, 4, 6))
            local iv = stage_lib.GetValue(2, 1.5, 0.9, 0.6)
            local vindex = stage_lib.GetValue(0.3, 0.4, 0.5, 0.6)
            for a in sp.math.AngleIterator(-90, n) do
                for v = 0, vn do
                    NewSimpleBullet(ball_big, 6, self.x, self.y, iv + v * vindex, a)
                end
            end
        end
    }, true)
end

stage.group.New('attr_select', {}, "Tutorial2", false)
local SimpleStage1 = stage.group.AddStage("Tutorial2", "Tutorial2@1", false)
function SimpleStage1:init()
    self.eventListener = eventListener()
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
    var.maxwave = 2
    var.chaos = 0
    --var.energy = 0
    --var.energy_efficiency = 0.05
    scene_class.init_set()
    lstg.tmpvar.ForceSeason = true
    task.New(self, function()
        task.Wait(60)
        PlayMusic2(scene_class._bgmlist[1])
        local tutorial = ext.tutorial
        tutorial:event(function(self)
            local n1 = self:addtext(_t("场景来到了杳无人烟的静海"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("这里会有§-不寻常的事情§d发生"), 480, 270, 1)
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
        task.Wait(60)
        lstg.tmpvar.SetSeasonEvent = function()
            local ss = ext.season_set
            ss._nextlock = true
            task.New(ss, function()
                task.Wait(50)
                tutorial:event(function(self)
                    local n1 = self:addtext(_t("下面介绍§g季节系统"), 480, 270, 1)
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n1.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n2 = self:addtext(_t("在游戏开始时，会弹出季节选择界面，在§p「春」§g「夏」§y「秋」§b「冬」§d四中季节里选择一种"), 480, 270, 1)
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

                    local n3 = self:addtext(_t("每种季节默认持续§p5波§d，选择框下边的5个点就是表示§p持续波数"), 480, 100, 1)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n3.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n4 = self:addtext(_t("选择某个季节后，接下来的每波将会出现该季节特定的§p天气"), 480, 100, 1)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n4.alpha = i
                        n4.y = 100 + 40 * i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n5 = self:addtext(_t("§p天气§d会给予场地特殊效果，按利弊分为§y祥瑞§d、§b通常§d、§r灾害§d3种"), 510, 140, 1)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n5.alpha = i
                        n5.y = 140 + 40 * i
                        task.Wait()
                    end
                    self:waitforpress()
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n3.alpha = 1 - i
                        n4.alpha = 1 - i
                        n5.alpha = 1 - i
                        task.Wait()
                    end

                    local n6 = self:addtext(_t("每当季节结束时，将弹出该界面重新选择一次季节"), 480, 200, 1)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n6.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n7 = self:addtext(_t("要注意的是，选择过的季节§r将无法再被选择"), 480, 160, 1)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n7.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    local n8 = self:addtext(_t("4种季节都选择完成后，§b开始新的一轮选择"), 480, 120, 1)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n8.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                    for i = 1, 15 do
                        i = task.SetMode[2](i / 15)
                        n6.alpha = 1 - i
                        n7.alpha = 1 - i
                        n8.alpha = 1 - i
                        task.Wait()
                    end
                    local n9 = self:addtext(_t("§y现在试试选择一个季节吧！"), 480, 270, 2)
                    for i = 1, 25 do
                        i = task.SetMode[2](i / 25)
                        n9.alpha = i
                        task.Wait()
                    end
                    self:waitforpress()
                end)
                ss._nextlock = false
                ss.locked = false
            end)
        end
        stage_lib.DoWaveEventFake(self, 1, "")
        task.Wait(60)
        tutorial:event(function(self)
            local n1 = self:addtext(_t("波数开始时，会显示§-当前天气名称§d，和简单显示§p天气的效果描述"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n1.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n2 = self:addtext(_t("可以暂停查看§p天气的详细描述§d，和§y所有遇到的天气"), 480, 270, 1)
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
            local n3 = self:addtext(_t("§g祥瑞§d天气会给予正面效果，使自机更加轻松面对处境"), 480, 270, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n3.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n4 = self:addtext(_t("§b通常§d天气会给予奇异效果，有时是利，有时是弊，需合理运用"), 480, 310, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n4.alpha = i
                task.Wait()
            end
            self:waitforpress()
            local n5 = self:addtext(_t("§r灾害§d天气会给予负面效果，会增大游戏难度，更具挑战"), 480, 230, 1)
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                n5.alpha = i
                task.Wait()
            end
            self:waitforpress()
        end)
        local d = 1
        for _ = 1, 3 do
            for k = 0, 15 do
                New(class.soul, d * (-300 + k / 15 * 600) + ran:Float(-45, 45), ran:Float(70, 181), ran:Sign(), 0)
                task.Wait(4)
            end
            d = -d
            task.Wait(150)
        end
        task.Wait(120)
        stage_lib.PassCheck()
        stage_lib.DoWaveEventFake(self, 2, "", nil, nil, true)
        local bclass = boss.Define(Trans("bossname", "Seiran"), 200, 400, _editor_class.seiran_bg, "Seiran")
        local sc = boss.card.New("", 2, 4, 40, HP(2000))
        boss.card.add(bclass, sc)
        function sc:before()
            task.MoveToForce(0, 100, 60, 2)
        end
        function sc:init()
            task.New(self, function()
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
                while true do
                    boss.cast(self, 120)
                    Newcharge_in(self.x, self.y, 218, 112, 224)
                    task.Wait(60)
                    Newcharge_out(self.x, self.y, 218, 112, 214)
                    local beat = stage_lib.GetValue(35, 20, 15, 10)
                    local N = int(stage_lib.GetValue(10, 14, 18, 20))
                    local v = stage_lib.GetValue(3, 4, 5, 6)
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
                                object.SetA(NewSimpleBullet(ball_huge, 8, self.x, self.y, v, a + t), v / 88, A)
                            end
                            u = i % 2 / 2
                            for r = -u, u do
                                task.New(self, shoot(9, 2, Angle(self, player) + r * 50, 12, 4, v * 1.3))
                            end

                            task.Wait(beat)

                        end
                    end)
                    task.Wait(beat * 5)


                end
            end)

        end
        boss.Create(bclass)
        stage_lib.PassCheck()
        task.Wait(60)
        ext.achievement:get(19)
        lstg.tmpvar.noPause = true
        stage.RefreshHiscore(false)
        New(stage.stage_clear_object, 500000)
        task.Wait(120)
        stage.group.ActionDo("直接结束游玩")


    end)
end