do
    --resource
    local path = "THlib\\player\\aya\\"
    LoadImageFromFile("aya_player_spell1", path .. "aya_spell1.png")
    LoadTexture('aya_player', path .. 'aya.png')
    LoadImageGroup('aya_player', 'aya_player', 0, 0, 32, 48, 8, 3, 0, 0)
    LoadTexture('aya_player_pic', path .. 'aya_pic.png')
    LoadImageFromFile("aya_spell_photoON", path .. "photoON.png")
    LoadImageFromFile("aya_spell_photoOFF", path .. "photoOFF.png")

    LoadImageFromFile("aya_player_bullet", path .. "aya_bullet.png", true, 48, 48)
end

local langModule = "aya_des"
loadLanguageModule(langModule, "THlib\\player\\aya")
local function _t(str)
    return Trans(langModule, str) or ""
end

aya_player = Class(player_class)

function aya_player:init()
    player_class.init(self)
    player_lib.SetPlayerBulletImg(1, "aya_player_bullet")
    self.imgs = {}
    for i = 1, 24 do
        self.imgs[i] = 'aya_player' .. i
    end
    if player_lib.GetPlayerStarLevel(1) then
        lstg.tmpvar.AyaSkill1 = true
    end
    if player_lib.GetPlayerStarLevel(2) then
        lstg.tmpvar.AyaSkill2 = true
    end
    if player_lib.GetPlayerStarLevel(3) then
        lstg.tmpvar.AyaSkill3 = true
    end
end
function aya_player:frame()
    player_class.frame(self)
end

local lib = player_lib
local pu = lib.CreatePlayerUnit(4, "Aya",  _t("name"), _t("subname"),
        'aya_player_pic', 500, 320, 0.45, aya_player,
        false, {
            { _t("Talent1name"), _t("Talent1des"), },
            { _t("Talent2name"), _t("Talent2des"), },
            { _t("Talent3name"), _t("Talent3des"), },
        }, 250, 128, 114)

--设置等级属性
aya_player.attribute = {
    [1] = lib.CreatePlayerAttributeList(16.6, 3.2, 0.8, 8.0,
            6, 4, 26, 9, 45),
    [10] = lib.CreatePlayerAttributeList(26.6, 3.6, 0.8, 20.0,
            6, 4, 30, 10, 43),
    [20] = lib.CreatePlayerAttributeList(30, 4, 0.8, 28.0,
            6, 4, 35, 11, 40),
}

lib.CreateSpellUnit(1, pu, "取材「暴力取材」", "aya_player_spell1", {
    [1] = { count = 8, dmg_index = 21.4, protect = 3.5, },
    [10] = { count = 12, dmg_index = 28.5, protect = 4.5, },
})

local spell1 = plus.Class(lib.spell_class)

function spell1:init(master, attribute)
    self.master = master
    self.count = int(attribute.count)
    self.dmg_index = attribute.dmg_index
    self.protect_time = attribute.protect
end
function spell1:spell()
    local p = self.master

    PlaySound('slash', 1.0)
    PlaySound('nep00', 1.0)
    local dmg = player_lib.GetPlayerDmg() * self.dmg_index
    local t = int(self.protect_time * 60)
    p.nextspell = t
    p.nextshoot = p.nextshoot + t
    p.protect = p.protect + t
    p.collect_line = p.collect_line - 600
    lstg.var.energy_efficiency = lstg.var.energy_efficiency - 0.75
    New(tasker, function()
        task.Wait(t)
        p.collect_line = p.collect_line + 600
        lstg.var.energy_efficiency = lstg.var.energy_efficiency + 0.75
    end)
    New(aya_player.bullets.photo_back, t * (self.count - 1) / self.count)
    for i = 0, self.count - 1 do
        local j = task.SetMode[2](i / self.count)
        New(tasker, function()
            task.Wait(t * j)
            New(aya_player.bullets.photo_shoot, 30, dmg)
            if i == self.count - 1 then
                PlaySound("explode")
                PlaySound("cardget")
            end
        end)
    end

    return t
end
function spell1:getDescribe()
    return _t("spelldes"):format(self.count, self.dmg_index * 100, self.protect_time)
end

local spells = { spell1 }
aya_player.spells = spells
do

    local bullets = {}
    aya_player.bullets = bullets
    local photo_back = Class(object)
    function photo_back:init(time)
        self.x, self.y = 0, 0
        self.img = "aya_spell_photoOFF"
        self.group = GROUP.GHOST
        self.layer = -400
        self.bound = false
        self.alpha = 1
        task.New(self, function()
            task.Wait(time)
            task.SmoothSetValueTo("alpha", 0, 15, 2)
            object.Del(self)
        end)
    end
    function photo_back:frame()
        task.Do(self)
    end
    function photo_back:render()
        SetImageState("white", "", self.alpha * 75, 0, 0, 0)
        RenderRect("white", -320, 320, -240, 240)
        SetImageState(self.img, "mul+add", self.alpha * 255, 255, 255, 255)
        Render(self.img, self.x, self.y, 90, 1.25)
    end
    bullets.photo_back = photo_back

    local photo_shoot = Class(object)
    function photo_shoot:init(time, dmg)
        self.x, self.y = 0, 0
        self.img = "aya_spell_photoON"
        self.group = GROUP.PLAYER_BULLET
        self.layer = -401
        self.bound = false
        self.alpha = 1
        self.dmg = dmg
        self.killflag = true
        self.a, self.b = 999, 999
        New(bomb_bullet_killer, 0, 0, 999, 100, false)
        PlaySound("shutter")
        task.New(self, function()
            task.SmoothSetValueTo("alpha", 0, time, 2)
            object.Del(self)
        end)
    end
    function photo_shoot:frame()
        task.Do(self)
        if self.timer >= 1 then
            self.colli = false
        end
    end
    function photo_shoot:render()
        SetImageState(self.img, "mul+add", self.alpha * 255, 255, 255, 255)
        Render(self.img, self.x, self.y, 90, 1.25)
    end
    bullets.photo_shoot = photo_shoot
end