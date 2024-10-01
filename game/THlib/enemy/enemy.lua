LoadTexture('enemy1', 'THlib\\enemy\\enemy1.png')
LoadImageGroup('enemy1_', 'enemy1', 0, 384, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy2_', 'enemy1', 0, 416, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy3_', 'enemy1', 0, 448, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy4_', 'enemy1', 0, 480, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy5_', 'enemy1', 0, 0, 48, 32, 4, 3, 8, 8)
LoadImageGroup('enemy6_', 'enemy1', 0, 96, 48, 32, 4, 3, 8, 8)
LoadImageGroup('enemy7_', 'enemy1', 320, 0, 48, 48, 4, 3, 16, 16)
LoadImageGroup('enemy8_', 'enemy1', 320, 144, 48, 48, 4, 3, 16, 16)
LoadImageGroup('enemy9_', 'enemy1', 0, 192, 64, 64, 4, 3, 16, 16)
LoadImageGroup('kedama', 'enemy1', 256, 320, 32, 32, 2, 2, 8, 8)
LoadImageGroup('enemy_x', 'enemy1', 192, 32, 32, 32, 4, 1, 8, 8)
LoadImageGroup('enemy_orb', 'enemy1', 192, 64, 32, 32, 4, 1, 8, 8)
LoadImageGroup('enemy_orb_ring', 'enemy1', 192, 96, 32, 32, 4, 1)
for i = 1, 4 do
    SetImageState('enemy_orb_ring' .. i, 'add+add', 255, 64, 64, 64)
end
LoadImageGroup('enemy_aura', 'enemy1', 192, 32, 32, 32, 4, 1)
for i = 1, 4 do
    SetImageState('enemy_aura' .. i, '', 128, 255, 255, 255)
end

LoadTexture('enemy2', 'THlib\\enemy\\enemy2.png')
LoadImageGroup('enemy10_', 'enemy2', 0, 0, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy11_', 'enemy2', 0, 32, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy12_', 'enemy2', 0, 64, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy13_', 'enemy2', 0, 96, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy14_', 'enemy2', 0, 128, 64, 64, 6, 2, 16, 16)
LoadImageGroup('enemy15_', 'enemy2', 0, 288, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy16_', 'enemy2', 0, 352, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy17_', 'enemy2', 0, 416, 32, 32, 12, 1, 8, 8)
LoadImageGroup('enemy18_', 'enemy2', 0, 480, 32, 32, 12, 1, 8, 8)
LoadPS('ghost_fire_r', 'THlib\\enemy\\ghost_fire_r.psi', 'parimg1', 8, 8)
LoadPS('ghost_fire_b', 'THlib\\enemy\\ghost_fire_b.psi', 'parimg1', 8, 8)
LoadPS('ghost_fire_g', 'THlib\\enemy\\ghost_fire_g.psi', 'parimg1', 8, 8)
LoadPS('ghost_fire_y', 'THlib\\enemy\\ghost_fire_y.psi', 'parimg1', 8, 8)

LoadTexture('enemy3', 'THlib\\enemy\\enemy3.png')
LoadImageGroup('Ghost1', 'enemy3', 0, 0, 32, 32, 8, 1, 8, 8)
LoadImageGroup('Ghost3', 'enemy3', 0, 32, 32, 32, 8, 1, 8, 8)
LoadImageGroup('Ghost2', 'enemy3', 0, 64, 32, 32, 8, 1, 8, 8)
LoadImageGroup('Ghost4', 'enemy3', 0, 96, 32, 32, 8, 1, 8, 8)
LoadImageFromFile('death_ef3', 'THlib\\enemy\\death_ef3.png')

