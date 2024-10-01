local module = "weather"
loadLanguageModule(module, "mod\\weather")
local function _t(str)
    return Trans(module, str)
end
local function _t1(str)
    return Trans(module, 1)[str]
end
local function _t2(str)
    return Trans(module, 2)[str]
end
local function _t3(str)
    return Trans(module, 3)[str]
end
local function _t4(str)
    return Trans(module, 4)[str]
end
local function _t5(str)
    return Trans(module, 5)[str]
end

-------------------
local lib = {}
weather_lib = lib

lib.season = {}
lib.weather = {}
local function DefineSeason(id, name)
    local n = {}
    n.id = id
    n.name = name
    n.weathers = {}
    lib.season[n.id] = n
    return n
end
DefineSeason(1, _t("spring"))
DefineSeason(2, _t("summer"))
DefineSeason(3, _t("autumn"))
DefineSeason(4, _t("winter"))
DefineSeason(5, _t("inside"))

local ColorList = {
    { 255, 227, 132 },
    { 135, 206, 235 },
    { 205, 128, 114 }
}
local BackColorList = {
    { 218, 112, 214 },
    { 189, 252, 201 },
    { 250, 200, 100 },
    { 135, 150, 235 },
    { 250, 100, 100 }
}
local state_name = { _t("state1"), _t("state2"), _t("state3") }
local function DefineWeather(id, inseason, name, state, switch, init, frame, final, subtitle, describe, pro, special_des)
    ---@class weather_unit
    local w = {}
    w.id = id
    w.inseason = inseason
    w.inseason_name = lib.season[inseason].name
    w.name = name
    w.subtitle = subtitle
    w.state = state
    w.state_name = state_name[state]
    w.R, w.G, w.B = unpack(ColorList[w.state])
    w.sR, w.sG, w.sB = unpack(BackColorList[w.inseason])
    w.describe = describe
    w.special_des = special_des
    w.switch = switch
    w._init = init
    w._frame = frame
    w._final = final
    if type(pro) == "function" then
        w.pro = pro
    else
        w.pro = function()
            return pro
        end
    end
    w.init = function()
        local data = scoredata
        data.Weather[id] = true
        data.FirstWeather = true--第一次遇到天气
        if switch then
            lstg.weather[switch] = true
        end
        if init then
            init()
        end
    end
    w.frame = frame or function()
    end
    w.final = function()
        local lw = lstg.weather
        if switch then
            lw[switch] = nil
        end
        if final then
            final()
        end
        ---一些一直需要重置的数据
        lw.enemyHP_offset = 0
        lw.enemyHP_index = 1
        lw.playerSpeed_index = 1
        lw.bullet_init_func = function()
        end
        lw.enemy_kill_func = function()
        end
    end
    table.insert(lib.season[inseason].weathers, w)
    lib.weather[id] = w
    scoredata.Weather[id] = scoredata.Weather[id] or false
end

local first10pro = function()
    if lstg.var._pathlike then
        return 1
    else
        if lstg.weather.season_wave == 1 then
            return 10
        else
            return 0
        end

    end
end
local middle10pro = function()
    if lstg.var._pathlike then
        return 1
    else
        local w = lstg.weather
        if w.season_wave == (w.season_last[w.now_season] + 1) / 2 then
            return 10
        else
            return 0
        end
    end
end

local function TaiFengInit()
    lstg.tmpvar.TaiFeng_miss = lstg.var.miss
    local w = lstg.weather
    w.playerSpeed_index = 0.75
    if not IsValid(lstg.tmpvar.TaiFengEff) then
        lstg.tmpvar.TaiFengEff = New(lib.class.TaiFengEff)
    end
end
local function TaiFengFinal()
    if lstg.var.miss == lstg.tmpvar.TaiFeng_miss then
        ext.achievement:get(69)
    end
end

