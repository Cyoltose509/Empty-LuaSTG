---=====================================
---core
---所有基础的东西都会在这里定义
---=====================================

lstg = lstg or {}

local path = "THlib\\lib\\"
----------------------------------------
---各个模块
lstg.DoFile("THlib\\plus\\plus.lua")--CHU神的plus库，replay系统、plusClass、NativeAPI

lstg.DoFile(path .. "Llanguage.lua")--多语言功能
lstg.DoFile(path .. "Lresources.lua")--资源的加载函数、资源枚举和判断
lstg.DoFile(path .. "Llog.lua")--简单的log系统
lstg.DoFile(path .. "Lglobal.lua")--用户全局变量
lstg.DoFile(path .. "Lmath.lua")--数学常量、数学函数、随机数系统
lstg.DoFile(path .. "Lobject.lua")--Luastg的Class、object
lstg.DoFile(path .. "Lobjectevents.lua")--一些object事件函数
lstg.DoFile(path .. "Lscreen.lua")--world、3d、viewmode的参数设置
lstg.DoFile(path .. "Linput.lua")--按键状态更新
lstg.DoFile(path .. "Ltask.lua")--task
lstg.DoFile(path .. "Lstage.lua")--stage关卡系统
lstg.DoFile(path .. "Ltext.lua")--文字渲染
lstg.DoFile(path .. "Lscoredata.lua")--玩家存档
lstg.DoFile(path .. "Llottery.lua")--抽卡
lstg.DoFile(path .. "Lmission.lua")--任务


lstg.DoFile(path .. "Lmusicload.lua")--音乐加载相关
lstg.DoFile(path .. "Llockfunc.lua")--解锁方式



----------------------------------------
---用户定义的一些函数
function GameExit()
    if not lstg.quit_flag then
        if not scoredata["Alt+F4"] then
            scoredata["Alt+F4"] = true
        end
    end
    SaveScoreData()
end

----------------------------------------
---全局回调函数，底层调用
function GameInit()
    --加载mod包
    if setting.mod ~= 'launcher' then
        Include 'mod\\root.lua'
    else
        Include 'launcher.lua'
    end
    --最后的准备
    InitAllClass()
    InitScoreData()
    InitMusicList()
    InitPlayer()
    mission_lib.InitMission()
    lottery_lib.DefineRewardPool()
    _editor_class = {}
    _editor_boss = {}
    _sc_list = {}
    SceneClass = {}
    boss_group = {}
    inboundboss = {}
    AchievementInfo = {}
    cheat = nil
    math.randomseed(os.time())
    CurrentVerifiableOffset = math.random(5, 100)
    CurrentMoney = scoredata.money + CurrentVerifiableOffset
    CurrentPearl = scoredata.nowPearls + CurrentVerifiableOffset
    SaveScoreData()

    SetViewMode("world")
    if stage.next_stage == nil then
        error('Entrance stage not set.')
    end
    --SetResourceStatus("stage")
end

local floatmoney = 0
function AddMoney(nums)
    local data = scoredata
    local offset = CurrentVerifiableOffset
    floatmoney = floatmoney + nums - int(nums)
    if floatmoney >= 1 then
        floatmoney = floatmoney - 1
        nums = nums + 1
    end
    data.money = data.money + int(nums)

    if data.money >= 80000 then
        ext.achievement:get(9)
    elseif data.money >= 40000 then
        ext.achievement:get(8)
    elseif data.money >= 10000 then
        ext.achievement:get(7)
    end
    CurrentMoney = data.money + offset
end

---供奉珠
function AddPearl(nums)
    local data = scoredata
    local offset = CurrentVerifiableOffset
    data.nowPearls = data.nowPearls + nums
    CurrentPearl = data.nowPearls + offset
    if nums > 0 then
        data.totalPearls = data.totalPearls + nums
        if not data.Achievement[32] then
            if data.totalPearls >= 1 then
                ext.achievement:get(31)
            end
            if data.totalPearls >= 10 then
                ext.achievement:get(32)
            end
        end
    end
end

function CheckData()
    local data = scoredata
    local offset = CurrentVerifiableOffset
    if CurrentMoney - offset ~= data.money then
        data.money = CurrentMoney - offset
        data.money = math.ceil(data.money)
        error("Invalid value")
    end
end

function IsSpecialMode()
    local self = stage.current_stage
    return self.is_challenge or lstg.var.chargeMode_cost or self.is_practice
end

function GetChargeCost()
    return lstg.var.chargeMode_cost
end

function DefineAchievement(id, rank, name, getway, noget_insp, hide, showcond)
    showcond = showcond or load("return true")
    AchievementInfo[id] = {
        name = name, getway = getway, hide = hide, rank = rank, showcond = showcond,
        noget_insp = noget_insp--特殊情况时不可获得，如挑战模式，作弊模式
    }
    local data = scoredata
    if data.Achievement[id] == true then
        ext.achievement.getcount = ext.achievement.getcount + 1
    else
        data.Achievement[id] = false
    end
    data.AchievementGetTime[id] = data.AchievementGetTime[id] or false
end



