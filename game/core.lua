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
lstg.DoFile(path .. "Lmusicload.lua")--音乐加载相关



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

function ChangeVideoMode2(set)
    return ChangeVideoMode(set.resx, set.resy, set.windowed, set.vsync)

end
----------------------------------------
---全局回调函数，底层调用
function GameInit()
    --加载mod包
    if setting.mod ~= 'launcher' then
        Include 'THlib\\THlib.lua'
        setting.mod = "WHAT"
        save_setting()
        if not ChangeVideoMode2(setting) then
            error(setting.windowed and "Invalid Resolution" or "Failed to FullScreen")
            --stage.QuitGame()
            --return
        end
        SetSEVolume(setting.sevolume / 100)
        SetBGMVolume2(setting.bgmvolume / 100)
        ResetScreen()--Lscreen
        SetResourceStatus 'global'
        ResetUI()
        Include 'mod\\root.lua'
        InitAllClass()--Lobject
        stage.Set('none', 'init')
    else
        Include 'launcher.lua'
    end
    --最后的准备
    InitAllClass()
    InitScoreData()
    InitMusicList()
    SceneClass = {}
    cheat = nil
    math.randomseed(os.time())
    CurrentVerifiableOffset = math.random(5, 100)
    SaveScoreData()

    SetViewMode("world")
    if stage.next_stage == nil then
        error('Entrance stage not set.')
    end
    --SetResourceStatus("stage")
end


function CheckData()
    local data = scoredata
end