LoadImageFromFile("wishing_ball", "THlib\\enemy\\wishing_ball.png", true)
local j = 0
local _j = 0
wishing_ball_obj = Class(object)
function wishing_ball_obj:init(x, y)

    self.group = GROUP.GHOST
    self.layer = LAYER.TOP
    self.x, self.y = x, y
    self.img = "wishing_ball"
    self.alpha = 0
    self.scale = 0
    self.offi = 0
    self.offy = 0
    self.offay = 4
    self.offai = 6
    self.particle = {}
    self.flag = false
    self.rendercircle = lstg.tmpvar.get_pearl < 3
    task.New(self, function()
        for i = 1, 60 do
            i = task.SetMode[2](i / 60)
            self.alpha = i
            self.scale = i
            self.offay = -4 + 3.5 * i
            self.offai = 6 - 2 * i
            task.Wait()
        end
        task.Wait(120)
        for i = 1, 35 do
            i = task.SetMode[1](i / 35)
            self.alpha = 1 - i
            self.scale = 1 - i
            task.Wait()
        end
        self.flag = true
        while #self.particle > 0 do
            task.Wait()
        end
        Del(self)
    end)
end
function wishing_ball_obj:frame()
    task.Do(self)
    self.offy = self.offy + self.offay
    self.offi = self.offi + self.offai
    if not self.flag then
        for k = 1, 3 do
            j = j + setting.rdQual / 5
            if j >= 1 then
                local R = self.offi * 2
                local a = k * 120 + self.timer * 55
                table.insert(self.particle, {
                    alpha = 15, maxalpha = ran:Float(40, 70),
                    size = ran:Float(4, 9),
                    x = cos(a) * R, y = sin(a) * R,
                    vx = ran:Float(-0.5, 0.5), vy = ran:Float(-0.5, 0.5),
                    timer = 0, lifetime = ran:Int(30, 60),
                    rot = ran:Float(0, 360), omiga = ran:Float(1, 2) * ran:Sign()
                })
                j = j - 1
            end
        end
        _j = _j + setting.rdQual / 5
        if _j >= 1 then
            table.insert(self.particle, {
                alpha = 15, maxalpha = ran:Float(40, 70),
                size = ran:Float(2, 4),
                x = 0, y = self.offy,
                vx = ran:Float(-0.5, 0.5), vy = ran:Float(-0.5, 0.5),
                timer = 0, lifetime = ran:Int(30, 60),
                rot = ran:Float(0, 360), omiga = ran:Float(1, 2) * ran:Sign()
            })
            _j = _j - 1
        end
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
end
function wishing_ball_obj:render()
    SetViewMode("ui")
    local A = self.alpha
    local x, y = WorldToUI(self.x, self.y)
    local R, G, B = 255, 227, 132
    for _, p in ipairs(self.particle) do
        SetImageState("white", "mul+add", p.alpha, R, G, B)
        misc.SectorRender(x + p.x, y + p.y, p.size * 0.8, p.size, 0, 360, 5 + setting.rdQual, p.rot)
    end
    if self.rendercircle then
        for i = 1, 60 do
            local offi = self.offi
            local n = min(60, 5 + int(offi + i) * 3)
            local r1, r2 = (i - 1 + offi) * 2, (i + offi) * 2
            local _x, _y = x, y

            for m = 1, n do
                local ang = 360 / n
                local angle = 360 / n * m + 210
                local alpha = A * 120 * sin(i * 3)
                SetImageState("white", "mul+add", alpha, R, G, B)
                Render4V('white',
                        _x + r2 * cos(angle - ang), _y + r2 * sin(angle - ang), 0.5,
                        _x + r1 * cos(angle - ang), _y + r1 * sin(angle - ang), 0.5,
                        _x + r1 * cos(angle), _y + r1 * sin(angle), 0.5,
                        _x + r2 * cos(angle), _y + r2 * sin(angle), 0.5)
            end
        end
    end
    local offy = self.offy
    SetImageState(self.img, "", A * 150, 200, 200, 200)
    Render(self.img, x, y + offy, 0, 0.1 * self.scale)

    SetViewMode("world")

end

local cos, sin = cos, sin
---@class enemybase
enemybase = Class(object)

function enemybase:init(hp, nontaijutsu)
    self.layer = LAYER.ENEMY
    self.group = GROUP.ENEMY
    if nontaijutsu then
        self.group = GROUP.NONTJT
    end
    self.bound = false
    self.colli = false
    self.maxhp = hp or 1
    self.hp = hp or 1

    setmetatable(self, {
        __index = GetAttr,
        __newindex = function(t, k, v)
            if k == 'colli' then
                rawset(t, '_colli', v)
            else
                SetAttr(t, k, v)
            end
        end
    })
    self.colli = true
    self._servants = {}
    self.dmg_factor = 1
    self.DMG_factor = 1
    self.gandu_count = 0
    if lstg.var.active_star then
        New(stg_levelUPlib.class2.active_star_bullet)
    end
