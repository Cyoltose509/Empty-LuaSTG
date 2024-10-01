local lib = {}
stg_levelUPlib = lib

loadLanguageModule("addition", "mod\\addition\\addition_lang")
loadLanguageModule("addition_item", "mod\\addition\\addition_lang")
local function _t(str)
    return Trans("addition", str) or ""
end

---@type level_obj
lib.class = DoFile("mod\\addition\\level_obj.lua")
---@type level_obj2
lib.class2 = DoFile("mod\\addition\\level_obj2.lua")
---@type level_obj3
lib.class3 = DoFile("mod\\addition\\level_obj3.lua")
---@type level_obj4
lib.class4 = DoFile("mod\\addition\\level_obj4.lua")
---@type level_obj5
lib.class5 = DoFile("mod\\addition\\level_obj5.lua")

local function EXP_Line_old(x, index)
    return int(-6660 / (x ^ 0.5 + index) + 731)
end

local function EXP_Line_New(x, f1, f50)
    local a = 0.001588372
    local b = -150 * a
    local d = 50 / 49 * (f1 - f50 / 50 - 4851 * a)
    local c = (f50 + 250000 * a - d) / 50
    return int(a * x * x * x + b * x * x + c * x + d)
end

local KP = 1.4 ^ 10

local function EXP_Line_New2(x, f50)
    return int(1.4 ^ (x - 40) + f50 - KP)
end

local function GetCurMaxEXP(x)
    local v = lstg.var
    x = x or v.level
    x = x + v.level_offset
    x = max(x, 1)
    local index = v.level_exp_index or 9
    local f1 = EXP_Line_old(1, index)
    local f50 = EXP_Line_old(50, index)
    local normal = 1
    if x <= 50 then
        normal = EXP_Line_New(x, f1, f50)
    else
        normal = EXP_Line_New2(x, f50)
    end
    if lstg.tmpvar.ReimuSkill2 and x % 5 == 0 then
        normal = 25
    end
    return normal
end
lib.GetCurMaxEXP = GetCurMaxEXP

---@param count number@获取数量
---@param othercondition fun(p:addition_unit)其他条件
local function GetAdditionList(count, othercondition)
    local var = lstg.var
    local wea = lstg.weather
    local normal = var.level_upOption
    count = count or normal
    othercondition = othercondition or function(add)
        if wea.BiYiRi then
            return add.state == 1
        end
        if wea.JiaoYiRi then
            return add.state == 2
        end
        if wea.QinHaiRi then
            return add.state == 3
        end
        return true
    end
    local list = {}
    local luck = player_lib.GetLuck()
    local chaos = var.chaos
    local temp = {}
    local lastp = 0
    local tmpvar_otherCondition = lstg.var.othercondition
    ---@param p addition_unit
    for _, p in ipairs(lib.AdditionList) do
        local nowc = (lstg.var.addition[p.id] or 0)
        local maxc = p.maxcount or 999
        if p.upgrade_get() and (nowc < maxc) and othercondition(p) and tmpvar_otherCondition(p) and not p.broken then
            if not (var.stop_0_tool and p.quality == 0) then
                local lp = p.luck_power * min(luck, 50) / 50
                local cp = p.chaos_power * min(chaos, 25) / 25
                local rp = p.repeat_power * nowc
                local nowp = max((p.proba + lp + cp) * (rp + 1), 0) * p.pro_fixed
                if nowp > 0 then
                    table.insert(temp, { p.id, lastp, lastp + nowp })
                end
                lastp = lastp + nowp
            end

        end
    end

    for _ = 1, count do
        local n = ran:Float(0, lastp)
        for k, p in ipairs(temp) do
            if p[2] <= n and n < p[3] then
                table.insert(list, lib.AdditionTotalList[p[1]])
                local len = p[3] - p[2]
                for _k = k + 1, #temp do
                    temp[_k][2] = temp[_k][2] - len
                    temp[_k][3] = temp[_k][3] - len
                end
                lastp = lastp - len
                table.remove(temp, k)
                break
            end
        end
    end
    return list
end
lib.GetAdditionList = GetAdditionList

local function RandomEvent(sound, describe)
    local k = GetAdditionList(1)
    lib.SetAddition(k[1], true)
    ext.notice_menu:AdditionAdd(k[1].id, sound, describe)
end

