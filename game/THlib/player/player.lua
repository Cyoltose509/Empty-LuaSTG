local lib = {}
player_lib = lib

----------------------------------------
---加载资源
LoadPS("player_death_ef", "THlib\\player\\player_death_ef.psi", "parimg1")
LoadImageFromFile("player_aura", "THlib\\player\\player_aura.png", true)
LoadImageFromFile("Grazer2", "THlib\\player\\Grazer.png", true)
LoadImageFromFile("player_bullet", 'THlib\\player\\player_bullet.png', true, 48, 48)
LoadImageFromFile("mimichan_bullet", 'THlib\\player\\mimichan.png', true, 48, 48)
DoFile("THlib\\player\\player_system.lua")

function InitPlayer()
    player_list = {}
    for _, dir in ipairs(lstg.FileManager.EnumFiles("THlib/player/", nil, true)) do
        if dir[2] then
            for _, file in ipairs(FindFiles(dir[1], "lua", "")) do
                DoFile(file[1])
            end
        end
    end
end

----------------------------------------
---player class
---@class player
player_class = Class(object)
lib.player_class = player_class

function player_class:init()
    lib.PlayerInit()
    New(BulletBreak_Table)
    New(ui.ChaosRenderObj)
    self.group = GROUP.PLAYER
    self.layer = LAYER.PLAYER
    self.bound = false
    self.x = 0
    self.y = -176
    self._blend = ""
    self._a, self._r, self._g, self._b = 255, 255, 255, 255
    self._wisys = PlayerWalkImageSystem(self) --by OLC，自机行走图系统
    self._playersys = player_lib.system(self) --by OLC，自机逻辑系统
    --self.class = player_class--
    lstg.player = self
    player = self
    local var = lstg.var
    if not var.init_player_data then
        error("Player data has not been initialized. (Call function item.PlayerInit.)")
    end
    if var.timeslow ~= 1 then
        var.timeslow = 1
    end
    local ps = var.player_select
    local ss = var.spell_select
    player_lib.SetPlayerAttribute(self, ps, var.player_level or 1)
    self.spell_sys = self.class.spells[ss](self, lib.GetSpellAttribute(ps, ss, var.spell_level or 1))
    self.skill_level = playerdata[self.name].unlock_c or 0
    if stage.current_stage.is_tutorial then
        self.skill_level = 0
        player_lib.SetPlayerAttribute(self, ps, 1)
        self.spell_sys = self.class.spells[ss](self, lib.GetSpellAttribute(ps, ss, 1))
    else

    end

    self.particle = {}
    self.energy_particle = {}
    ---作为储存射击子弹的表
    self.shoot_table = {}
    self.StopLoss = false--在一些特殊情况时停止流失生命
    self.shoot_rot = 90
    task.New(self, function()
        local w = {}
        task.init_left_wait(w)
        local j = 0
        local gold = (sqrt(5) - 1) / 2
        while true do
            --一对的自我也要改记得
            local sspeed = player_lib.GetShootAttribute()
            local interval = 60 / sspeed
            table.insert(self.shoot_table, {
                offset = w.task_left_wait,
                offa = (self.shoot_angle_off * gold * j) % max(0.01, self.shoot_angle_off),
                d = j % 2 * 2 - 1
            })
            j = j + 1
            task.Wait2(w, interval)
        end
    end)
end

