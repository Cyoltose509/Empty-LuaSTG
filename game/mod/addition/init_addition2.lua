---一个新的定义tool，和init_addition.lua分开
-------------------------------------------------

local lib = stg_levelUPlib
local NewToolUnit = lib.NewToolUnit
local AddWaveEvent = lib.AddWaveEvent
local RemoveWaveEvent = lib.RemoveWaveEvent

---@param upl number@当前波所升等级
---@param fixed number@修正倍率
---@param slevel number@裨益自身等级
---@param sattri number@自机当前面板数值
local function GetBENEFITvalue(upl, fixed, slevel, sattri)
    upl = upl or 0
    fixed = fixed or 1
    slevel = slevel or 1
    sattri = sattri or 1
    return (1 + (slevel / 50) ^ 4) * (upl ^ (1.85 * (1.2 - slevel / 80))) * (2 ^ (6 - 50 / slevel)) / (sattri ^ (1 / fixed))
end

local function GetBENEFITLevel()
    if not IsValid(player) then
        return
    end
    local v = lstg.var
    local l = player_lib.GetLuck()  or 0
    local dangerM = 1 - 200 / (v.chaos + 500)
    local pl = task.SetMode[1](ran:Float(min(dangerM, l / 200), dangerM))
    return max(int(pl * 80), 1)
end
local BENEFITcolor = {
    { 200, 200, 200 },
    { 66, 157, 70 },
    { 80, 151, 242 },
    { 156, 40, 177 },
    { 255, 151, 0 },
    { 213, 1, 0 },
    { 3, 254, 235 },
    { 60, 60, 234 },
}

