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

stage.group.New('attr_select', {}, "Tutorial3", false)
local SimpleStage1 = stage.group.AddStage("Tutorial3", "Tutorial3@1", false)
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

        lstg.tmpvar.noPause = true
        stage.RefreshHiscore(false)
        New(stage.stage_clear_object, 500000)
        task.Wait(120)
        stage.group.ActionDo("直接结束游玩")


    end)
end