end

local lstg, min, max = lstg, min, max
local int = int

function enemybase:frame()
    SetAttr(self, 'colli', BoxCheck(self, lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt) and self._colli)
    if self.hp <= 0 then
        object.Kill(self)
    end
    task.Do(self)
    self._colli = self._colli and not self.transparent
end

--
function enemybase:colli(other)
    if other.dmg then
        lstg.var.score = lstg.var.score + 10
        local dmg = other.dmg
        if lstg.var.posion_dot and other.isMainBullet then
            if self.dmg_factor * self.DMG_factor > 0 then
                self.gandu_count = self.gandu_count + 1
            end
            dmg = dmg + self.gandu_count * 0.19
        end
        enemybase.take_damage(self, dmg)
        if self._master and self._dmg_transfer and IsValid(self._master) then
            enemybase.take_damage(self._master, dmg * self._dmg_transfer)
        end
    end
    other.killerenemy = self
    if not (other.killflag) then
        object.Kill(other)
    end
    if not other.mute then
        if self.dmg_factor then
            if self.hp > 100 then
                PlaySound('damage00', 0.4, self.x / 200)
            else
                PlaySound('damage01', 0.6, self.x / 200)
            end
        else
            if self.hp > 60 then
                if self.hp > self.maxhp * 0.2 then
                    PlaySound('damage00', 0.4, self.x / 200)
                else
                    PlaySound('damage01', 0.6, self.x / 200)
                end
            else
                PlaySound('damage00', 0.35, self.x / 200, true)
            end
        end
    end
end

function enemybase:del()
    object.DelServants(self)
end

function enemybase:take_damage(dmg)
    if self.dmgmaxt then
        self.dmgt = self.dmgmaxt
    end
    if not self.protect then
        Damage(self, dmg)
    end
end

local k = 0
function Damage(obj, dmg)
    local v = lstg.var
    local w = lstg.weather
    local tvar = lstg.tmpvar
    local dmg_factor = 1
    if obj.hp and not obj.transparent then
        if v.dmgfactor_withlifeleft > 0 then
            local p = v.lifeleft / v.maxlife
            local dmg_lifeleft = (1 - p) * (0.5 + v.dmgfactor_withlifeleft / 3)
            dmg_factor = dmg_factor + dmg_lifeleft
        end
        if IsValid(tvar.black_fog_circle) then
            if Dist(obj, player) < tvar.black_fog_circle.R then
                dmg_factor = dmg_factor + 0.75
            end
        end
        --計算傷害倍率
        dmg_factor = dmg_factor * (obj.dmg_factor or 1) * (obj.DMG_factor or 1)
        ---------
        dmg = dmg * dmg_factor
        dmg = max(dmg, 0)
        if obj.maxhp then
            dmg = min(dmg, obj.maxhp)
        end
        if dmg > 0 then
            k = k + dmg - int(dmg)
            v.score = v.score + int(dmg) * 10
            if k >= 1 then
                v.score = v.score + int(k) * 10
                k = k - int(k)
            end
            obj.hp = obj.hp - dmg

            local addindex = 1 / v.enemyHP_index
            activeItem_lib.AddActiveChargeByAttack(dmg * addindex)
            if lstg.tmpvar.sakura_kekkai and not v.ON_sakura then
                local index2 = (player.__slow_flag) and 6 or 12
                v.sakura = min(50000, v.sakura + dmg * index2 * addindex)
            end
            local scs = stage.current_stage
            if not scs.is_tutorial and not GetChargeCost() and not scs.is_practice then
                ---供奉珠的获得
                local data = scoredata
                data.pearlGet = data.pearlGet + dmg / 4200 * addindex
                while data.pearlGet >= 1 do
                    local pro = (data.pearlGetIndex + 1) / 3
                    if scoredata.totalPearls >= #lottery_lib.totalPool then
                        pro = pro * 0.12
                    end
                    if ran:Float(0, 1) <= pro then
                        AddPearl(1)

                        lstg.tmpvar.get_pearl = lstg.tmpvar.get_pearl + 1
                        if lstg.tmpvar.get_pearl >= 3 then
                            ext.achievement:get(70)
                        end
                        New(wishing_ball_obj, obj.x, obj.y)
                        PlaySound("lgods1", 1)--加个声音提示一下
                        data.pearlGetIndex = 0
                    else
                        data.pearlGetIndex = data.pearlGetIndex + 1
                    end
                    data.pearlGet = data.pearlGet - 1
                end

            end

            if v._season_system then
                if w.DaHan and ran:Float(0, 1) < 0.25 then
                    NewSimpleBullet(ball_small, 15, obj.x, obj.y,
                            min(12, 5 + v.chaos / 120), ran:Float(0, 360))
                end
            end

        end
    end