---注意，这样的裨益不能失去，否则会出现计算问题
---@param getValueFunc fun(d:number, flag:boolean)
local function NewBENEFIT(id, title, getValueFunc, setValueFunc, otherstr)
    local n = lib.NewSimpleAdditionUnit(id, 0, 1, title, function()
    end, "", function()
        return lstg.var._pathlike
    end)
    n.R, n.G, n.B = 132, 255, 227
    n.spBENEFIT = true
    otherstr = otherstr or "%s%0.2f"
    function n:RefreshFunc()
        self.BENEFIT_level = GetBENEFITLevel() or 1
        self.R, self.G, self.B = unpack(BENEFITcolor[math.ceil(self.BENEFIT_level / 10)])
        local value = getValueFunc(self.BENEFIT_level)
        value = max(0.01, int(value * 100) / 100)
        self.title4 = "【裨益SP】" .. ("(Lv.%d)"):format(self.BENEFIT_level) .. otherstr:format(title, value)
        self._add_value = value
    end
    n.event = function(d)
        if n._add_value and d == 1 then
            setValueFunc(n)
        end
    end
    table.remove(lib.ListByState[1], #lib.ListByState[1])
end
lib.NewBENEFIT = NewBENEFIT

local function DefineBENEFIT()
    NewBENEFIT(174, "攻击力+", function(slevel)
        local upl = lstg.tmpvar.level_up_count
        local fixed = 0.38
        local sattri = player_lib.GetPlayerDmg()
        return GetBENEFITvalue(upl, fixed, slevel, sattri)
    end, function(self)
        player.dmg_offset = player.dmg_offset + self._add_value
    end)
    NewBENEFIT(175, "幸运值+", function(slevel)
        local upl = lstg.tmpvar.level_up_count
        local fixed = 0.7
        local sattri = player_lib.GetLuck()
        return GetBENEFITvalue(upl, fixed, slevel, sattri)
    end, function(self)
        player_lib.AddLuck(self._add_value)
    end)
    NewBENEFIT(176, "移速+", function(slevel)
        local upl = lstg.tmpvar.level_up_count
        local fixed = 0.25
        local sattri = player_lib.GetPlayerSpeed()
        return GetBENEFITvalue(upl, fixed, slevel, sattri)
    end, function(self)
        player.lspeed_offset = player.lspeed_offset + self._add_value
        player.hspeed_offset = player.hspeed_offset + self._add_value
    end)
    NewBENEFIT(177, "射速+", function(slevel)
        local upl = lstg.tmpvar.level_up_count
        local fixed = 0.65
        local sattri = player_lib.GetShootAttribute()
        return GetBENEFITvalue(upl, fixed, slevel, sattri)
    end, function(self)
        local ss = player.shoot_set.speed
        ss.offset = ss.offset + self._add_value
    end)
    NewBENEFIT(178, "射程+", function(slevel)
        local upl = lstg.tmpvar.level_up_count
        local fixed = 0.72
        local sattri = select(3, player_lib.GetShootAttribute())
        return GetBENEFITvalue(upl, fixed, slevel, sattri)
    end, function(self)
        local ss = player.shoot_set.range
        ss.offset = ss.offset + self._add_value
    end)
end
stg_levelUPlib.DefineBENEFIT = DefineBENEFIT

local function DefineTool2()
    local function _t0(str)
        return Trans("addition_item", 1)[str] or ""
    end
    local function _t1(str)
        return Trans("addition_item", 2)[str] or ""
    end
    local function _t2(str)
        return Trans("addition_item", 3)[str] or ""
    end
    local function _t3(str)
        return Trans("addition_item", 4)[str] or ""
    end
    local function _t4(str)
        return Trans("addition_item", 5)[str] or ""
    end

    --0

    --1
    NewToolUnit(167, 1, 0, 156, _t1("旋转猫猫"), function(d, flag)
        if flag then
            lstg.tmpvar.rotate_cat = lstg.tmpvar.rotate_cat or {}
            table.insert(lstg.tmpvar.rotate_cat, New(lib.class5.rotate_cat, #lstg.tmpvar.rotate_cat))

        else
            if lstg.tmpvar.rotate_cat then
                if IsValid(lstg.tmpvar.rotate_cat[1]) then
                    Del(lstg.tmpvar.rotate_cat[1])
                    table.remove(lstg.tmpvar.rotate_cat, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(168, 1, 0, 157, _t1("黄豆包"), function(d, flag)
        if flag then
            lib.bun_cat_achievement()
            lstg.tmpvar.bun_cat1 = New(lib.class5.bun_cat, 1)
        else
            if IsValid(lstg.tmpvar.bun_cat1) then
                Del(lstg.tmpvar.bun_cat1)
            end
        end
    end, 1, true, true)
    NewToolUnit(169, 1, 0, 158, _t1("红豆包"), function(d, flag)
        if flag then
            lib.bun_cat_achievement()
            lstg.tmpvar.bun_cat2 = New(lib.class5.bun_cat, 2)
        else
            if IsValid(lstg.tmpvar.bun_cat2) then
                Del(lstg.tmpvar.bun_cat2)
            end
        end
    end, 1, true, true)
    NewToolUnit(170, 1, 0, 159, _t1("绿豆包"), function(d, flag)
        if flag then
            lib.bun_cat_achievement()
            lstg.tmpvar.bun_cat3 = New(lib.class5.bun_cat, 3)
        else
            if IsValid(lstg.tmpvar.bun_cat3) then
                Del(lstg.tmpvar.bun_cat3)
            end
        end
    end, 1, true, true)
    NewToolUnit(171, 1, 0, 160, _t1("蓝豆包"), function(d, flag)
        if flag then
            lib.bun_cat_achievement()
            lstg.tmpvar.bun_cat4 = New(lib.class5.bun_cat, 4)
        else
            if IsValid(lstg.tmpvar.bun_cat4) then
                Del(lstg.tmpvar.bun_cat4)
            end
        end
    end, 1, true, true)
    NewToolUnit(172, 1, 0, 161, _t1("垒叠的石头"), function(d, flag, otherflag)
        local v = lstg.var
        v.level_offset = v.level_offset - 1 * d
        if flag and not otherflag then
            AddExp((lib.GetCurMaxEXP(v.level + 1) - v.now_exp + 1) / v.exp_factor)
        end
    end, 1, false)
    NewToolUnit(180, 1, 0, 164, _t1("电子木鱼"), function(d, flag)
        local v = lstg.var
        local count = 0
        v.elec_fish = v.elec_fish + d
        if flag and v.elec_fish == 1 then
            player._playersys:addFrameBeforeEvent("elec_fish", 1, function()
                if v.frame_counting then
                    count = count + 1
                    while count >= 240 - v.elec_fish * 60 do
                        DropExpPoint(1, player.x, player.y + 40)
                        count = count - (240 - v.elec_fish * 60)
                    end
                end
            end)
        elseif not flag and v.elec_fish == 0 then
            player._playersys:removeFrameBeforeEvent("elec_fish")
        end
    end, 3, true)

    --2
    NewToolUnit(173, 2, 0, 162, _t2("石是球势"), function(d, flag)
        local v = lstg.var
        v.exp_factor = v.exp_factor + 0.5 * d
        v.exp_drop_factor = v.exp_drop_factor + 0.75 * d
    end, 1, false)
    NewToolUnit(181, 2, 0, 165, _t2("无情之地"), function(d, flag)
        local v = lstg.var
        v.fierce_place = v.fierce_place + d
        if flag and v.fierce_place == 1 then
            player._playersys:addFrameBeforeEvent("fierce_place", 1, function()
                if v.frame_counting then
                    object.EnemyNontjtDo(function(e)
                        if e.class.base.take_damage then
                            e.class.base.take_damage(e, (0.01 + v.fierce_place * 0.01) * (e.maxhp) / 60)
                        end
                    end)
                end
            end)
        elseif not flag and v.fierce_place == 0 then
            player._playersys:removeFrameBeforeEvent("fierce_place")
        end
    end, 3, true)
    --3
    NewToolUnit(179, 3, 0, 163, _t3("彼时结界"), function(d, flag)
        local v = lstg.var
        v.temporal_barrier = flag
    end, 1, false)

    --4
end
stg_levelUPlib.DefineTool2 = DefineTool2

local function bun_cat_achievement()
    local v = lstg.var
    if v.addition[168] and v.addition[169] and v.addition[170] and v.addition[171] then
        ext.achievement:get(151)
    end
end
stg_levelUPlib.bun_cat_achievement = bun_cat_achievement