do
    DefineWeather(1, 1, _t1("name1"), 1, "LiChun", function()
        player_lib.AddLife(lstg.var.maxlife)
        local list = stg_levelUPlib.GetAdditionList(3, function(p)
            return p.state == 1 and not p.spBENEFIT
        end)
        ext.popup_menu:FlyIn(_t1("other1"), 189, 252, 201, list, "bonus")
        for _, p in ipairs(list) do
            stg_levelUPlib.SetAddition(p)
        end
    end, nil, nil, _t1("subt1"), _t1("des1"), first10pro, _t1("sp1"))
    DefineWeather(2, 1, _t1("name2"), 2, "YuShui", function()
        player_lib.AddLife(0.2 * lstg.var.maxlife)
        if not IsValid(lstg.tmpvar.YuShuiEff) then
            lstg.tmpvar.YuShuiEff = New(lib.class.YuShuiEff)
        end
        lstg.weather.bullet_init_func = function(self)
            local p2 = ran:Float(0, 1)
            if p2 < 0.36 then
                bullet.setfakeColli(self, false)
                --雨水
            end
        end
    end, nil, nil, _t1("subt2"), _t1("des2"), 1)
    DefineWeather(3, 1, _t1("name3"), 3, "JingZhe", function()
        player_lib.AddLife(0.5 * lstg.var.maxlife)
        if not IsValid(lstg.tmpvar.JingZhe_lightninger) then
            lstg.tmpvar.JingZhe_lightninger = New(lib.class.JingZhe_lightninger)
        end
    end, nil, nil, _t1("subt3"), _t1("des3"), 1)
    DefineWeather(4, 1, _t1("name4"), 1, "ChunFen", function()
        local v = lstg.var
        player_lib.AddLife(0.5 * v.maxlife)
        if v.lifeleft == v.maxlife then
            player_lib.AddMaxLife(15)
        end

        local lvl_lib = stg_levelUPlib
        local got = {}
        for _ = 1, 2 do
            local can_get = {}
            for i, nowc in pairs(lstg.var.addition) do
                local p = lvl_lib.AdditionTotalList[i]
                if p.isTool then
                    local maxc = p.maxcount or 999
                    if p.upgrade_get() and (nowc < maxc) then
                        table.insert(can_get, i)
                    end
                end
            end
            if #can_get > 0 then
                local i = can_get[ran:Int(1, #can_get)]
                local t = lvl_lib.AdditionTotalList[i]
                table.insert(got, t)
                lvl_lib.SetAddition(t)
            else
                break
            end
        end
        if #got > 0 then
            ext.popup_menu:FlyIn(_t1("other4"), 218, 112, 214, got, "bonus")
        else
            AddExp((stg_levelUPlib.GetCurMaxEXP(v.level + 1) - v.now_exp) / v.exp_factor)
        end
    end, nil, nil, _t1("subt4"), _t1("des4"), middle10pro, _t1("sp4"))
    DefineWeather(5, 1, _t1("name5"), 2, "QingMing", function()
        ext.achievement:get(34)
        player_lib.AddLife(0.1 * lstg.var.maxlife)
        lstg.weather.bullet_init_func = function(self)
            object.SetSize(self, 0.5)
            object.SetColli(self, self.a * 0.35)
        end
    end, nil, nil, _t1("subt5"), _t1("des5"), 1)
    DefineWeather(6, 1, _t1("name6"), 1, "GuYu", function()
        player_lib.AddLife(0.2 * lstg.var.maxlife)
        local v = lstg.var
        v.exp_factor = v.exp_factor + 0.5
        if not IsValid(lstg.tmpvar.GuYuEff) then
            lstg.tmpvar.GuYuEff = New(lib.class.GuYuEff)
        end
    end, function()
        if lstg.var.frame_counting then
            player_lib.AddLife(5 * 0.1 / 60)
        end
    end, function()
        local v = lstg.var
        v.exp_factor = v.exp_factor - 0.5
    end, _t1("subt6"), _t1("des6"), 1)
    DefineWeather(7, 1, _t1("name7"), 3, "QingLan", nil, function()
        local t = stage.current_stage.timer
        local chaos = lstg.var.chaos
        local interval = int(sp.math.GetNumByInverse(chaos, 1, 17, 6))
        local v = min(chaos / 500 + 0.5, 2)
        if t % interval == 0 and lstg.var.frame_counting then
            lib.class.QingLanBullet(-340, ran:Float(-200, 350), 0.7 * v, ran:Float(0, 360), 3 * v, -1 * v)
        end
    end, nil, _t1("subt7"), _t1("des7"), 1)
    DefineWeather(31, 1, _t1("name31"), 2, "JiYu", function()
        lstg.weather.bullet_init_func = function(self)
            object.SetColli(self, self.a * 0.75)
        end
        if not IsValid(lstg.tmpvar.JiYuEff) then
            lstg.tmpvar.JiYuEff = SmearScreen("JIYU", 8, 9999,
                    LAYER.ENEMY_BULLET - 10, LAYER.ENEMY_BULLET + 10, "")
        end
        lstg.tmpvar.JiYuEff.flag = false
    end, nil, function()
        if IsValid(lstg.tmpvar.JiYuEff) then
            lstg.tmpvar.JiYuEff.flag = true
        end
    end, _t1("subt31"), _t1("des31"), 1)
    DefineWeather(39, 1, _t1("name39"), 3, "YunYing", function()
        if not IsValid(lstg.tmpvar.YunYingEff) then
            lstg.tmpvar.YunYingEff = New(lib.class.YunYingEff)
        end
        lstg.weather.enemy_kill_func = function(self)
            lib.class.PutYunYing(self.x, self.y)
        end
    end, nil, nil, _t1("subt39"), _t1("des39"), 1)
    DefineWeather(40, 1, _t1("name40"), 3, "ChunWu", function()
        if not IsValid(lstg.tmpvar.ChunWuEff) then
            lstg.tmpvar.ChunWuEff = New(lib.class.ChunWuEff)
        end
    end, function()
        local t = stage.current_stage.timer
        if t % 60 == 0 then
            New(lib.class.ChunWuFog, ran:Float(-300, 300), ran:Float(-200, 200), 0.6, ran:Float(0, 360))
        end
    end, nil, _t1("subt40"), _t1("des40"), 1)
    DefineWeather(50, 1, _t1("name50"), 2, "XinYang", function()
        if not IsValid(lstg.tmpvar.XinYangEff) then
            lstg.tmpvar.XinYangEff = New(lib.class.XinYangEff)
        end
    end, nil, nil, _t1("subt50"), _t1("des50"), 1)
    DefineWeather(51, 1, _t1("name51"), 1, "YunTian", function()
        local p = player
        p.dmg_offset = p.dmg_offset + 1
    end, nil, function()
        local p = player
        p.dmg_offset = p.dmg_offset - 1
    end, _t1("subt51"), _t1("des51"), 1)
    DefineWeather(52, 1, _t1("name52"), 1, "RongXue", function()
        if not IsValid(lstg.tmpvar.RongXueEff) then
            lstg.tmpvar.RongXueEff = New(lib.class.RongXueEff)
        end
        local w = lstg.weather
        w.bullet_init_func = function(self)
            task.New(self, function()
                while w.RongXue do
                    if ran:Float(0, 1) < 0.01 then
                        if self.group == GROUP.ENEMY_BULLET then
                            object.Del(self)
                        end
                        item.dropItem(item.drop_exp, 1, self.x, self.y)
                        local eff = lstg.tmpvar.RongXueEff
                        if IsValid(eff) then
                            eff.create_snow(self.x, self.y)
                        end
                    end
                    task.Wait(34)
                end
            end)
        end
    end, nil, nil, _t1("subt52"), _t1("des52"), 1)
    DefineWeather(53, 1, _t1("name53"), 1, "FengXuYun", nil, nil, nil, _t1("subt53"), _t1("des53"), 1)
    DefineWeather(54, 1, _t1("name54"), 2, "YuYun", function()
        if not IsValid(lstg.tmpvar.YuYunEff) then
            lstg.tmpvar.YuYunEff = New(lib.class.YuYunEff)
        end
        local w = lstg.weather
        w.playerSpeed_index = 1.5
    end, nil, nil, _t1("subt54"), _t1("des54"), 1)
end -- spring

do
    DefineWeather(8, 2, _t2("name8"), 2, "LiXia", function()
        local v = lstg.var
        player_lib.AddMaxLife(v.lifeleft * 0.05)
    end, nil, nil, _t2("subt8"), _t2("des8"), first10pro, _t2("sp8"))
    DefineWeather(9, 2, _t2("name9"), 1, "XiaoMan", function()
        local v = lstg.var
        player_lib.SetEnergy(nil, v.energy_stack + 2)
        v.energy = v.maxenergy * v.energy_stack
    end, nil, function()
        local v = lstg.var
        player_lib.SetEnergy(nil, v.energy_stack - 2)
    end, _t2("subt9"), _t2("des9"), 1)
    DefineWeather(10, 2, _t2("name10"), 1, "MangZhong", function()
        player_lib.AddLife(0.5 * lstg.var.maxlife)
        if not IsValid(lstg.tmpvar.MangZhongEff) then
            lstg.tmpvar.MangZhongEff = New(lib.class.MangZhongEff)
        end
    end, nil, nil, _t2("subt10"), _t2("des10"), 1)
    DefineWeather(11, 2, _t2("name11"), 2, "XiaZhi", function()
        local v = lstg.var
        v.exp_factor = v.exp_factor + 0.25
        local w = lstg.weather
        w.enemyHP_index = 1.5
    end, nil, function()
        local v = lstg.var
        v.exp_factor = v.exp_factor - 0.25
    end, _t2("subt11"), _t2("des11"), middle10pro, _t2("sp11"))
    DefineWeather(12, 2, _t2("name12"), 3, "XiaoShu", function()
        if not IsValid(lstg.tmpvar.XiaoShuEff) then
            lstg.tmpvar.XiaoShuEff = New(lib.class.XiaoShuEff)
        end
        local w = lstg.weather
        w.enemyHP_index = 1.3
    end, function()
        if lstg.var.frame_counting then
            player_lib.ReduceLife(1 * 0.0045 * max(lstg.var.maxlife, 50) / 35, true, nil, 0.01)
        end
    end, nil, _t2("subt12"), _t2("des12"), 1)
    DefineWeather(13, 2, _t2("name13"), 3, "DaShu", function()
        if not IsValid(lstg.tmpvar.DaShuEff) then
            lstg.tmpvar.DaShuEff = New(lib.class.DaShuEff)
        end
        local w = lstg.weather
        w.enemyHP_index = 0.77
    end, function()
        if lstg.var.frame_counting then
            player_lib.ReduceLife(3 * 0.0045 * max(lstg.var.maxlife, 50) / 35, true, nil, 0.01)
        end
    end, nil, _t2("subt13"), _t2("des13"), 1)
    DefineWeather(14, 2, _t2("name14"), 3, "XiaYu", function()
        if not IsValid(lstg.tmpvar.XiaYuEff) then
            lstg.tmpvar.XiaYuEff = New(lib.class.XiaYuEff)
        end
    end, function()
        local t = stage.current_stage.timer
        local chaos = lstg.var.chaos
        local interval = int(sp.math.GetNumByInverse(chaos, 1, 17, 6))
        local v = min(chaos / 120 + 1.5, 8)
        if lstg.var.frame_counting then
            if t % interval == 0 then
                local b = NewSimpleBullet(grain_a, 6, ran:Float(-320, 320), 245,
                        ran:Float(v - 0.3, v + 0.3), -90 + ran:Float(-6, 6))
                b.fogtime = 1
            end
            if t % (interval * 2) == 0 then
                local x, y = ran:Float(-320, 320), 245
                local b = NewSimpleBullet(grain_a, 6, x, y, v, Angle(x, y, player))
                b.fogtime = 1
            end
        end
    end, nil, _t2("subt14"), _t2("des14"), 1)
    DefineWeather(32, 2, _t2("name32"), 1, "ZhenYu", function()
        if not IsValid(lstg.tmpvar.ZhenYuEff) then
            lstg.tmpvar.ZhenYuEff = New(lib.class.ZhenYuEff)
        end
        lstg.var.level_upOption = lstg.var.level_upOption + 1
    end, nil, function()
        lstg.var.level_upOption = lstg.var.level_upOption - 1
    end, _t2("subt32"), _t2("des32"), 1)
    DefineWeather(41, 2, _t2("name41"), 1, "TianQiYu", function()
        if not IsValid(lstg.tmpvar.TianQiYuEff) then
            lstg.tmpvar.TianQiYuEff = New(lib.class.TianQiYuEff)
        end
    end, function()
        if lstg.var.frame_counting then
            player_lib.AddLife(20 * 0.1 / 60)
        end
    end, nil, _t2("subt41"), _t2("des41"), 1)
    DefineWeather(42, 2, _t2("name42"), 1, "WuYun", function()
        local w = lstg.weather
        w.enemyHP_index = 0.50
    end, nil, nil, _t2("subt42"), _t2("des42"), 1)
    DefineWeather(55, 2, _t2("name55"), 3, "HeFeng", function()
        local w = lstg.weather
        w.playerSpeed_index = 1.25
        if not IsValid(lstg.tmpvar.HeFengEff) then
            lstg.tmpvar.HeFengEff = New(lib.class.HeFengEff)
        end
    end, nil, nil, _t2("subt55"), _t2("des55"), 1)
    DefineWeather(56, 2, _t2("name56"), 3, "TaiFeng", TaiFengInit, nil, TaiFengFinal, _t2("subt56"), _t2("des56"), 1, _t2("sp56"))
    DefineWeather(60, 2, _t2("name60"), 2, "YinQing", function()
        local w = lstg.weather
        w.bullet_init_func = function(self)
            if ran:Int(1, 2) == 1 then
                bullet.setfakeColli(self, false)
            end
            task.New(self, function()
                local t = stage.current_stage
                while w.YinQing do
                    if t.timer % 120 == 0 then
                        bullet.setfakeColli(self, self._no_colli)

                    end
                    task.Wait()
                end
            end)
        end
    end, nil, nil, _t2("subt60"), _t2("des60"), 1)
    DefineWeather(61, 2, _t2("name61"), 3, "JiYun", function()
        local w = lstg.weather
        w.enemyHP_index = 1.2
    end, nil, nil, _t2("subt61"), _t2("des61"), 1)
    DefineWeather(67, 2, _t2("name67"), 1, "QingLang", function()
    end, nil, nil, _t2("subt67"), _t2("des67"), function()
        if stage.current_stage.is_tutorial then
            return 0
        else
            return 1
        end
    end)
end--summer

do
    DefineWeather(15, 3, _t3("name15"), 1, "LiQiu", nil, nil, nil, _t3("subt15"), _t3("des15"), first10pro, _t3("sp15"))
    DefineWeather(16, 3, _t3("name16"), 2, "ChuShu", nil, function()
        local v = lstg.var
        if v.frame_counting then
            if v.lifeleft > v.maxlife / 2 then
                player_lib.ReduceLife(5 * 0.0045 * max(v.maxlife, 50) / 35, true)
            else
                player_lib.AddLife(7 * 0.0045 * max(v.maxlife, 50) / 35)
            end
        end
    end, nil, _t3("subt16"), _t3("des16"), 1)
    DefineWeather(17, 3, _t3("name17"), 1, "BaiLu", function()
        if not IsValid(lstg.tmpvar.BaiLuEff) then
            lstg.tmpvar.BaiLuEff = New(lib.class.BaiLuEff)
        end
        lstg.weather.enemy_kill_func = function(self)
            item.dropItem(item.drop_dewdrop, 1, self.x, self.y)
        end
    end, nil, nil, _t3("subt17"), _t3("des17"), 1)
    DefineWeather(18, 3, _t3("name18"), 1, "QiuFen", function()
        if not IsValid(lstg.tmpvar.QiuFenEff) then
            lstg.tmpvar.QiuFenEff = New(lib.class.QiuFenEff)
        end
    end, function()
        if lstg.var.frame_counting then
            object.EnemyNontjtDo(function(e)
                sp:UnitSetVIndex(e, -0.25)
            end)
        end
    end, nil, _t3("subt18"), _t3("des18"), middle10pro, _t3("sp18"))
    DefineWeather(19, 3, _t3("name19"), 1, "HanLu", function()
        lstg.weather.enemy_kill_func = function(self)
            local x, y = self.x, self.y
            for _ = 1, ran:Int(0, 4) do
                local col = ran:Int(0, 1) * 12 + 2
                local b = NewSimpleBullet(grain_a, col, x, y, 1.6, ran:Float(0, 360))
                b.ag = 0.03
                b.omiga = ran:Float(2, 3) * ran:Sign()
                b.maxvy = 4.3
            end
        end
    end, function()
        local t = stage.current_stage.timer
        if lstg.var.frame_counting then
            if t % 15 == 0 then
                item.dropItem(item.drop_exp, 1, ran:Float(-300, 300), 240)
            end
        end
    end, nil, _t3("subt19"), _t3("des19"), 1)
    DefineWeather(20, 3, _t3("name20"), 3, "ShuangJiang", function()
        lstg.weather.ShuangJiang_speed_low = 0
    end, function()

        if not scoredata.Achievement[64] then
            local ball_huge_c = 0
            object.BulletIndesDo(function(b)
                if b.imgclass == ball_huge then
                    ball_huge_c = ball_huge_c + 1
                end
            end)
            if ball_huge_c > 10 then
                ext.achievement:get(64)
            end
        end
    end, function()
        lstg.weather.ShuangJiang_speed_low = 0
    end, _t3("subt20"), _t3("des20"), 1)
    DefineWeather(21, 3, _t3("name21"), 2, "GuWuYu", function()
        local GuWuYu_Colors = { 2, 12, 14 }
        object.BulletIndesDo(function(b)
            b.GuWuYu_index = GuWuYu_Colors[ran:Int(1, 3)]
        end)
        lstg.weather.bullet_init_func = function(self)
            self.GuWuYu_index = GuWuYu_Colors[ran:Int(1, 3)]
            object.SetSizeColli(self, 1.05)
        end
    end, nil, nil, _t3("subt21"), _t3("des21"), 1)
    DefineWeather(35, 3, _t3("name35"), 2, "LinYun", nil, function()
        if lstg.var.frame_counting then
            object.BulletIndesDo(function(b)
                if not b.not_move then
                    if not b.LinYun_set then
                        if abs(b.vx) > abs(b.vy) then
                            b.LinYun_set = 1
                        else
                            b.LinYun_set = 2
                        end
                    end
                    if b.LinYun_set == 1 then
                        b.y = b.y - b.vy
                    else
                        b.x = b.x - b.vx
                    end
                end
            end)
        end
    end, nil, _t3("subt35"), _t3("des35"), 1)
    DefineWeather(43, 3, _t3("name43"), 3, "QiuLaoHu", function()
        if not IsValid(lstg.tmpvar.QiuLaoHuEff) then
            lstg.tmpvar.QiuLaoHuEff = New(lib.class.QiuLaoHuEff)
        end
    end, function()
        if lstg.var.frame_counting then
            player_lib.ReduceLife(2 * 0.0045 * max(lstg.var.maxlife, 50) / 35, "QiuLaoHu")

        end
    end, nil, _t3("subt43"), _t3("des43"), 1)
    DefineWeather(44, 3, _t3("name44"), 1, "QiuShi", nil, nil, nil, _t3("subt44"), _t3("des44"), 1)
    DefineWeather(45, 3, _t3("name45"), 3, "FeiKong", function()
        if not IsValid(lstg.tmpvar.FeiKongEff) then
            lstg.tmpvar.FeiKongEff = New(lib.class.FeiKongEff)
        end
        player_lib.AddMaxLife(5)
        lstg.weather.enemy_kill_func = function(self)
            local chaos = lstg.var.chaos
            for a in sp.math.AngleIterator(ran:Float(0, 360), int(min(9, chaos / 12.5))) do
                NewSimpleBullet(ball_mid_c, 2, self.x, self.y, min(9, 2 + chaos / 888 * 7), a)
            end
        end
    end, nil, nil, _t3("subt45"), _t3("des45"), 1)
    DefineWeather(57, 3, _t3("name57"), 3, "TaiFeng", TaiFengInit, nil, TaiFengFinal, _t3("subt57"), _t3("des57"), 1, _t3("sp57"))
    DefineWeather(58, 3, _t3("name58"), 1, "JuanYun", nil, nil, nil, _t3("subt58"), _t3("des58"), 1)
    DefineWeather(59, 3, _t3("name59"), 1, "SheRi", function()
        local v = lstg.var
        player_lib.AddMaxLife(5)
        v.lifeleft = v.maxlife--TODO 这样子回满血--逃离所有检测与计算
        v.energy = v.maxenergy * v.energy_stack
        local p = player
        p.dmg_fixed = p.dmg_fixed + 0.5
        local set = p.shoot_set
        local ss = set.speed
        local sr = set.range
        local sb = set.bvelocity
        ss.offset = ss.offset + 10
        sr.fixed = sr.fixed + 0.5
        sb.fixed = sb.fixed + 0.5
        player_lib.SetPlayerCollisize(2)
        if not IsValid(lstg.tmpvar.SheRiEff) then
            lstg.tmpvar.SheRiEff = New(lib.class.SheRiEff)
        end
    end, nil, function()
        local p = player
        p.dmg_fixed = p.dmg_fixed - 0.5
        local set = p.shoot_set
        local ss = set.speed
        local sr = set.range
        local sb = set.bvelocity
        ss.offset = ss.offset - 10
        sr.fixed = sr.fixed - 0.5
        sb.fixed = sb.fixed - 0.5
        player_lib.SetPlayerCollisize(-2)
    end, _t3("subt59"), _t3("des59"), 1)
    DefineWeather(66, 3, _t3("name66"), 2, "QiuShuang", function()
        if not IsValid(lstg.tmpvar.QiuShuangEff) then
            lstg.tmpvar.QiuShuangEff = New(lib.class.QiuShuangEff)
        end
        lstg.weather.enemy_kill_func = function(self)
            New(boss_explode_maple, self.x, self.y, 80)
        end
    end, nil, nil, _t3("subt66"), _t3("des66"), 1)
end--autumn

do
    DefineWeather(22, 4, _t4("name22"), 1, "LiDong", nil, function()
        if lstg.var.frame_counting then
            object.EnemyNontjtDo(function(e)
                sp:UnitSetVIndex(e, -0.25)
            end)
        end
    end, nil, _t4("subt22"), _t4("des22"), first10pro, _t4("sp22"))
    DefineWeather(23, 4, _t4("name23"), 3, "XiaoXue", function()
        local w = lstg.weather
        w.bullet_init_func = function(self)
            task.New(self, function()
                while w.XiaoXue do
                    task.Wait(10)
                    if ran:Float(0, 1) < 0.02 and w.XiaoXue and self.group == GROUP.ENEMY_BULLET then
                        self._frozen = true
                        self.xiaoxue_frozen = true
                        task.Clear(self, true)
                        break
                    end
                end
                task.Wait()
                if self.xiaoxue_frozen and w.XiaoXue then
                    object.StopMoving(self)
                end
            end)
        end
    end, function()
        if lstg.var.frame_counting then
            object.EnemyNontjtDo(function(e)
                sp:UnitSetVIndex(e, -0.25)
            end)
        end
    end, function()
        object.BulletIndesDo(function(b)
            if b.xiaoxue_frozen then
                Del(b)
            end
        end)
    end, _t4("subt23"), _t4("des23"), 1)
    DefineWeather(24, 4, _t4("name24"), 3, "DaXue", nil, function()
        if lstg.var.frame_counting then
            object.EnemyNontjtDo(function(e)
                sp:UnitSetVIndex(e, -0.33)
            end)
            local t = stage.current_stage.timer
            local chaos = lstg.var.chaos
            local interval = int(max(12 - chaos / 100, 1))
            local v = min(chaos / 120 + 1.5, 8)
            if t % interval == 0 then
                NewSimpleBullet(ball_small, 8, ran:Float(-320, 320), 245,
                        ran:Float(v - 0.3, v + 0.3), -90 + ran:Float(-6, 6))
            end
        end
    end, nil, _t4("subt24"), _t4("des24"), 1)
    DefineWeather(25, 4, _t4("name25"), 1, "DongZhi", function()
        local v = lstg.var
        AddExp((stg_levelUPlib.GetCurMaxEXP(v.level + 1) - v.now_exp + 1) / v.exp_factor)
        if not IsValid(lstg.tmpvar.DongZhiEff) then
            lstg.tmpvar.DongZhiEff = New(lib.class.DongZhiEff)
        end
    end, function()
        if lstg.var.frame_counting then
            object.BulletIndesDo(function(b)
                object.Del(b)
            end)
        end
    end, nil, _t4("subt25"), _t4("des25"), middle10pro, _t4("sp25"))
    DefineWeather(26, 4, _t4("name26"), 3, "XiaoHan", nil, function()
        if lstg.var.frame_counting then
            local t = stage.current_stage.timer
            if t % 15 == 0 then
                New(lib.class.XiaoHanFog, ran:Float(-300, 300), ran:Float(-200, 200), 0.6, ran:Float(0, 360))
            end
            object.EnemyNontjtDo(function(e)
                e._xiaohan_slowed = nil
                sp:UnitClearVIndexSet(e)
            end)
            object.BulletIndesDo(function(e)
                e._xiaohan_slowed = nil
                sp:UnitClearVIndexSet(e)
            end)
            player._xiaohan_slowed = nil
            sp:UnitClearVIndexSet(player)
        end
    end, nil, _t4("subt26"), _t4("des26"), 1)
    DefineWeather(36, 4, _t4("name36"), 1, "RuiXue", nil, function()
        if lstg.var.frame_counting then
            local t = stage.current_stage.timer
            if t % 8 == 0 then
                item.dropItem(item.drop_exp, 1, ran:Float(-320, 320), 245)
            end
        end
    end, nil, _t4("subt36"), _t4("des36"), 1)
    DefineWeather(37, 4, _t4("name37"), 3, "ZuanShiChen", function()

        local w = lstg.weather
        w.ZuanShiChen_GetLife = lstg.var.lifeleft
        if not IsValid(lstg.tmpvar.ZuanShiChenEff) then
            lstg.tmpvar.ZuanShiChenEff = New(lib.class.ZuanShiChenEff)
        end
    end, nil, nil, _t4("subt37"), _t4("des37"), 1)
    DefineWeather(46, 4, _t4("name46"), 3, "DongYu", function()
        if not IsValid(lstg.tmpvar.DongYuEff) then
            lstg.tmpvar.DongYuEff = New(lib.class.DongYuEff)
        end
        local w = lstg.weather
        w.enemyHP_index = 0.75
        w.enemy_kill_func = function(self)
            local chaos = lstg.var.chaos
            local x, y = self.x, self.y
            local A = Angle(self, player)
            New(tasker, function()
                for _ = 1, int(min(9, 3 + chaos / 50)) do
                    for a in sp.math.AngleIterator(A, 5) do
                        NewSimpleBullet(ball_mid_c, 8, x, y, min(3 + chaos / 70, 9), a)
                    end
                    task.Wait(3)
                end
            end)
        end
    end, nil, nil, _t4("subt46"), _t4("des46"), 1)
    DefineWeather(68, 4, _t4("name68"), 3, "DaHan", function()

        if not IsValid(lstg.tmpvar.DaHanEff) then
            lstg.tmpvar.DaHanEff = New(lib.class.DaHanEff)
        end
        lstg.weather.enemy_kill_func = function(self)
            local b = NewSimpleBullet(ball_big, 6, self.x, self.y, 0.8, Angle(self, player))
            b.group = GROUP.INDES
            b.dahan_bullet = true
        end
    end, function()
        if lstg.var.frame_counting then
            object.EnemyNontjtDo(function(e)
                sp:UnitSetVIndex(e, -0.55)
            end)
        end
    end, function()
        object.IndesDo(function(b)
            if b.dahan_bullet then
                Del(b)
            end
        end)
    end, _t4("subt68"), _t4("des68"), 1)
    DefineWeather(69, 4, _t4("name69"), 1, "ChunXue", function()
        mission_lib.GoMission(47)
        local w = lstg.weather
        w.selected_season[1] = false
        w.next_season = 1
        if not IsValid(lstg.tmpvar.ChunXueEff) then
            lstg.tmpvar.ChunXueEff = New(lib.class.ChunXueEff)
        end
        if not lstg.var.addition[58] then
            stg_levelUPlib.sakura_kekkai_init()
        end
    end, function()
        if lstg.var.frame_counting then
            if not lstg.var.ON_sakura then
                lstg.var.sakura = 50000
            end
        end
    end, function()
        if not lstg.var.addition[58] then
            stg_levelUPlib.sakura_kekkai_fade()
        end
    end, _t4("subt69"), _t4("des69"), function()
        if lstg.var._pathlike then
            return 1
        else
            local w = lstg.weather
            if w.season_wave == w.season_last[w.now_season] then
                return lstg.var.addition[58] and 8 or 4
            else
                return 0
            end
        end
    end, _t4("sp69"))
    DefineWeather(70, 4, _t4("name70"), 3, "BaoFengXue", function()
        lstg.tmpvar.BaoFengXue_miss = lstg.var.miss
        if not IsValid(lstg.tmpvar.BaoFengXueEff) then
            lstg.tmpvar.BaoFengXueEff = New(lib.class.BaoFengXueEff)
        end
    end, function()
        if lstg.var.frame_counting then
            local t = stage.current_stage.timer
            local chaos = lstg.var.chaos
            local interval = int(sp.math.GetNumByInverse(chaos, 1, 30, 10))
            local v = min(chaos / 120 + 1.5, 8)
            if t % interval == 0 then
                NewSimpleBullet(ball_small, 8, ran:Float(-320, 320), 245,
                        ran:Float(v - 0.3, v + 0.3), -90 + ran:Float(-6, 6))
                NewSimpleBullet(ball_big, 8, ran:Float(-320, 320), 250,
                        ran:Float(v - 0.3, v + 0.3), -90 + ran:Float(-6, 6))
            end
        end
    end, function()
        if lstg.var.miss == lstg.tmpvar.BaoFengXue_miss then
            ext.achievement:get(61)
        end
    end, _t4("subt70"), _t4("des70"), 1)
    DefineWeather(71, 4, _t4("name71"), 2, "JieHan", function()
        lstg.weather.playerSpeed_index = 0.5
        if not IsValid(lstg.tmpvar.JieHanEff) then
            lstg.tmpvar.JieHanEff = New(lib.class.JieHanEff)
        end
    end, nil, nil, _t4("subt71"), _t4("des71"), 1)
    DefineWeather(72, 4, _t4("name72"), 2, "HuaYun", function()
        if not IsValid(lstg.tmpvar.HuaYunEff) then
            lstg.tmpvar.HuaYunEff = New(lib.class.HuaYunEff)
        end
        lib.HuaYunLilyWhite()
    end, function()
        if lstg.var.frame_counting then
            local dropEXP = function(e)
                if e.timer % 30 == 0 then
                    local x = e.x + ran:Float(30, 40) * ran:Sign()
                    local y = e.y + ran:Float(30, 40) * ran:Sign()
                    local b = New(item.drop_exp, x, y)
                    b.can_collect_online = false
                    task.New(b, function()
                        task.Wait(60)
                        New(bubble3, b.img, b.x, b.y, b.rot, b.dx, b.dy, b.omiga, 8, b.hscale, b.hscale,
                                Color(b._a, b._r, b._g, b._b), Color(0, b._r, b._g, b._b), b.layer, b._blend)
                        Del(b)
                    end)
                end
            end
            object.EnemyNontjtDo(dropEXP)
            dropEXP(player)
        end
    end, nil, _t4("subt72"), _t4("des72"), 1)
    DefineWeather(73, 4, _t4("name73"), 3, "ShuangHua", function()
        if not IsValid(lstg.tmpvar.ShuangHuaEff) then
            lstg.tmpvar.ShuangHuaEff = New(lib.class.ShuangHuaEff)
        end
        player._playersys:addGrazingBeforeEvent("ShuangHua", 1, function(p, _, other)
            if ran:Float(0, 1) < 0.4 then
                New(lib.class.ice, other.x, other.y, 60)
            end
        end)
    end, nil, function()
        player._playersys:removeGrazingBeforeEvent("ShuangHua")
    end, _t4("subt73"), _t4("des73"), 1)
    DefineWeather(74, 4, _t4("name74"), 3, "BingYun", function()
        if not IsValid(lstg.tmpvar.BingYunEff) then
            lstg.tmpvar.BingYunEff = New(lib.class.BingYunEff)
        end
    end, nil, nil, _t4("subt74"), _t4("des74"), 1)
end--winter

do
    DefineWeather(27, 5, _t5("name27"), 3, "ShenJing", function()
        if not IsValid(lstg.tmpvar.ShenJingEff) then
            lstg.tmpvar.ShenJingEff = New(lib.class.ShenJingEff)
        end
        lstg.weather.bullet_init_func = function(self)
            local a, b = self.a, self.b
            bullet.ChangeImage(self, bulletStyles[ran:Int(1, #bulletStyles)], self._index)
            self.a, self.b = a, b
        end
    end, nil, nil, _t5("subt27"), _t5("des27"), 1)
    DefineWeather(28, 5, _t5("name28"), 2, "BiShi", function()
        if not IsValid(lstg.tmpvar.BiShiEff) then
            lstg.tmpvar.BiShiEff = New(lib.class.BiShiEff)
        end
        lstg.weather.bullet_init_func = function(self)
            bullet.setfakeColli(self, false)
        end
    end, function()
        if lstg.var.frame_counting then
            object.EnemyNontjtDo(function(e)
                e.colli = false
            end)
            object.BulletIndesDo(function(e)
                e.colli = false
            end)
            object.LaserDo(function(e)
                e.colli = false
            end)
        end
    end, nil, _t5("subt28"), _t5("des28"), 1)
    DefineWeather(29, 5, _t5("name29"), 3, "KuangQi", function()
        if not IsValid(lstg.tmpvar.KuangQiEff) then
            lstg.tmpvar.KuangQiEff = New(lib.class.KuangQiEff)
        end
        local w = lstg.weather
        w.playerSpeed_index = 2
    end, function()
        local doAccel = function(e)
            sp:UnitSetVIndex(e, 1)
        end
        object.EnemyNontjtDo(doAccel)
        object.BulletIndesDo(doAccel)
    end, nil, _t5("subt29"), _t5("des29"), 1)
    DefineWeather(30, 5, _t5("name30"), 3, "XuanWo", function()
        if not IsValid(lstg.tmpvar.XuanWoEff) then
            lstg.tmpvar.XuanWoEff = New(lib.class.XuanWoEff)
        end
    end, function()
        local doRotate = function(e)
            if not e.__not_XuanWo then
                local R = Dist(0, 0, e)
                local A = Angle(0, 0, e)
                local v = R / 200
                e.x = e.x + cos(A + 90) * v
                e.y = e.y + sin(A + 90) * v
            end
        end
        object.EnemyNontjtDo(doRotate)
        object.BulletIndesDo(doRotate)
        object.LaserDo(doRotate)
        doRotate(player)
        for _, i in ObjList(GROUP.ITEM) do
            doRotate(i)
        end
    end, nil, _t5("subt30"), _t5("des30"), 1)
    DefineWeather(33, 5, _t5("name33"), 3, "GanYao", function()
        if not IsValid(lstg.tmpvar.GanYaoEff) then
            lstg.tmpvar.GanYaoEff = New(lib.class.GanYaoEff)
        end
    end, nil, function()
    end, _t5("subt33"), _t5("des33"), 1)
    DefineWeather(34, 5, _t5("name34"), 3, "NiZhuan", function()
        mission_lib.GoMission(5)
        if not IsValid(lstg.tmpvar.NiZhuanEff) then
            lstg.tmpvar.NiZhuanEff = New(lib.class.NiZhuanEff)
        end
    end, function()
        if lstg.var.reverse_shoot then
            ext.achievement:get(71)
        end
    end, nil, _t5("subt34"), _t5("des34"), 1)
    DefineWeather(38, 5, _t5("name38"), 1, "weatherX", function()
        if not IsValid(lstg.tmpvar.weatherXEff) then
            lstg.tmpvar.weatherXEff = New(lib.class.weatherXEff)
        end
        local lvl_lib = stg_levelUPlib
        local got = {}
        local othercond = function(tool)
            return tool.isTool
        end
        for _ = 1, 5 do
            local tool = lvl_lib.GetAdditionList(1, othercond)[1]
            if tool then
                tool.temporary = true
                table.insert(got, tool)
                lvl_lib.SetAddition(tool, true)
            else
                break
            end
        end
        lstg.weather.weatherXgot = got
        if #got > 0 then
            ext.popup_menu:FlyIn(_t5("other38_1"), 255, 227, 132, got, "bonus")
        end
    end, nil, function()
        local lvl_lib = stg_levelUPlib
        if lstg.weather.weatherXgot then
            local got = lstg.weather.weatherXgot
            local lost = {}
            for _, p in ipairs(got) do
                if lstg.var.addition[p.id] then
                    p.temporary = false
                    lvl_lib.RemoveAddition(p)
                    table.insert(lost, p)
                end
            end
            if #got > 0 then
                ext.popup_menu:FlyIn(_t5("other38_2"), 250, 128, 114, lost, "invalid")
            end
        end
    end, _t5("subt38"), _t5("des38"), 1)
    DefineWeather(47, 5, _t5("name47"), 1, "BiYiRi", nil, function()
        if lstg.var.frame_counting then
            local t = stage.current_stage.timer
            if t % 100 == 0 then
                local othercond = function(tool)
                    return tool.state == 1 and not tool.spBENEFIT
                end
                local addition = stg_levelUPlib.GetAdditionList(1, othercond)[1]
                item.dropItem(item.drop_addition_sp, 1, ran:Float(-320, 320), 245, addition.id)
            end
        end
    end, nil, _t5("subt47"), _t5("des47"), 1)
    DefineWeather(48, 5, _t5("name48"), 2, "JiaoYiRi", nil, function()
        if lstg.var.frame_counting then
            local t = stage.current_stage.timer
            if t % 80 == 0 then
                local othercond = function(tool)
                    return tool.state == 2
                end
                local addition = stg_levelUPlib.GetAdditionList(1, othercond)[1]
                item.dropItem(item.drop_addition_sp, 1, ran:Float(-320, 320), 245, addition.id)
            end
        end
    end, nil, _t5("subt48"), _t5("des48"), 1)
    DefineWeather(49, 5, _t5("name49"), 3, "QinHaiRi", nil, function()
        if lstg.var.frame_counting then
            local t = stage.current_stage.timer
            if t % 60 == 0 then
                local othercond = function(tool)
                    return tool.state == 3
                end
                local addition = stg_levelUPlib.GetAdditionList(1, othercond)[1]
                item.dropItem(item.drop_addition_sp, 1, ran:Float(-320, 320), 245, addition.id)
            end
        end
    end, nil, _t5("subt49"), _t5("des49"), 1)
    DefineWeather(62, 5, _t5("name62"), 2, "HuanYu", function()
        ext.achievement:get(51)
        if not IsValid(lstg.tmpvar.HuanYuEff) then
            lstg.tmpvar.HuanYuEff = New(lib.class.HuanYuEff)
        end
        lstg.weather.bullet_init_func = function(self)
            bullet.ChangeImage(self, ball_huge, 6, true)
            object.SetColli(self, 2)
        end
    end, nil, nil, _t5("subt62"), _t5("des62"), 1)
    DefineWeather(63, 5, _t5("name63"), 2, "FuYue", function()
        if not IsValid(lstg.tmpvar.FuYueEff) then
            lstg.tmpvar.FuYueEff = New(lib.class.FuYueEff)
        end
    end, nil, nil, _t5("subt63"), _t5("des63"), 1)
    DefineWeather(64, 5, _t5("name64"), 2, "FuRi", function()
        if not IsValid(lstg.tmpvar.FuRiEff) then
            lstg.tmpvar.FuRiEff = New(lib.class.FuRiEff)
        end
    end, nil, nil, _t5("subt64"), _t5("des64"), 1)
    DefineWeather(65, 5, _t5("name65"), 2, "YinYang", function()
        local w = lstg.weather
        w.bullet_init_func = function(self)
            if ran:Int(1, 2) == 1 then
                bullet.setfakeColli(self, false)
            end
            task.New(self, function()
                while w.YinYang do
                    if player._playersys:keyIsPressed("slow") then
                        bullet.setfakeColli(self, self._no_colli)
                    end
                    task.Wait()
                end
            end)
        end
    end, nil, nil, _t5("subt65"), _t5("des65"), 1)
    DefineWeather(75, 5, _t5("name75"), 2, "JiGuang", function()

        lstg.tmpvar.JiGuangID = ran:Int(1, #lib.weather)
        while lstg.tmpvar.JiGuangID == 75 or lstg.tmpvar.JiGuangID == 33 do
            lstg.tmpvar.JiGuangID = ran:Int(1, #lib.weather)
        end--偷偷排除绀药，TODO
        local w = lib.weather[lstg.tmpvar.JiGuangID]
        if w and w.switch then
            lstg.weather[w.switch] = true
        end
        if w and w._init then
            w._init()
        end
    end, function()
        local w = lib.weather[lstg.tmpvar.JiGuangID]
        if w and w._frame then
            w._frame()
        end
    end, function()
        local w = lib.weather[lstg.tmpvar.JiGuangID]
        if w and w.switch then
            lstg.weather[w.switch] = nil
        end
        if w and w._final then
            w._final()
        end
    end, _t5("subt75"), _t5("des75"), 1)
    DefineWeather(76, 5, _t5("name76"), 1, "weatherX", function()
        if not IsValid(lstg.tmpvar.weatherXEff) then
            lstg.tmpvar.weatherXEff = New(lib.class.weatherXEff)
        end
        local lvl_lib = stg_levelUPlib
        local got = {}
        local othercond = function(tool)
            return tool.isTool
        end
        for _ = 1, 10 do
            local tool = lvl_lib.GetAdditionList(1, othercond)[1]
            if tool then
                tool.temporary = true
                table.insert(got, tool)
                lvl_lib.SetAddition(tool, true)
            else
                break
            end

        end
        lstg.weather.weatherXgot = got
        if #got > 0 then
            ext.popup_menu:FlyIn(_t5("other38_1"), 255, 227, 132, got, "bonus")
        end
    end, nil, function()
        local lvl_lib = stg_levelUPlib
        if lstg.weather.weatherXgot then
            local got = lstg.weather.weatherXgot
            local lost = {}
            for _, p in ipairs(got) do
                if lstg.var.addition[p.id] then
                    p.temporary = false
                    lvl_lib.RemoveAddition(p)
                    table.insert(lost, p)
                end
            end
            if #got > 0 then
                ext.popup_menu:FlyIn(_t5("other38_2"), 250, 128, 114, lost, "invalid")
            end
        end

    end, _t5("subt76"), _t5("des76"), 1)
    DefineWeather(77, 5, _t5("name77"), 1, "weatherX", function()
        if not IsValid(lstg.tmpvar.weatherXEff) then
            lstg.tmpvar.weatherXEff = New(lib.class.weatherXEff)
        end
        local lvl_lib = stg_levelUPlib
        local got = {}
        local othercond = function(tool)
            return tool.isTool
        end
        for _ = 1, 5 do
            local tool = lvl_lib.GetAdditionList(1, othercond)[1]
            if tool then
                tool.temporary = true
                table.insert(got, tool)
                lvl_lib.SetAddition(tool, true)
            else
                break
            end
        end
        if #got > 0 then
            ext.popup_menu:FlyIn(_t5("other38_1"), 255, 227, 132, got, "bonus")
        end
    end, nil, nil, _t5("subt77"), _t5("des77"), function()
        if stagedata.challenge_finish[1] > 0 then
            return 1
        else
            return 0
        end
    end, _t5("sp77"))
    DefineWeather(78, 5, _t5("name78"), 3, "WangYu", nil, function()
        local t = stage.current_stage.timer
        if lstg.var.frame_counting then
            if t % 4 == 0 then
                local d = ran:Sign()
                New(lib.dead_soul, 350 * d, ran:Float(-220, 220), ran:Float(2, 4) * -d, 0)
            end
        end
    end, nil, _t5("subt78"), _t5("des78"), 1)
    DefineWeather(79, 5, _t5("name79"), 1, "LiuXingYu", function()
        if not IsValid(lstg.tmpvar.LiuXingYuEff) then
            lstg.tmpvar.LiuXingYuEff = New(lib.class.LiuXingYuEff)
        end

        local othercond = function(tool)
            return tool.quality == 4
        end
        local addition = stg_levelUPlib.GetAdditionList(1, othercond)
        if #addition > 0 then
            item.dropItem(item.drop_card, 1, 0, 240, addition[1].id)
        end
    end, function()
        if lstg.var.frame_counting then
            local t = stage.current_stage.timer
            local chaos = lstg.var.chaos
            local interval = int(sp.math.GetNumByInverse(chaos, 1, 17, 6))
            local v = min(chaos / 120 + 1, 5)
            local Kcolor = { 100, 100, 100 }
            if t % interval == 0 then
                local va = -40
                v = v + abs(sin(t)) * 1
                local b = NewSimpleBullet(star_small, 8, ran:Float(-500, 300), 260, v, va)
                b.bound = false
                b.ag = v / 100
                b.omiga = 3
                function b:frame_other()
                    if self.y < -245 then
                        if #self.smear == 0 then
                            object.RawDel(self)
                        end
                    else
                        bullet.smear_add(self, 100)

                    end
                    bullet.smear_frame(self, 7)
                end
                function b:render_other()
                    bullet.smear_render(self, "mul+add", Kcolor)
                end

            end
        end
    end, nil, _t5("subt79"), _t5("des79"), function()
        local va = lstg.var.addition
        if va[40] or va[41] or va[42] then
            return 1
        else
            return 0
        end
    end, _t5("sp79"))
end--inside

local function GanYaoRewind()
    local self = stage.current_stage
    local var = lstg.var
    local wea = lstg.weather
    var.lifeleft = 0.001
    player.lock = true
    player.StopLoss = true
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
        mask_fader:Do("close")
        task.Wait(15)
        mask_fader:Do("open")
        ResetPool()
        lstg.tmpvar = {}
        self.eventListener = eventListener()
        New(player_list[var.player_select].class)
        local scene_class = self.scene_class
        background.Create(scene_class._bg)
        local p = player
        local lastp = player_lib._cache_player
        stg_levelUPlib.InitAddition()
        activeItem_lib.InitActive()
        for t, k in pairs(player_lib._cache_var.addition) do
            for _ = 1, k do
                stg_levelUPlib.SetAddition(stg_levelUPlib.AdditionTotalList[t], true, true)
            end
        end
        for _, v in ipairs(player_lib.__must_save_data) do
            p[v] = lastp[v]
        end
        for k, v in pairs(player_lib._cache_var) do
            var[k] = v
        end
        for k, v in pairs(player_lib._cache_weather) do
            lstg.weather[k] = v
        end
        for k,v in pairs(player_lib._cache_active_data) do
            local Active=activeItem_lib.ActiveTotalList[k]
            for index,value in pairs(v) do
                Active[index] = value
            end
        end
        task.Wait(15)
        player.StopLoss = false
        var.next_wave_id = var.now_wave_id
        if var._season_system then
            wea.next_weather = wea.now_weather
            wea.season_wave = wea.season_wave - 1
            table.remove(wea.total_weather)
        end
        --var.wave = var.wave + 1
        self.start_function(var.wave)
    end)
end
lib.GanYaoRewind = GanYaoRewind

local function JieHan_eff()
    local k = lstg.tmpvar.JieHan_eff_id or 0
    SmearScreen("JieHan" .. k, 60, 1, nil, nil, "mul+add",
            nil, nil, nil, 100, 100, 255)
    lstg.tmpvar.JieHan_eff_id = k + 1
end
lib.JieHan_eff = JieHan_eff

local function HuaYunLilyWhite()
    local bclass = boss.Define(Trans("bossname", "Whitelily"), 0, 400, nil, "Whitelily")

    local non_sc = boss.card.New("", 4, 7, 40, stage_lib.GetHP(900))
    boss.card.add(bclass, non_sc)
    function non_sc:before()
        self.is_subBoss = true
        self.ui.timeCounter.yoffset2 = -15
        --self.ui.drawtime = false
    end
    function non_sc:other_drop()
        local othercond = function(tool)
            return tool.quality == 3 or tool.quality == 4
        end
        local addition = stg_levelUPlib.GetAdditionList(1, othercond)
        if #addition > 0 then
            item.dropItem(item.drop_card, 1, self.x, self.y + 30, addition[1].id)
        end
    end
    function non_sc:init()
        task.New(self, function()
            local function teleport(ix, iy, x, y)
                Newcharge_in(ix, iy, 135, 206, 235)
                task.Wait(50)
                for i = 1, 10 do
                    i = sin(i * 9)
                    self.hscale = 1 - i
                    self.vscale = 1 + i
                    task.Wait()
                end
                self.x, self.y = x, y
                task.New(self, function()
                    for i = 1, 10 do
                        i = sin(i * 9)
                        self.hscale = i
                        self.vscale = 2 - i
                        task.Wait()
                    end
                end)
            end
            teleport(0, 100, 0, 100)
            task.Wait(25)
            task.init_left_wait(self)
            local var = lstg.var
            while true do
                local d = 1
                for k = 1, 4 do
                    local rot = ran:Float(0, 360)
                    for n = 1, 5 do
                        for a, i in sp.math.AngleIterator(rot, int(min(var.chaos / 45) + 5, 13) * 3) do
                            local t = int(i / 3) % 2
                            local v = 1.5 + n
                            local tv = min(10, var.chaos / 250 + 1.3)
                            if t == 1 then
                                Create.bullet_dec_setangle(self.x, self.y, arrow_big, 2, false,
                                        { v = v, a = a, time = 60 }, { func = function(self)
                                            object.SetV(self, tv, Angle(self, player), true)
                                        end })
                            else
                                Create.bullet_dec_setangle(self.x, self.y, grain_a, 6, false,
                                        { v = v, a = a, time = 60 }, { v = tv, a = a - i % 3 * 90 })
                            end
                        end
                        rot = rot + 6 * d
                    end
                    PlaySound("tan00")
                    task.Wait(max(25, 60 - var.chaos / 10))

                    local x, y = task.MoveToPlayer(0, -200, 200, 100, 160,
                            50, 60, 20, 40, 2, 1)
                    if k == 4 then
                        x = 0
                        y = -30
                    end
                    teleport(self.x, self.y, x, y)
                    task.Wait(50)
                    d = -d
                end
                task.New(self, function()
                    task.MoveTo(0, 120, 150, 3)
                end)
                local t = int(min(20 + var.chaos / 25), 65)
                for i = 1, t do
                    local r = ran:Float(0.2, 0.7)
                    local v = ran:Float(1, 2) + min(var.chaos / 400, 6)
                    local k = int(min(4 + var.chaos / 60, 12))
                    local c = (k - 1) / 2
                    for n = -c, c do
                        local rot = 90 + d * (10 + 250 / t * i) + n * 60 / c
                        Create.bullet_changeangle(self.x, self.y, ball_mid, 4 - d * 2,
                                v, rot, { r = d * r, time = 60 })
                    end
                    d = -d
                    PlaySound("tan00")
                    task.Wait2(self, 150 / t)
                end
                task.Wait(max(32, 80 - var.chaos / 25))
            end


        end)
    end
    boss.Create(bclass)
end
lib.HuaYunLilyWhite = HuaYunLilyWhite

local dead_soul = Class(enemy)
function dead_soul:init(x, y, vx, vy)
    enemy.init(self, 30, 1, false, true, false, 0)
    self.pass_check = true
    self.is_damage = true--有害
    self.last_priority = true
    self.flag = false
    self.x, self.y = x, y
    self.vx, self.vy = vx, vy
end
lib.dead_soul = dead_soul

DoFile("mod\\weather\\weather_obj.lua")
DoFile("mod\\weather\\weather_obj2.lua")
DoFile("mod\\weather\\weather_obj3.lua")