end

function KillEnemyFunction(self, drop_func)
    local v = lstg.var
    local w = lstg.weather
    player_lib.AddLife(self.maxhp / v.enemyHP_index * v.heal_factor)
    mission_lib.GoMission(4, 1 / 1000 * 100)
    mission_lib.GoMission(45, 1 / 3332.5 * 100)--怕有误差,3333改成3332.5
    mission_lib.GoMission(46, 1 / 10000 * 100)
    scoredata._total_kill_enemy = scoredata._total_kill_enemy + 1
    do
        -- local index = (player.protect > 0) and 0.05 or 1
        local RAW_VALUE = 0.15 + 0.02 * (5 - setting.rdQual)--以单个粒子能量值决定渲染质量
        local value = self.maxhp / v.enemyHP_index * 0.02
        if #player.energy_particle < 200 then
            if value < 40 * RAW_VALUE then
                for _ = 1, value / RAW_VALUE do
                    player_lib.NewEnergySp(self.x, self.y, RAW_VALUE)
                end
                value = value % RAW_VALUE
                player_lib.NewEnergySp(self.x, self.y, value)
            else
                for _ = 1, 40 do
                    player_lib.NewEnergySp(self.x, self.y, value / 40)
                end
            end
        else
            player_lib.NewEnergySp(self.x, self.y, value)
        end

    end--能量点的掉落

    if drop_func then
        drop_func(self)
        local exp = item.drop_exp
        if v._season_system then
            if w.XiaZhi then
                item.dropItem(exp, 1, self.x, self.y)
            end
            if w.WuYun and ran:Float(0, 1) < 0.5 then
                item.dropItem(exp, 1, self.x, self.y)
            end
        end
    end
    if v.blood_magic then
        local x, y = self.x, self.y
        New(tasker, function()
            local count = 3
            for _, p in ipairs(stg_levelUPlib.ListByTags.sacrifice) do
                if v.addition[p.id] then
                    count = count + 1
                end
            end
            local ROT = 0
            if v.addition[55] then
                ROT = 180
            end
            for _ = 1, count do
                NewSimpleBullet(grain_c, 2, x, y, min(1.8 + v.chaos / 40, 6), Angle(x, y, player) + ROT)
                task.Wait(4)
            end
        end)
    end
    if v.enemy_contact > 0 then
        object.EnemyNontjtDo(function(e)
            if e.class.base.take_damage then
                e.class.base.take_damage(e, self.maxhp * v.enemy_contact)
            end
        end)
    end
    if v.crazy_torch > 0 then
        local num = 0.3
        if v.crazy_torch == 3 then
            num = 0.6
        end
        v.crazy_torch_n = v.crazy_torch_n + num
        if v.crazy_torch_t < 60 then
            v.crazy_torch_t = 60
        else
            v.crazy_torch_t = min(v.crazy_torch_t + 10, 200)
        end
    end
    if v.fallen_snow then
        for _ = 1, ran:Int(1, 2) do
            New(stg_levelUPlib.class2.fallen_snow_bullet, ran:Float(-300, 300), 250)
        end
    end
    if v.active_star then
        New(stg_levelUPlib.class2.active_star_bullet)
    end
    if v.del_bullet_with_enemy then
        local minD = 999
        local target
        object.BulletDo(function(b)
            local d = Dist(b, self)
            if d < minD then
                target = b
                minD = d
            end
        end)
        if IsValid(target) then
            Del(target)
        end
    end
    if v.forever_scarlet then
        local index = 2.5
        if v.scarlet_focus > 0 then
            index = 5
        end
        New(stg_levelUPlib.class3.forever_scarlet_moon, self.a * index, self.x, self.y)
    end
    if v.cross_laser > 0 then
        if ran:Float(0, 1) < stage_lib.GetValue(0.1, 1, 1, 1, player_lib.GetLuck()) then
            for a in sp.math.AngleIterator(0, 4) do
                New(stg_levelUPlib.class4.cross_laser, self.x, self.y, a, v.cross_laser * 30)

            end
        end
    end
    -------------
    if v._season_system then
        w.enemy_kill_func(self)
    end