local function SelectAddition(otherevent, othercondition)
    local tvar = lstg.tmpvar
    local list
    if tvar.next_additionList then
        list = tvar.next_additionList
        tvar.next_additionList = nil
    else
        list = GetAdditionList(nil, othercondition)
    end
    ext.level_menu:FlyIn(list, otherevent, nil, true)
    if tvar.levelUp_event then
        tvar.levelUp_event()
        tvar.levelUp_event = nil
    end
end
lib.SelectAddition = SelectAddition

local function LevelUp(otherevent)
    local v = lstg.var
    v.level = v.level + 1
    lstg.tmpvar.level_up_count = lstg.tmpvar.level_up_count + 1--波内升级个数
    do
        if v.level >= 5 then
            ext.achievement:get(14)
        end
        if v.level >= 15 then
            mission_lib.GoMission(10)
        end
        if v.level >= 20 then
            mission_lib.GoMission(37)
        end
        if v.level >= 25 then
            mission_lib.GoMission(38)
        end
        if v.level >= 30 then
            mission_lib.GoMission(39)
        end
    end
    if v.red_wish > 0 then
        lib.red_wish_LevelUp()
    end
    if v.philosopher_stone then
        local p = player
        local ss = p.shoot_set.speed
        ss.offset = ss.offset - 0.012 * v.philosopher_stone_n
        p.dmg_offset = p.dmg_offset - 0.012 * v.philosopher_stone_n
        v.philosopher_stone_n = 0--贤者之石
    end
    if v.levelup_healing then
        player_lib.AddLife(min(v.level, 50) * 0.01 * v.maxlife)
    end
    if v.randomLevelUp then
        RandomEvent()
        otherevent()
    else
        if lstg.weather.QiuFen and ran:Float(0, 1) < 0.25 then
            local k = GetAdditionList(1)
            lib.SetAddition(k[1])
            ext.popup_menu:FlyInOneTool(Trans("weather", 3)["other18"], 255, 227, 132, k[1].id, "bonus2")
        end--额外获得一个道具
        if v.infinite_nightmare and ran:Float(0, 1) < 0.13 then
            local k = lib.ListByState[3][ran:Int(1, #lib.ListByState[3])]
            lib.SetAddition(k, true)
            ext.notice_menu:AdditionAdd(k.id, "pin00", Trans("addition_item", 1)["永恒的回音"],
                    25, 250, 128, 114)
        end
        if not v.level_up_func then
            if not v._pathlike then
                SelectAddition(otherevent)
            end
        else
            v.level_up_func(otherevent)
        end
    end
end

---设置加成
---@param m addition_unit
local function SetAddition(m, nostolen, otherflag)
    lib.SortToolUnits()
    local v = lstg.var
    local k = GetAdditionList(1, function(tool)
        return tool.isTool
    end)
    if not nostolen and v.steal_sun and ran:Float(0, 1) < 0.2 and #k > 0 then

        lib.SetAddition(k[1], true)
        if k[1].quality == 4 and m.quality == 0 then
            ext.achievement:get(92)
        end
        if k[1].quality <= 3 and m.quality == 4 then
            ext.achievement:get(63)
        end
        ext.popup_menu:FlyInOneTool(_t("additionStolen"), 250, 255, 255, k[1].id)
        ext.popup_menu:FlyInOneTool(_t("additionLost"), 250, 128, 114, m.id, "invalid")
    else
        local c = 1
        if m.state == 1 and v.double_BiYi and not m.spBENEFIT then
            c = 2
        end
        for _ = 1, c do
            if m.id then
                --这是不是真的
                if not v.addition[m.id] then
                    v.addition[m.id] = 1
                    if m.state > 10 then
                        table.insert(v.addition_order, { id = m.id, x = 880, y = 480 - 45 * 4, index = 0, count = 1 })--用于ui显示，提前存个x和y和index
                        v.addition_pos[m.id] = #v.addition_order
                    end
                else
                    v.addition[m.id] = v.addition[m.id] + 1
                    if m.state > 10 then
                        local unit = v.addition_order[v.addition_pos[m.id]]
                        unit.index = unit.index + 0.15--闪烁一下
                        unit.count = unit.count + 1
                    end
                end
                local state = m.state
                if state > 10 then
                    ext.achievement:get(11)
                    state = 11
                end
                v.addition_count[state] = v.addition_count[state] or 0
                v.addition_count[state] = v.addition_count[state] + 1
                scoredata.BookAddition[m.id] = true
                scoredata.ShowNewAddition[m.id] = true
            end
            if lstg.tmpvar.AyaSkill2 and m.isTool then
                player_lib.AddMaxLife(1)
                player_lib.AddChaos(-1)
            end
            m.event(1, true, otherflag)
            ---任务相关
            if lib.SearchToolTag(m, "nine") then
                mission_lib.GoMission(14, 1 / 9 * 100 + 0.01)
            end
        end
    end
end
lib.SetAddition = SetAddition

local function RemoveAddition(m)
    lib.SortToolUnits()
    local v = lstg.var
    if m.id and v.addition[m.id] then
        --这是不是真的
        if v.addition[m.id] == 1 then
            v.addition[m.id] = nil
            if m.state > 10 then
                local pos = v.addition_pos[m.id]
                table.remove(v.addition_order, pos)
                v.addition_pos[m.id] = nil
                for k in pairs(v.addition_pos) do
                    if v.addition_pos[k] > pos then
                        v.addition_pos[k] = v.addition_pos[k] - 1
                    end
                end
            end
        else
            v.addition[m.id] = v.addition[m.id] - 1
            if m.state > 10 then
                local unit = v.addition_order[v.addition_pos[m.id]]
                unit.index = unit.index + 0.15--闪烁一下
                unit.count = unit.count - 1
            end
        end
        if not m.broken then
            if lstg.tmpvar.AyaSkill2 and m.isTool then
                player_lib.AddMaxLife(-1)
                player_lib.AddChaos(1)
            end
            m.del_func()
        end
        local state = m.state
        if v.addition_count[state] and v.addition_count[state] > 0 then
            v.addition_count[state] = v.addition_count[state] - 1
        end

    end
end
lib.RemoveAddition = RemoveAddition

---道具的损坏
local function BreakAddition(m)
    lib.SortToolUnits()
    local v = lstg.var
    if m.id and v.addition[m.id] then
        if not m.broken then
            for _ = 1, v.addition[m.id] do
                if lstg.tmpvar.AyaSkill2 and m.isTool then
                    player_lib.AddMaxLife(-1)
                    player_lib.AddChaos(1)
                end
                m.del_func()
            end
        end
        m.broken = true
    end
end
lib.BreakAddition = BreakAddition

---损坏道具的恢复
local function RecoverAddition(m)
    lib.SortToolUnits()
    local v = lstg.var
    if m.id then
        --这是不是真的
        if m.state > 10 then
            local unit = v.addition_order[v.addition_pos[m.id]]
            unit.index = unit.index + 0.15--闪烁一下
        end
    end
    if lstg.tmpvar.AyaSkill2 and m.isTool then
        player_lib.AddMaxLife(1)
        player_lib.AddChaos(-1)
    end
    m.broken = false
    m.event(1, true)
end
lib.RecoverAddition = RecoverAddition

local function TwiceAddition(func)
    ---@type addition_unit
    local self = {}
    self.title = _t("Trade") .. _t("TwiceAddition")

    self.R, self.G, self.B = 250, 150, 200
    self.state = 2
    self.pic = "addition_state" .. self.state
    self.describe = _t("TwiceAdditionDes")
    self.event = func
    return self
end
lib.TwiceAddition = TwiceAddition

local function NoneAddition()
    ---@type addition_unit
    local self = {}
    self.title = _t("NONEtitle") .. _t("NoneAddition")
    self.title2 = self.title
    self.R, self.G, self.B = 230, 250, 230
    self.state = 1
    self.pic = "addition_state" .. self.state
    self.describe = _t("NoneAdditionDes")
    self.event = function()
    end
    return self
end
lib.NoneAddition = NoneAddition

local function VoidAddition(func)
    ---@type addition_unit
    local self = {}
    self.title = _t("Unselectedtitle")
    self.title2 = self.title
    self.R, self.G, self.B = 250, 230, 230
    self.state = 1
    self.pic = "addition_state" .. self.state
    self.describe = _t("Unselectedtitle")
    self.event = func or function()
    end
    return self
end
lib.VoidAddition = VoidAddition

local function NotFoundAddition()
    ---@type addition_unit
    local self = {}
    self.title = "【？？】？？？"
    self.R, self.G, self.B = 120, 120, 120
    self.state = 1
    self.pic = "menu_check_addition"
    self.describe = "？  ？  ？\n？  ？  ？"
    self.event = function()
    end
    return self
end
lib.NotFoundAddition = NotFoundAddition

local function LockedAddition()
    ---@type addition_unit
    local self = {}
    self.title = _t("Unlockedtitle")
    self.title2 = self.title
    self.R, self.G, self.B = 120, 120, 120
    self.state = 4
    self.pic = "addition_state" .. self.state
    if not CheckRes("tex", self.pic) then
        LoadImageFromFile(self.pic, ("mod\\addition\\addition_unit\\state%s.png"):format(self.state), true)
    end
    self.describe = _t("Unlockedtitle")
    self.event = function()
    end
    return self
end
lib.LockedAddition = LockedAddition

function AddExp(exp, LiQiuFlag)
    LiQiuFlag = LiQiuFlag or false
    local v = lstg.var
    exp = exp * v.exp_factor
    local maxexp = GetCurMaxEXP()
    local last = v.now_exp
    v.now_exp = min(maxexp, v.now_exp + exp)
    local now = v.now_exp
    if v.now_exp >= maxexp then
        v.now_exp = 0
        local n = (exp - (now - last)) / v.exp_factor
        LevelUp(function()
            if v.blue_wish ~= 0 then
                if not v.level_up_func then
                    if not v._pathlike then
                        SelectAddition()
                    end
                else
                    v.level_up_func()
                end
            end
            if lstg.weather.LiQiu and ran:Float(0, 1) < 0.5 and not LiQiuFlag then
                LiQiuFlag = true
                n = n + GetCurMaxEXP()--额外升一级
            end
            AddExp(n, LiQiuFlag)
            player.protect = max(9 + v.protect_time_ex, player.protect)--无敌一下
        end)

    end
end

function DropExpPoint(exp, x, y)
    local var = lstg.var
    var.drop_exp_point = var.drop_exp_point + exp - int(exp)
    if var.drop_exp_point >= 1 then
        item.dropItem(item.drop_exp, int(var.drop_exp_point), x, y)
        var.drop_exp_point = var.drop_exp_point - int(var.drop_exp_point)
    end--小数式掉落
    item.dropItem(item.drop_exp, int(exp), x, y)
end

lib.AdditionList = {}--当前的列表
lib.ListByQual = { {}, {}, {}, {}, {} }
lib.ListByTags = {}
lib.ListByState = {}
lib.AdditionTotalList = {}--总加成列表

local qual_col = {
    { 230, 220, 230 },
    { 130, 255, 132 },
    { 128, 210, 255 },
    { 255, 128, 240 },
    { 255, 220, 132 }
}

---@return addition_unit
---@param event fun(d:number, flag:boolean)
local function NewSimpleAdditionUnit(id, repeatp, state, title, event, text, cond, maxc, initialTake, qual, locked)
    ---@class addition_unit
    local self = {}
    self.id = id
    ---基础概率
    self.proba = 0.1
    ---幸运值权重
    self.luck_power = 0.1
    ---混沌值权重
    self.chaos_power = 0
    local beforeTitle = ""
    if state == 1 then
        ---裨益与品质1等效
        table.insert(lib.ListByQual[2], self)
        self._quality = 1
        beforeTitle = _t("Benefit")
    elseif state == 2 then
        ---交易与品质2等效
        table.insert(lib.ListByQual[3], self)
        self._quality = 2
        beforeTitle = _t("Trade")
    elseif state == 3 then
        beforeTitle = _t("Infringe")
    else
        beforeTitle = _t("Item")
    end
    ---叠卡权重
    self.repeat_power = repeatp
    self.title = beforeTitle .. title
    ---除去前缀的名称
    self.title2 = title
    ---只保留前缀的名称
    self.title3 = beforeTitle
    self.title4 = nil---可供修改的伪名称
    self.NeedRefresh = nil
    self.R, self.G, self.B = 255, 255, 255
    ---概率修正，一般由其他道具修改
    self.pro_fixed = 1
    self.state = state
    if state == 1 then
        self.R, self.G, self.B = 189, 252, 201
    elseif state == 2 then
        self.R, self.G, self.B = 250, 150, 200
    elseif state == 3 then
        self.R, self.G, self.B = 250, 100, 100
    end
    if state > 10 then
        self.isTool = true
        self.quality = qual
        self.R, self.G, self.B = unpack(qual_col[qual + 1])
        self._quality = qual
        ---副标题
        self.subtitle = ""
        ---详述
        self.detail = ""
        ---叠加效果
        self.repeat_des = ""
        ---道具协同
        self.collab_des = ""
        ---解锁方式
        self.unlock_des = ""
        ---出现前提
        self.cond_des = ""
        ---标签
        self.tags = {}
    end
    self.pic = "addition_state" .. self.state
    if GlobalLoading then
        LoadImageFromFile(self.pic, ("mod\\addition\\addition_unit\\state%s.png"):format(self.state), true)
        local w, h = GetImageSize(self.pic)
        local k = max(w, h)
        SetImageScale(self.pic, 256 / k)
    else
        table.insert(LoadRes, function()
            LoadImageFromFile(self.pic, ("mod\\addition\\addition_unit\\state%s.png"):format(self.state), true)
            local w, h = GetImageSize(self.pic)
            local k = max(w, h)
            SetImageScale(self.pic, 256 / k)
        end)
    end
    self.describe = text
    ---选择后进行的事件
    self.event = event
    self.maxcount = maxc
    ---当这个道具满叠时，通关时即可解锁初始携带
    ---允许解锁初始携带，默认为否（即不可以初始携带）
    self.initialTake = initialTake or false
    ---损坏？
    self.broken = false
    self.del_func = function()
        self.event(-1, false)--消失时就-1（减回去），false（开关关掉）
    end--道具损坏/消失时执行的函数
    ---临时道具
    self.temporary = false

    self.is_locked = locked--保存其拥有的flag
    ---出现的条件
    self.condition = cond
    ---是否在升级时出现
    self.upgrade_get = function()
        local flag = true
        if state == 3 then
            return lstg.weather.QinHaiRi--非侵害日时侵害直接不出现
        end
        flag = flag and scoredata.UnlockAddition[self.id]--解锁机制
        if self.condition then
            flag = flag and self.condition()
        end
        return flag
    end

    if state < 10 then
        lib.ListByState[state] = lib.ListByState[state] or {}
        table.insert(lib.ListByState[state], self)
    end
    table.insert(lib.AdditionList, self)
    lib.AdditionTotalList[id] = self

    local data = scoredata
    if not initialTake then
        data.initialAddition[id] = false
    else
        data.initialAddition[id] = data.initialAddition[id] or false
    end
    data.ShowNewAddition[id] = data.ShowNewAddition[id] or false
    data.BookAddition[id] = data.BookAddition[id] or false
    data.NoticeinitialAddition[id] = data.NoticeinitialAddition[id] or false
    if not data.UnlockAddition[id] then
        if locked then
            data.UnlockAddition[id] = false
        else
            data.UnlockAddition[id] = true--就直接开启咯
        end
    end

    return self
end
lib.NewSimpleAdditionUnit = NewSimpleAdditionUnit

---@param event fun(d:number, flag:boolean)
local function NewNomalUnit(id, repeatp, state, title, event, text)
    NewSimpleAdditionUnit(id, repeatp, state, title, event, text)
end
lib.NewNomalUnit = NewNomalUnit

local function AddWaveEvent(eventName, eventLevel, eventFunc)
    if stage.current_stage.eventListener then
        return stage.current_stage.eventListener:addEvent("waveEvent@before", eventName, eventLevel, eventFunc)
    end
end
lib.AddWaveEvent = AddWaveEvent
local function RemoveWaveEvent(eventName)
    if stage.current_stage.eventListener then
        return stage.current_stage.eventListener:remove("waveEvent@before", eventName)
    end
end
lib.RemoveWaveEvent = RemoveWaveEvent

local function AddWaveFinalEvent(eventName, eventLevel, eventFunc)
    if stage.current_stage.eventListener then
        return stage.current_stage.eventListener:addEvent("waveEvent@after", eventName, eventLevel, eventFunc)
    end
end
lib.AddWaveFinalEvent = AddWaveFinalEvent
local function RemoveWaveFinalEvent(eventName)
    if stage.current_stage.eventListener then
        return stage.current_stage.eventListener:remove("waveEvent@after", eventName)
    end
end
lib.RemoveWaveFinalEvent = RemoveWaveFinalEvent

--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------

---@param tool addition_unit
local function SearchToolTag(tool, tagname)
    if tool.tags then
        for _, n in ipairs(tool.tags) do
            if n == lib.tagslist[tagname] then
                return true
            end
        end
    end
end
lib.SearchToolTag = SearchToolTag

---按品质分概率
---刷新高级裨益
local function SortToolUnits()
    local list = lib.ListByQual
    local v = lstg.var
    local w = lstg.weather
    local nums = {}
    for i = 1, 5 do
        nums[i] = #list[i]
    end
    for _, u in pairs(lib.AdditionTotalList) do
        local nowc = (v.addition and v.addition[u.id]) or 0
        local maxc = u.maxcount or 999
        if nowc >= maxc or u.pro_fixed == 0 or not u.upgrade_get() then
            if u._quality then
                local k = u._quality + 1
                nums[k] = nums[k] - 1
            end
        end--不可获得的时候减掉概率的计算
    end

    local qual_pro = { 0.1, 0.40, 0.40, 0.1, 0 }
    local qual_luckp = { -0.05, 0, 0.02, 0.02, 0.01 }
    local qual_chaosp = { -0.005, -0.01, 0, 0.01, 0.005 }
    if w.RuiXue then
        qual_pro[5] = qual_pro[5] + 0.05
        qual_pro[4] = qual_pro[4] + 0.1
        --0级1级被顶下去
        qual_pro[1] = qual_pro[1] - 0.05
        qual_pro[2] = qual_pro[2] - 0.1
    end
    for i = 1, 5 do
        local num = max(nums[i], 1)

        qual_pro[i] = qual_pro[i] / num
        qual_luckp[i] = qual_luckp[i] / num
        qual_chaosp[i] = qual_chaosp[i] / num
        ---@param unit addition_unit
        for _, unit in ipairs(list[i]) do
            unit.proba = max(qual_pro[i], 0)
            unit.luck_power = qual_luckp[i]
            unit.chaos_power = qual_chaosp[i]
        end
    end

end
lib.SortToolUnits = SortToolUnits

local tagslist = {
    --常见标签定义
    defend = _t("defend"),
    sacrifice = _t("sacrifice"),
    chaos = _t("chaos"),
    life = _t("life"),
    tp = _t("tp"),
    nine = _t("nine"),
    resurrection = _t("resurrection"),
    RGB = _t("RGB"),
    neet = _t("neet"),
    baby = _t("baby"),
    siyuan = _t("siyuan"),
    store = _t("store"),
}
lib.tagslist = tagslist

---道具的详细信息补充
local function DetailToolUnit(id, stitle, detail, repeatd, tags, collabd, unlockd, condd)
    local none = _t("none")
    ---@type addition_unit
    local u = lib.AdditionTotalList[id]
    u.subtitle = stitle or none
    u.detail = detail or none
    u.repeat_des = repeatd or none
    u.collab_des = collabd or none
    u.unlock_des = unlockd or none
    u.cond_des = condd or none
    if type(tags) == "string" then
        u.tags = { tags }
    else
        u.tags = tags or { none }
    end

end
lib.DetailToolUnit = DetailToolUnit

---语言模块式补充道具详细信息
local module = "addition_des"
loadLanguageModule(module, "mod\\addition\\addition_lang")

---@param event fun(d:number, flag:boolean)
---@param locked boolean@是否锁定，需要特定情况来解锁，或者在升级时永远无法获得
---@param getCond function@在升级时所有条件符合后，最后的出现条件
local function NewToolUnit(id, qual, repeatp, state, title, event, maxc, initialTake, locked, getCond)
    local p = qual + 1
    local c = Trans(module, p)[id]
    local n = NewSimpleAdditionUnit(id, repeatp, state, title, event, c.sdes, getCond, maxc, initialTake, qual, locked)
    DetailToolUnit(id, c.stitle, c.detail, c.repeatd, c.tags, c.collabd, c.unlockd, c.condd)
    table.insert(lib.ListByQual[p], n)
end
lib.NewToolUnit = NewToolUnit

DoFile("mod\\addition\\init_addition2.lua")
DoFile("mod\\addition\\init_addition.lua")