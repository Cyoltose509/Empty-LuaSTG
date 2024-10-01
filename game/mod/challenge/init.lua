local lib = {}
challenge_lib = lib
lib.class = {}
---@param money number
---@param conditionList table
local function SetSceneUnlockWay(self, money, conditionList)
    if money or conditionList then
        self.price = money or 0
        self.conditionList = conditionList or {}
        local data = stagedata
        data.challenge_unlock[self.id] = data.challenge_unlock[self.id] or false
        self.unlock_way = function()
            return data.challenge_unlock[self.id]
        end
    else
        self.price = 0
        self.unlock_way = load("return true")
    end
end
---@return scene_class
local function NewChallenge(id, bg, bgmlist, maxwave, inStageID, title, subtitle, initset, frameset, money, conditionList, success_func)
    ---@class challenge_unit
    local unit = {}
    --游戏外属性
    unit.id = id
    unit.title = title
    unit.subtitle = subtitle
    unit.inStageID = inStageID
    unit.init_set = initset or function()
    end
    unit.frame_set = frameset or function()
    end
    unit.success_func = success_func or function()
    end
    SetSceneUnlockWay(unit, money, conditionList)
    --游戏内属性
    unit._bg = bg
    unit._bgmlist = bgmlist
    unit._maxwave = maxwave

    challenge_lib.class[id] = unit
    local data = stagedata
    data.challenge_finish[id] = data.challenge_finish[id] or 0
    data.challenge_time[id] = data.challenge_time[id] or false
    return unit
end
lib.NewChallenge = NewChallenge

DoFile("mod\\challenge\\stage1.lua")
DoFile("mod\\challenge\\stage2.lua")
DoFile("mod\\challenge\\game.lua")