end

enemy = Class(enemybase)
enemy.take_damage = enemybase.take_damage

_enemy_aura_tb = { 1, 2, 3, 4, 3, 1, nil, nil, nil, 3, 1, 4, 1, nil, 3, 1, 2, 4, 3, 1, 2, 4, 1, 2, 3, 4, nil, nil, nil, nil, 1, 3, 2, 1 }
_death_ef_tb = { 1, 2, 3, 4, 3, 1, 1, 2, 1, 3, 1, 4, 1, 1, 3, 1, 2, 4, 3, 1, 2, 4, 1, 2, 3, 4, 1, 3, 2, 4, 1, 3, 2, 4 }

---1~4小妖精，5~6翅膀大一点的小妖精
---7~8小蝴蝶，9大白蝴蝶，
---10~13红翅膀的小妖精，14大黑蝴蝶
---15~18戴着帽子的小妖精
---19~22毛玉，23~26阴阳玉
---27~30没有法阵的阴魂，31~34带法阵的阴魂
function enemy:init(style, hp, clear_bullet, auto_delete, nontaijutsu, drop_exps)
    enemybase.init(self, hp, nontaijutsu or false)
    self.clear_bullet = clear_bullet or false
    self.auto_delete = (auto_delete or auto_delete == nil) and true
    self._blend = ""
    self._a, self._r, self._g, self._b = 255, 255, 255, 255
    self._wisys = EnemyWalkImageSystem(self, style, 8)--by OLC，新行走图系统
    self.drop_exps = drop_exps
    self.dmgmaxt = 2

    if lstg.var._season_system then
        --天气系统
        local w = lstg.weather
        if w.YuShui then
            local p2 = ran:Float(0, 1)
            if p2 < 0.1 then
                self._colli = false
                self.transparent = true
            end
        end
        if w.BiShi then
            self._colli = false
            self.transparent = true
        end
        self.JiYunFlag = w.JiYun
    end
end

function enemy:frame()
    enemybase.frame(self)
    self._wisys:frame()--by OLC，新行走图系统
    if self.dmgt and self.dmgt > 0 then
        self.dmgt = self.dmgt - 1
    end
    if self.auto_delete and BoxCheck(self, lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt) then
        self.bound = true
    end
end

function enemy:render()
    self._wisys:render(self.dmgt, self.dmgmaxt)--by OLC and ETC，新行走图系统
end

local cols = { { 255, 99, 71 }, { 125, 255, 125 }, { 125, 125, 255 }, { 255, 227, 132 } }
function enemy.death_ef(x, y, _, index)
    local qual = setting.rdQual
    New(enemy_death_ef1, index, x, y)
    New(enemy_death_ef2, qual * 10, x, y, index)--不用hp来搞特效了
    local Num = qual + 1
    for _ = 1, ran:Int(Num - 2, Num + 2) do
        New(enemy_death_ef3, x, y, ran:Float(0.8, 2), ran:Float(0, 360), ran:Int(70, 90), ran:Float(0.9, 1.1), unpack(cols[index]))
    end
end

function enemy:kill()
    if self.JiYunFlag then
        object.Preserve(self)
        self.hp = self.maxhp
        self.JiYunFlag = nil
    end
    PlaySound('enep00', 0.3, self.x / 200, true)
    enemy.death_ef(self.x, self.y, self.maxhp, self.death_ef)
    DropExpPoint(self.drop_exps, self.x, self.y)
    KillEnemyFunction(self, self.class.drop)
    if self.clear_bullet then
        New(bullet_cleaner, player.x, player.y, 800, 40, 40, true, false, 0, 0)
        --New(bullet_killer, player.x, player.y, false)
    end
    object.KillServants(self)

