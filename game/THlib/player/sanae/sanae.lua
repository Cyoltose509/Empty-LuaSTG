do
    --resource
    local path = "THlib\\player\\sanae\\"
    LoadImageFromFile("sanae_player_spell1", path .. "sanae_spell1.png")
    LoadTexture('sanae_player', path .. 'sanae.png')
    LoadImageGroup('sanae_player', 'sanae_player', 0, 0, 32, 48, 8, 3, 0, 0)
    LoadTexture('sanae_player_pic', path .. 'sanae_pic.png')

    LoadImageFromFile("sanae_player_bullet", path .. "sanae_bullet.png", true, 48, 48)
end

local langModule = "sanae_des"
loadLanguageModule(langModule, "THlib\\player\\sanae")
local function _t(str)
    return Trans(langModule, str) or ""
end

sanae_player = Class(player_class)

function sanae_player:init()
    player_class.init(self)
    player_lib.SetPlayerBulletImg(1, "sanae_player_bullet")
    self.imgs = {}
    for i = 1, 24 do
        self.imgs[i] = 'sanae_player' .. i
    end
end
function sanae_player:frame()
    player_class.frame(self)
end

local lib = player_lib
local pu = lib.CreatePlayerUnit(6, "Sanae",  _t("name"), _t("subname"),
        'sanae_player_pic', 550, 357, 0.32, sanae_player,
        false, {
            { _t("Talent1name"), _t("Talent1des"), },
            { _t("Talent2name"), _t("Talent2des"), },
            { _t("Talent3name"), _t("Talent3des"), },
        }, 150, 255, 175)

--设置等级属性
sanae_player.attribute = {
    [1] = lib.CreatePlayerAttributeList(20.0, 3, 0.6, 25,
            4.3, 2.2, 20, 9, 46),
    [10] = lib.CreatePlayerAttributeList(30.0, 6, 0.6, 40,
            4.3, 2.2, 15, 10, 43),
    [20] = lib.CreatePlayerAttributeList(36.6, 14, 0.6, 50,
            4.3, 2.2, 10, 11, 38),
}

lib.CreateSpellUnit(1, pu, "「」", "sanae_player_spell1", {
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
    p.protect = p.protect + t
    p.collect_line = p.collect_line - 600
    lstg.var.energy_efficiency = lstg.var.energy_efficiency - 0.75
    New(tasker, function()
        task.Wait(t)
        p.collect_line = p.collect_line + 600
        lstg.var.energy_efficiency = lstg.var.energy_efficiency + 0.75
    end)

    return t
end
function spell1:getDescribe()
    return _t("spelldes"):format(self.count, self.dmg_index * 100, self.protect_time)
end

local spells = { spell1 }
sanae_player.spells = spells
do

    local bullets = {}
    sanae_player.bullets = bullets
end