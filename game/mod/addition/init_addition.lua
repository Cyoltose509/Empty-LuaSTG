local lib = stg_levelUPlib
local NewNomalUnit = lib.NewNomalUnit
local NewToolUnit = lib.NewToolUnit
local AddWaveEvent = lib.AddWaveEvent
local RemoveWaveEvent = lib.RemoveWaveEvent

local function DefineOther()
    local function _t1(str)
        return Trans("addition", "BIYI")[str] or ""
    end
    local function _t2(str)
        return Trans("addition", "JIAOYI")[str] or ""
    end
    local function _t3(str)
        return Trans("addition", "QINGHAI")[str] or ""
    end
    NewNomalUnit(1, 0, 1, _t1("射程+10%"), function(d)
        local ss = player.shoot_set.range
        ss.factor = ss.factor + 0.1 * d
    end, _t1("des1"))
    NewNomalUnit(3, 0, 1, _t1("攻击力+10%"), function(d)
        local p = player
        p.dmg_factor = p.dmg_factor + 0.1 * d
    end, _t1("des3"))
    NewNomalUnit(4, 0, 1, _t1("生命值上限+5"), function(d)
        player_lib.AddMaxLife(5 * d)
    end, _t1("des4"))
    NewNomalUnit(8, 0, 1, _t1("幸运值+3.7"), function(d)
        player_lib.AddLuck(3.7 * d)
    end, _t1("des8"))
    NewNomalUnit(9, 0, 1, _t1("混沌值-5%"), function(d)

        player_lib.AddChaos(-5 * d)
    end, _t1("des9"), function()
        return lstg.var.chaos > 0
    end)
    NewNomalUnit(10, 0, 1, _t1("生命值回复10.00"), function(d)
        player_lib.AddLife(10)
    end, _t1("des10"))
    NewNomalUnit(15, 0, 1, _t1("符卡充能效率+7%"), function(d)
        local var = lstg.var
        var.energy_efficiency = var.energy_efficiency + 0.07 * d
    end, _t1("des15"))
    NewNomalUnit(19, 0, 1, _t1("经验获取倍率+10%"), function(d)
        local var = lstg.var
        var.exp_factor = var.exp_factor + 0.1 * d
    end, _t1("des19"))
    NewNomalUnit(65, 0, 1, _t1("自机射速+4%"), function(d)
        local ss = player.shoot_set.speed
        ss.factor = ss.factor + 0.04 * d
    end, _t1("des65"))

    NewNomalUnit(11, 0, 2, _t2("攻击力+15%，生命值上限-5"), function(d)
        player_lib.AddMaxLife(-5 * d)
        local p = player
        p.dmg_factor = p.dmg_factor + 0.15 * d
    end, _t2("des11"))
    NewNomalUnit(12, 0, 2, _t2("生命值上限+10，混沌值+11%"), function(d)
        player_lib.AddMaxLife(10 * d)
        player_lib.AddChaos(11 * d)
    end, _t2("des12"))
    NewNomalUnit(16, 0, 2, _t2("混沌值-10%，幸运值-4"), function(d)
        player_lib.AddChaos(-10 * d)
        player_lib.AddLuck(-4 * d)
    end, _t2("des16"))
    NewNomalUnit(33, 0, 2, _t2("自机移速+15%，攻击力-12%"), function(d)
        local p = player
        p.hspeed_factor = p.hspeed_factor + 0.15 * d
        p.lspeed_factor = p.lspeed_factor + 0.15 * d
        p.dmg_factor = p.dmg_factor - 0.12 * d
    end, _t2("des33"))
    NewNomalUnit(34, 0, 2, _t2("幸运值+4，生命值上限-4"), function(d)
        player_lib.AddLuck(4 * d)
        player_lib.AddMaxLife(-4 * d)
    end, _t2("des34"))
    NewNomalUnit(66, 0, 2, _t2("自机射速+7%，混沌值+9%"), function(d)
        local ss = player.shoot_set.speed
        ss.factor = ss.factor + 0.07 * d
        player_lib.AddChaos(9 * d)
    end, _t2("des66"))

    NewNomalUnit(13, 0, 3, _t3("混沌值+25%"), function(d)
        player_lib.AddChaos(25 * d)
    end, _t3("des13"))
    NewNomalUnit(14, 0, 3, _t3("生命值上限-7"), function(d)
        player_lib.AddMaxLife(-7 * d)
    end, _t3("des14"))
    NewNomalUnit(31, 0, 3, _t3("自机移速-20%"), function(d)
        player.hspeed_factor = player.hspeed_factor - 0.2 * d
        player.lspeed_factor = player.lspeed_factor - 0.2 * d
    end, _t3("des31"))
    NewNomalUnit(32, 0, 3, _t3("攻击力-25%"), function(d)
        local p = player
        p.dmg_factor = max(0, p.dmg_factor - 0.25 * d)
    end, _t3("des32"))
    NewNomalUnit(67, 0, 3, _t3("射速-20%"), function(d)
        local ss = player.shoot_set.speed
        ss.factor = ss.factor - 0.2 * d
    end, _t3("des67"))
    NewNomalUnit(68, 0, 3, _t3("弹速-20%"), function(d)
        local bv = player.shoot_set.bvelocity
        bv.factor = bv.factor - 0.20 * d
    end, _t3("des68"))
    NewNomalUnit(69, 0, 3, _t3("判定大小+15%"), function(d)
        player_lib.SetPlayerCollisize(nil, 0.15 * d)
    end, _t3("des69"))
end

