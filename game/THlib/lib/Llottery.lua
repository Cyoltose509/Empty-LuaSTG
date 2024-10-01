local lib = {}

lottery_lib = lib

lib.totalPool = {}--总池子
lib.currentPool = {}--当前池子
lib.ToolCount = 0
lib.CharaCount = 0

---@param state number@1资金力，2道具，3角色
---@param quality number@1蓝，2紫，3黄
local function NewRewardUnit(id, data, state, event, quality)
    ---@class reward_unit
    local u = {}
    u.state = state
    u.id = id
    u.data = data
    u.event = event
    u.quality = quality
    table.insert(lib.totalPool, u)
    scoredata.rewarded[u.id] = scoredata.rewarded[u.id] or false
    return u
end

local function Reward_Money(count, quality)
    local t = #lib.totalPool
    local id = t + 1
    return NewRewardUnit(id, count, 1, function()
        AddMoney(count)
    end, quality)
end

local function Reward_Tool(toolid, quality)
    local t = #lib.totalPool
    local id = t + 1
    lib.ToolCount = lib.ToolCount + 1
    return NewRewardUnit(id, toolid, 2, function()
        scoredata.UnlockAddition[toolid] = true
        scoredata.BookAddition[toolid] = true--可以在图鉴里显示
    end, quality)
end

local function Reward_Player(playerid, quality)
    local t = #lib.totalPool
    local id = t + 1
    lib.CharaCount = lib.CharaCount + 1
    return NewRewardUnit(id, playerid, 3, function()
        local p = player_list[playerid]
        local data = playerdata[p.name]
        if data.unlock_c then
            data.unlock_c = min(3, data.unlock_c + 1)
            if data.unlock_c == 3 then
                local achievementGet = { 95, 96, 122, 123, 1, 1, 1 }--TODO
                ext.achievement:get(achievementGet[playerid])
            end
        else
            ---以后获得角色自动有1天赋
            data.unlock_c = 1
        end
        data.choose_skill[data.unlock_c] = true
    end, quality)
end

local function InitRewardPool()
    lib.currentPool = {}
    for _, p in ipairs(lib.totalPool) do
        if not scoredata.rewarded[p.id] then
            table.insert(lib.currentPool, p)
        end
    end
end
lib.InitRewardPool = InitRewardPool

local function DefineRewardPool()
    ---v1.0
    for i = 1, 85 do
        local count = (i % 4) * 50 + 400
        Reward_Money(count, 1)
    end
    for i = 1, 30 do
        local count = (i % 4) * 50 + 800
        Reward_Money(count, 1)
    end
    for i = 1, 10 do
        local count = (i % 4) * 50 + 1200
        Reward_Money(count, 1)
    end
    --0级
    Reward_Tool(88, 2)
    --1级
    Reward_Tool(35, 2)
    Reward_Tool(91, 2)
    Reward_Tool(95, 2)
    Reward_Tool(121, 2)
    --2级
    Reward_Tool(94, 2)
    --3级
    Reward_Tool(21, 2)
    Reward_Tool(63, 2)
    Reward_Tool(77, 2)
    Reward_Tool(84, 2)
    Reward_Tool(93, 2)
    Reward_Tool(105, 2)
    Reward_Tool(111, 2)
    Reward_Tool(123, 2)
    Reward_Tool(129, 2)
    Reward_Tool(130, 2)
    Reward_Tool(131, 2)
    --4级
    Reward_Tool(64, 2)
    Reward_Tool(115, 2)
    for _ = 1, 3 do
        Reward_Player(1, 3)
        Reward_Player(2, 3)
    end

    ---v1.1
    for i = 1, 101 do
        local count = (i % 4) * 50 + 400
        Reward_Money(count, 1)
    end
    for i = 1, 30 do
        local count = (i % 4) * 50 + 800
        Reward_Money(count, 1)
    end
    for i = 1, 10 do
        local count = (i % 4) * 50 + 1200
        Reward_Money(count, 1)
    end
    --0级
    Reward_Tool(143, 2)
    --1级
    Reward_Tool(141, 2)
    Reward_Tool(145, 2)
    Reward_Tool(146, 2)
    Reward_Tool(148, 2)
    Reward_Tool(149, 2)
    Reward_Tool(156, 2)
    Reward_Tool(167, 2)
    --2级
    Reward_Tool(139, 2)
    Reward_Tool(140, 2)
    Reward_Tool(147, 2)
    Reward_Tool(157, 2)
    --3级
    Reward_Tool(150, 2)
    for _ = 1, 3 do
        Reward_Player(3, 3)
        Reward_Player(4, 3)
    end

    ---v1.3
    for _ = 1, 3 do
        Reward_Player(5, 3)
        Reward_Player(6, 3)
        Reward_Player(7, 3)
    end
end
lib.DefineRewardPool = DefineRewardPool

local function GetReward(reward)
    local t = os.time()
    local data = scoredata
    table.insert(data.rewardedRecord, { reward.id, t })
    data.rewarded[reward.id] = true
    reward.event()
end
lib.GetReward = GetReward