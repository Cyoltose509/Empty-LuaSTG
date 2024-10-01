do
    --resource
    local path = "THlib\\player\\sakuya\\"
    LoadImageFromFile("sakuya_player_spell1", path .. "sakuya_spell1.png")
    LoadTexture('sakuya_player', path .. 'sakuya.png')
    LoadImageGroup('sakuya_player', 'sakuya_player', 0, 0, 32, 48, 8, 3, 0, 0)
    LoadTexture('sakuya_player_pic', path .. 'sakuya_pic.png')

    LoadImageFromFile("sakuya_player_bullet", path .. "sakuya_bullet.png", true, 48, 48)
end

local langModule = "sakuya_des"
loadLanguageModule(langModule, "THlib\\player\\sakuya")
local function _t(str)
    return Trans(langModule, str) or ""
end

sakuya_player = Class(player_class)

function sakuya_player:init()
    player_class.init(self)
    player_lib.SetPlayerBulletImg(1, "sakuya_player_bullet")
    self.imgs = {}
    for i = 1, 24 do
        self.imgs[i] = 'sakuya_player' .. i
    end
end
function sakuya_player:frame()
    player_class.frame(self)
end

local lib = player_lib
local pu = lib.CreatePlayerUnit(5, "Sakuya", _t("name"), _t("subname"),
        'sakuya_player_pic', 308, 301, 0.5, sakuya_player,
        false, {
            { _t("Talent1name"), _t("Talent1des"), },
            { _t("Talent2name"), _t("Talent2des"), },
            { _t("Talent3name"), _t("Talent3des"), },
        }, 218, 75, 214)

--设置等级属性
sakuya_player.attribute = {
    [1] = lib.CreatePlayerAttributeList(20.0, 5, 0.65, 20.0,
            4.5, 2.5, 12, 12, 43),
    [10] = lib.CreatePlayerAttributeList(30.0, 5.5, 0.65, 25.0,
            4.5, 2.5, 16, 14, 45),
    [20] = lib.CreatePlayerAttributeList(40.0, 6, 0.6, 32.0,
            4.5, 2.5, 20, 16, 47),
}

lib.CreateSpellUnit(1, pu, "幻幽「迷幻的杰克」", "sakuya_player_spell1", {
    [1] = { dmg_index = 25, protect = 5, },
    [10] = { dmg_index = 30, protect = 7, },
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
    local dmg = player_lib.GetPlayerDmg() * self.dmg_index
    local t = int(self.protect_time * 60)
    p.nextspell = t
    p.protect = p.protect + t
    p.collect_line = p.collect_line - 600
    lstg.var.energy_efficiency = lstg.var.energy_efficiency - 0.75
    New(sakuya_player.bullets.sp_ef, t)
    New(tasker, function()
        for _ = 1, self.protect_time do
            PlaySound("clock")
            task.Wait(60)
        end
    end)
    New(tasker, function()
        for _ = 1, t do
            object.BulletDo(function(b)
                if not b._stop_x and not b._stop_y then
                    b._stop_x = b.x
                    b._stop_y = b.y
                end
                b.x = b._stop_x
                b.y = b._stop_y
            end)
            task.Wait()
        end
        p.collect_line = p.collect_line + 600
        lstg.var.energy_efficiency = lstg.var.energy_efficiency + 0.75
        PlaySound('slash', 1.0)
        object.EnemyNontjtDo(function(o)
            if o.colli and o.class.base.take_damage then
                Damage(o, dmg)
            end
        end)
        object.BulletDo(function(b)
            object.Kill(b)
        end)
    end)

    return t
end
function spell1:getDescribe()
    return _t("spelldes"):format(self.protect_time, self.dmg_index * 100)
end

local spells = { spell1 }
sakuya_player.spells = spells
do

    local bullets = {}
    sakuya_player.bullets = bullets
    local sp_ef = Class(object)
    bullets.sp_ef = sp_ef
    function sp_ef:init(t)
        self.layer = LAYER.TOP + 15
        self.group = GROUP.PLAYER
        self.colli = false

        self.bound = false
        self.R = 0
        task.New(self, function()
            for i = 1, 30 do
                self.R = self.R + 30
                stage_lib.SetGlobalMusicVolume(self, 1 - i / 30)
                task.Wait()
            end
            task.Wait(t - 60)
            for i = 1, 30 do
                self.R = self.R - 30
                stage_lib.SetGlobalMusicVolume(self, i / 30)
                task.Wait()
            end
            Del(self)
        end)
    end
    function sp_ef:frame()
        task.Do(self)
        self.x, self.y = player.x, player.y
    end
    function sp_ef:render()
        SetImageState("white", "add+sub", 255, 255, 255, 255)
        misc.SectorRender(self.x, self.y, 0, self.R, 0, 360, 75)
    end
end