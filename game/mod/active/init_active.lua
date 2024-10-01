local lib = activeItem_lib
local NewActiveUnit = lib.NewActiveUnit

local function DefineActive()
    local function _t0(str)
        return Trans("active_item", 1)[str] or str
    end
    local function _t1(str)
        return Trans("active_item", 2)[str] or str
    end
    local function _t2(str)
        return Trans("active_item", 3)[str] or str
    end
    local function _t3(str)
        return Trans("active_item", 4)[str] or str
    end
    local function _t4(str)
        return Trans("active_item", 5)[str] or str
    end

    NewActiveUnit(1, 1, _t1("神风！"), function()
        PlaySound("explode")
        local p = player
        p.nextsp = 25--小冷却
        player_lib.PlayerMiss(p, 5, "kamikaze")
        Newcharge_out(p.x, p.y, 250, 128, 114)
        local dmg = player_lib.GetPlayerDmg()
        local R = sqrt(dmg) * 20
        stg_levelUPlib.class.lifeboom_func(p.x, p.y, R, dmg * 0.1, 60, 250, 128, 114)
    end, 1, 1 / 900, 1)

end
activeItem_lib.DefineActive = DefineActive

local function InitActive()
    for _, u in ipairs(lib.ActiveTotalList) do
        u.pro_fixed = 1
        u.energy = 1
        --初始化属性
        u.type = u._type
        u.charge_c = u._charge_c
        u.energy_max = u._energy_max
    end

end
activeItem_lib.InitActive = InitActive