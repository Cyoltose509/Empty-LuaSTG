---层次结构
---@class LAYER
LAYER = {
    --- -700
    BG = -700,
    --- -600
    ENEMY = -600,
    --- -500
    PLAYER_BULLET = -500,
    --- -400
    PLAYER = -400,
    --- -300
    ITEM = -300,
    --- -200
    ENEMY_BULLET = -200,
    --- -100
    ENEMY_BULLET_EF = -100,
    --- 0
    TOP = 0
}
----------------------------------------
---class
local emptyfunc = function()
end
local all_class = {}

---base class of all classes
local object = { 0, 0, 0, 0, 0, 0,
                 is_class = true,
                 ---方便填东西的东西吧应该吧
                 init = function(self, x, y, group, layer)
                     self.x, self.y = x or self.x, y or self.y
                     self.group = group or self.group
                     self.layer = layer or self.layer
                 end,
                 del = emptyfunc,
                 frame = emptyfunc,
                 render = DefaultRenderFunc,
                 colli = emptyfunc,
                 kill = emptyfunc
}
table.insert(all_class, object)
---@class object
_G.object = object

---有用吗
---将目标的回调函数给自己
local function Equivalent(self, target)
    self.init = target.init
    self.del = target.del
    self.frame = target.frame
    self.render = target.render
    self.colli = target.colli
    self.kill = target.kill
end

---有用吗
---对回调函数进行整理，给底层调用
local function ClassSort(class)
    class[1] = class.init
    class[2] = class.del
    class[3] = class.frame
    class[4] = class.render
    class[5] = class.colli
    class[6] = class.kill
end
RegisterClass = ClassSort
---定义新类
---@param base object
---@param define table
---@param sort boolean@是否现场整理
---@return object
function Class(base, define, sort)
    base = base or object
    local result = { emptyfunc, emptyfunc, emptyfunc, emptyfunc, emptyfunc, emptyfunc, is_class = true, base = base }
    Equivalent(result, base)
    if type(define) == "table" then
        for k, v in pairs(define) do
            result[k] = v
        end
    end
    if sort then
        ClassSort(result)
    else
        table.insert(all_class, result)
    end
    return result
end

function InitAllClass()
    for _, v in pairs(all_class) do
        ClassSort(v)
    end
    all_class = {}
end

---碰撞组
---@class GROUP
local GROUP = {
    ---0
    GHOST = 0,
    ---1
    ENEMY_BULLET = 1,
    ---2
    ENEMY = 2,
    ---3
    PLAYER_BULLET = 3,
    ---4
    PLAYER = 4,
    ---5
    INDES = 5,
    ---6
    ITEM = 6,
    ---7
    NONTJT = 7,
    ---8
    SPELL = 8, --由OLC添加，可用于自机bomb
    ---9
    CPLAYER = 9,
    ---10
    LASER = 10,
    ---11
    ENEMY_BULLET2 = 11--特殊的子弹组
}
_G.GROUP = GROUP

---碰撞对，用于碰撞检测
---第一个是全局池，第二个是关卡池
---@type <GROUP,GROUP> table[]
GROUP.CollisionPairs = {
    {
        { GROUP.PLAYER, GROUP.ENEMY_BULLET },
        { GROUP.PLAYER, GROUP.ENEMY_BULLET2 },
        { GROUP.PLAYER, GROUP.ENEMY },
        { GROUP.PLAYER, GROUP.INDES },
        { GROUP.ENEMY, GROUP.PLAYER_BULLET },
        { GROUP.NONTJT, GROUP.PLAYER_BULLET },
        { GROUP.ITEM, GROUP.PLAYER },
        { GROUP.SPELL, GROUP.ENEMY },
        { GROUP.SPELL, GROUP.NONTJT },
        { GROUP.SPELL, GROUP.ENEMY_BULLET },
        { GROUP.SPELL, GROUP.ENEMY_BULLET2 },
        { GROUP.SPELL, GROUP.INDES },
        { GROUP.PLAYER, GROUP.LASER },
        { GROUP.SPELL, GROUP.LASER },
        { GROUP.CPLAYER, GROUP.PLAYER },
        { GROUP.ENEMY_BULLET2, GROUP.ENEMY_BULLET }--很常用，我干脆放全局得了
    },
    {}
}
function GROUP.RegisterCollisionPair(pool, group1, group2)
    table.insert(GROUP.CollisionPairs[pool], { group1, group2 })
end
function GROUP.UnregisterCollisionPair(pool, group1, group2)
    for i = #GROUP.CollisionPairs[pool], 1, -1 do
        local v = GROUP.CollisionPairs[pool][i]
        if v[1] == group1 and v[2] == group2 then
            table.remove(GROUP.CollisionPairs[pool], i)
            return
        end
    end

end
function GROUP.CollisionCheck()
    for _, v in ipairs(GROUP.CollisionPairs[1]) do
        CollisionCheck(v[1], v[2])
    end
    for _, v in ipairs(GROUP.CollisionPairs[2]) do
        CollisionCheck(v[1], v[2])
    end
end
function GROUP.ResetCollisionPairs(pool)
    for i = 1, #GROUP.CollisionPairs[pool] do
        GROUP.CollisionPairs[pool][i] = nil
    end
end


