---主动道具逻辑
local lib = {}
activeItem_lib = lib

loadLanguageModule("active", "mod\\active")
loadLanguageModule("active_item", "mod\\active\\active_lang")
local function _t(str)
    return Trans("active", str) or ""
end

lib.ListByQual = { {}, {}, {}, {}, {} }
lib.ActiveTotalList = {}--主动道具总列表

local qual_col = {
    { 200, 220, 230 },
    { 110, 255, 132 },
    { 108, 210, 255 },
    { 235, 128, 240 },
    { 235, 220, 132 }
}

---@return addition_unit
---@param event fun()
---@param active_type number@充能类型：1是每帧，2是每波，3是每点攻击
---@param charge_c number@充能量
local function NewSimpleActiveUnit(id, qual, title, event, active_type, charge_c, maxe, cond, locked)
    ---@class active_unit
    local self = {}
    self.id = id
    ---可供修改的数据
    self.type = active_type
    self.charge_c = charge_c
    self.energy = 1
    self.energy_max = maxe or 1

    ---内部存储的数据
    self._type = active_type
    self._charge_c = charge_c
    self._energy_max = maxe
    ---基础概率
    self.proba = 0.1
    ---幸运值权重
    self.luck_power = 0.1
    ---混沌值权重
    self.chaos_power = 0
    local beforeTitle = _t("active")
    ---叠卡权重
    self.title = beforeTitle .. title
    ---除去前缀的名称
    self.title2 = title
    ---只保留前缀的名称
    self.title3 = beforeTitle
    self.R, self.G, self.B = 255, 255, 255
    ---概率修正，一般由其他道具修改
    self.pro_fixed = 1
    ---图片，默认为id
    self.state = id
    self.quality = qual
    self.R, self.G, self.B = unpack(qual_col[qual + 1])
    self._quality = qual
    ---副标题
    self.subtitle = ""
    ---详述
    self.detail = ""
    ---简述
    self.describe = ""
    ---解锁方式
    self.unlock_des = ""
    ---出现前提
    self.cond_des = ""
    ---标签
    self.tags = {}
    self.pic = "active_state" .. self.state
    if GlobalLoading then
        LoadImageFromFile(self.pic, ("mod\\active\\active_unit\\state%s.png"):format(self.state), true)
        local w, h = GetImageSize(self.pic)
        local k = max(w, h)
        SetImageScale(self.pic, 256 / k)
    else
        table.insert(LoadRes, function()
            LoadImageFromFile(self.pic, ("mod\\active\\active_unit\\state%s.png"):format(self.state), true)
            local w, h = GetImageSize(self.pic)
            local k = max(w, h)
            SetImageScale(self.pic, 256 / k)
        end)
    end

    ---使用后进行的事件
    self.event = event
    self.is_locked = locked--保存其拥有的flag
    ---出现的条件
    self.condition = cond

    lib.ActiveTotalList[id] = self

    local data = scoredata
    data.ShowNewActive[id] = data.ShowNewActive[id] or false
    data.BookActive[id] = data.BookActive[id] or false
    if not data.UnlockActive[id] then
        if locked then
            data.UnlockActive[id] = false
        else
            data.UnlockActive[id] = true--就直接开启咯
        end
    end

    return self
end
lib.NewSimpleActiveUnit = NewSimpleActiveUnit

---道具的详细信息补充
local function DetailActiveUnit(id, describe, stitle, detail, tags, unlockd, condd)
    local none = _t("none")
    ---@type addition_unit
    local u = lib.ActiveTotalList[id]
    u.subtitle = stitle or none
    u.describe = describe or none
    u.detail = detail or none
    u.unlock_des = unlockd or none
    u.cond_des = condd or none
    if type(tags) == "string" then
        u.tags = { tags }
    else
        u.tags = tags or { none }
    end

end
lib.DetailActiveUnit = DetailActiveUnit

---语言模块式补充道具详细信息
local module = "active_des"
loadLanguageModule(module, "mod\\active\\active_lang")

---@param event fun()
---@param active_type number@充能类型：1是每帧，2是每波，3是每点攻击
---@param charge_c number@充能量
local function NewActiveUnit(id, qual, title, event, active_type, charge_c, maxe, cond, locked)
    local p = qual + 1
    local c = Trans(module, p)[id] or {}
    local n = NewSimpleActiveUnit(id, qual, title, event, active_type, charge_c, maxe, cond, locked)
    DetailActiveUnit(id, c.sdes, c.stitle, c.detail, c.tags, c.unlockd, c.condd)
    table.insert(lib.ListByQual[p], n)
end
lib.NewActiveUnit = NewActiveUnit

local function SetActive(id)
    local var = lstg.var
    table.insert(var.active_item, 1, id)
    table.insert(var.UI_active_item, 1, {
        id = id,
        alpha = 0,
    })
    if #var.active_item > var.max_active_item then
        table.remove(var.active_item, 1)
        --TODO:掉落前一个主动
    end
end
lib.SetActive = SetActive

local function AddActiveChargeByWave()
    local var = lstg.var
    local id = var.active_item[1]
    if id then
        local Active = lib.ActiveTotalList[id]
        if Active.type == 2 then
            Active.energy = min(Active.energy_max, Active.energy + Active.charge_c)
            PlaySound("lgods1")--TODO:音效更改
        end
    end
end
lib.AddActiveChargeByWave = AddActiveChargeByWave

local function AddActiveChargeByFrame()
    local var = lstg.var
    local id = var.active_item[1]
    if id then
        local Active = lib.ActiveTotalList[id]
        if Active.type == 1 then
            Active.energy = min(Active.energy_max, Active.energy + Active.charge_c)
        end
    end
end
lib.AddActiveChargeByFrame = AddActiveChargeByFrame

local function AddActiveChargeByAttack(dmg)
    local var = lstg.var
    local id = var.active_item[1]
    if id then
        local Active = lib.ActiveTotalList[id]
        if Active.type == 3 then
            Active.energy = min(Active.energy_max, Active.energy + Active.charge_c * dmg)
        end
    end
end
lib.AddActiveChargeByAttack = AddActiveChargeByAttack

DoFile("mod\\active\\init_active.lua")