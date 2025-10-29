---=====================================
---core
---所有基础的东西都会在这里定义
---=====================================

lstg = lstg or {}
local Display = require("lstg.Display")
local displays = Display.getAll()
local main_display
for _, d in ipairs(displays) do
    if d:isPrimary() then
        main_display = d
    end
end
function GetFullScreenResolution()
    local w, h = 1280, 720
    if main_display then
        local size = main_display:getSize()
        w, h = size.width, size.height
    end
    local km = math.min(w / 16 * 9, h)
    return km * 16 / 9, km
end
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
    --若有开发者模式文件，则优先盖过演示模式
    if FileExist("debug.lua") then
        Include("debug.lua")--开发者模式
    elseif FileExist("demo.lua") then
        Include("demo.lua")--演示模式
    end

    --准备

    Include 'scripts\\init.lua'


    cheat = nil
    math.randomseed(os.time())




    --加载
    save_setting()
    if not ChangeVideoMode2(setting) then
        error("Invalid Resolution")
        --stage.QuitGame()
        --return
    end
    --初始化
    SetSEVolume(setting.sevolume / 100)
    SetBGMVolume(setting.bgmvolume / 100)
    ResetScreen()--Lscreen
    SetResourceStatus 'global'
    ResetUI()
    Include("scripts\\game\\root.lua")
    InitScoreData()
    InitAllClass()
    if not scoredata.first_language then
        SetDefaultLanguage()
        --stage.Set("none", "language")
    end
    stage.Set('init')
    SaveScoreData()
    SetViewMode("world")
end

function SetDefaultLanguage()
    local lang_dict = {
        schinese = 1,
        tchinese = 2,
        english = 3,
        japanese = 4,
    }
    local curlang-- = luaSteam.GetSteamUILanguage()
    local lang = lang_dict[curlang] or 3
    setting.language = lang
    switchLanguage(lang)
    save_setting()
    scoredata.first_language = true
end

function ChangeVideoMode2(set)
    local gs = set.graphics_system
    if not gs.fullscreen then
        return ChangeVideoMode(gs.width, gs.height, not gs.fullscreen, gs.vsync)
    else
        local w, h = GetFullScreenResolution()
        return ChangeVideoMode(w, h, not gs.fullscreen, gs.vsync)
    end
end

local path = "scripts\\lib\\"
lstg.DoFile("launch.lua")--启动文件，主要是初始化一些参数
----------------------------------------
---各个模块

lstg.DoFile("scripts\\plus\\plus.lua")--CHU神的plus库，replay系统、plusClass、NativeAPI

lstg.DoFile(path .. "Ltable.lua")--OLC的table.sort优化
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
lstg.DoFile(path .. "Llockfunc.lua")--解锁方式
lstg.DoFile(path .. "Llanguage.lua")--多语言功能

SetSplash(true)
ChangeVideoMode2(setting)
ResetScreen()--Lscreen