local function DefineTool()
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
    NewToolUnit(28, 0, 0, 25, _t0("历经伤痛之心"), function(d, flag)
        local v = lstg.var
        v.forever33 = flag
    end, 1, true, true)
    NewToolUnit(36, 0, -0.3, 29, _t0("灵体外质"), function(d, flag)
        if flag then
            if not lstg.tmpvar.bomb_to_protect then
                lstg.tmpvar.bomb_to_protect = { count = 1 }
            else
                local bomb_to_protect = lstg.tmpvar.bomb_to_protect
                bomb_to_protect.count = bomb_to_protect.count + 1
            end
        else
            local bomb_to_protect = lstg.tmpvar.bomb_to_protect
            bomb_to_protect.count = bomb_to_protect.count - 1
            if bomb_to_protect.count == 0 then
                lstg.tmpvar.bomb_to_protect = nil
            end
        end
    end, 2, false)
    NewToolUnit(39, 0, 0, 32, _t0("疏与密的境界"), function(d, flag)
        local p = player
        player_lib.SetPlayerCollisize(0.5 * d, nil, 1 * d)
        if flag then
            p._playersys:addFrameBeforeEvent("refresh_grazer_colli", 1, function(self)
                self.grazer_colli = self.A * 18.6
            end)
        else
            p._playersys:removeFrameBeforeEvent("refresh_grazer_colli")
            p.grazer_colli = 24
        end
    end, 1, true, true)
    NewToolUnit(43, 0, 0, 36, _t0("反馈调节机"), function(d, flag)
        if flag then
            player._playersys:addFrameBeforeEvent("chaosadjuster", 1, function()

                local v = lstg.var
                if v.frame_counting then
                    if v.wave % 2 == 0 then
                        player_lib.AddChaos(-0.1 / 60)
                    else
                        player_lib.AddChaos(0.1 / 60)
                    end
                end
            end)
        else
            player._playersys:removeFrameBeforeEvent("chaosadjuster")
        end
    end, 1, true)
    NewToolUnit(46, 0, 0, 39, _t0("行稳致远"), function(d, flag)
        local p = player
        p.hspeed_offset = p.hspeed_offset - 0.3 * d
        p.lspeed_offset = p.lspeed_offset + 0.3 * d
        local v = lstg.var
        v.stable_hspeed, v.stable_lspeed = player_lib.GetPlayerSpeed()
    end, 3, true)
    NewToolUnit(48, 0, 0, 41, _t0("Blood Magic"), function(d, flag)
        local v = lstg.var
        v.blood_magic = flag
    end, 1, true, true)
    NewToolUnit(54, 0, 0, 47, _t0("便携式隙间"), function(d, flag)
        local p = player
        if flag then
            lstg.tmpvar.yukariTool1 = New(lib.class.YukariTool, -310, player.y, 90)
            lstg.tmpvar.yukariTool2 = New(lib.class.YukariTool, 310, player.y, 90)
            local t1, t2 = lstg.tmpvar.yukariTool1, lstg.tmpvar.yukariTool2
            t1.vscale = -1
            t1.opposite = t2
            t2.opposite = t1
            p._playersys:addFrameBeforeEvent("refreshYukariTool", 1, function()
                t1.y = t1.y + (-t1.y + player.y) * 0.1
                t2.y = t1.y
            end)
        else
            if IsValid(lstg.tmpvar.yukariTool1) then
                Del(lstg.tmpvar.yukariTool1)
            end
            if IsValid(lstg.tmpvar.yukariTool2) then
                Del(lstg.tmpvar.yukariTool2)
            end
            p._playersys:removeFrameBeforeEvent("refreshYukariTool")
        end
    end, 1, true, true)
    NewToolUnit(56, 0, 0, 49, _t0("天地有用"), function(d, flag)
        local p = player
        p.dmg_fixed = p.dmg_fixed + 0.5 * d
        lstg.var.reverse_shoot = flag
    end, 1, false, true)
    NewToolUnit(83, 0, 0, 72, _t0("偷天换日"), function(d, flag)
        local v = lstg.var
        v.steal_sun = flag
    end, 1, false)
    NewToolUnit(88, 0, 0, 77, _t0("运动学定律"), function(d, flag)
        local v = lstg.var
        v.kinematics = flag
        local ssb = player.shoot_set.bvelocity
        ssb.offset = ssb.offset + 0.3 * d
    end, 1, true, true)
    NewToolUnit(98, 0, 0, 87, _t0("可持续发展"), function(d, flag)
        if flag then
            AddWaveEvent("recycleAddition", 1, function()
                local t = ran:Float(0, 1)
                local pos = 1
                if t < 0.3 then
                    pos = 1
                elseif t < 0.7 then
                    pos = 2
                else
                    pos = 3
                end
                local k = lib.ListByState[pos][ran:Int(1, #lib.ListByState[pos])]
                lib.SetAddition(k, true)
                ext.notice_menu:AdditionAdd(k.id, "pin00", _t0("可持续发展!!"), 25)
            end)
        else
            RemoveWaveEvent("recycleAddition")
        end
    end, 1, true)
    NewToolUnit(102, 0, 0, 91, _t0("秘神的指引"), function(d, flag)
        lstg.weather.MustSeason5 = flag
    end, 1, false, true, function()
        return lstg.var._season_system
    end)
    NewToolUnit(107, 0, 0, 96, _t0("血色阴阳玉"), function(d, flag)
        if flag then
            player_lib.AddLife(10)
            if not IsValid(lstg.tmpvar.TPyyy) then
                lstg.tmpvar.TPyyy = New(lib.class2.TPyyy)
            end
        else
            if IsValid(lstg.tmpvar.TPyyy) then
                Del(lstg.tmpvar.TPyyy)
            end
        end
    end, 1, true)
    NewToolUnit(134, 0, 0, 123, _t0("分子重组仪"), function(d, flag, otherflag)
        if not otherflag then
            local lost = {}
            local get = {}
            local addition = sp:CopyTable(lstg.var.addition)
            for i, c in pairs(addition) do
                local l = lib.AdditionTotalList[i]
                if i ~= 134 and l.isTool and not l.temporary then
                    for _ = 1, c do
                        lib.RemoveAddition(l)
                        table.insert(lost, l)
                        local g = lib.GetAdditionList(1, function(p)
                            return p.isTool and p.id ~= i and p.id ~= 134
                        end)
                        if #g > 0 then
                            lib.SetAddition(g[1], true)
                            table.insert(get, g[1])
                        end
                    end
                end
            end
            if #get > 0 then
                ext.popup_menu:FlyIn(_t0("获得道具"), 255, 227, 132, get, "bonus")
            end
            if #lost > 0 then
                ext.popup_menu:FlyIn(_t0("失去道具"), 250, 128, 114, lost, "invalid")
            end
        end
    end, 1, false)
    NewToolUnit(136, 0, 0, 125, _t0("无间之钟"), function(d, flag)
        lstg.var.level_upOption = lstg.var.level_upOption + d
    end, 1, false, false, function()
        return not stage.current_stage.is_challenge
    end)
    NewToolUnit(137, 0, 0, 126, _t0("永恒的回音"), function(d, flag)
        lstg.var.infinite_nightmare = flag
        lstg.var.exp_factor = lstg.var.exp_factor + 0.2 * d
        if flag then
            lib.AdditionTotalList[136].pro_fixed = 0
            player_lib.AddChaos(25)
        else
            lib.AdditionTotalList[136].pro_fixed = 1
        end
    end, 1, false, false, function()
        return false
    end)
    NewToolUnit(142, 0, 0, 131, _t0("MAX M"), function(d, flag)
        lstg.var.MAX_M = flag
        local p = player
        p.hspeed_offset = p.hspeed_offset - 0.25 * d
        p.lspeed_offset = p.lspeed_offset - 0.25 * d
    end, 1, true)
    NewToolUnit(143, 0, 0, 132, _t0("幽灵沙包"), function(d, flag)
        if flag then
            lstg.tmpvar.soul_baby = lstg.tmpvar.soul_baby or {}
            table.insert(lstg.tmpvar.soul_baby, New(lib.class4.soul_baby))

        else
            if lstg.tmpvar.soul_baby then
                if IsValid(lstg.tmpvar.soul_baby[1]) then
                    Del(lstg.tmpvar.soul_baby[1])
                    table.remove(lstg.tmpvar.soul_baby, 1)
                end
            end
        end
    end, 1, true, true)
    NewToolUnit(151, 0, 0, 140, _t0("休止符"), function(d, flag)
        lstg.var.stop_0_tool = flag
        if not scoredata.stop_0_tool then
            scoredata.stop_0_tool = true
        end
    end, 1, false)
    NewToolUnit(153, 0, 0, 142, _t0("小小星球"), function(d, flag)
        local ss = player.shoot_set.range
        ss.offset = ss.offset + 7 * d
        ss.fixed = ss.fixed + 1.77 * d
        lstg.var.rotate_star = flag
    end, 1, false)
    NewToolUnit(158, 0, 0, 147, _t0("符札化络合物"), function(d, flag)
        lstg.var.nue_main_bullet = flag
    end, 1, false)

    NewToolUnit(02, 1, 0, 85, _t1("轻量储能包"), function(d)
        local v = lstg.var
        player_lib.SetEnergy(v.maxenergy - 7 * d)
    end, 1, true, true)
    NewToolUnit(05, 1, 0, 11, _t1("生命的丰穰"), function(d, flag)
        if flag then
            if not IsValid(lstg.tmpvar.lifeadder) then
                lstg.tmpvar.lifeadder = New(lib.class.lifeadder)
            else
                local lifeadder = lstg.tmpvar.lifeadder
                lifeadder.count = lifeadder.count + 1
            end
        else
            local lifeadder = lstg.tmpvar.lifeadder
            if IsValid(lifeadder) then
                lifeadder.count = lifeadder.count - 1
                if lifeadder.count == 0 then
                    Del(lifeadder)
                end
            end
        end
    end, 3, true)
    NewToolUnit(06, 1, 0, 12, _t1("生命爆炸之药"), function(d, flag)
        lstg.var.life_boom = lstg.var.life_boom + d
    end, 3, true)
    NewToolUnit(20, 1, 0, 17, _t1("纯粹的自信"), function(d, flag)
        if flag then
            if not IsValid(lstg.tmpvar.attackInProtect) then
                lstg.tmpvar.attackInProtect = New(lib.class.attackInProtect)
            else
                local attackInProtect = lstg.tmpvar.attackInProtect
                attackInProtect.count = attackInProtect.count + 1
            end
        else
            local attackInProtect = lstg.tmpvar.attackInProtect
            if IsValid(attackInProtect) then
                attackInProtect.count = attackInProtect.count - 1
                if attackInProtect.count == 0 then
                    Del(attackInProtect)
                end
            end
        end
    end, 3, true)
    NewToolUnit(23, 1, 0, 20, _t1("饥饿的狼犬"), function(d, flag)
        lstg.var.dmgfactor_withlifeleft = lstg.var.dmgfactor_withlifeleft + d
    end, 3, true)
    NewToolUnit(35, 1, 0, 28, _t1("幸运的招财猫"), function(d, flag)
        if flag then
            AddWaveEvent("addluck", 1, function()
                local v = lstg.var
                player_lib.AddLuck(min((-player_lib.GetLuck()  + 100) / 60, 1))
            end)
        else
            RemoveWaveEvent("addluck")
        end
    end, 1, false, true)
    NewToolUnit(38, 1, 0, 31, _t1("光学迷彩服"), function(d, flag)
        local p = player
        player_lib.SetPlayerCollisize(-0.1 * d)
        p._wisys.alpha = p._wisys.alpha - 1 / 3 * d
    end, 3, true)
    NewToolUnit(49, 1, 0, 42, _t1("伊吹大山岚"), function(d, flag)
        local p = player
        local v = lstg.var
        p.hspeed_offset = p.hspeed_offset + 0.25 * d
        p.lspeed_offset = p.lspeed_offset + 0.25 * d
        v.delete_bullet = v.delete_bullet + 0.05 * d
    end, 2, true)
    NewToolUnit(57, 1, 0, 50, _t1("积善成德"), function(d, flag)
        lstg.var.accumulate_exp = lstg.var.accumulate_exp + d
    end, 3, true)
    NewToolUnit(59, 1, 0, 52, _t1("背扉的秘国"), function(d, flag, otherflag)
        if flag then
            lstg.tmpvar.back_door = New(lib.class.back_door)
            if not otherflag then
                mission_lib.GoMission(34, 1 / 5 * 100)
            end
        else
            if IsValid(lstg.tmpvar.back_door) then
                Del(lstg.tmpvar.back_door)
            end
        end
    end, 1, true)
    NewToolUnit(60, 1, 0, 54, _t1("损坏的空间"), function(d, flag)
        if flag then
            lstg.tmpvar.broken_room = New(lib.class.broken_room)
            mission_lib.GoMission(23)
        else
            if IsValid(lstg.tmpvar.broken_room) then
                Del(lstg.tmpvar.broken_room)
            end
        end
    end, 1, false, true)
    NewToolUnit(70, 1, 0, 58, _t1("太阳表面"), function(d, flag)
        if flag then
            lstg.tmpvar.SUN = New(lib.class2.SUN)
        else
            if IsValid(lstg.tmpvar.SUN) then
                Del(lstg.tmpvar.SUN)
            end
        end
    end, 1, false)
    NewToolUnit(75, 1, 0, 63, _t1("颂德之玉"), function(d, flag)
        lstg.var.friendly_ball_huge = flag
    end, 1, false)
    NewToolUnit(79, 1, 0, 67, _t1("以血换血"), function(d, flag)
        lstg.var.lifelife_exchange = flag
        local tvar = lstg.tmpvar
        if flag then
            tvar.lifelife_exchangeCD = 0
            player._playersys:addFrameBeforeEvent("del_lifelife_exchangeCD", 1, function()
                tvar.lifelife_exchangeCD = max(0, tvar.lifelife_exchangeCD - 1)
            end)
        else
            player._playersys:removeFrameBeforeEvent("del_lifelife_exchangeCD")
            tvar.lifelife_exchangeCD = nil
        end
    end, 1, false, true)
    NewToolUnit(82, 1, 0, 71, _t1("月与海的传送门"), function(d, flag)
        local p = player
        p.hspeed_offset = p.hspeed_offset + 0.35 * d
        p.lspeed_offset = p.lspeed_offset + 0.35 * d
        local v = lstg.var
        v.borderless_moving = flag
        player.outborder_time = 0
        player.borderless_offset = 0
    end, 1, true, true)
    NewToolUnit(91, 1, 0, 80, _t1("完美散华"), function(d, flag)
        local v = lstg.var
        v.perfect_spread = v.perfect_spread + d
    end, 2, true, true)
    NewToolUnit(92, 1, 0, 81, _t1("寂静的冬天"), function(d, flag)
        local v = lstg.var
        v.fallen_snow = flag
        if flag then
            lstg.tmpvar.fallen_snow_winter_ef = New(lib.class2.fallen_snow_winter_ef)
        else
            if IsValid(lstg.tmpvar.fallen_snow_winter_ef) then
                Del(lstg.tmpvar.fallen_snow_winter_ef)
            end
        end
    end, 1, true, true)
    NewToolUnit(95, 1, 0, 84, _t1("赤蛮奇之头"), function(d, flag)
        if flag then
            lstg.tmpvar.sekibanki_head = {}
            for i = 1, 3 do
                table.insert(lstg.tmpvar.sekibanki_head, New(lib.class2.sekibanki_head, i * 120))
            end
        else
            for _, p in ipairs(lstg.tmpvar.sekibanki_head) do
                if IsValid(p) then
                    Del(p)
                end
            end
        end
    end, 1, true, true)
    NewToolUnit(97, 1, 0, 86, _t1("龙颈之玉"), function(d, flag)
        if flag then
            lstg.tmpvar.dragon_jade = New(lib.class3.dragon_jade)
        else
            if IsValid(lstg.tmpvar.dragon_jade) then
                Del(lstg.tmpvar.dragon_jade)
            end
        end
    end, 1, true, true)
    NewToolUnit(99, 1, 0, 88, _t1("火鼠的皮衣"), function(d, flag)
        if flag then
            lstg.tmpvar.fire_drop_shooter = New(lib.class3.fire_drop_shooter)
        else
            if IsValid(lstg.tmpvar.fire_drop_shooter) then
                Del(lstg.tmpvar.fire_drop_shooter)
            end
        end
    end, 1, true, true)
    NewToolUnit(103, 1, 0, 92, _t1("公转轨道异常"), function(d, flag)
        local w = lstg.weather
        for i = 1, 5 do
            w.season_last[i] = w.season_last[i] + d
        end
    end, 1, true, true, function()
        return lstg.var._season_system and not lstg.var._pathlike
    end)
    NewToolUnit(104, 1, 0, 93, _t1("天气之神的眷顾"), function(d, flag)
        lstg.weather.TwiceXiangRui = flag
    end, 1, false, nil, function()
        return lstg.var._season_system and not lstg.var._pathlike
    end)
    NewToolUnit(109, 1, 0, 98, _t1("量子弹幕"), function(d, flag)
        lstg.var.quantum_bullet = flag
    end, 1, false)
    NewToolUnit(110, 1, 0, 99, _t1("幻无垢"), function(d, flag)
        lstg.var.del_bullet_with_enemy = flag
    end, 1, false)
    NewToolUnit(117, 1, 0, 106, _t1("佛的御石钵"), function(d, flag)
        local v = lstg.var
        v.protect_time_ex = v.protect_time_ex + 26 * d
        v.buddhist_diamond = flag
    end, 1, true, true)
    NewToolUnit(118, 1, 0, 107, _t1("加长反射弧"), function(d, flag)
        lstg.var.reflex_arc = flag
    end, 1, true)
    NewToolUnit(120, 1, 0, 109, _t1("自指悖论"), function(d, flag)
        lstg.var.self_paradox = flag
    end, 1, true)
    NewToolUnit(121, 1, 0, 110, _t1("黑雾异变"), function(d, flag)
        if flag then
            lstg.tmpvar.black_fog_circle = New(lib.class2.black_fog_circle)
        else
            if IsValid(lstg.tmpvar.black_fog_circle) then
                Del(lstg.tmpvar.black_fog_circle)
            end
        end
    end, 1, true, true)
    NewToolUnit(138, 1, 0, 127, _t1("过往的风花"), function(d, flag)
        if flag then
            AddWaveEvent("randomTemporary", 1, function()
                local lvl_lib = stg_levelUPlib
                if lstg.tmpvar.randomTemporary then
                    local t = lstg.tmpvar.randomTemporary
                    t.temporary = false
                    for _ = 1, t.maxcount do
                        lvl_lib.RemoveAddition(t)
                    end
                    lstg.tmpvar.randomTemporary = nil
                end
                local othercond = function(tool)
                    return tool.isTool and not lstg.var.addition[tool.id]
                end
                local tool = lvl_lib.GetAdditionList(1, othercond)[1]
                if tool then
                    tool.temporary = true
                    for _ = 1, tool.maxcount do
                        lvl_lib.SetAddition(tool, true, true)
                    end
                end
                lstg.tmpvar.randomTemporary = tool
                if tool then
                    ext.notice_menu:AdditionAdd(tool.id, "pin00", _t1("过往的风花"), 25, 255, 227, 132)
                end
            end)
            lstg.tmpvar.huyuelin_baby = New(lib.class4.huyuelin_baby)
        else
            RemoveWaveEvent("randomTemporary")
            if lstg.tmpvar.randomTemporary then
                local t = lstg.tmpvar.randomTemporary
                t.temporary = false
                lstg.tmpvar.randomTemporary = nil
            end
            if IsValid(lstg.tmpvar.huyuelin_baby) then
                Del(lstg.tmpvar.huyuelin_baby)
            end
        end
    end, 1, false)
    NewToolUnit(141, 1, 0, 130, _t1("上海人偶"), function(d, flag)
        if flag then
            lstg.tmpvar.ningyou_baby = lstg.tmpvar.ningyou_baby or {}
            table.insert(lstg.tmpvar.ningyou_baby, New(lib.class4.ningyou_baby))
        else
            if lstg.tmpvar.ningyou_baby then
                if IsValid(lstg.tmpvar.ningyou_baby[1]) then
                    Del(lstg.tmpvar.ningyou_baby[1])
                    table.remove(lstg.tmpvar.ningyou_baby, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(145, 1, 0, 134, _t1("死宛团子宝宝"), function(d, flag)
        if flag then
            lib.siyuan_achievement()
            lstg.tmpvar.siyuan_baby1 = lstg.tmpvar.siyuan_baby1 or {}
            table.insert(lstg.tmpvar.siyuan_baby1, New(lib.class4.siyuan_baby1))
        else
            if lstg.tmpvar.siyuan_baby1 then
                if IsValid(lstg.tmpvar.siyuan_baby1[1]) then
                    Del(lstg.tmpvar.siyuan_baby1[1])
                    table.remove(lstg.tmpvar.siyuan_baby1, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(146, 1, 0, 135, _t1("安产大炮"), function(d, flag)
        local ss = player.shoot_set.speed
        ss.offset = ss.offset + 1.4 * d
        lstg.var.rotate_shoot_rot = flag
    end, 1, false, true)
    NewToolUnit(148, 1, 0, 137, _t1("流汗猫猫"), function(d, flag)
        if flag then
            lstg.tmpvar.sweat_cat = lstg.tmpvar.sweat_cat or {}
            table.insert(lstg.tmpvar.sweat_cat, New(lib.class4.sweat_cat))
        else
            if lstg.tmpvar.sweat_cat then
                if IsValid(lstg.tmpvar.sweat_cat[1]) then
                    Del(lstg.tmpvar.sweat_cat[1])
                    table.remove(lstg.tmpvar.sweat_cat, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(149, 1, 0, 138, _t1("大喷菇"), function(d, flag)
        if flag then
            lstg.tmpvar.mushroom_baby = lstg.tmpvar.mushroom_baby or {}
            table.insert(lstg.tmpvar.mushroom_baby, New(lib.class4.mushroom_baby))
        else
            if lstg.tmpvar.mushroom_baby then
                if IsValid(lstg.tmpvar.mushroom_baby[1]) then
                    Del(lstg.tmpvar.mushroom_baby[1])
                    table.remove(lstg.tmpvar.mushroom_baby, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(154, 1, 0, 143, _t1("梅露兰的小号"), function(d, flag)
        local p = player
        p.dmg_fixed = p.dmg_fixed - 0.8 * d
        local ss = p.shoot_set.speed
        ss.offset = ss.offset + 1 * d
        ss.fixed = ss.fixed + 1.5 * d
        local tvar = lstg.tmpvar
        if flag then
            tvar.player_bullet_scale = tvar.player_bullet_scale * 0.7
        else
            tvar.player_bullet_scale = tvar.player_bullet_scale / 0.7
        end
    end, 1, false, true)
    NewToolUnit(156, 1, 0, 145, _t1("膜膜膜"), function(d, flag)
        player.dmg_offset = player.dmg_offset + 0.2 * d
        if flag then
            lib.siyuan_achievement()
            lstg.tmpvar.siyuan_baby4 = lstg.tmpvar.siyuan_baby4 or {}
            table.insert(lstg.tmpvar.siyuan_baby4, New(lib.class4.siyuan_baby4))
        else
            if lstg.tmpvar.siyuan_baby4 then
                if IsValid(lstg.tmpvar.siyuan_baby4[1]) then
                    Del(lstg.tmpvar.siyuan_baby4[1])
                    table.remove(lstg.tmpvar.siyuan_baby4, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(159, 1, 0, 148, _t1("小小星之伞"), function(d, flag)
        local v = lstg.var
        v.protect_kogasa = flag
        v.protect_kogasa_CD = 0
        if flag then
            player._playersys:addFrameBeforeEvent("protect_kogasa_CD", 1, function(p)
                v.protect_kogasa_CD = max(v.protect_kogasa_CD - 1, 0)
            end)
        else
            player._playersys:removeFrameBeforeEvent("protect_kogasa_CD")
        end
    end, 1, true, true)
    NewToolUnit(160, 1, 0, 149, _t1("Game Killer"), function(d, flag)
        local v = lstg.var
        v.game_killer = flag
    end, 1, true, true)
    NewToolUnit(163, 1, 0, 152, _t1("摆烂小孩"), function(d, flag)
        if flag then
            lib.siyuan_achievement()
            lstg.tmpvar.siyuan_baby5 = lstg.tmpvar.siyuan_baby5 or {}
            table.insert(lstg.tmpvar.siyuan_baby5, New(lib.class4.siyuan_baby5))
        else
            if lstg.tmpvar.siyuan_baby5 then
                if IsValid(lstg.tmpvar.siyuan_baby5[1]) then
                    Del(lstg.tmpvar.siyuan_baby5[1])
                    table.remove(lstg.tmpvar.siyuan_baby5, 1)
                end
            end
        end
    end, 10, true, true)
    NewToolUnit(165, 1, 0, 154, _t1("旋转水皿"), function(d, flag)
        if flag then
            AddWaveEvent("protect_dish", 1, function()
                for _ = 1, 3 do
                    New(lib.class4.protect_dish, ran:Float(-290, 290), ran:Float(-200, 200))
                end
            end)
        else
            RemoveWaveEvent("protect_dish")
        end
    end, 1, false)

    NewToolUnit(7, 2, 0, 13, _t2("女仆飞刀"), function(d, flag)
        if flag then
            if not IsValid(lstg.tmpvar.straightknife_shooter) then
                lstg.tmpvar.straightknife_shooter = New(lib.class.straightknife_shooter)
            else
                local straightknife_shooter = lstg.tmpvar.straightknife_shooter
                straightknife_shooter.count = straightknife_shooter.count + 1
            end
        else
            local straightknife_shooter = lstg.tmpvar.straightknife_shooter
            if IsValid(straightknife_shooter) then
                straightknife_shooter.count = straightknife_shooter.count - 1
                if straightknife_shooter.count == 0 then
                    Del(straightknife_shooter)
                end
            end
        end
    end, 3, true)
    NewToolUnit(17, 2, 0, 14, _t2("金刚不灭之身"), function(d, flag)
        lstg.var.goldenbody = flag
        if flag then
            lstg.tmpvar.golden_body = New(lib.class2.golden_body)
        else
            if IsValid(lstg.tmpvar.golden_body) then
                Del(lstg.tmpvar.golden_body)
            end
        end
    end, 1, false, true)
    NewToolUnit(22, 2, 0, 19, _t2("吸血鬼之牙"), function(d, flag)
        local var = lstg.var
        var.heal_factor = var.heal_factor + 0.0016 * d
    end, 3, false)
    NewToolUnit(25, 2, 0, 22, _t2("专注法阵"), function(d, flag)
        if flag then
            lstg.tmpvar.strength_aura = New(lib.class.strength_aura)
        else
            if IsValid(lstg.tmpvar.strength_aura) then
                Del(lstg.tmpvar.strength_aura)
            end
        end
    end, 1, true)
    NewToolUnit(30, 2, 0, 27, _t2("魔力护瓶"), function(d, flag)
        if flag then
            if not IsValid(lstg.tmpvar.magic_bottle) then
                lstg.tmpvar.magic_bottle = New(lib.class.magic_bottle_renderer)
            else
                local magic_bottle = lstg.tmpvar.magic_bottle
                magic_bottle.count = magic_bottle.count + 1
                magic_bottle.dev_value = min(magic_bottle.dev_value, 100 - magic_bottle.count * 30)
            end
            mission_lib.GoMission(44)
        else
            local magic_bottle = lstg.tmpvar.magic_bottle
            if IsValid(magic_bottle) then
                magic_bottle.count = magic_bottle.count - 1
                magic_bottle.dev_value = min(magic_bottle.dev_value, 100 - magic_bottle.count * 30)
                if magic_bottle.count == 0 then
                    Del(magic_bottle)
                end
            end
        end
    end, 2, true, true)
    NewToolUnit(44, 2, 0, 37, _t2("平安喜乐"), function(d, flag)
        lstg.var.peace_chaos = flag
    end, 1, true, true)
    NewToolUnit(45, 2, 0, 38, _t2("⑨之祝福"), function(d, flag)
        local v = lstg.var
        local p = player
        p.dmg_offset = p.dmg_offset + 0.9 * d
        p.hspeed_offset = p.hspeed_offset + 0.9 * d
        p.lspeed_offset = p.lspeed_offset + 0.9 * d
        player_lib.SetPlayerCollisize(-0.09 * d)
        player_lib.AddMaxLife(9 * d)
        player_lib.AddLife(9 * d)
        player_lib.AddChaos(-0.9 * d)
        player_lib.SetEnergy(v.maxenergy - 0.9 * d)
        if flag then
            if lstg.var.addition[24] then
                mission_lib.GoMission(8)
            end
            local othert = lib.AdditionTotalList[24]
            othert.pro_fixed = othert.pro_fixed + 9
        else
            local othert = lib.AdditionTotalList[24]
            othert.pro_fixed = othert.pro_fixed - 9
        end
    end, 1, false, true)
    NewToolUnit(52, 2, 0, 45, _t2("一对的自我"), function(d, flag)
        local p = player
        if flag then
            lstg.tmpvar.fake_player = New(lib.class.fake_player)
            p._wisys.alpha2 = p._wisys.alpha2 * 0.7
            AddWaveEvent("refresh_fakeplayer", 1, function()
                task.New(lstg.tmpvar.fake_player, function()
                    local self = task.GetSelf()
                    for i = 1, 10 do
                        self.vscale = 1 + i / 10
                        self.hscale = 1 - i / 10
                        task.Wait()
                    end
                    self.x, self.y = player.x, player.y
                    for i = 1, 10 do
                        self.vscale = 2 - i / 10
                        self.hscale = i / 10
                        task.Wait()
                    end
                end)
            end)
        else
            if IsValid(lstg.tmpvar.fake_player) then
                Del(lstg.tmpvar.fake_player)
            end
            p._wisys.alpha2 = p._wisys.alpha2 / 0.7
            RemoveWaveEvent("refresh_fakeplayer")
        end
    end, 1, false, true)
    NewToolUnit(55, 2, 0, 48, _t2("见血封喉术"), function(d, flag)
        local p = player
        p.dmg_offset = p.dmg_offset + 0.5 * d
        p.dmg_fixed = p.dmg_fixed + 0.25 * d
        if flag then
            p._playersys:addFrameBeforeEvent("damage_when_shoot", 1, function(self)
                if lstg.var.frame_counting then
                    if self.__shoot_flag and self.nextshoot <= 0 then
                        local v = lstg.var
                        local n = player_lib.ReduceLife(0.0045 * max(v.maxlife, 50) / 35, true)
                        if v.cowrie_shell and n and n > 0 then
                            v.weak_life = v.weak_life + n
                            v.maxweak_life = v.maxweak_life + n
                        end
                    end
                end
            end)
        else
            p._playersys:removeFrameBeforeEvent("damage_when_shoot")
        end
    end, 1, false, true)
    NewToolUnit(61, 2, 0, 53, _t2("正体不明的飞仓"), function(d, flag)
        lstg.var.nue_special_bullet = flag
    end, 1)
    NewToolUnit(62, 2, 0, 55, _t2("ToDo清单"), function(d, flag)
        local var = lstg.var
        local p = player
        if flag then
            var.todo_graze_check = 100 + 50 * var.wave
            var.todo_graze = 0
            local finish_flag
            p._playersys:addGrazingBeforeEvent("addpower", 1, function(self)
                var.todo_graze = var.todo_graze + 1
                if var.todo_graze >= var.todo_graze_check and not finish_flag then
                    finish_flag = true
                    local k = lib.GetAdditionList(1, function(tool)
                        return tool.isTool and tool.quality ~= 0
                    end)
                    if k[1] then
                        lib.SetAddition(k[1], true)
                        ext.notice_menu:AdditionAdd(k[1].id, "bonus2", _t2("ToDo擦弹成功!!"))
                    end
                end
            end)
            AddWaveEvent("todo_graze", 1, function()
                local last_graze = var.todo_graze
                local w = var.wave + 1
                var.todo_graze_check = int(0.8 * last_graze + w * w)
                var.todo_graze = 0
                finish_flag = false
            end)
        else
            var.todo_graze_check = nil
            var.todo_graze = 0
            p._playersys:removeGrazingBeforeEvent("addpower")
            RemoveWaveEvent("todo_graze")
        end
    end, 1, false, true)
    NewToolUnit(71, 2, 0, 59, _t2("便携式后户"), function(d, flag)
        local ss = player.shoot_set.range
        ss.offset = ss.offset + 7 * d
        lstg.var.shuttle_main_bullet = flag
    end, 1, false, true)
    NewToolUnit(73, 2, 0, 61, _t2("极欲的暴食"), function(d, flag)
        local v = lstg.var
        v.violent_eater = flag
        v.violent_eater_n = 0
        v.violent_eater_CD = 0
        if flag then
            player._playersys:addFrameBeforeEvent("violent_eater", 1, function(p)
                v.violent_eater_CD = max(v.violent_eater_CD - 1, 0)
                if v.violent_eater_CD == 0 then
                    if v.violent_eater_n > 0 then
                        p.grazer_colli_factor = p.grazer_colli_factor - 0.01 * v.violent_eater_n * 0.02
                        v.violent_eater_n = v.violent_eater_n - v.violent_eater_n * 0.02
                    end
                end
            end)
            player._playersys:addGrazingBeforeEvent("violent_eater", 1, function(p)
                if v.violent_eater_n < 200 then
                    p.grazer_colli_factor = p.grazer_colli_factor + 0.01
                    v.violent_eater_n = v.violent_eater_n + 1
                end
                v.violent_eater_CD = 10
            end)
        else
            player._playersys:removeFrameBeforeEvent("violent_eater")
            player._playersys:removeGrazingBeforeEvent("violent_eater")
        end
    end, 1, false, true)
    NewToolUnit(76, 2, 0, 64, _t2("向神山的贡品"), function(d, flag)
        if flag then
            player_lib.AddLife(25)
            player.collect_line = player.collect_line - 64
        else
            player.collect_line = player.collect_line + 64
        end
    end, 1, true, true)
    NewToolUnit(78, 2, 0, 66, _t2("妖怪测谎仪"), function(d, flag)
        if flag then
            if not IsValid(lstg.tmpvar.lie_detector) then
                lstg.tmpvar.lie_detector = New(lib.class2.lie_detector)
            else
                lstg.tmpvar.lie_detector.count = lstg.tmpvar.lie_detector.count + 1
            end
            if lstg.tmpvar.god_circle_with_lie_detector then
                for i = lstg.tmpvar.lie_detector.count * 3 - 2, lstg.tmpvar.lie_detector.count * 3 do
                    lstg.tmpvar.god_circle_with_lie_detector[i] = New(lib.class3.god_circle_with_lie_detector, i)
                end
            end
        else
            local lie_detector = lstg.tmpvar.lie_detector
            if IsValid(lie_detector) then
                local god_circle = lstg.tmpvar.god_circle_with_lie_detector
                if god_circle then
                    for i = lie_detector.count * 3 - 2, lie_detector.count * 3 do
                        if IsValid(god_circle[i]) then
                            Del(god_circle[i])
                        end
                    end
                end
                lie_detector.count = lie_detector.count - 1
                if lie_detector.count == 0 then
                    Del(lie_detector)
                end
            end
        end
    end, 2, true)
    NewToolUnit(80, 2, 0, 68, _t2("硝酸甘油"), function(d, flag)
        local v = lstg.var
        if flag then
            v.bomb_healing = v.bomb_healing or 0 --开大回血
            v.bomb_healing = v.bomb_healing + 8
        else
            v.bomb_healing = v.bomb_healing - 8
            if v.bomb_healing == 0 then
                v.bomb_healing = nil
            end
        end
    end, 2, true, true)
    NewToolUnit(81, 2, 0, 69, _t2("经验血袋"), function(d, flag)
        lstg.var.levelup_healing = flag
    end, 1, true, true)
    NewToolUnit(85, 2, 0, 74, _t2("EXHP"), function(d, flag)
        lstg.var.hp_to_exp = flag
    end, 1, true, true)
    NewToolUnit(87, 2, 0, 76, _t2("以命汲命"), function(d, flag)
        local v = lstg.var
        v.chip_addmaxlife = flag
    end, 1, true)
    NewToolUnit(94, 2, 0, 83, _t2("符海突击学说"), function(d, flag)
        local p = player
        p.dmg_fixed = p.dmg_fixed - 0.34 * d
        local ss = p.shoot_set.speed
        ss.offset = ss.offset + 1 * d
        ss.fixed = ss.fixed + 0.5 * d
        p.shoot_angle_off = p.shoot_angle_off + 15 * d
    end, 1, false, true)
    NewToolUnit(114, 2, 0, 103, _t2("燕的子安贝"), function(d, flag)
        lstg.var.cowrie_shell = flag
        if flag then
            player._playersys:addFrameBeforeEvent("cowrie_shell", 1, function()

                local v = lstg.var
                if v.frame_counting then
                    if v.weak_life > 0 then
                        local n = player_lib.AddLife(v.maxweak_life / 360) or 0
                        v.weak_life = max(0, v.weak_life - n)
                    else
                        v.maxweak_life = 0
                    end
                end
            end)
        end
    end, 1, false, true)
    NewToolUnit(116, 2, 0, 105, _t2("中子星"), function(d, flag)
        lstg.var.neutron_star = flag
        local p = player
        p.hspeed_offset = p.hspeed_offset - 0.45 * d
        p.lspeed_offset = p.lspeed_offset - 0.45 * d
        player_lib.SetPlayerCollisize(0, 0, -0.25 * d)
    end, 1, false, true)
    NewToolUnit(119, 2, 0, 108, _t2("虚与实的境界"), function(d, flag)
        if flag then
            player._playersys:addFrameBeforeEvent("fake_and_real", 1, function(p)
                if p._playersys:keyIsPressed("slow") then
                    local mindist1, mindist2 = 999, 999
                    local target1, target2
                    object.BulletIndesDo(function(o)
                        local dist = Dist(p, o)
                        if dist < mindist1 then
                            mindist1 = dist
                            target1 = o
                        end
                    end)
                    object.BulletIndesDo(function(o)
                        local dist = Dist(p, o)
                        if dist < mindist2 and dist > mindist1 then
                            mindist2 = dist
                            target2 = o
                        end
                    end)
                    if IsValid(target1) then
                        New(lib.class2.fake_and_real_eff, target1)
                        bullet.setfakeColli(target1, target1._no_colli)
                    end
                    if IsValid(target2) then
                        New(lib.class2.fake_and_real_eff, target2)
                        bullet.setfakeColli(target2, target2._no_colli)
                    end
                end
            end)
        else
            player._playersys:removeFrameBeforeEvent("fake_and_real")
        end
    end, 1, true, true)
    NewToolUnit(122, 2, 0, 111, _t2("具现化记忆"), function(d, flag)
        local ss = player.shoot_set.speed
        ss.offset = ss.offset + 0.7 * d
        local sr = player.shoot_set.range
        sr.fixed = sr.fixed + 1 * d
        lstg.var.return_bullet = flag
    end, 1, false)
    NewToolUnit(135, 2, 0, 124, _t2("永远的幼月"), function(d, flag)
        lstg.var.forever_scarlet = flag
    end, 1, false)
    NewToolUnit(139, 2, 0, 128, _t2("茶杯灵梦"), function(d, flag)
        if flag then
            lstg.tmpvar.reimu_baby = lstg.tmpvar.reimu_baby or {}
            table.insert(lstg.tmpvar.reimu_baby, New(lib.class4.reimu_baby))
        else
            if lstg.tmpvar.reimu_baby then
                if IsValid(lstg.tmpvar.reimu_baby[1]) then
                    Del(lstg.tmpvar.reimu_baby[1])
                    table.remove(lstg.tmpvar.reimu_baby, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(140, 2, 0, 129, _t2("茶杯魔理沙"), function(d, flag)
        if flag then
            lstg.tmpvar.marisa_baby = lstg.tmpvar.marisa_baby or {}
            table.insert(lstg.tmpvar.marisa_baby, New(lib.class4.marisa_baby))
        else
            if lstg.tmpvar.marisa_baby then
                if IsValid(lstg.tmpvar.marisa_baby[1]) then
                    Del(lstg.tmpvar.marisa_baby[1])
                    table.remove(lstg.tmpvar.marisa_baby, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(144, 2, 0, 133, _t2("后撤的大人"), function(d, flag)
        local v = lstg.var
        v.behind_main_bullet = flag
    end, 1, false)
    NewToolUnit(147, 2, 0, 136, _t2("招财宛"), function(d, flag)
        if flag then
            lib.siyuan_achievement()
            lstg.tmpvar.siyuan_baby2 = lstg.tmpvar.siyuan_baby2 or {}
            table.insert(lstg.tmpvar.siyuan_baby2, New(lib.class4.siyuan_baby2))
        else
            if lstg.tmpvar.siyuan_baby2 then
                if IsValid(lstg.tmpvar.siyuan_baby2[1]) then
                    Del(lstg.tmpvar.siyuan_baby2[1])
                    table.remove(lstg.tmpvar.siyuan_baby2, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(152, 2, 0, 141, _t2("Mimichan"), function(d, flag)
        local p = player
        local v = lstg.var
        p.dmg_offset = p.dmg_offset + 1.5 * d
        v.is_mimichan = flag
        if flag then
            player_lib.SetPlayerBulletImg(2,"mimichan_bullet")
        else
            player_lib.SetPlayerBulletImg(2)
        end
    end, 1, false, true)
    NewToolUnit(155, 2, 5, 144, _t2("深海七花"), function(d, flag, otherflag)
        local var = lstg.var
        local tvar = lstg.tmpvar
        local eventArr = {
            function()
                if flag then
                    if not otherflag then
                        ext.popup_menu:FlyInOneTool(_t2("深海七花之绿(恢复25生命值)"), 100, 255, 100, 155, "bonus")
                    end
                    player_lib.AddLife(25)
                end
            end,
            function()
                if flag then
                    if not otherflag then
                        ext.popup_menu:FlyInOneTool(_t2("深海七花之红(生命上限+10)"), 250, 100, 100, 155, "bonus")
                    end
                end
                player_lib.AddMaxLife(10 * d)
            end,
            function()
                if not otherflag then
                    if flag then
                        local list = stg_levelUPlib.GetAdditionList(3, function(p)
                            return p.state == 1 and not p.spBENEFIT
                        end)
                        var.seven_flower_BiYi_list = list
                        local show_list = sp:CopyTable(list)
                        table.insert(show_list, lib.AdditionTotalList[155])
                        ext.popup_menu:FlyIn(_t2("深海七花之紫(获得3个裨益)"), 218, 112, 214, show_list, "bonus")
                        for _, p in ipairs(list) do
                            stg_levelUPlib.SetAddition(p)
                        end
                    else
                        if var.seven_flower_BiYi_list then
                            for _, p in ipairs(var.seven_flower_BiYi_list) do
                                stg_levelUPlib.RemoveAddition(p)
                            end
                        end
                    end
                end
            end,
            function()
                if not otherflag then
                    if flag then
                        local list = {}
                        local QingHai_list = {}
                        local count = (var.addition_count[3]) or 0
                        for k, p in pairs(var.addition) do
                            local tool = lib.AdditionTotalList[k]
                            if tool.state == 3 then
                                for _ = 1, p do
                                    table.insert(QingHai_list, tool)
                                end
                            end
                        end
                        for _ = 1, min(count, 3) do
                            table.insert(list, table.remove(QingHai_list, ran:Int(1, #QingHai_list)))
                        end
                        var.seven_flower_QingHai_list = list
                        local show_list = sp:CopyTable(list)
                        table.insert(show_list, lib.AdditionTotalList[155])
                        ext.popup_menu:FlyIn(_t2("深海七花之橙(删除3个灾害)"), 135, 200, 200, show_list, "bonus")
                        for _, p in ipairs(list) do
                            stg_levelUPlib.RemoveAddition(p)
                        end
                    else
                        if var.seven_flower_QingHai_list then
                            for _, p in ipairs(var.seven_flower_QingHai_list) do
                                stg_levelUPlib.SetAddition(p)
                            end
                        end
                    end
                end
            end,
            function()
                if not otherflag then
                    if flag then
                        local list = {}
                        local Broken_list = {}
                        local count = 0
                        for k, p in pairs(var.addition) do
                            local tool = lib.AdditionTotalList[k]
                            if tool.broken then
                                for _ = 1, p do
                                    count = count + 1
                                    table.insert(Broken_list, tool)
                                end
                            end
                        end
                        for _ = 1, min(count, 3) do
                            table.insert(list, table.remove(Broken_list, ran:Int(1, #Broken_list)))
                        end
                        var.seven_flower_Broken_list = list
                        local show_list = sp:CopyTable(list)
                        table.insert(show_list, lib.AdditionTotalList[155])
                        ext.popup_menu:FlyIn(_t2("深海七花之青(修复3个损坏的道具)"), 135, 206, 235, show_list, "bonus")
                        for _, p in ipairs(list) do
                            stg_levelUPlib.RecoverAddition(p)
                        end
                    else
                        if var.seven_flower_Broken_list then
                            for _, p in ipairs(var.seven_flower_Broken_list) do
                                stg_levelUPlib.BreakAddition(p)
                            end
                        end
                    end
                end
            end,
            function()
                if flag and not otherflag then
                    ext.popup_menu:FlyInOneTool(_t2("深海七花之黄(缩短夏季时长)"), 255, 227, 132, 155, "bonus")
                end
                local w = lstg.weather
                w.season_last[2] = w.season_last[2] - d
            end,
            function()
                if flag and not otherflag then
                    ext.popup_menu:FlyInOneTool(_t2("深海七花之蓝(缩短冬季时长)"), 130, 140, 222, 155, "bonus")
                end
                local w = lstg.weather
                w.season_last[4] = w.season_last[4] - d
            end
        }
        tvar.seven_flower_count = tvar.seven_flower_count or 0
        if flag then
            tvar.seven_flower_count = tvar.seven_flower_count + 1
            eventArr[var.seven_flowers[tvar.seven_flower_count]]()
        else
            eventArr[var.seven_flowers[tvar.seven_flower_count]]()
            tvar.seven_flower_count = tvar.seven_flower_count - 1
        end
    end, 7, false, true)
    NewToolUnit(157, 2, 0, 146, _t2("扭臀猫猫"), function(d, flag)
        local ss = player.shoot_set.speed
        ss.offset = ss.offset + 0.9 * d
        if flag then
            lstg.tmpvar.tease_cat = lstg.tmpvar.tease_cat or {}
            table.insert(lstg.tmpvar.tease_cat, New(lib.class4.tease_cat))
        else
            if lstg.tmpvar.tease_cat then
                if IsValid(lstg.tmpvar.tease_cat[1]) then
                    Del(lstg.tmpvar.tease_cat[1])
                    table.remove(lstg.tmpvar.tease_cat, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(164, 2, 0, 153, _t2("向侧之月"), function(d, flag)
        if flag then
            lstg.tmpvar.protect_moon = New(lib.class4.protect_moon)
            AddWaveEvent("150achievement", 1, function()
                lstg.tmpvar.protect_moon_achievement = lstg.var.chaos >= 100
            end)
            lib.AddWaveFinalEvent("150achievement", 1, function()
                if lstg.tmpvar.protect_moon_achievement then
                    ext.achievement:get(150)
                end
            end)
        else
            if IsValid(lstg.tmpvar.protect_moon) then
                Del(lstg.tmpvar.protect_moon)
            end
            RemoveWaveEvent("150achievement")
            lib.RemoveWaveFinalEvent("150achievement")
        end
    end, 1, false, true)
    NewToolUnit(166, 2, 0, 155, _t2("异议！"), function(d, flag)
        if flag then
            lstg.tmpvar.igiari_shooter = New(lib.class4.igiari_shooter)
        else
            if IsValid(lstg.tmpvar.igiari_shooter) then
                Del(lstg.tmpvar.igiari_shooter)
            end
        end
    end, 1, false)

    NewToolUnit(18, 3, 0, 15, _t3("水獭灵的帮助"), function(d, flag)
        if flag then
            if not IsValid(lstg.tmpvar.greenhyper_center) then
                lstg.tmpvar.greenhyper_center = New(lib.class.GreenHyperCenter)
            else
                local greenhyper_center = lstg.tmpvar.greenhyper_center
                greenhyper_center.count = greenhyper_center.count + 1
            end
        else
            local greenhyper_center = lstg.tmpvar.greenhyper_center
            if IsValid(greenhyper_center) then
                greenhyper_center.count = greenhyper_center.count - 1
                if greenhyper_center.count == 0 then
                    Del(lstg.tmpvar.greenhyper_center)
                end
            end
        end
    end, 2, false)
    NewToolUnit(21, 3, 0, 18, _t3("守财奴的教训"), function(d, flag)
        local var = lstg.var
        var.graze_exp = min(1, var.graze_exp + 0.15 * d)
        var.graze_exp_count = 0
    end, 3, false, true)
    NewToolUnit(24, 3, 0, 21, _t3("冰之妖精"), function(d, flag)
        if flag then
            if lstg.var.addition[45] then
                mission_lib.GoMission(8)
            end
            if not IsValid(lstg.tmpvar.small_ice_shooter) then
                lstg.tmpvar.small_ice_shooter = New(lib.class.small_ice_shooter)
            else
                local small_ice_shooter = lstg.tmpvar.small_ice_shooter
                small_ice_shooter.count = small_ice_shooter.count + 1
            end
        else
            local small_ice_shooter = lstg.tmpvar.small_ice_shooter
            if IsValid(small_ice_shooter) then
                small_ice_shooter.count = small_ice_shooter.count - 1
                if small_ice_shooter.count == 0 then
                    Del(small_ice_shooter)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(26, 3, 0, 23, _t3("经验探测仪"), function(d, flag)
        if flag then
            if not IsValid(lstg.tmpvar.exp_pendulum_shooter) then
                lstg.tmpvar.exp_pendulum_shooter = New(lib.class.exp_pendulum_shooter)
            else
                local exp_pendulum_shooter = lstg.tmpvar.exp_pendulum_shooter
                exp_pendulum_shooter.count = exp_pendulum_shooter.count + 1
            end
        else
            local exp_pendulum_shooter = lstg.tmpvar.exp_pendulum_shooter
            if IsValid(exp_pendulum_shooter) then
                exp_pendulum_shooter.count = exp_pendulum_shooter.count - 1
                if exp_pendulum_shooter.count == 0 then
                    Del(exp_pendulum_shooter)
                end
            end
        end
    end, 3, false, true)
    NewToolUnit(29, 3, 10, 26, _t3("大促销：神子牌令牌"), function(d, flag, otherflag)
        if flag then
            local count = lstg.var.addition[29] or 0
            if not otherflag then
                if ran:Float(0, 1) < 0.17 + count * 0.06 and count <= 16 then
                    lib.SetAddition(lib.AdditionTotalList[29])
                    ext.popup_menu:FlyInOneTool(_t3("买一送一！"), 255, 227, 132, 29, "bonus2")
                end --买一送一
            end
            if not IsValid(lstg.tmpvar.miko_laser_shooter) then
                lstg.tmpvar.miko_laser_shooter = New(lib.class.miko_laser_shooter)
            else
                local miko_laser_shooter = lstg.tmpvar.miko_laser_shooter
                miko_laser_shooter.count = miko_laser_shooter.count + 1
            end
            if count == 17 then
                lstg.tmpvar.miko_laser_back = New(_editor_class.MikoBack, player, -90, 1)
                ext.achievement:get(86)
            end
        else
            local miko_laser_shooter = lstg.tmpvar.miko_laser_shooter
            if IsValid(miko_laser_shooter) then
                miko_laser_shooter.count = miko_laser_shooter.count - 1
                if miko_laser_shooter.count == 0 then
                    Del(miko_laser_shooter)
                end
                if IsValid(lstg.tmpvar.miko_laser_back) and miko_laser_shooter.count <= 16 then
                    Del(lstg.tmpvar.miko_laser_back)
                end
            end
        end
    end, 17, false)
    NewToolUnit(37, 3, 0, 30, _t3("心连心"), function(d, flag)
        lstg.var.kokoro_musubu = flag
    end, 1, false)
    NewToolUnit(50, 3, 0, 43, _t3("生与死的境界"), function(d, flag)
        local var = lstg.var
        var.life_dead = flag
        if flag then
            AddWaveEvent("life_dead_refresh", 1, function()
                var.life_dead = true
            end)
        else
            RemoveWaveEvent("life_dead_refresh")
        end
    end, 1, false, true)
    NewToolUnit(53, 3, 0, 46, _t3("恐慌的笼罩"), function(d, flag)
        if flag then
            lstg.tmpvar.scaring_mask = New(lib.class.scaring_mask)
        else
            if IsValid(lstg.tmpvar.scaring_mask) then
                Del(lstg.tmpvar.scaring_mask)
            end
        end
    end, 1, false, false, function()
        return false
    end)
    NewToolUnit(63, 3, 0, 56, _t3("蓬莱人形"), function(d, flag)
        if flag then
            lstg.tmpvar.ningyouer = New(lib.class.ningyouer)
        else
            if IsValid(lstg.tmpvar.ningyouer) then
                Del(lstg.tmpvar.ningyouer)
            end
        end
    end, 1, false, true)
    NewToolUnit(72, 3, 0, 60, _t3("引诱式黄泉"), function(d, flag)
        local ssr = player.shoot_set.range
        ssr.offset = ssr.offset + 7 * d
        local ssb = player.shoot_set.bvelocity
        ssb.offset = ssb.offset - 2.5 * d
        lstg.var.trail_main_bullet = flag
    end, 1, false)
    NewToolUnit(74, 3, 0, 62, _t3("不死的尾羽"), function(d, flag)
        lstg.var.fire_bird_resurrection = flag
        lstg.tmpvar.bird_resurrecting = false
        lstg.tmpvar.bird_resurrected = 0
    end, 1, true, true)
    NewToolUnit(77, 3, 0, 65, _t3("幽谷回响"), function(d, flag)
        local ssr = player.shoot_set.range
        ssr.offset = ssr.offset + 7 * d
        lstg.var.bound_main_bullet = flag
    end, 1, false, true)
    NewToolUnit(84, 3, 0, 73, _t3("时间回溯"), function(d, flag)
        lstg.var.rewindable = flag
    end, 1, false, true)
    NewToolUnit(89, 3, 0, 78, _t3("破碎的护身符"), function(d, flag)
        local p = player
        local v = lstg.var
        if flag then
            p._playersys:addFrameBeforeEvent("chaos_remove30", 1, function()
                if v.chaos >= 30 then
                    NewBon(player.x, player.y, 30, 60, 200, 64, 64)
                    PlaySound("nice")
                    player_lib.AddChaos(-30)
                    lib.BreakAddition(lib.AdditionTotalList[89])
                end
            end)
        else
            p._playersys:removeFrameBeforeEvent("chaos_remove30")
        end
    end, 1, false, true, function()
        return not lstg.var._pathlike
    end)
    NewToolUnit(93, 3, 0, 82, _t3("风神的祝歌"), function(d, flag)
        local v = lstg.var
        v.snake_main_bullet = flag
    end, 1, false, true)
    NewToolUnit(96, 3, 0, 70, _t3("灵力槽"), function(d, flag)
        player_lib.SetEnergy(nil, lstg.var.energy_stack + 1 * d)
    end, 1, false, true)
    NewToolUnit(100, 3, 0, 89, _t3("Powerful Point"), function(d, flag)
        lstg.var.powerful_point = flag
    end, 1, false)
    NewToolUnit(101, 3, 0, 90, _t3("蓬莱的玉枝"), function(d, flag)
        lstg.tmpvar.penglai_jade_count = 0
        if flag then
            player._playersys:addFrameBeforeEvent("shoot_penglai_jade", 1, function(self)
                if self.__shoot_flag and self.nextshoot <= 0 then
                    if self.timer % 45 == 0 then
                        local t = ran:Int(1, 3)
                        local c = (t - 1) / 2
                        local tA = -90
                        if lstg.var.reverse_shoot then
                            tA = 90
                        end
                        for m = -c, c do
                            New(lib.class3.penglai_jade_bullet, self.x, self.y, 10, tA + m * 20 + ran:Float(-9, 9), player_lib.GetPlayerDmg() * 1.2)
                        end
                    end
                end
            end)
        else
            player._playersys:removeFrameBeforeEvent("shoot_penglai_jade")
        end
    end, 1, false, true)
    NewToolUnit(105, 3, 0, 94, _t3("幻想万华镜"), function(d, flag)
        lstg.var.mangekyou = flag
    end, 1, false, true)
    NewToolUnit(106, 3, 0, 95, _t3("九代稗谷"), function(d, flag)
        lstg.var.resurrect9 = max(0, lstg.var.resurrect9 + 8 * d)
    end, 1, false, true)
    NewToolUnit(108, 3, 0, 97, _t3("活力的繁星"), function(d, flag)
        lstg.var.active_star = flag
        if flag then
            if not IsValid(lstg.tmpvar.active_star_back) then
                lstg.tmpvar.active_star_back = New(lib.class2.active_star_back)
            end
        else
            if IsValid(lstg.tmpvar.active_star_back) then
                Del(lstg.tmpvar.active_star_back)
            end
        end
    end, 1, false)
    NewToolUnit(111, 3, 0, 100, _t3("幻想烟花"), function(d, flag)
        player.dmg_offset = player.dmg_offset + 1 * d
        local ss = player.shoot_set.speed
        ss.fixed = ss.fixed - 0.77 * d
        local sr = player.shoot_set.range
        sr.offset = sr.offset - 3.5 * d
        sr.fixed = sr.fixed - 0.34 * d
        lstg.var.imaginary_main_bullet = flag
    end, 1, false, true)
    NewToolUnit(112, 3, -0.3, 101, _t3("生之残梦"), function(d, flag)
        lstg.var.ikinokosu_yume = lstg.var.ikinokosu_yume + d
    end, 3, false, true)
    NewToolUnit(113, 3, 0, 102, _t3("荷取牌能量盾"), function(d, flag)
        local var = lstg.var
        if flag then
            var.kappa_shield_count = var.kappa_shield_count + 1
            lstg.tmpvar.kappa_shield = New(lib.class2.kappa_shield)
            AddWaveEvent("refresh_kappa_shield", 1, function()
                local before = int(var.kappa_shield_count)
                var.kappa_shield_count = min(3, var.kappa_shield_count + 0.75)
                local after = int(var.kappa_shield_count)
                if after - before > 0 then
                    lstg.tmpvar.kappa_shield.index = 1
                    PlaySound("kappa_shield_on")
                end
            end)
        else
            RemoveWaveEvent("refresh_kappa_shield")
            var.kappa_shield_count = 0
            if IsValid(lstg.tmpvar.kappa_shield) then
                Del(lstg.tmpvar.kappa_shield)
            end
        end
    end, 1, false, true)
    NewToolUnit(123, 3, 0, 112, _t3("绯红的专注"), function(d, flag)
        lstg.var.scarlet_focus = lstg.var.scarlet_focus + d
    end, 3, true, true)
    NewToolUnit(124, 3, 0, 113, _t3("冰之鳞"), function(d, flag)
        if flag then
            lstg.tmpvar.wave_bullet_shooter = New(lib.class3.wave_bullet_shooter)
        else
            if IsValid(lstg.tmpvar.wave_bullet_shooter) then
                Del(lstg.tmpvar.wave_bullet_shooter)
            end
        end
    end, 1, false, true)
    NewToolUnit(125, 3, 0, 114, _t3("贤者之石"), function(d, flag)
        lstg.var.philosopher_stone = flag
    end, 1, false, true)
    NewToolUnit(126, 3, 0, 115, _t3("宝塔的神光"), function(d, flag)
        if flag then
            lstg.tmpvar.god_circle = New(lib.class3.god_circle)
            lstg.tmpvar.god_circle_with_lie_detector = {}
            if IsValid(lstg.tmpvar.lie_detector) then
                for i = 1, lstg.tmpvar.lie_detector.count * 3 do
                    lstg.tmpvar.god_circle_with_lie_detector[i] = New(lib.class3.god_circle_with_lie_detector, i)
                end
            end
        else
            if IsValid(lstg.tmpvar.god_circle) then
                Del(lstg.tmpvar.god_circle)
            end
            for _, de in pairs(lstg.tmpvar.god_circle_with_lie_detector) do
                if IsValid(de) then
                    Del(de)
                end
            end
            lstg.tmpvar.god_circle_with_lie_detector = nil
        end
    end, 1, false)
    NewToolUnit(127, 3, 0, 116, _t3("疯狂的火炬"), function(d, flag)
        local v = lstg.var
        v.crazy_torch = v.crazy_torch + d
        if v.crazy_torch == 1 and d == 1 then
            local p = player
            p._playersys:addFrameBeforeEvent("adddmg_crazy_torch", 1, function()
                local var = lstg.var
                if var.frame_counting then
                    if var.crazy_torch > 0 then
                        var.crazy_torch_t = max(var.crazy_torch_t - 1, 0)
                        if var.crazy_torch_t >= 120 then
                            var.crazy_torch_n = max(var.crazy_torch_n - 1 / 15, 0)
                        elseif var.crazy_torch_t < 30 then
                            if var.crazy_torch_n <= 25 then
                                var.crazy_torch_n = 0
                            else
                                var.crazy_torch_n = max(var.crazy_torch_n - 2, 0)
                            end
                        end
                    end
                end
            end)
        elseif v.crazy_torch == 0 and d == -1 then
            local p = player
            p._playersys:removeFrameBeforeEvent("adddmg_crazy_torch")
        end
    end, 3, false, true)
    NewToolUnit(128, 3, 0, 117, _t3("玻璃大炮"), function(d, flag)
        local p = player
        p.dmg_fixed = p.dmg_fixed + 0.69 * d
        local v = lstg.var
        v.glass_bon = flag
        local tvar = lstg.tmpvar
        if flag then
            player_lib.AddMaxLife(-v.maxlife + 20)
            tvar.player_bullet_scale = tvar.player_bullet_scale * 1.69
        else
            tvar.player_bullet_scale = tvar.player_bullet_scale / 1.69
        end
    end, 1, false, true)
    NewToolUnit(129, 3, 0, 118, _t3("寻求者"), function(d, flag)
        local v = lstg.var
        v.red_main_bullet = flag
        if v.addition[129] and v.addition[130] and v.addition[131] then
            ext.achievement:get(106)
        end
    end, 1, false, true)
    NewToolUnit(130, 3, 0, 119, _t3("渴望者"), function(d, flag)
        local v = lstg.var
        v.green_main_bullet = flag
        if v.addition[129] and v.addition[130] and v.addition[131] then
            ext.achievement:get(106)
        end
    end, 1, false, true)
    NewToolUnit(131, 3, 0, 120, _t3("喜爱者"), function(d, flag)
        local v = lstg.var
        v.blue_main_bullet = flag
        if v.addition[129] and v.addition[130] and v.addition[131] then
            ext.achievement:get(106)
        end
    end, 1, false, true)
    NewToolUnit(150, 3, 0, 139, _t3("拉拉宛"), function(d, flag)
        if flag then
            lib.siyuan_achievement()
            lstg.tmpvar.siyuan_baby3 = lstg.tmpvar.siyuan_baby3 or {}
            table.insert(lstg.tmpvar.siyuan_baby3, New(lib.class4.siyuan_baby3))
        else
            if lstg.tmpvar.siyuan_baby3 then
                if IsValid(lstg.tmpvar.siyuan_baby3[1]) then
                    Del(lstg.tmpvar.siyuan_baby3[1])
                    table.remove(lstg.tmpvar.siyuan_baby3, 1)
                end
            end
        end
    end, 3, true, true)
    NewToolUnit(161, 3, 0, 150, _t3("团子生命力"), function(d, flag)
        local v = lstg.var
        v.chip_adddmg = flag
    end, 1, false, true)

    NewToolUnit(27, 4, 0, 24, _t4("幽魂梦舞"), function(d, flag)
        if flag then
            local baodi = -16
            local graze_count = 0
            local var = lstg.var
            player._playersys:addGrazingBeforeEvent("tracing_soul", 1, function(p, _, other)
                graze_count = graze_count + 1
                if graze_count == 2 then
                    local yes = (min(player_lib.GetLuck() , 5) + 15 / 66 + baodi) * min(player_lib.GetLuck() , 1)
                    yes = yes / 100
                    local c = ran:Float(0, 1)
                    if c <= yes then
                        baodi = max(-16, baodi - 8)
                        local dmg = player_lib.GetPlayerDmg()
                        New(lib.class.tracing_soul, other.x, other.y, 9, c * 360, dmg * 0.2, 288)
                        if other.group == GROUP.ENEMY_BULLET then
                            object.Del(other)
                        end
                    else
                        baodi = min(40, baodi + 8)
                    end
                    graze_count = 0
                end
            end)
        else
            player._playersys:removeGrazingBeforeEvent("tracing_soul")
        end
    end, 1, false)
    NewToolUnit(40, 4, 0, 33, _t4("天星之沐愿(绿)"), function(d, flag)
        local v = lstg.var
        v.green_wish = v.green_wish + d
        if v.green_wish == 1 and d == 1 then
            lib.AdditionTotalList[41].pro_fixed = 0
            lib.AdditionTotalList[42].pro_fixed = 0
        elseif v.green_wish == 0 and d == -1 then
            lib.AdditionTotalList[41].pro_fixed = 1
            lib.AdditionTotalList[42].pro_fixed = 1
        end
    end, 3, false)
    NewToolUnit(41, 4, 0, 34, _t4("天星之沐愿(蓝)"), function(d, flag)
        local v = lstg.var
        v.blue_wish = v.blue_wish + d
        v.exp_factor = v.exp_factor + 0.2 * d
        if v.blue_wish == 1 and d == 1 then
            v.exp_factor = v.exp_factor - 0.5
            v.level_upOption = v.level_upOption - 1
            lib.AdditionTotalList[40].pro_fixed = 0
            lib.AdditionTotalList[42].pro_fixed = 0
        elseif v.blue_wish == 0 and d == -1 then
            v.exp_factor = v.exp_factor + 0.5
            v.level_upOption = v.level_upOption + 1
            lib.AdditionTotalList[40].pro_fixed = 1
            lib.AdditionTotalList[42].pro_fixed = 1
        end
    end, 3, false)
    NewToolUnit(42, 4, 0, 35, _t4("天星之沐愿(红)"), function(d, flag)
        local v = lstg.var
        v.red_wish = v.red_wish + d
        if v.red_wish == 1 and d == 1 then
            lib.AdditionTotalList[40].pro_fixed = 0
            lib.AdditionTotalList[41].pro_fixed = 0
        elseif v.red_wish == 0 and d == -1 then
            lib.AdditionTotalList[40].pro_fixed = 1
            lib.AdditionTotalList[41].pro_fixed = 1
        end
    end, 3, false)
    NewToolUnit(47, 4, 0, 40, _t4("妖精联结"), function(d, flag)
        local v = lstg.var
        v.enemy_contact = v.enemy_contact + 0.04 * d
        if flag then
            lstg.tmpvar.enemy_contact_ef = New(lib.class2.enemy_contact_ef)
        else
            if IsValid(lstg.tmpvar.enemy_contact_ef) then
                Del(lstg.tmpvar.enemy_contact_ef)
            end
        end
    end, 1, false, true)
    NewToolUnit(51, 4, 0, 44, _t4("光之屏障"), function(d, flag)
        if flag then
            lstg.tmpvar.blue_barrier = New(lib.class.blue_barrier)
        else
            if IsValid(lstg.tmpvar.blue_barrier) then
                Del(lstg.tmpvar.blue_barrier)
            end
        end
    end, 1, false)
    NewToolUnit(58, 4, 0, 51, _t4("樱花结界"), function(d, flag)
        if flag then
            if lstg.var._season_system then
                local w = lstg.weather
                w.season_last[1] = w.season_last[1] + 1
            end
            lib.sakura_kekkai_init()
        else
            if lstg.var._season_system then
                local w = lstg.weather
                w.season_last[1] = w.season_last[1] - 1
            end
            lib.sakura_kekkai_fade()
        end
    end, 1, false, true)
    NewToolUnit(64, 4, 0, 57, _t4("贪欲的敛财"), function(d, flag)
        local var = lstg.var
        var.greedy_exp = flag
        var.level_offset = var.level_offset - 7 * d
        AddExp(0)
    end, 1, false, true)
    NewToolUnit(86, 4, 0, 75, _t4("阴晴圆缺"), function(d, flag)
        lstg.var.dmg_reduction = flag
    end, 1, false, true)
    NewToolUnit(90, 4, 0, 79, _t4("甘美之毒"), function(d, flag)
        local ss = player.shoot_set.speed
        ss.offset = ss.offset + 0.7 * d
        lstg.var.posion_dot = flag
    end, 1, false, true)
    NewToolUnit(115, 4, 0, 104, _t4("护守之莲"), function(d, flag)
        local var = lstg.var
        var.protect_lotus = flag
        if flag then
            lstg.tmpvar.protect_lotus = New(lib.class2.protect_lotus)
        else
            var.lotus_record_b = 0
            var.lotus_count = 0
            if IsValid(lstg.tmpvar.protect_lotus) then
                Del(lstg.tmpvar.protect_lotus)
            end
        end
    end, 1, false, true)
    NewToolUnit(132, 4, 0, 121, _t4("怪力乱神"), function(d, flag)
        local p = player
        p.dmg_offset = p.dmg_offset + 1 * d
        p.dmg_fixed = p.dmg_fixed + 0.67 * d
    end, 1, false)
    NewToolUnit(133, 4, 0, 122, _t4("封之术法"), function(d, flag)
        lstg.var.cyoltose = flag
        local tvar = lstg.tmpvar
        tvar.cyoltose_style = nil
        tvar.cyoltose_color = nil
        if flag then
            AddWaveEvent("resetCyoltose_Get", 1, function()
                tvar.cyoltose_style = nil
                tvar.cyoltose_color = nil
            end)
        else
            RemoveWaveEvent("resetCyoltose_Get")
        end
    end, 1, false, true)
    NewToolUnit(162, 4, 0, 151, _t4("死亡十字"), function(d, flag)
        lstg.var.cross_laser = lstg.var.cross_laser + d
    end, 2, false)
end

local function PrintOut()
    local file1 = io.open("User\\what2.lua", "wb")
    file1:write([[local t = stg_levelUPlib.tagslist
]])
    file1:write([[local GongFeng = Trans("addition", "GongFeng")
]])
    file1:write("\n")
    file1:write("return {\n")
    for k = 1, 5 do
        file1:write("{\n")
        for i, p in ipairs(lib.AdditionTotalList) do
            if p.isTool then
                if k == p.quality + 1 then
                    if true then
                        file1:write(("[\"%s\"] = \"%s\",\n"):format(p.title2, p.title2))
                    else
                        file1:write(("[%d] = {\n"):format(i))
                        file1:write(("stitle = [[%s]],\n"):format(p.subtitle))
                        file1:write(("sdes = [[%s]],\n"):format(p.describe))
                        file1:write(("detail = [[%s]],\n"):format(p.detail))
                        file1:write(("repeatd = [[%s]],\n"):format(p.repeat_des))
                        file1:write(("tags = %s,\n"):format(STT(p.tags)))
                        file1:write(("collabd = [[%s]],\n"):format(p.collab_des))
                        file1:write(("unlockd = [[%s]],\n"):format(p.unlock_des))
                        file1:write(("condd = [[%s]],\n"):format(p.cond_des))
                        file1:write("},\n")
                    end
                end
            end
        end
        file1:write("},\n")
    end
    file1:write([[}]])
end

local function DefineAddition()
    lib.AdditionList = {}--当前的列表
    lib.ListByQual = { {}, {}, {}, {}, {} }
    lib.ListByTags = {}
    lib.ListByState = {}
    lib.AdditionTotalList = {}--总加成列表
    DefineOther()
    lib.DefineBENEFIT()
    DefineTool()
    lib.DefineTool2()
    lib.SortToolUnits()
    for name, str in pairs(lib.tagslist) do
        lib.ListByTags[name] = {}
        ---@param p addition_unit
        for _, p in pairs(lib.AdditionTotalList) do
            if p.tags then
                for _, n in ipairs(p.tags) do
                    if n == str then
                        table.insert(lib.ListByTags[name], p)
                        break
                    end
                end
            end
        end

    end
    --PrintOut()
end
stg_levelUPlib.DefineAddition = DefineAddition

local function InitAddition()
    for _, u in ipairs(lib.AdditionTotalList) do
        u.pro_fixed = 1
        u.broken = false
        u.temporary = false
    end
    lib.SortToolUnits()
end
stg_levelUPlib.InitAddition = InitAddition

local function BirdResurrecting()
    local var = lstg.var
    PlaySound("explode")
    PlaySound("resurrecting")
    var.lifeleft = 0.001
    New(lib.class2.resurrection_bird)
end
stg_levelUPlib.BirdResurrecting = BirdResurrecting

local function Rewinding()
    local var = lstg.var
    local tvar = lstg.tmpvar
    local wea = lstg.weather
    local self = stage.current_stage
    var.rewindable = false
    var.lifeleft = 0.001
    tvar.rewind_resurrecting = true
    player.StopLoss = true
    PlaySound("rewind_clock")
    player.lock = true
    object.EnemyNontjtDo(function(b)
        task.Clear(b)
    end)
    object.BulletIndesDo(function(b)
        task.Clear(b)
    end)
    for _, b in ObjList(GROUP.PLAYER) do
        task.Clear(b)
    end
    task.Clear(self)

    task.New(self, function()
        task.New(self, function()
            for i = 1, 120 do
                local k = task.SetMode[2](i / 120 * 2)
                i = task.SetMode[2](i / 120)
                local viewbillboard = lstg.viewbillboard
                local eye = viewbillboard.eye
                local at = viewbillboard.at
                local t = 15 + i * 140
                eye[1], eye[2], eye[3] = cos(t) * 1.5, 1 - i * 2, sin(t) * 1.5 + 0.5
                at[1], at[2], at[3] = 0, 0, 0.5
                viewbillboard.fovy = 1
                ext.OtherScreenEff:Open(function()
                    SetViewMode("ui")
                    SetImageState("white", "", 255, 0, 0, 0)
                    local cx, cy = 480, 270
                    misc.SectorRender(cx, cy, 0, k * 600, 0, 360, 80)
                    viewbillboard:Set3D()
                    local s = k * 0.8
                    local z = 0.5
                    Render4V("level_obj_rewind_clock", -s, s, z, s, s, z, s, -s, z, -s, -s, z)
                    SetImageState("white", "", 255, 255, 255, 255)
                    local mA = 90 - i * 30
                    local x1, y1, x2, y2, x3, y3, x4, y4 = 0, 0.005, s * 0.4, 0.005, s * 0.4, -0.005, 0, -0.005
                    x1, y1 = cos(mA) * x1 - sin(mA) * y1, cos(mA) * y1 + sin(mA) * x1
                    x2, y2 = cos(mA) * x2 - sin(mA) * y2, cos(mA) * y2 + sin(mA) * x2
                    x3, y3 = cos(mA) * x3 - sin(mA) * y3, cos(mA) * y3 + sin(mA) * x3
                    x4, y4 = cos(mA) * x4 - sin(mA) * y4, cos(mA) * y4 + sin(mA) * x4
                    Render4V("white", x1, y1, z, x2, y2, z, x3, y3, z, x4, y4, z)
                    mA = 90 - i * 360
                    x1, y1, x2, y2, x3, y3, x4, y4 = 0, 0.002, s * 0.45, 0.002, s * 0.45, -0.002, 0, -0.002
                    x1, y1 = cos(mA) * x1 - sin(mA) * y1, cos(mA) * y1 + sin(mA) * x1
                    x2, y2 = cos(mA) * x2 - sin(mA) * y2, cos(mA) * y2 + sin(mA) * x2
                    x3, y3 = cos(mA) * x3 - sin(mA) * y3, cos(mA) * y3 + sin(mA) * x3
                    x4, y4 = cos(mA) * x4 - sin(mA) * y4, cos(mA) * y4 + sin(mA) * x4
                    Render4V("white", x1, y1, z, x2, y2, z, x3, y3, z, x4, y4, z)
                    -- Set3dMode("ui")
                end, true)
                task.Wait()
            end
        end)
        task.Wait(60)
        ext.ExecuteFlag = false
        tvar.rewind_resurrecting = false
        ResetPool()
        lstg.tmpvar = {}
        self.eventListener = eventListener()
        New(player_list[var.player_select].class)
        local scene_class = self.scene_class
        background.Create(scene_class._bg)
        local p = player
        local lastp = player_lib._last_cache_player
        stg_levelUPlib.InitAddition()
        activeItem_lib.InitActive()
        for t, k in pairs(player_lib._last_cache_var.addition) do
            for _ = 1, k do
                stg_levelUPlib.SetAddition(stg_levelUPlib.AdditionTotalList[t], true, true)
            end
        end
        for k, v in pairs(player_lib._last_cache_var) do
            var[k] = v
        end
        for _, v in ipairs(player_lib.__must_save_data) do
            p[v] = lastp[v]
        end
        for k, v in pairs(player_lib._last_cache_weather) do
            lstg.weather[k] = v
        end
        for k,v in pairs(player_lib._last_cache_active_data) do
            local Active=activeItem_lib.ActiveTotalList[k]
            for index,value in pairs(v) do
                Active[index] = value
            end
        end
        if not var.addition[84] then
            stg_levelUPlib.SetAddition(stg_levelUPlib.AdditionTotalList[84])
        end
        var.rewindable = false
        var.rewind_CD = true
        stg_levelUPlib.AdditionTotalList[84].broken = true

        task.Wait(60)
        player.StopLoss = false
        var.next_wave_id = var.now_wave_id
        var.wave = player_lib._last_cache_var.wave
        if var._season_system then
            wea.next_weather = wea.now_weather
            wea.season_wave = player_lib._last_cache_weather.season_wave - 1
            table.remove(wea.total_weather)
            --table.remove(wea.total_weather)
        end
        --var.wave = var.wave + 1
        self.start_function(var.wave)
    end)
end
stg_levelUPlib.Rewinding = Rewinding

local function Resurrect9_func()
    local function _t3(str)
        return Trans("addition_item", 4)[str] or ""
    end
    local var = lstg.var
    var.resurrect9 = var.resurrect9 - 1
    if var.resurrect9 == 0 then
        local tool = lib.AdditionTotalList[106]
        lib.BreakAddition(tool)
        ext.achievement:get(78)
    end
    local x, y = player.x, player.y
    local R = var.resurrect9 * 15
    for a in sp.math.AngleIterator(90, var.resurrect9 + 1) do
        local r, g, b = sp:HSVtoRGB(a, 0.6, 1)
        NewBon(x + cos(a) * R, y + sin(a) * R, 45, 75, r, g, b)
    end
    PlaySound("piyo")
    PlaySound("nice")
    player.protect = player.protect + 120

    player_lib.AddMaxLife(-var.maxlife + 9)
    var.lifeleft = var.maxlife
    local tlist = {}
    for i in pairs(var.addition) do
        ---@type addition_unit
        local tool = lib.AdditionTotalList[i]
        if tool.isTool and not tool.broken and i ~= 106 then
            table.insert(tlist, tool)
        end
    end
    if #tlist > 0 then
        local tool = tlist[ran:Int(1, #tlist)]
        lib.BreakAddition(tool)
        ext.notice_menu:AdditionAdd(tool.id, "invalid", _t3("道具损坏..."), 30, 250, 128, 114)
    end
end
stg_levelUPlib.Resurrect9_func = Resurrect9_func

local function ikinokosu_yume_eff_old(p)
    task.New(p, function()
        local sys = p._playersys
        local _color = Color(255, 255, 255, 255)
        local _uv1, _uv2, _uv3, _uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
        _uv1[6] = _color
        _uv2[6] = _color
        _uv3[6] = _color
        _uv4[6] = _color
        local n = 15
        for t = 1, 60 do
            local m = task.SetMode[1](task.SetMode[2](t / 60 * 2))
            local kr1 = 0
            local kr2 = 0
            local dr1 = 1.5
            local dr2 = 1.5
            sys.renderfunc = function()
                for i = 1, 42 do
                    dr2 = 1.5 + 1 * m * sin(i * 5)
                    _color = Color(255 - 100 * (1 - i / 42) * m, 255, 255, 255)
                    for r = 1, n do
                        local da = 360 / n
                        local ang = r * da
                        local cx, cy = p.x, p.y
                        local offa = 0
                        local offx, offy = 0, t / 60 * 100 - 50
                        _uv1[6] = _color
                        _uv2[6] = _color
                        _uv3[6] = _color
                        _uv4[6] = _color
                        _uv1[1], _uv1[2] = cx + offx + cos(ang + offa) * kr2, cy + offy + sin(ang + offa) * kr2
                        _uv2[1], _uv2[2] = cx + offx + cos(ang + offa) * (kr2 + dr2), cy + offy + sin(ang + offa) * (kr2 + dr2)
                        _uv3[1], _uv3[2] = cx + offx + cos(ang + da + offa) * (kr2 + dr2), cy + offy + sin(ang + da + offa) * (kr2 + dr2)
                        _uv4[1], _uv4[2] = cx + offx + cos(ang + da + offa) * kr2, cy + offy + sin(ang + da + offa) * kr2

                        _uv1[4], _uv1[5] = cx + offx + cos(ang) * kr1, cy + offy + sin(ang) * kr1
                        _uv2[4], _uv2[5] = cx + offx + cos(ang) * (kr1 + dr1), cy + offy + sin(ang) * (kr1 + dr1)
                        _uv3[4], _uv3[5] = cx + offx + cos(ang + da) * (kr1 + dr1), cy + offy + sin(ang + da) * (kr1 + dr1)
                        _uv4[4], _uv4[5] = cx + offx + cos(ang + da) * kr1, cy + offy + sin(ang + da) * kr1
                        _uv1[4], _uv1[5] = WorldToScreen(_uv1[4], _uv1[5])
                        _uv2[4], _uv2[5] = WorldToScreen(_uv2[4], _uv2[5])
                        _uv3[4], _uv3[5] = WorldToScreen(_uv3[4], _uv3[5])
                        _uv4[4], _uv4[5] = WorldToScreen(_uv4[4], _uv4[5])
                        RenderTexture(sys.rendert, "", _uv1, _uv2, _uv3, _uv4)
                    end
                    kr1 = kr1 + dr1
                    kr2 = kr2 + dr2
                end
            end
            task.Wait()
        end
        p._playersys.renderfunc = nil
    end)
end

local function ikinokosu_yume_eff()
    local k = lstg.tmpvar.ikinokosu_yume_eff_id or 0
    SmearScreen("IKINOKOSU_YUME" .. k, 60, 1, nil, nil, "mul+add")
    lstg.tmpvar.ikinokosu_yume_eff_id = k + 1
end
stg_levelUPlib.ikinokosu_yume_eff = ikinokosu_yume_eff

local function sakura_kekkai_init()
    if not lstg.tmpvar.sakura_kekkai then
        lstg.tmpvar.sakura_kekkai = {
            black_alpha = 0,
            circle = { alpha = 0, rot = { 0, 0 }, omiga = { -0.6, 0.6 }, scale = 1.1 },
            count = 0,
            CD = 0,
            back_obj = nil
        }
        player._playersys:addFrameBeforeEvent("sakura_kekkai", 1, function()
            local s = lstg.tmpvar.sakura_kekkai
            if not lstg.var.ON_sakura and lstg.var.sakura >= 50000 and s.CD <= 0 then
                lstg.var.ON_sakura = true
                s.back_obj = New(lib.class.sakura_back, s)
                s.circle.scale = 1.1
                PlaySound("Sakura", 1)
                lstg.var.sakura_bonus = true
                player.protect = player.protect + 60
                player_lib.AddLife(10)
            end
            if lstg.var.ON_sakura then
                for _, unit in ObjList(GROUP.ITEM) do
                    unit.target = player
                    unit.attract = 10
                end
                s.black_alpha = min(s.black_alpha + 2, 120)
                s.circle.alpha = min(s.circle.alpha + 255 / 60, 255)
                s.circle.rot[1] = s.circle.rot[1] + s.circle.omiga[1]
                s.circle.rot[2] = s.circle.rot[2] + s.circle.omiga[2]
                s.circle.scale = lstg.var.sakura / 50000 + 0.1
                lstg.var.sakura = max(lstg.var.sakura - 50000 / 540, 0)
                if lstg.var.sakura == 0 then
                    lstg.var.ON_sakura = false
                    if lstg.var.sakura_bonus then
                        s.count = min(s.count + 1, 10)
                        New(lib.class.Sakura_bonus, s.count)
                    else
                        s.count = 0
                        PlaySound("bonus2", 0.2, 0, false)
                        local b
                        object.BulletDo(function(unit)
                            b = New(item.sakura, unit.x, unit.y, nil, nil, 10)
                            b.attract = 10
                            b.target = player
                            Del(unit)
                        end)
                        cutLasersByCircle(0, 0, 999, function(x, y)
                            b = New(item.sakura, x, y, nil, nil, 10)
                            b.attract = 10
                            b.target = player
                        end)
                    end

                    player.protect = max(player.protect, 40)
                    s.CD = 39
                end
            else
                s.black_alpha = max(s.black_alpha - 12, 0)
                s.circle.alpha = max(s.circle.alpha - 25.5, 0)
            end
            s.CD = max(0, s.CD - 1)
        end)
    end
end
stg_levelUPlib.sakura_kekkai_init = sakura_kekkai_init

local function sakura_kekkai_fade()

    if lstg.tmpvar.sakura_kekkai then
        local s = lstg.tmpvar.sakura_kekkai
        if IsValid(s.back_obj) then
            Del(s.back_obj)
        end
        lstg.var.sakura = 0
        lstg.var.ON_sakura = false
        lstg.tmpvar.sakura_kekkai = nil
        player._playersys:removeFrameBeforeEvent("sakura_kekkai")
    end
end
stg_levelUPlib.sakura_kekkai_fade = sakura_kekkai_fade

local function red_wish_LevelUp()
    for _ = 1, 2 do
        local v = lstg.var
        local p = player
        local dmg = player_lib.GetPlayerDmg()

        local s_set = p.shoot_set
        local speed_set = s_set.speed
        local bv_set = s_set.bvelocity
        local range_set = s_set.range
        local sspeed, bv, lifetime = player_lib.GetShootAttribute()
        local red_wish_map = {
            { dmg, function(c)
                p.dmg_offset = p.dmg_offset + c
            end }, --攻击力
            { sspeed, function(c)
                speed_set.offset = speed_set.offset + c
            end }, --射速
            { lifetime, function(c)
                range_set.offset = range_set.offset + c
            end }, --射程
            { bv, function(c)
                bv_set.offset = bv_set.offset + c
            end }, --弹速
        }
        table.sort(red_wish_map, function(a, b)
            return a[1] < b[1]
        end)
        local pro = ran:Float(0, 1)
        local pos = 1
        if pro > 0.9 then
            pos = 4
        elseif pro > 0.7 then
            pos = 3
        elseif pro > 0.4 then
            pos = 2
        end
        local value = 0.5 + 0.5 * v.red_wish
        red_wish_map[pos][2](value)
    end
end
stg_levelUPlib.red_wish_LevelUp = red_wish_LevelUp

local function siyuan_achievement()
    local v = lstg.var
    if v.addition[145] and v.addition[156] and v.addition[163] and
            v.addition[147] and v.addition[150] then
        ext.achievement:get(147)
    end
end
stg_levelUPlib.siyuan_achievement = siyuan_achievement


--[[
    NewToolUnit(60, 4, 1, 0, 53, "这就是梭哈！", function()
        local v = lstg.var
        v.randomLevelUp = true
        v.exp_factor = v.exp_factor + 0.5
    end, "经验点获得的经验值+50%\n并且每次升级的\"选择加成\"改为\"随机事件\"", 1, true)--]]
--[[
        NewToolUnit(41, 4, 20, 0, 34, "天星之沐愿(蓝)", function()
        local v = lstg.var
        player._playersys:addGrazingBeforeEvent("addscore", 1, function()
            local addscore = int(v.score * 0.0005 / 10) * 10
            v.score = v.score + addscore
        end)
        lib.AdditionTotalList[40].pro_fixed = 0
        lib.AdditionTotalList[42].pro_fixed = 0
        v.chaos_factor = 1.33
    end, "自机每擦1颗弹，获得当前总分0.05%的分数，混沌值变化时额外改变33%\n", 1, true)
--]]