end
function enemy:del()
    if BoxCheck(self, lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt) then
        enemy.death_ef(self.x, self.y, self.maxhp, self.death_ef)
    end
end
do
    local white = "white"
    enemy_death_ef1 = Class(object)
    enemy_death_ef2 = Class(object)
    enemy_death_ef3 = Class(object)
    function enemy_death_ef1:init(index, x, y)
        self.img = 'bubble' .. index
        self.layer = LAYER.ENEMY
        self.group = 0
        self.x = x
        self.y = y
        self.rot = stage.current_stage.timer * 2.6
        self.bound = false
    end
    function enemy_death_ef1:render()
        local t = self.timer
        local alpha = 1 - t / 30
        alpha = 255 * alpha * alpha
        local img = self.img
        local rot = self.rot
        local x, y = self.x, self.y

        SetImageState(img, 'mul+add', alpha, 255, 255, 255)
        Render(img, x, y, rot + 15, 0.4 - t * 0.01, t * 0.2 + 0.7)
        Render(img, x, y, rot + 45, 0.4 - t * 0.01, t * 0.2 + 0.7)
        Render(img, x, y, rot + 75, 0.4 - t * 0.01, t * 0.2 + 0.7)
    end
    function enemy_death_ef1:frame()
        if self.timer == 30 then
            Kill(self)
        end
    end

    function enemy_death_ef2:init(hp, x, y, index)
        self.r, self.g, self.b = unpack(cols[index])
        self.x = x
        self.y = y
        self.group = 0
        self.layer = LAYER.ENEMY
        self.circle, self.circle2 = {}, {}
        self.c = int(hp / 20) + 1
        for i = 1, self.c do
            self.circle[i] = { x + ran:Float(-15, 15), y + ran:Float(-15, 15) }
        end
        for i = 1, 3 do
            self.circle2[i] = { x + ran:Float(-15, 15), y + ran:Float(-15, 15) }
        end
        self.bound = false
    end
    function enemy_death_ef2:render()
        local u = sin(self.timer * 2)
        local misc = misc
        SetImageState(white, 'mul+add', 200 - 200 * u, 255, 255, 255)
        for _, t in ipairs(self.circle) do
            misc.SectorRender(t[1], t[2], u * 30 * 0.98, u * 30, 0, 360, 18)
        end
        SetImageState(white, 'mul+add', 200 - 200 + 200 * sin(90 - self.timer * 2), self.r, self.g, self.b)
        for _, t in ipairs(self.circle2) do
            misc.SectorRender(t[1], t[2], u * 50 * 0.98, u * 50, 0, 360, 6, 0)
        end

    end
    function enemy_death_ef2:frame()
        if self.timer == 45 then
            Kill(self)
        end
    end

    function enemy_death_ef3:init(x, y, v, a, lifetime, size, r, g, b)
        self.img = 'death_ef3'
        self.x, self.y = x, y
        self.rot = ran:Float(0, 360)
        self.bound = false
        self.omiga = ran:Float(0.8, 1.2) * ran:Sign()
        self.hscale = size
        self.vscale = size

        self.layer = LAYER.ENEMY
        self.group = 0

        self.size = size
        self.v = v
        self.angle = a
        self.lifetime = lifetime
        self._x, self._y = x, y
        self.r, self.g, self.b = r, g, b
        self._s = ran:Float(1, 3)

    end
    function enemy_death_ef3:render()
        SetImageState(self.img, 'mul+add', 125 - 125 + 125 * sin(90 - min(1, self.timer / self.lifetime) * 90), self.r, self.g, self.b)
        object.render(self)
    end
    function enemy_death_ef3:frame()
        if self.timer >= self.lifetime then
            self.hide = true
            Del(self)
        end
        local t = self.timer - 1
        local i = (90 / self.lifetime) * t
        local l = self.v * self.lifetime
        self.x = self._x + l * cos(self.angle) * sin(i)
        self.y = self._y + l * sin(self.angle) * sin(i)
        self.hscale = self.size + (-self._s * self.size / self.lifetime) * t
    end
end

Include 'THlib\\enemy\\boss.lua'