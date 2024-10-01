do
    --resource
    local path = "THlib\\player\\youmu\\"
    LoadImageFromFile("youmu_player_spell1", path .. "youmu_spell1.png")
    LoadTexture('youmu_player', path .. 'youmu.png')
    LoadImageGroup('youmu_player', 'youmu_player', 0, 0, 32, 48, 8, 3, 0, 0)
    LoadTexture('youmu_player_pic', path .. 'youmu_pic.png')

    LoadImageFromFile("youmu_player_bullet", path .. "youmu_bullet.png", true, 48, 48)
end

local langModule = "youmu_des"
loadLanguageModule(langModule, "THlib\\player\\youmu")
local function _t(str)
    return Trans(langModule, str) or ""
end

youmu_player = Class(player_class)

function youmu_player:init()
    player_class.init(self)
    player_lib.SetPlayerBulletImg(1, "youmu_player_bullet")
    self.imgs = {}
    for i = 1, 24 do
        self.imgs[i] = 'youmu_player' .. i
    end
end
function youmu_player:frame()
    player_class.frame(self)
end

local lib = player_lib
local pu = lib.CreatePlayerUnit(7, "Youmu",  _t("name"), _t("subname"),
        'youmu_player_pic', 344, 494, 0.48, youmu_player,
        false, {
            { _t("Talent1name"), _t("Talent1des"), },
            { _t("Talent2name"), _t("Talent2des"), },
            { _t("Talent3name"), _t("Talent3des"), },
        }, 100, 100, 255)

--设置等级属性
youmu_player.attribute = {
    [1] = lib.CreatePlayerAttributeList(10.0, 4, 0.7, 15.0,
            5, 3, 12, 11, 46),
    [10] = lib.CreatePlayerAttributeList(15.0, 5, 0.7, 18.0,
            5, 3, 16, 13, 43),
    [20] = lib.CreatePlayerAttributeList(20.0, 5.5, 0.7, 21.0,
            5, 3, 20, 15, 38),
}

lib.CreateSpellUnit(1, pu, "「」", "youmu_player_spell1", {
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
youmu_player.spells = spells
do

    local bullets = {}
    youmu_player.bullets = bullets
end