local checkContinuingSpell_time = 0
local checkContinuingSpell_count = 0
function player_class:spell()
    local v = lstg.var
    local tvar = lstg.tmpvar
    local healing = true
    if not tvar.bird_resurrecting and not tvar.rewind_resurrecting then
        if v.ON_sakura then
            lstg.var.sakura = 0
            lstg.var.sakura_bonus = false
            player.nextspell = 40
            return
        end
        if v.kokoro_musubu and v.energy < v.maxenergy then
            local need = (v.maxenergy - v.energy) / 8 + v.maxlife / 8
            if v.lifeleft > need then
                v.energy = v.maxenergy
                player_lib.ReduceLife(need, nil, true, nil, "no_dmg")
                healing = false
                PlaySound("extend2")
            end
        end
        if v.energy >= v.maxenergy then
            if v.bomb_healing then
                lib.AddLife(healing and v.bomb_healing or 5)
            end
            do
                if checkContinuingSpell_time > 0 then
                    checkContinuingSpell_count = checkContinuingSpell_count + 1
                    if checkContinuingSpell_count >= 2 then
                        ext.achievement:get(15)
                    end
                else
                    checkContinuingSpell_count = 1
                end
            end--杂鱼的末日

            local time
            if tvar.bomb_to_protect then
                PlaySound("goast1")
                time = self.spell_sys.protect_time * 60 * (1.6 + 0.4 * tvar.bomb_to_protect.count)
                self.protect = self.protect + time
                self.nextspell = self.nextspell + time
                self.nextshoot = self.nextshoot + time
                self.hspeed_factor = self.hspeed_factor + 0.5
                self.lspeed_factor = self.lspeed_factor + 0.5
                task.New(self, function()
                    task.Wait(time)
                    StopSound("goast1")
                    PlaySound("goast2")
                    player.hspeed_factor = player.hspeed_factor - 0.5
                    player.lspeed_factor = player.lspeed_factor - 0.5
                end)
            else
                time = self.spell_sys:spell()
            end
            scoredata._total_bomb = scoredata._total_bomb + 1
            lstg.tmpvar.spell_count = lstg.tmpvar.spell_count + 1
            mission_lib.GoMission(11, 1 / 5 * 100 + 0.01)--魔力护瓶
            mission_lib.GoMission(1, 1 / 15 * 100 + 0.01)--硝酸甘油
            mission_lib.GoMission(18, 1 / 30 * 100 + 0.01)--灵力槽
            if lstg.tmpvar.spell_count >= 5 then
                mission_lib.GoMission(36)
            end

            if tvar.MarisaSkill3 then
                local slib = stg_levelUPlib
                local k = slib.ListByState[1][ran:Int(1, #slib.ListByState[1])]
                slib.SetAddition(k, true)
                ext.notice_menu:AdditionAdd(k.id, "bonus", Trans("marisa_des", "Talent3name"), 25)
            end
            checkContinuingSpell_time = time + 30
            v.energy = v.energy - v.maxenergy
        end
    end
end

function player_class:special()
    local v = lstg.var
    local ActiveID = v.active_item[1]
    if ActiveID then
        local Active = activeItem_lib.ActiveTotalList[ActiveID]
        if Active.energy >= 1 then
            Active.event()
            Active.energy = Active.energy - 1
        end
    end
end
function player_class:shoot(dmgindex, ox, oy, shoot_table)
    dmgindex = dmgindex or 1
    ox = ox or 0
    oy = oy or 0
    local _, bv, lifetime = player_lib.GetShootAttribute()
    local dmg = lib.GetPlayerDmg() * dmgindex
    local var = lstg.var
    local rot = 90
    if var.rotate_shoot_rot then
        rot = self.shoot_rot
        if IsValid(self.target) and self.target.colli and self.target.class.base.take_damage then
            local a = (Angle(self, self.target) - self.shoot_rot) % 360
            if a > 180 then
                a = a - 360
            end
            local da = bv / 30
            if da >= abs(a) then
                self.shoot_rot = Angle(self, self.target)
            else
                self.shoot_rot = self.shoot_rot + sign(a) * da
            end
        end
    end
    local A = var.reverse_shoot and (rot + 180) or rot
    local class = player_main_bullet
    if var.imaginary_main_bullet then
        class = player_main_bullet_imaginary
        dmg = dmg * 1.5
    end
    local self_paradox_pro = 0
    if var.self_paradox then
        self_paradox_pro = 0.07
        for i, p in pairs(var.addition) do
            if stg_levelUPlib.AdditionTotalList[i].isTool then
                for _ = 1, p do
                    self_paradox_pro = self_paradox_pro + 0.0032
                end
            end
        end
    end

    for _, p in ipairs(shoot_table or self.shoot_table) do
        PlaySound('plst00', 0.15, self.x)
        local k = -p.offset * bv
        local d = p.d
        local kx = 10
        local offa = p.offa
        if offa ~= 0 then
            kx = 0
        end--如果存在散射角，就不正负交替
        if var.rotate_star then
            offa = offa + 90
        end
        local ang = A + offa * d
        local x = self.x + ox + cos(ang) * k
        local y = self.y + oy + sin(ang) * k

        New(class, x - kx * d, y, bv, ang, dmg, lifetime)
        if var.behind_main_bullet and ran:Float(0, 1) < min(1, 9 / (101 - player_lib.GetLuck())) then
            New(class, x - kx * d, y, bv, ang + 180, dmg, lifetime)
        end
        if ran:Float(0, 1) < self_paradox_pro then
            New(class, x, y, bv, ran:Float(0, 360), dmg, lifetime)
        end
    end
end
function player_class:frame()
    local tvar = lstg.tmpvar
    self.dmg_offset = max(self.dmg_offset, -self.dmg)
    self.A = player_lib.GetPlayerCollisize()
    self.B = self.A
    if tvar.lost then
        return
    end
    if self.realrealreal_lock then
        return
    end

    local w = lstg.weather
    if w.now_weather and w.now_weather ~= 0 then
        local weather_frame = weather_lib.weather[w.now_weather].frame
        weather_frame()
    end
    stage_lib.RefreshHPindex()
    activeItem_lib.AddActiveChargeByFrame()

    task.Do(self)
    checkContinuingSpell_time = max(0, checkContinuingSpell_time - 1)
    self._playersys:doFrameBeforeEvent()
    self._playersys:frame()
    self.spell_sys:frame()
    self._playersys:doFrameAfterEvent()
    do
        local p
        for i = #self.particle, 1, -1 do
            p = self.particle[i]
            p.x = p.x + p.vx
            p.y = p.y + p.vy
            p.vx = p.vx - p.vx * 0.04
            p.vy = p.vy - p.vy * 0.04
            --if p.timer > 10 then
            p.alpha = max(p.alpha - 4, 0)
            if p.alpha == 0 then
                table.remove(self.particle, i)
            end
            --end
            p.timer = p.timer + 1
        end
        for i = #self.shoot_table, 1, -1 do
            table.remove(self.shoot_table, i)
        end
        local s
        local _w = lstg.world
        for i = #self.energy_particle, 1, -1 do
            s = self.energy_particle[i]
            task.Do(s)
            s.timer = s.timer + 1
            s.rot = s.rot + s.omiga
            if s.cao or not sp.math.PointBoundCheck(s.x, s.y, _w.boundl, _w.boundr, _w.boundb, _w.boundt) then
                table.remove(self.energy_particle, i)
            end
        end
    end--粒子等帧行为
    tvar.playerSpeed_index = nil
    SetImageScale(lib.GetPlayerBulletImg(), tvar.player_bullet_scale / 4)
end
function player_class:render()
    if self.realrealreal_lock then
        return
    end
    self._playersys:doRenderBeforeEvent()
    self._playersys:render()
    self.spell_sys:render()
    self._playersys:doRenderAfterEvent()

    if self.protect > 0 then
        local tA = min(self.protect, 20) / 20
        ui:RenderText("title", ("%0.2f"):format(self.protect / 60), self.x, self.y + 20,
                0.5, Color(tA * 150, 255, 255, 255), "centerpoint")
    end
    local v = lstg.var
    local life = (lstg.ui.lifeleft or v.lifeleft) / v.maxlife
    local weak_life = v.weak_life / v.maxlife

    SetImageState("white", "", 85, 0, 0, 0)
    RenderRect("white", self.x - 20, self.x + 20, self.y - 20, self.y - 25)
    SetImageState("white", "", 85, sp:HSVtoRGB(90 * life, 0.8, 1))
    RenderRect("white", self.x - 19, self.x - 19 + 38 * life, self.y - 21, self.y - 24)
    if weak_life > 0 then
        SetImageState("white", "", 85, sp:HSVtoRGB(90 * life, 0.8, 0.3))
        RenderRect("white", self.x - 19 + 38 * life, self.x - 19 + 38 * min(1, weak_life + life), self.y - 21, self.y - 24)
    end
    for _, p in ipairs(self.particle) do
        SetImageState("bright", "mul+add", p.alpha, self.colorR, self.colorG, self.colorB)
        Render("bright", p.x, p.y, 0, p.size / 150)
    end
    for _, s in ipairs(self.energy_particle) do
        SetImageState("white", "mul+add", s.alpha / 2, unpack(s.color))
        Render("white", s.x, s.y, s.rot, s.scale * 3 / 8 + sin(s.timer * 8) / 8)
        SetImageState("white", "mul+add", s.alpha, unpack(s.color))
        Render("white", s.x, s.y, s.rot, s.scale * 2 / 8 + sin(s.timer * 8) / 8)
    end

end
function player_class:colli(other)
    self._playersys:doColliBeforeEvent(other)
    self._playersys:colli(other)
    self._playersys:doColliAfterEvent(other)
end
function player_class:findtarget()
    self.target = nil
    self.target2 = nil--新增目标计算
    local maxpri = -1
    local mindist = 999
    local dx, dy, pri, dist
    object.EnemyNontjtDo(function(o)
        if o.colli and o.class.base.take_damage then
            dist = Dist(self, o)
            if o.last_priority then
                dist = 999
            end
            if dist < mindist then
                mindist = dist
                self.target2 = o
            end
            dx = self.x - o.x
            dy = self.y - o.y
            pri = abs(dy) / (abs(dx) + 0.01)
            if pri > maxpri then
                maxpri = pri
                self.target = o
            end
        end
    end)
end

local SetImageState = SetImageState
local Render = Render

---@class grazer
grazer = Class(object)
function grazer:init(player)
    self.layer = LAYER.ENEMY_BULLET_EF + 50
    self.group = GROUP.PLAYER
    self.player = player or lstg.player
    --self.player=lstg.player
    self.aura = 0
    self.aura_d = 0
    self.log_state = self.player.slow
    self._slowTimer = 0
    self._pause = 0
    self.gp = {}
    self.bound = false
    self.grazed = 0
    self.alpha2 = 0
end
function grazer:frame()
    if lstg.tmpvar.lost then
        return
    end
    local p = self.player
    self.x = p.x
    self.y = p.y
    self.hide = p.hide
    self.a = (p.grazer_colli * p.grazer_colli_factor + p.grazer_colli_offset) * p.grazer_colli_fixed
    self.b = self.a
    if not p.time_stop then
        if self.log_state ~= p.slow then
            self.log_state = p.slow
            self._pause = 30
        end
        if p.slow == 1 then
            if self._slowTimer < 30 then
                self._slowTimer = self._slowTimer + 1
            end
        else
            self._slowTimer = 0
        end
        if self._pause == 0 then
            self.aura = self.aura + 1.5
        end
        if self._pause > 0 then
            self._pause = self._pause - 1
        end
        local S = cos(90 * self._slowTimer / 30)
        S = S * S
        self.aura_d = 180 * S
    end
    local g
    for i = #self.gp, 1, -1 do
        g = self.gp[i]
        g.x = g.x + cos(g.a) * g.v
        g.y = g.y + sin(g.a) * g.v
        if g.timer >= 10 then
            g.alpha = max(0, g.alpha - 16)
        end
        g.v = max(0.1, g.v - 0.03)
        g.rot = g.rot + g.omiga
        g.timer = g.timer + 1
        if g.alpha == 0 then
            table.remove(self.gp, i)
        end
    end
    if self.grazed_add then
        if self.grazed < 30 then
            self.grazed = self.grazed + 1
        end
        self.grazed_add = nil
    else
        if self.grazed > 0 then
            self.grazed = self.grazed - 1
        end
    end
    if self.a / 24 > 1.5 then
        self.alpha2 = self.alpha2 + (-self.alpha2 + 1) * 0.1
    else
        self.alpha2 = self.alpha2 + (-self.alpha2) * 0.1
    end
end
function grazer:render()
    local p = self.player
    for _, g in ipairs(self.gp) do
        SetImageState("white", "mul+add", g.alpha, 255, 227, 132)
        Render("white", g.x, g.y, g.rot, 0.25)
        SetImageState("white", "mul+add", g.alpha / 2, 255, 227, 132)
        Render("white", g.x, g.y, g.rot, 0.25)
    end
    local size = p.A
    if size < 0.5 then
        size = 0.8
    elseif size < 1 then
        size = size * 0.4 + 0.5
    else
        size = 0.9 + (size - 1) * 0.2
    end
    SetImageState("player_aura", "", 192, 255, 255, 255)
    Render("player_aura", self.x, self.y, -self.aura + self.aura_d, self.player.lh * size / 4)
    SetImageState("player_aura", "", Color(0xC0FFFFFF) * self.player.lh + Color(0x00FFFFFF) * (1 - self.player.lh))
    Render("player_aura", self.x, self.y, self.aura, (2 - self.player.lh) * size / 4)
    local size2 = self.a / 24
    if size2 > 1.5 then
        SetImageState('Grazer2', 'mul+rev', 3.2 * self.grazed * self.alpha2, 255, 255, 255)
        Render('Grazer2', self.x, self.y, -self.ani, 0.25 * (size2 + 2 - 2 * task.SetMode[2](min(12, self.grazed) / 12)))
    end
end
function grazer:colli(other, new)
    local w = lstg.weather
    local tvar = lstg.tmpvar
    if tvar.lost then
        return
    end
    if lstg.weather.BiShi then
        return
    end
    if lstg.var.stop_getting then
        return
    end
    if other.group ~= GROUP.ENEMY then
        local p = self.player
        if (not (other._graze) or other._inf_graze) or (other.IsLaser and new) then
            p._playersys:doGrazingBeforeEvent(other)
            local var = lstg.var
            if var.graze_exp > 0 then
                DropExpPoint(var.graze_exp - var.graze_exp_count, other.x, other.y)
                var.graze_exp_count = min(var.graze_exp - 0.0001, var.graze_exp_count + var.graze_exp * 0.00000001)
            end
            var.graze = var.graze + 1
            var.score = var.score + 100
            PlaySound("graze", 0.5, self.x / 120)
            if #self.gp <= 90 then
                table.insert(self.gp, { x = self.x, y = self.y,
                                        a = ran:Float(0, 360), v = ran:Float(4, 5),
                                        alpha = 180, timer = 1, rot = ran:Float(0, 360), omiga = ran:Sign() * 5 })
            end
            if not (other._inf_graze) or (other.IsLaser and new) then
                other._graze = true
            end
            p._playersys:doGrazingAfterEvent(other)
            if var.graze >= 1000 then
                mission_lib.GoMission(13)
            end
            if var.graze >= 2000 then
                mission_lib.GoMission(35)
            end
        end
        self.grazed_add = true
    end
end

function lib.PlayerMiss(p, num, dmg_type)
    local sound = "pldead00"
    local v = lstg.var
    if v.lost then
        return
    end
    local w = lstg.weather
    local mb = lstg.tmpvar.magic_bottle
    local mbtrue
    ---根据子弹判定大小扣血
    local diffindex = { 1, 1, 1.5, 1.5, 1.5, 1.5 }
    local c = num * diffindex[v.difficulty + 1] * stage_lib.GetValue(1, 1.25, 1.5, 10)
    if w.ZuanShiChen then
        c = w.ZuanShiChen_GetLife
    end

    if v.ON_sakura and not mbtrue then
        v.sakura = 0
        v.sakura_bonus = false
        c = 0
    else
        if IsValid(mb) then
            local k = v.maxenergy / 100 * v.energy_stack
            if v.energy >= 70 * k then
                v.energy = v.energy - mb.dev_value * k
                mb.dev_value = min(mb.dev_value + 10, 100 - mb.count * 30)
                c = 0
                sound = "gun00"
                mbtrue = true
            else
                local t = v.energy_stack
                c = c * (1 + t * (0.2 - 0.05 * mb.count))
                if v.forever33 then
                    c = max(0.01, v.maxlife * 0.33) * sign(c)---兼容风絮云
                end
            end
        else
            if v.forever33 then
                c = max(0.01, v.maxlife * 0.33) * sign(c)---兼容风絮云
            end
        end
        if c ~= 0 then
            if w.JieHan and ran:Float(0, 1) < 0.5 then
                c = 0
                sound = nil
                PlaySound("yumedead")
                NewWave(p.x, p.y, 3, 120, 60, 100, 100, 240)
                weather_lib.JieHan_eff(p)
            end
        end--结寒天气
        if c ~= 0 then
            if v.kappa_shield_count >= 1 then
                v.kappa_shield_count = v.kappa_shield_count - 1
                local unit = lstg.tmpvar.kappa_shield
                unit.index = 1
                c = 0
                sound = nil
                PlaySound("kappa_shield_off")

            end
        end
        if c ~= 0 then
            if v.ikinokosu_yume > 0 and ran:Float(0, 1) < v.ikinokosu_yume * 0.23 then
                c = 0
                sound = nil
                PlaySound("yumedead")
                NewWave(p.x, p.y, 3, 120, 60, 240, 240, 240)
                stg_levelUPlib.ikinokosu_yume_eff(p)
            end
        end--生之残梦

        local pro_time = 60 + v.protect_time_ex

        if v.reflex_arc and c > 0 then
            p.protect = max(p.protect, int(pro_time / 2))
            PlaySound("pldead00_fake")
            New(stg_levelUPlib.class2.reflex_arc_eff)
            New(tasker, function()
                for _ = 1, 99 do
                    if v.lost then
                        break
                    end
                    task.Wait()
                end
                if not v.lost then
                    lib.ReduceLife(c, nil, nil, nil, dmg_type)
                    p.death = 2
                    p.protect = max(p.protect, pro_time)
                    PlaySound("pldead00", 0.38)
                    New(player_death_ef, p.x, p.y)
                    if v.life_boom > 0 then
                        stg_levelUPlib.class.lifeboom_func(p.x, p.y, v.life_boom * 75, v.life_boom * 0.1 * lib.GetPlayerDmg(),
                                45, 255, 227, 132)
                    end
                end
            end)
        else
            p.protect = max(p.protect, pro_time)
            if c > 0 then
                p.death = 2
                lib.ReduceLife(c, nil, nil, nil, dmg_type)
            else
                lib.AddLife(-c)
            end
            if sound then
                PlaySound(sound, 0.38)
            end
            New(player_death_ef, p.x, p.y)
            if v.life_boom > 0 then
                stg_levelUPlib.class.lifeboom_func(p.x, p.y, (v.life_boom / 5) * 200, v.life_boom / 5 * 2,
                        45, 255, 227, 132)
            end
        end
    end
    if c > 0 then
        do
            local addv = { 1, 3, 4, 4, v.challenge_addchaos or 4, 3 }
            local addchao = addv[v.difficulty + 1]
            if v.difficulty == 0 then
                addchao = 1
            end
            if v.chaos >= 50 then
                addchao = addchao * 0.8
            end
            if v.chaos >= 100 then
                addchao = addchao * 0.9
            end
            if stage.current_stage.scene_class then
                if v.wave > stage.current_stage.scene_class._maxwave then
                    addchao = addchao * 1.5
                end
            end
            if v.peace_chaos then
                addchao = addchao * 0.66
            end
            player_lib.AddChaos(addchao)
        end--增加chaos
        if v.scarlet_count >= 9 then
            ext.achievement:get(73)
        end
        v.scarlet_count = 1--绯红的专注
        if v.temporal_barrier then
            object.BulletIndesDo(function(b)
                New(stg_levelUPlib.class2.fake_and_real_eff, b)
                bullet.setfakeColli(b, b._no_colli)
            end)
        end--彼时结界
        if v.glass_bon then
            lib.AddMaxLife(-2.5)
        end--玻璃大炮
        if v.protect_kogasa and v.protect_kogasa_CD == 0 then
            local Y = 60
            if v.reverse_shoot then
                Y = -Y
            end
            PlaySound("boon00")
            New(stg_levelUPlib.class4.protect_kogasa, player.x, player.y + Y)
            v.protect_kogasa_CD = 105
        end--小小星之伞
        v.miss = v.miss + 1--检测无伤用
    end
end

function lib.AddEnergy(n)

    local var = lstg.var
    if var.lost then
        return
    end
    local efficiency = lib.GetEnergyEfficiency()
    n = max(n, 0)
    n = n * max(efficiency, 0)
    local maxenergy = var.maxenergy * var.energy_stack
    if var.energy < maxenergy then
        local lastcount = int(var.energy / var.maxenergy)
        var.energy = min(maxenergy, var.energy + n)
        local nowcount = int(var.energy / var.maxenergy)
        if nowcount > lastcount then
            PlaySound("opshow")
        end
    end
end

function lib.NewEnergySp(x, y, value)
    local p = player
    local par = p.energy_particle
    table.insert(par, { x = x, y = y, rot = ran:Float(0, 360), omiga = ran:Sign(), color = { 200, 200, 200 }, alpha = 45, scale = 0, timer = 0 })
    task.New(par[#par], function()
        local self = task.GetSelf()
        local v, a = ran:Float(1, 5), ran:Float(0, 360)
        for i = 29, 0, -1 do
            self.scale = sin(90 - i * 3) * 1.6
            self.x = self.x + cos(a) * v * sin(i * 3)
            self.y = self.y + sin(a) * v * sin(i * 3)
            coroutine.yield()
        end
        task.Wait(ran:Int(1, 30))
        local t = int(Dist(self.x, self.y, p) / 300 * 60)
        task.MoveToTarget(p, t, 1)
        PlaySound("item00")
        lib.AddEnergy(value)
        self.color[1], self.color[2], self.color[3] = p.colorR, p.colorG, p.colorB
        self.alpha = 20
        v, a = ran:Float(2, 5), ran:Float(0, 360)
        local px, py = p.x, p.y
        for i = 59, 0, -1 do
            self.scale = 1.6 - sin(90 - i * 1.5) * 0.6
            self.x = self.x + cos(a) * v * sin(i * 1.5)
            self.y = self.y + sin(a) * v * sin(i * 1.5)
            coroutine.yield()
        end
        task.New(self, function()
            for i = 59, 0, -1 do
                self.scale = sin(i * 1.5)
                coroutine.yield()
            end
        end)
        task.MoveToForce(px, py, 60, 1)
        self.cao = true
    end)
end

function lib.SetEnergy(maxe, stacks)
    local var = lstg.var
    if var.lost then
        return
    end
    stacks = stacks or var.energy_stack
    maxe = maxe or var.maxenergy
    var.maxenergy = maxe
    var.energy_stack = stacks
    var.energy = min(var.energy, var.maxenergy * var.energy_stack)
end
---@param LossType boolean@是否是流失类型的减少生命
---减少生命
function lib.ReduceLife(n, LossType, noGanYao, minv, dmg_type)
    local w = lstg.weather
    local v = lstg.var
    local flag = true
    if v.lost then
        return 0
    end

    if LossType then
        flag = not player.StopLoss
    end
    if w.GanYao and not LossType and not noGanYao then
        weather_lib.GanYaoRewind()
        return 0
    else
        if flag then
            local no_dmg = dmg_type == "no_dmg"
            if v.dmg_reduction and not no_dmg then
                n = n - 1
                n = n / 2
            end
            n = max(0, n)
            if not LossType and not no_dmg then
                if v.cowrie_shell then
                    n = n * 1.5
                    v.weak_life = n
                    v.maxweak_life = n
                end--燕的子安贝

            end
            if v.life_dead and v.lifeleft - n <= 0 then
                n = 0
                New(stg_levelUPlib.class2.life_dead_eff)
                PlaySound("hyz_timestop0")
                lib.AddLife(v.maxlife / 2)
                lib.AddMaxLife(-v.maxlife / 2)
                v.life_dead = false
            end--生与死的境界
            if v.lifeleft - n <= 0 and not no_dmg then
                if LossType == "ScaringMask" then
                    ext.achievement:get(120)
                elseif LossType == "QiuLaoHu" then
                    ext.achievement:get(50)
                end
                if dmg_type == "IsEnemy" then
                    ext.achievement:get(42)
                elseif dmg_type == "Lightning" then
                    ext.achievement:get(62)
                end
            end
            if n > 0 then
                minv = minv or -0.1
                if w.QingLang then
                    minv = 0.01--不会死亡
                end
                v.lifeleft = Forbid(v.lifeleft - n, minv)
                if v.lifelife_exchange and lstg.tmpvar.lifelife_exchangeCD == 0 then
                    object.EnemyNontjtDo(function(e)
                        if e.class.base.take_damage then
                            e.class.base.take_damage(e, lib.GetPlayerDmg() * 0.35)
                        end
                    end)
                    lstg.tmpvar.lifelife_exchangeCD = 60
                end
                if v.hp_to_exp then
                    v.hp_to_exp_lost_hp = v.hp_to_exp_lost_hp + n
                    local count = 0
                    local maxf = max(v.maxlife, 0.1) * 0.0285
                    while v.hp_to_exp_lost_hp >= maxf do
                        v.hp_to_exp_lost_hp = v.hp_to_exp_lost_hp - maxf
                        count = count + 1
                    end
                    item.dropItem(item.drop_exp, count, player.x, player.y + 45)
                end
                if v._season_system then
                    if w.XinYang and not no_dmg then
                        lib.AddMaxLife(n * 0.25)
                    end
                end
            end
            return n
        end
    end
end
---增加生命
function lib.AddLife(n, no_addmax)
    if not lstg.tmpvar.bird_resurrecting and not lstg.tmpvar.rewind_resurrecting then
        n = max(0, n)
        local v = lstg.var
        local w = lstg.weather
        if v.lost then
            return 0
        end

        if v.green_wish ~= 0 and not no_addmax then
            if v.lifeleft + n > v.maxlife then
                lib.AddMaxLife((0.2 + v.green_wish * 0.1) * (v.lifeleft + n - v.maxlife))
            end
        end
        if v._season_system then
            if w.LiDong then
                lib.AddMaxLife(n * 0.12)
                n = 0
            end
            if w.XinYang then
                n = 0--不回血
            end
            if w.YunTian then
                lib.AddEnergy(n / v.maxlife * v.maxenergy)
            end
        end
        v.lifeleft = min(v.maxlife, v.lifeleft + n)
        return n--返回真正获得的生命值
    end
end

---增加(减少)生命上限
function lib.AddMaxLife(n)
    n = n or 0
    local v = lstg.var
    if v.lost then
        return
    end
    local w = lstg.weather
    if v._season_system then
        if w.TianQiYu then
            n = 0--不增加上限
        end
    end
    v.maxlife = max(0.01, v.maxlife + n)
    if v.glass_bon then
        v.maxlife = min(20, v.maxlife)
    end
    if v.maxlife > 100 then
        ext.achievement:get(72)
    elseif v.maxlife == 0.01 then
        ext.achievement:get(74)
    end
    v.lifeleft = min(v.maxlife, v.lifeleft)
end

---增加(减少)混沌值
function lib.AddChaos(n)
    local var = lstg.var
    if var.lost then
        return
    end
    n = n * var.chaos_factor
    var._off_chaos = var._off_chaos + n
    var.chaos = max(var.chaos + n, 0)
    if var.chaos >= 200 then
        mission_lib.GoMission(12)
    end
    if var.chaos >= 150 then
        mission_lib.GoMission(17)
    end
end

---增加(减少)幸运值
function lib.AddLuck(l)
    local var = lstg.var
    if var.lost then
        return
    end
    l = l or 0
    var.luck = Forbid(var.luck + l, 0, var.maxluck)
end

function lib.GetLuck()
    local var = lstg.var
    return var.luck * var.luck_factor
end

function lib.SetPlayerCollisize(offset, factor, fixed)
    mission_lib.GoMission(3)
    local p = player
    if offset then
        p.collisize_offset = p.collisize_offset + offset
    end
    if factor then
        p.collisize_factor = p.collisize_factor + factor
    end
    if fixed then
        p.collisize_fixed = p.collisize_fixed + fixed
    end

end

function lib.GetPlayerDmg(p)
    p = p or player
    if not p then
        return
    end
    local v = lstg.var
    local tvar = lstg.tmpvar
    local crazy_torch_index = 0.35
    if v.crazy_torch == 3 then
        crazy_torch_index = 0.5
    end
    local offset = 0
    offset = offset + int(v.crazy_torch_n) * crazy_torch_index

    local factor = p.dmg_factor
    if IsValid(tvar.strength_aura) and IsValid(p) then
        local sa = tvar.strength_aura
        if Dist(p, sa) < sa.r then
            factor = factor + 0.5
        end
    end
    if IsValid(tvar.wave_bullet_shooter) and tvar.wave_bullet_shooter.open and IsValid(p) then
        offset = offset + 0.5
    end
    if tvar.AyaSkill1 then
        offset = offset + int(v.maxenergy * v.energy_stack - v.energy) * 0.035
    end
    return max((p.dmg * factor + p.dmg_offset + offset) * p.dmg_fixed, 0.01)
end

function lib.GetPlayerSpeed(p)
    local w = lstg.weather
    local v = lstg.var
    p = p or player
    if p.ice_frozen then
        return 0, 0
    end
    local hfactor = p.hspeed_factor
    local lfactor = p.lspeed_factor
    if IsValid(lstg.tmpvar.strength_aura) and IsValid(p) then
        local sa = lstg.tmpvar.strength_aura
        if Dist(p, sa) < sa.r then
            hfactor = hfactor - 0.15
            lfactor = lfactor - 0.15
        end
    end
    local hspeed = (p.hspeed * hfactor + p.hspeed_offset) * p.hspeed_fixed
    local lspeed = (p.lspeed * lfactor + p.lspeed_offset) * p.lspeed_fixed
    local index = 1
    for _ = 1, w.ShuangJiang_speed_low do
        index = index * 0.75
    end
    index = index * w.playerSpeed_index
    if lstg.tmpvar.playerSpeed_index then
        index = index * lstg.tmpvar.playerSpeed_index
    end
    hspeed = max(hspeed, 0.01, v.stable_hspeed)
    lspeed = max(lspeed, 0.01, v.stable_lspeed)
    if hspeed * index == 0.01 then
        ext.achievement:get(75)
    end
    return hspeed * index, lspeed * index
end

function lib.GetPlayerStarLevel(num)
    local pclass = player_list[lstg.var.player_select]
    return playerdata[pclass.name].choose_skill[num]
end

function lib.GetPlayerCollisize(p)
    p = p or player
    local offset = p.collisize_offset
    if IsValid(lstg.tmpvar.wave_bullet_shooter) and lstg.tmpvar.wave_bullet_shooter.open and IsValid(p) then
        offset = offset - 0.1
    end
    local c = (p.collisize * p.collisize_factor + offset) * p.collisize_fixed
    c = max(0.01, c)
    if c == 0.01 then
        ext.achievement:get(76)
    end
    return c
end

---依次返回射速，弹速，射程
function lib.GetShootAttribute(p)
    p = p or player
    local v = lstg.var
    local tvar = lstg.tmpvar
    local s_set = p.shoot_set
    local speed_set = s_set.speed
    local bv_set = s_set.bvelocity
    local range_set = s_set.range
    local sspeed = max(0.5, (speed_set.value * speed_set.factor + speed_set.offset) * speed_set.fixed)
    local bv = max(0.5, (bv_set.value * bv_set.factor + bv_set.offset) * bv_set.fixed)
    local lifetime = max(1, (range_set.value * range_set.factor + range_set.offset) * range_set.fixed)
    if tvar.AyaSkill3 then
        sspeed = sspeed + (v.addition_count[3] or 0) * 4
    end
    return sspeed, bv, lifetime
end

function lib.GetEnergyEfficiency()
    local var = lstg.var
    local tvar = lstg.tmpvar
    local efficiency = var.energy_efficiency
    if tvar.MarisaSkill2 and var.wave_hard then
        efficiency = efficiency + 0.5
    end
    return efficiency
end

local spell_class = plus.Class()
lib.spell_class = spell_class
function spell_class:getName()

end
function spell_class:init()

end
function spell_class:frame()

end
function spell_class:spell()

end
function spell_class:render()

end

---一些必须要存储的player的数据
lib.__must_save_data = {
    "x", "y",
    "dmg", "dmg_factor", "dmg_offset", "dmg_fixed",
    "hspeed", "lspeed",
    "hspeed_factor", "lspeed_factor",
    "hspeed_offset", "lspeed_offset",
    "hspeed_fixed", "lspeed_fixed",
    "collisize", "collisize_factor", "collisize_offset", "collisize_fixed",
    "grazer_colli", "grazer_colli_factor", "grazer_colli_offset", "grazer_colli_fixed",
    "shoot_set", "shoot_angle_off"
}
lib._last_cache_player = {}
lib._last_cache_var = {}
lib._last_cache_weather = {}
lib._last_cache_active_data = {}
lib._cache_player = {}
lib._cache_var = {}
lib._cache_weather = {}
lib._cache_active_data = {}
function lib.PlayerInit()
    lstg.tmpvar.player_bullet_scale = 0.5
    lib.ResetPlayerBulletImg()
    lib.LevelInit()
    lib.ActiveInit()
    lib.PathInit()
    lib.OtherInit()
    lib.WeatherInit()

    stg_levelUPlib.InitAddition()
    activeItem_lib.InitActive()
end

function lib.LevelInit()
    local var = lstg.var
    -----------------
    var.othercondition = function()
        return true
    end
    var.exp_drop_factor = 1
    var.challenge_addchaos = nil
    var.FINAL_HARD_BOSS = true
    var.miss = 0
    var.level = 1
    var.level_exp_index = 9
    var.now_exp = 0
    var.chaos = 0
    var.luck = 1--幸运值
    var.luck_factor = 1
    var.maxluck = 100--最大幸运值
    var.addition = {}--加成记录
    var.addition_count = {}--加成类别数量记录
    var.addition_order = {}--加成顺序记录
    var.addition_pos = {}--加成id映射为加成顺序
    var.wave = 1--波数写为1？
    var.wave_luck = false
    var.wave_hard = false
    var.wave_boss = false--3个标签
    var.maxwave = nil
    var.next_wave_id = nil
    var.now_wave_id = nil
    var.enemyHP_index = 1--怪物血量倍率，实时更新
    var.level_upOption = 3--3选1
    var.level_offset = 0--和升级有关的，隐藏数据
    var.drop_exp_point = 0--计算经验点的小数部分
    var.maxenergy = 100--所需符卡能量
    var.energy = 100--初始符卡能量
    var.energy_stack = 1--符卡储存上限（默认为1个）
    var.energy_efficiency = 1--符卡充能效率
    var.exp_factor = 1--获得经验值的倍率
    var.heal_factor = 0--击败敌人回血的倍率
    var.graze_exp = 0--擦弹获得经验值的数量，最高为1
    var.graze_exp_count = 0--缓存
    var.goldenbody = false--金刚不灭之身
    var.forever33 = false--永无伤痛之心
    var.enemy_contact = 0--妖精联结
    var.blood_magic = false--blood magic
    var.delete_bullet = 0--伊吹大山岚,使弹幕失去判定概率
    var.kokoro_musubu = false--心连心
    var.life_dead = false--生与死的境界
    var.reverse_shoot = false--天地有用
    var.accumulate_exp = 0--积善成德
    var.ON_sakura = false--樱花结界相关
    var.sakura = 0--樱花结界相关
    var.randomLevelUp = false--随机升级
    var.chaos_factor = 1--加混沌值倍率
    var.green_wish = 0--绿沐愿
    var.blue_wish = 0--蓝沐愿
    var.red_wish = 0--红沐愿
    var.crazy_torch = 0--疯狂的火炬
    var.crazy_torch_n = 0
    var.crazy_torch_t = 0
    var.todo_graze_check = nil--todo清单
    var.todo_graze = 0
    var.nue_special_bullet = false--正体不明的飞仓
    var.greedy_exp = false--贪欲的敛财
    var.shuttle_main_bullet = false--主炮穿墙
    var.trail_main_bullet = false--主炮诱导
    var.bound_main_bullet = false--主炮诱导
    var.fire_bird_resurrection = false--不死尾羽
    var.friendly_ball_huge = false--颂德之玉
    var.lifelife_exchange = false--以血换血
    var.bomb_healing = nil--开大回血（硝酸甘油）
    var.levelup_healing = false--升级回血（经验血袋）
    var.borderless_moving = false--无边界移动（月与海的传送门）
    var.steal_sun = false--偷天换日
    var.rewindable = false--时间回溯
    var.rewind_CD = false--时间回溯的CD
    var.hp_to_exp = false--EXHP
    var.hp_to_exp_lost_hp = 0--EXHP计算流失生命值
    var.dmg_reduction = false--伤害减免（阴晴圆缺）
    var.chip_addmaxlife = false--以命汲命
    var.kinematics = false--运动学定律
    var.posion_dot = false--甘美之毒
    var.perfect_spread = 0--完美散华
    var.fallen_snow = false--寂静的冬天
    var.snake_main_bullet = false--风神的祝歌
    var.double_BiYi = false--双蛋黄
    var.mangekyou = false--万华镜
    var.resurrect9 = 0--九代稗谷
    var.active_star = false--活力的繁星
    var.quantum_bullet = false--量子弹幕
    var.del_bullet_with_enemy = false--幻无垢
    var.dmgfactor_withlifeleft = 0--饥饿的狼犬
    var.imaginary_main_bullet = false--幻想烟花
    var.ikinokosu_yume = 0--生之残梦
    var.kappa_shield_count = 0--荷取牌能量盾
    var.cowrie_shell = false--燕的子安贝
    var.weak_life = 0
    var.maxweak_life = 0
    var.protect_lotus = false--护守之莲
    var.lotus_record_b = 0--记录清弹个数
    var.lotus_open = false
    var.buddhist_diamond = false--佛的御石钵
    var.protect_time_ex = 0--额外增加的无敌时间
    var.reflex_arc = false--加长反射弧
    var.self_paradox = false--自指悖论
    var.return_bullet = false--具现化记忆
    var.scarlet_focus = 0--绯红的专注
    var.scarlet_record = 0--记录开火时长
    var.scarlet_count = 1
    var.philosopher_stone = false--贤者之石
    var.philosopher_stone_n = 0--收集经验点个数
    var.life_boom = 0--生命爆炸
    var.peace_chaos = false--平安喜乐
    var.neutron_star = false--中子星
    var.violent_eater = false--极欲的暴食
    var.violent_eater_n = 0
    var.violent_eater_CD = 0
    var.glass_bon = false--玻璃大炮
    var.red_main_bullet = false--寻求者
    var.blue_main_bullet = false--喜爱者
    var.blue_main_bullet_count = 0
    var.green_main_bullet = false--渴望者
    var.powerful_point = false
    var.cyoltose = false--封之术法
    var.forever_scarlet = false--永远的满月
    var.infinite_nightmare = false--永恒的回音
    var.MAX_M = false--MAX M
    var.behind_main_bullet = false--后撤的大人
    var.rotate_shoot_rot = false--安产大炮
    var.stop_0_tool = false--休止符
    var.is_mimichan = false--Mimichan
    var.rotate_star = false--小小星球
    local nums = { 1, 2, 3, 4, 5, 6, 7 }
    var.seven_flowers = {}--深海七花
    for _ = 1, 7 do
        table.insert(var.seven_flowers, table.remove(nums, ran:Int(1, #nums)))
    end
    var.seven_flower_BiYi_list = nil
    var.seven_flower_QingHai_list = nil
    var.seven_flower_Broken_list = nil
    var.nue_main_bullet = false--符札化络合物
    var.protect_kogasa = false--小小星之伞
    var.protect_kogasa_CD = 0
    var.game_killer = false--Game Killer
    var.chip_adddmg = false--团子生命力
    var.cross_laser = 0--死亡十字
    var.stable_hspeed = 0.01--行稳致远
    var.stable_lspeed = 0.01--行稳致远
    var.temporal_barrier = false--彼世结界
    var.elec_fish = 0--电子木鱼
    var.fierce_place = 0--无情之地
end
function lib.ActiveInit()
    local var = lstg.var
    var.active_item = {}--当前拥有的主动道具
    var.max_active_item = 1--最大主动道具数量
    var.UI_active_item = {}--UI上显示的主动道具
end
function lib.PathInit()
    local var = lstg.var
    ---路径模式
    var._pathlike = false
    var._off_chaos = 0
    var.frame_counting = true--一些每帧事件的计时
    var.stop_getting = false--禁止擦弹、ppt等
    var.path_view = 7
    var.now_path_x, var.now_path_y = 1, 1
end
function lib.OtherInit()
    local var = lstg.var

    local data = stagedata
    local pdata = playerdata[player_list[data.player_pos].name]
    var.player_select = data.player_pos
    var.spell_select = data.spell_pos[data.player_pos]
    var.player_level = pdata.level
    var.spell_level = pdata.spells[var.spell_select]
    if not stage.current_stage.is_challenge and not stage.current_stage.is_practice then
        var.difficulty = data.DiffSelection[var.scene_id] - 1--错个位
        lstg.tmpvar.hiscore = stagedata.hiscore[var.scene_id][var.difficulty]
    end
    lstg.tmpvar.playerSpeed_index = nil

    ---季节系统
    var._season_system = false
    ----禁止低速
    var.forbid_slow = false
    -----------------分数数据
    --var.lifeleft = 100
    --var.maxlife = 100

    var.graze = 0
    var.score = 0
    var.score_tmp = 0
    var.score_draw = 0
    -----------------其他数据
    --var.gray = false
    var.hp_render = true
    var.init_player_data = true
    var.timeslow = 1
    var.CYFPS = 60
    var.lost = false
    var.stop_shoot = false
    var.level_up_func = nil
    --计量wave里的obj高峰
    lstg.tmpvar.objcount = {}
    lstg.tmpvar.fileexist = {}
    ext.RestartBlack = 0
    lstg.tmpvar.spell_count = 0
    lstg.tmpvar.baby_stack = {}
    lstg.tmpvar.level_up_count = 0
end
function lib.WeatherInit()
    local w = lstg.weather
    for t in pairs(w) do
        w[t] = nil
    end--直接重制一些变量的开关
    w.total_weather = {}
    w.season_last = { 5, 5, 5, 5, 5 }--季节持续时间
    w.season_wave = 0
    w.now_season = 0
    w.now_weather = 0
    w.enemyHP_offset = 0
    w.enemyHP_index = 1
    w.playerSpeed_index = 1
    w.bullet_init_func = function()

    end
    w.enemy_kill_func = function()
    end
    w.selected_season = { false, false, false, false }
    w.next_weather = nil
    w.next_season = nil
    w.ShuangJiang_speed_low = 0
    w.ZuanShiChen_GetLife = nil
    w.MustSeason5 = false
    w.TwiceXiangRui = false
end

----------------------------------

---端点式列表，然后取值，是一段段一次函数
function lib.GetAttributeByLevel(list, level)
    ---@type p_attributeList
    local result = {}

    local k_list = {}
    local k1, k2 = 0, 0--level所处位置
    for i in pairs(list) do
        table.insert(k_list, i)
    end
    table.sort(k_list)
    for i = 1, #k_list - 1 do
        if level >= k_list[i] and level <= k_list[i + 1] then
            k1 = k_list[i]
            k2 = k_list[i + 1]
            break
        end
    end
    for p in pairs(list[1]) do
        result[p] = list[k1][p] + (list[k2][p] - list[k1][p]) / (k2 - k1) * (level - k1)
        -- result[p] = int(result[p] * 10) / 10--默认保留两位小数
    end
    return result
end
function lib.CreatePlayerUnit(id, name, display_name, nickname, picture, renderx, rendery, renderscale, class, unlock_c, sdescribe, R, G, B)
    ---@class PlayerUnit
    local unit = {
        id = id, name = name, display_name = display_name, nickname = nickname,
        picture = picture, renderx = renderx, rendery = rendery, renderscale = renderscale,
        spells = {}, init_unlock_c = unlock_c, skill_describe = sdescribe, R = R, G = G, B = B,
        class = class
    }
    player_list[id] = unit
    --数据初始化
    if not playerdata[name] then
        local data = {}
        ---解锁技能
        ---如果是false，就是角色本身都没解锁
        data.unlock_c = unlock_c or false
        data.level = 1
        data.now_exp = 0
        data.spells = {}
        data.choose_skill = { false, false, false }
        playerdata[name] = data
    end
    stagedata.spell_pos[id] = stagedata.spell_pos[id] or 1
    return unit
end
function lib.CreatePlayerAttributeList(hp, dmg, collisize, luck, hspeed, lspeed, Sspeed, Sbvelocity, Srange)
    ---@class p_attributeList
    local list = {
        hp = hp, dmg = dmg, collisize = collisize,
        luck = luck, hspeed = hspeed, lspeed = lspeed,
        shoot_set_speed = Sspeed, shoot_set_bvelocity = Sbvelocity, shoot_set_range = Srange
    }
    return list
end
function lib.SetPlayerAttribute(self, player_listID, level)
    local p = player_list[player_listID]
    local v = lstg.var
    ---@type p_attributeList
    local attribute = lib.GetAttributeByLevel(p.class.attribute, level or playerdata[p.name].level)
    v.lifeleft = attribute.hp
    v.maxlife = attribute.hp
    v.luck = attribute.luck
    v._init_luck = attribute.luck
    self.colorR, self.colorG, self.colorB = p.R, p.G, p.B
    self.name = p.name
    --攻击力
    self.dmg = attribute.dmg
    self.dmg_factor = 1
    self.dmg_offset = 0
    self.dmg_fixed = 1
    --速度
    self.hspeed = attribute.hspeed
    self.lspeed = attribute.lspeed
    self.hspeed_factor = 1
    self.lspeed_factor = 1
    self.hspeed_offset = 0
    self.lspeed_offset = 0
    self.hspeed_fixed = 1
    self.lspeed_fixed = 1
    --碰撞大小
    self.collisize = attribute.collisize
    self.collisize_factor = 1
    self.collisize_offset = 0
    self.collisize_fixed = 1
    self.A = (self.collisize * self.collisize_factor + self.collisize_offset) * self.collisize_fixed
    self.B = self.A
    --擦弹范围大小
    self.grazer_colli = 24
    self.grazer_colli_factor = 1
    self.grazer_colli_offset = 0
    self.grazer_colli_fixed = 1
    --攻击设置
    local shoot_set = {
        --射速(每秒发射几颗)
        speed = {
            value = attribute.shoot_set_speed,
            factor = 1, offset = 0, fixed = 1
        },
        --弹速
        bvelocity = {
            value = attribute.shoot_set_bvelocity,
            factor = 1, offset = 0, fixed = 1
        },
        --射程(子弹存在几帧)
        range = {
            value = attribute.shoot_set_range,
            factor = 1, offset = 0, fixed = 1
        }
    }
    self.shoot_set = shoot_set
    self.shoot_angle_off = 0

end

---@param belonging PlayerUnit
function lib.CreateSpellUnit(id, belonging, display_name, picture, attribute_list, introduce)
    ---@class SpellUnit
    local unit = {
        id = id, belonging = belonging, display_name = display_name, picture = picture,
        attribute_list = attribute_list,
        introduce = introduce
    }
    belonging.spells[id] = unit
    if playerdata[belonging.name] then
        local wpdata = playerdata[belonging.name].spells
        wpdata[id] = wpdata[id] or 1
    end
    return unit
end
function lib.GetSpellAttribute(player_listID, spell_ID, level)
    local p = player_list[player_listID]
    local sp = p.spells[spell_ID]
    local attribute = lib.GetAttributeByLevel(sp.attribute_list, level or playerdata[p.name].spells[spell_ID])
    return attribute
end

function lib.ResetPlayerBulletImg()
    lstg.var.player_bullet_img = {
        [0] = "player_bullet", --初始图像
        [1] = nil, --自机自带的图像
    }
end

---pos越大优先级越大
---@param img string@若不填则取消设置
function lib.SetPlayerBulletImg(pos, img)
    lstg.var.player_bullet_img[pos] = img or nil
end
function lib.GetPlayerBulletImg()
    local m = 0
    local rimg = "player_bullet"
    for i, p in pairs(lstg.var.player_bullet_img) do
        if i >= m then
            m = i
            rimg = p
        end
    end
    return rimg
end

player_death_ef = Class(object)
function player_death_ef:init(x, y)
    self.x = x
    self.y = y
    self.img = "player_death_ef"
    self.hscale = 0.7
    self.vscale = 0.7
    self.layer = LAYER.PLAYER + 50
end
function player_death_ef:frame()
    if self.timer == 4 then
        ParticleStop(self)
    end
    if self.timer == 60 then
        object.Del(self)
    end
end

player_bullet_straight = Class(object)
function player_bullet_straight:init(img, x, y, v, angle, dmg)
    self.group = GROUP.PLAYER_BULLET
    self.layer = LAYER.PLAYER_BULLET
    self.img = img
    self.x = x
    self.y = y
    self.rot = angle
    self.vx = v * cos(angle)
    self.vy = v * sin(angle)
    self.dmg = dmg
    if self.a ~= self.b then
        self.rect = true
    end
end

player_bullet_trail = Class(object)
function player_bullet_trail:init(img, x, y, v, angle, target, trail, dmg)
    self.group = GROUP.PLAYER_BULLET
    self.layer = LAYER.PLAYER_BULLET
    self.img = img
    self.x = x
    self.y = y
    self.rot = angle
    self.v = v
    self.target = target
    self.trail = trail
    self.dmg = dmg
end
function player_bullet_trail:frame()
    if IsValid(self.target) and self.target.colli and self.target.class.base.take_damage then
        local a = (Angle(self, self.target) - self.rot) % 360
        if a > 180 then
            a = a - 360
        end
        local da = self.trail / (Dist(self, self.target) + 1)
        if da >= abs(a) then
            self.rot = Angle(self, self.target)
        else
            self.rot = self.rot + sign(a) * da
        end
    end
    self.vx = self.v * cos(self.rot)
    self.vy = self.v * sin(self.rot)
end

player_main_bullet_ef = Class(object)
function player_main_bullet_ef:init(x, y, rot, v, hscale, vscale, alpha, timeout, r, g, b)
    self.x = x
    self.y = y
    self.rot = rot
    self.vx = v * cos(rot)
    self.vy = v * sin(rot)
    self.hscale, self.vscale = hscale, vscale
    self.alpha = alpha
    self.img = lib.GetPlayerBulletImg()
    self.layer = LAYER.PLAYER_BULLET + 50
    self.time_out = timeout
    local j = 1
    if not self.time_out then
        local qual = setting.rdQual
        for _ = 1, int(self.alpha * 3) do
            if #player.particle < 100 + qual * 20 then
                j = j + qual / 5
                if j > 1 then
                    local _a = ran:Float(0, 360)
                    local _v = ran:Float(4, 8)
                    table.insert(player.particle, {
                        x = self.x, y = self.y, size = ran:Float(6, 15),
                        vx = cos(_a) * _v, vy = sin(_a) * _v,
                        alpha = ran:Float(120, 170), timer = 0,
                    })
                    j = j - 1
                end
            end
        end
    end
    self.R, self.G, self.B = r, g, b
end
function player_main_bullet_ef:frame()
    if self.timer == 7 then
        Del(self)
    end
end
function player_main_bullet_ef:render()
    local A = self.alpha * (1 - self.timer / 8) * 0.8
    --SetImageState(self.img, "mul+add", A * 100, self._r, self._g, self._b)
    -- Render(self.img, self.x, self.y, 0, self.hscale * 0.7, self.vscale * 0.7)
    SetImageState(self.img, "", A * 200, 255, 255, 255)
    DefaultRenderFunc(self)
end

local Nue_bullet_event = {
    function(self)
        object.SetSizeColli(self, ran:Float(0.5, 2))
    end,
    function(self)
        self.dmg = self.dmg * ran:Float(0, 2.5)
    end,
    function(self)
        local v = self.real_v * ran:Float(0.25, 1.5)
        self.real_v = v
        if not lstg.var.mimichan then
            self.v = v
            object.SetV(self, self.v, self.rot)
        end
    end,
    function(self)
        self.lifetime = int(self.lifetime * ran:Float(0.5, 2))
    end,
    function(self)
        self.R = ran:Float(0, 255)
        self.G = ran:Float(0, 255)
        self.B = ran:Float(0, 255)
    end,
}
local RGB_cache = {
    { true, false, false },
    { false, true, false },
    { false, false, true },
}
local main_bullet_table = {}
local main_bullet_count = 0

local function blueDrop(self)
    if self.is_blue then
        local v = lstg.var
        local koff = 99 / (1600 - #main_bullet_table)
        if #main_bullet_table <= 150 then
            koff = 0
        end
        local s = max(self.a / 12 - koff - v.blue_main_bullet_count, 0.001)
        DropExpPoint(s, self.x, self.y)
        v.blue_main_bullet_count = v.blue_main_bullet_count + s * 0.00001
    end
end
player_main_bullet = Class(player_bullet_straight)
function player_main_bullet:init(x, y, v, a, dmg, lifetime, red, green, blue)
    local var = lstg.var

    if not (red or green or blue) then
        if var.red_main_bullet and ran:Float(0, 1) < 0.16 then
            red = true
            dmg = dmg * 3.3--伤害增幅在这里
        end
        if var.green_main_bullet and ran:Float(0, 1) < 0.17 then
            green = true
        end
        if var.blue_main_bullet and ran:Float(0, 1) < 0.1 then
            blue = true
        end
    end
    player_bullet_straight.init(self, lib.GetPlayerBulletImg(), x, y, v, a, dmg)
    local factor = lstg.tmpvar.player_bullet_scale
    local collisize = 24 * factor
    self.a, self.b = collisize, collisize
    self.lifetime = int(lifetime or 999)
    self.shuttle_flag = var.shuttle_main_bullet and 1 or 0
    self.target = nil
    self.trail = 400
    self.alpha = 1
    self.rotate_d = sign(player.x - self.x)
    if self.rotate_d == 0 then
        self.rotate_d = ran:Sign()
    end
    self.real_v = v
    self.v = v
    self.isMainBullet = true
    self.can_division = self.lifetime >= 13
    local p = player
    self._r, self._g, self._b = p.colorR, p.colorG, p.colorB
    if var.is_mimichan then
        self.v = 0
        self.vx, self.vy = 0, 0
        task.New(self, function()

            for _ = 1, self.lifetime do
                local ax = cos(self.rot) * v * 2 / self.lifetime
                local ay = sin(self.rot) * v * 2 / self.lifetime
                self.vx = self.vx + ax
                self.vy = self.vy + ay
                task.Wait()
            end
        end)
    end--Mimichan
    if var.kinematics then
        self.vx, self.vy = self.vx + player.dx, self.vy + player.dy
        self.v = GetV(self)
    end--运动学定律
    if var.perfect_spread > 0 then
        main_bullet_count = main_bullet_count + 1
        while main_bullet_count >= 110 do
            main_bullet_count = main_bullet_count - 110
            for A in sp.math.AngleIterator(ran:Float(0, 360), var.perfect_spread * 9) do
                New(player_main_bullet, player.x, player.y, self.real_v, A, self.dmg, self.lifetime)
            end

        end
    end--完美散华


    if not (red or green or blue) then
        self.R, self.G, self.B = 190, 190, 190
    else
        self.R, self.G, self.B = 100, 100, 100
        if red then
            self.R = 255
            self.is_red = true
        end
        if green then
            self.G = 255
            self.is_green = true
        end
        if blue then
            self.B = 255
            self.is_blue = true
        end
    end

    if var.nue_main_bullet then
        local np = ran:Float(0, 1)
        if np < 3 then
            local t = { 1, 2, 3, 4, 5 }
            local _t = {}
            for _ = 1, ran:Int(1, 2) do
                table.insert(_t, table.remove(t, ran:Int(1, #t)))
            end
            for _, c in ipairs(_t) do
                Nue_bullet_event[c](self)
            end
        end
    end

    sp:UnitListUpdate(main_bullet_table)
    sp:UnitListAppend(main_bullet_table, self)
    if #main_bullet_table >= 1500 then
        if var.perfect_spread > 0 then
            main_bullet_count = main_bullet_count - 1
        end
        object.RawDel(self)
    end
end
function player_main_bullet:frame()
    task.Do(self)
    self.v, self.rot = GetV(self)
    local p = player
    self.target = p.target
    local t = self.timer
    local v = lstg.var
    if self.lifetime == t then
        self.time_out = true
        object.Kill(self)
    end
    if v.rotate_star then
        local r = 5.8 + sin(self.timer * 3)
        self.rot = self.rot - self.rotate_d * r
        object.SetV(self, self.v, self.rot)
    end
    if v.return_bullet and not self.have_returned and t >= self.lifetime / 2 then
        self.have_returned = true
        self.vx, self.vy = -self.vx, -self.vy
        self.ax, self.ay = -self.ax, -self.ay
        self.rot = Angle(0, 0, self.vx, self.vy)
        self.rotate_d = -self.rotate_d
        if v.shuttle_main_bullet and self.shuttle_flag == 0 then
            self.shuttle_flag = 1
        end
    end
    if v.shuttle_main_bullet and self.shuttle_flag > 0 then
        local w = lstg.world
        if self.y > w.t then
            self.y = w.b + (self.y - w.t)
            self.shuttle_flag = self.shuttle_flag - 1
        end
        if self.y < w.b then
            self.y = w.t + (self.y - w.b)
            self.shuttle_flag = self.shuttle_flag - 1
        end
        if self.x > w.r then
            self.x = w.l + (self.x - w.r)
            self.shuttle_flag = self.shuttle_flag - 1
        end
        if self.x < w.l then
            self.x = w.r + (self.x - w.l)
            self.shuttle_flag = self.shuttle_flag - 1
        end
    end
    if v.bound_main_bullet and self.shuttle_flag == 0 then
        local w = lstg.world
        if self.y > w.t then
            self.vy = -self.vy
            self.rot = -self.rot
            self.y = w.t - (self.y - w.t)
        end
        if self.y < w.b then
            self.vy = -self.vy
            self.rot = -self.rot
            self.y = w.b - (self.y - w.b)
        end
        if self.x > w.r then
            self.vx = -self.vx
            self.rot = 180 - self.rot
            self.x = w.r - (self.x - w.r)
        end
        if self.x < w.l then
            self.vx = -self.vx
            self.rot = 180 - self.rot
            self.x = w.l - (self.x - w.l)
        end
    end
    if v.MAX_M then
        local D = Dist(self, p)
        local A = Angle(self, p)
        local index = 0.002
        if v.neutron_star then
            index = 0.003
        end
        object.SetA(self, D * index, A)

    end
    if v.trail_main_bullet then
        player_bullet_trail.frame(self)
    end
    if v.snake_main_bullet then
        if IsValid(self.target) and Dist(self, self.target) < self.trail then
            local higher_than_target = false
            if self.vy > 0 then
                higher_than_target = self.y > self.target.y and (self.y - self.dy < self.target.y)
            else
                higher_than_target = self.y < self.target.y and (self.y - self.dy > self.target.y)
            end
            if higher_than_target and not self.isturn_around then
                self.y = self.target.y
                object.SetV(self, self.v, Angle(self, self.target), true)
                self.isturn_around = true
            end
        end
    end

    if lstg.weather.BingYun and self.timer > 5 then
        if lstg.var.frame_counting then
            if ran:Float(0, 1) < 0.03 then
                New(weather_lib.class.ice, self.x, self.y, 60)
                Del(self)
            end
        end
    end
end
function player_main_bullet:kill()
    New(player_main_bullet_ef, self.x, self.y, self.rot, min(2.5, self.v), self.hscale, self.vscale, self.alpha, self.time_out, self.R, self.G, self.B)
    local v = lstg.var
    local t = stage.current_stage.timer
    if not self.time_out then
        --如果不是超过射程而清除
        blueDrop(self)
        if self.is_green then
            player_lib.AddLife(0.025)
        end
        if v.mangekyou then
            for a in sp.math.AngleIterator(t * 4.5, 4) do
                New(player_main_bullet_mangekyou, self.x, self.y, self.real_v, a, self.dmg * 0.2, self.lifetime, self.is_red, self.is_green, self.is_blue)
            end
        else
            if self.is_blue and self.is_green and self.is_red then
                for z = -1, 1 do
                    local c = RGB_cache[z + 2]
                    local b = New(player_main_bullet, self.x, self.y, self.real_v, self.rot + z * 15, self.dmg, self.lifetime, c[1], c[2], c[3])
                    b.colli = false
                    task.New(b, function()
                        task.Wait(2)
                        b.colli = true
                    end)

                end
            end
        end

    end
end
function player_main_bullet:render()
    --SetImageState(self.img, "mul+add", self.alpha * 100, self._r, self._g, self._b)
    --Render(self.img, self.x, self.y, 0, self.hscale * 0.7, self.vscale * 0.7)
    SetImgState(self, "", self.alpha * 200, self.R, self.G, self.B)
    DefaultRenderFunc(self)


end

player_main_bullet_imaginary = Class(player_main_bullet)
function player_main_bullet_imaginary:init(x, y, v, a, dmg, lifetime, red, green, blue)
    player_main_bullet.init(self, x, y, v, a, dmg, lifetime, red, green, blue)
    object.SetSizeColli(self, 1.6)
    self.is_imaginary = true
end
function player_main_bullet_imaginary:kill()
    New(player_main_bullet_ef, self.x, self.y, self.rot, min(2.5, self.v), self.hscale, self.vscale, self.alpha, self.time_out, self.R, self.G, self.B)
    local v = lstg.var
    local t = stage.current_stage.timer
    if v.imaginary_main_bullet then
        if v.perfect_spread > 0 then
            main_bullet_count = main_bullet_count - 1
        end
        for a in sp.math.AngleIterator(t * 1.3, ran:Int(6, 9)) do
            New(player_main_bullet, self.x, self.y, self.real_v, a, self.dmg / 1.5, max(ran:Int(5, 8), self.lifetime * 0.6), self.is_red, self.is_green, self.is_blue)
        end
    end
    if not self.time_out then
        --如果不是超过射程而清除
        blueDrop(self)
        if self.is_green then
            player_lib.AddLife(0.002 * self.dmg)
        end
    end
end

player_main_bullet_mangekyou = Class(player_main_bullet)
function player_main_bullet_mangekyou:init(x, y, v, a, dmg, lifetime, red, green, blue)
    player_main_bullet.init(self, x, y, v, a, dmg, lifetime, red, green, blue)
    object.SetSizeColli(self, 0.75)
    self.is_mangekyou = true
    self.colli = false
    task.New(self, function()
        task.Wait()
        self.colli = true
    end)
end
function player_main_bullet_mangekyou:kill()
    New(player_main_bullet_ef, self.x, self.y, self.rot, min(2.5, self.v), self.hscale, self.vscale, self.alpha, self.time_out, self.R, self.G, self.B)
    if not self.time_out then
        --如果不是超过射程而清除
        blueDrop(self)
        if self.is_green then
            player_lib.AddLife(0.002 * self.dmg)
        end
        if self.is_blue and self.is_green and self.is_red then
            for z = -1, 1 do
                local c = RGB_cache[z + 2]
                New(player_main_bullet_mangekyou, self.x, self.y, self.real_v, self.rot + z * 15, self.dmg, self.lifetime, c[1], c[2], c[3])
            end
        end
    end
end




