chiruno_player = Class(player_class)
do
    --resource
    local path = "THlib\\player\\chiruno\\"
    LoadImageFromFile("chiruno_player_spell1", path .. "chiruno_spell1.png")
    LoadTexture('chiruno_player', path .. 'chiruno.png')
    LoadImageGroup('chiruno_player', 'chiruno_player', 0, 0, 32, 48, 8, 3, 0, 0)
    LoadTexture('chiruno_player_pic', path .. 'chiruno_pic.png')

    LoadImageFromFile("chiruno_player_bullet", path .. "chiruno_bullet.png", true, 48, 48)
end

local langModule = "chiruno_des"
loadLanguageModule(langModule, "THlib\\player\\chiruno")
local function _t(str)
    return Trans(langModule, str) or ""
end

function chiruno_player:init()
    player_class.init(self)
    player_lib.SetPlayerBulletImg(1, "chiruno_player_bullet")
    self.imgs = {}
    for i = 1, 24 do
        self.imgs[i] = 'chiruno_player' .. i
    end
    self.bright = {}
    if player_lib.GetPlayerStarLevel(1) then
        player_lib.SetEnergy(35, 3)
        player_lib.AddEnergy(114514)
    end
    if player_lib.GetPlayerStarLevel(2) then
        lstg.tmpvar.ChirunoSkill2 = true
    end
    if player_lib.GetPlayerStarLevel(3) then
        lstg.tmpvar.ChirunoSkill3 = true
    end
end
function chiruno_player:frame()
    player_class.frame(self)
    local b
    for i = #self.bright, 1, -1 do
        b = self.bright[i]
        b.alpha = max(0, b.alpha - 10)
        b.x = b.x + cos(b.a) * b.v
        b.y = b.y + sin(b.a) * b.v
        if b.alpha == 0 then
            table.remove(self.bright, i)
        end
    end
end

local lib = player_lib
local pu = lib.CreatePlayerUnit(3, "Chiruno",  _t("name"), _t("subname"),
        'chiruno_player_pic', 500, 340, 0.38, chiruno_player,
        false, {
            { _t("Talent1name"), _t("Talent1des"), },
            { _t("Talent2name"), _t("Talent2des"), },
            { _t("Talent3name"), _t("Talent3des"), },
        }, 135, 206, 235)

--设置等级属性
chiruno_player.attribute = {
    [1] = lib.CreatePlayerAttributeList(16.0, 6.3, 0.8, 18.0,
            4.8, 2.5, 14, 7, 53),
    [10] = lib.CreatePlayerAttributeList(20.0, 6.6, 0.8, 22.0,
            4.8, 2.5, 15, 8, 48),
    [20] = lib.CreatePlayerAttributeList(24.0, 7, 0.75, 25.0,
            4.8, 2.5, 16, 9, 46),
}

lib.CreateSpellUnit(1, pu, "冰符「小小冰镇世界」", "chiruno_player_spell1", {
    [1] = { dmg_index = 0.3, protect = 2, },
    [10] = { dmg_index = 0.6, protect = 2.5, },
})

local spell1 = plus.Class(lib.spell_class)

function spell1:init(master, attribute)
    self.master = master
    self.dmg_index = attribute.dmg_index
    self.protect_time = attribute.protect
end
function spell1:spell()
    local p = self.master

    PlaySound('slash', 1.0)
    PlaySound('release', 1.0)
    local dmg = player_lib.GetPlayerDmg() * self.dmg_index
    local t = int(self.protect_time * 60)
    if not lstg.tmpvar.ChirunoSkill2 then
        p.nextspell = t
    else
        p.nextspell = 2
    end
    p.protect = max(p.protect, t)
    p.collect_line = p.collect_line - 600

    --lstg.var.energy_efficiency = lstg.var.energy_efficiency - 0.6
    New(tasker, function()
        task.Wait(t)
        p.collect_line = p.collect_line + 600
       -- lstg.var.energy_efficiency = lstg.var.energy_efficiency + 0.6
    end)
    New(chiruno_player.bullets.spell_unit, dmg, t, 80)

    return t
end
function spell1:getDescribe()
    --持续帧数30
    return _t("spelldes"):format(self.dmg_index * 6000, self.protect_time)
end

local spells = { spell1 }
chiruno_player.spells = spells
do

    local bullets = {}
    chiruno_player.bullets = bullets
    local spell_unit = Class(object)
    function spell_unit:init(dmg, time, radius)
        self.x, self.y = player.x, player.y
        self.group = 3
        self.layer = -401
        self.bound = false
        self.colli = true
        self.alpha = 0
        self.col = { 60, 100, 235 }
        self.a = 0
        self.dmg = dmg
        self.killflag = true
        self.count = 0
        local _radius = radius
        self.drop_item = function(x, y)
            player_lib.NewEnergySp(x, y, 0.015)
        end
        if lstg.tmpvar.ChirunoSkill3 then
            self.drop_item = function(x, y, is_laser)
                player_lib.NewEnergySp(x, y, 0.015)
                if not is_laser then
                    local percent = 0.0035
                    self.a = self.a + radius * percent
                    _radius = _radius + radius * percent
                end
            end
        end
        self.alpha = 0
        task.New(self, function()
            for i = 1, 15 do
                i = task.SetMode[2](i / 15)
                self.a = i * _radius
                task.Wait()
            end
        end)
        task.New(self, function()
            task.SmoothSetValueTo("alpha", 255, 15, 2)
            task.Wait(time)
            self.colli = false
            task.SmoothSetValueTo("alpha", 0, 15, 2)
            object.Del(self)
        end)
    end
    function spell_unit:frame()
        task.Do(self)
        self.b = self.a
        if self.colli then
            cutLasersByCircle(self.x, self.y, self.a, function(x, y)
                self.drop_item(x, y, true)
            end)
            object.BulletDo(function(o)
                if Dist(self, o) < self.a then
                    object.Del(o)
                    self.drop_item(o.x, o.y)
                    --New(main_item, o.x, o.y, nil, nil, true, nil, 0.6)
                end
            end)
            object.LaserDo(function(o)
                if Dist(self, o) < self.a and not o.Isradial and not o.Isgrowing then
                    object.Del(o)
                    self.drop_item(o.x, o.y)
                    --New(main_item, o.x, o.y, nil, nil, true, nil, 0.6)
                end
            end)
        end
    end
    function spell_unit:render()
        SetImageState("white", "mul+add", self.alpha / 2.7, 60, 100, 235)
        misc.SectorRender(self.x, self.y, 0, self.a, 0, 360, 40)
        misc.SectorRender(self.x, self.y, self.a - 8, self.a, 0, 360, 40)
    end
    bullets.spell_unit = spell_unit
end