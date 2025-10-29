---=====================================
---stagegroup|replay|pausemenu system
---extra game loop
---=====================================

----------------------------------------
---ext加强库

---@class ext @额外游戏循环加强库
ext = {}

local extpath = "scripts\\ext\\"
DoFile(extpath .. "ext_pause_menu.lua")--暂停菜单和暂停菜单资源
DoFile(extpath .. "ext_other.lua")--一些函数整理
DoFile(extpath .. "ext_mouse.lua")--鼠标控制


ext.FrameCounter = 0--用来改变假fps的变量

ext.eventListener = eventListener()
ext.eventListener:create("frameEvent@before")
ext.eventListener:create("frameEvent@after")


---重置缓速计数器
function ext.ResetTicker()
end

----------------------------------------
---extra user function
---设置标题
local function ChangeGameTitle()
    local mod = "LuaSTG"
    local t = {
        string.format("FPS=%.1f", GetFPS()),
        ui.version,
    }
    if DEBUG then
        table.insert(t, "Objects=" .. GetnObj())
    end
    if mod then
        SetTitle(mod .. " | " .. table.concat(t, " | "))
    else
        SetTitle(table.concat(t, " | "))
    end
end

---切关处理
local function ChangeGameStage()
    ResetWorldOffset()--by ETC，重置world偏移
    GROUP.ResetCollisionPairs(2)
    SaveScoreData()
    ext.notUIdraw = nil
    lstg.ui.alpha = 1
    lstg.ResetLstgtmpvar()--重置lstg.tmpvar

    if lstg.nexttmpvar then
        lstg.tmpvar = lstg.nexttmpvar
        lstg.nexttmpvar = nil
    end


    -- 初始化随机数
    if lstg.var.ran_seed then
        ran:Seed(lstg.var.ran_seed)
    end
    if not stage.next_stage.is_menu then
    end
    --切换关卡
    SetSuperPause(0)
    stage.current_stage = stage.next_stage
    stage.next_stage = nil
    stage.current_stage.timer = 0
    stage.current_stage:init()
end

---行为帧动作(和游戏循环的帧更新分开)
local function DoFrame()
    object.BulletIndesDo(function(b)
        object.ClearVIndex(b)
    end)
    lstg.AfterFrame(2)
    --刷新输入
    Input.GetInput()
    --切关处理
    local stage = stage
    Print(stage.next_stage)
    if stage.next_stage then
        Print("gogogogogo")
        if stage.current_stage then
            stage.current_stage:del()
            task.Clear(stage.current_stage)
            if stage.preserve_res then
                stage.preserve_res = nil
            else
                RemoveResource 'stage'
                ext.OtherScreenEff.rtcount = {}
            end
            ResetPool()
        end
        ChangeGameStage()
    end
    local nopause = (lstg.GetCurrentSuperPause() <= 0)
    if nopause or stage.nopause then
        task.Do(stage.current_stage)
        stage.current_stage:frame()
        stage.current_stage.timer = stage.current_stage.timer + 1
    end
    mask_fader:frame()

    lstg.ObjFrame(2)

    if nopause or stage.nopause then
        lstg.BoundCheck(2)
    end
    if nopause then
        GROUP.CollisionCheck()
    end


end
_G.DoFrame = DoFrame

---优先菜单弹出统一管理
local PriorMenu = {
}
ext.PriorMenu = PriorMenu
local function CheckPriorMenuKilled()
    local flag = true
    for _, p in ipairs(PriorMenu) do
        if not p:IsKilled() then
            flag = false
            break
        end
    end
    return flag
end
ext.CheckPriorMenuKilled = CheckPriorMenuKilled
local function PriorMenuFrame()
    local flag = true
    for _, p in ipairs(PriorMenu) do
        if flag then
            p:frame()
        else
            break
        end
        flag = p:IsKilled()
    end
end
local function PriorMenuRender()
    for i = #PriorMenu, 1, -1 do
        local p = PriorMenu[i]
        p:render()
    end
end

---缓速和加速
local function DoFrameEx()
    local Count = 1
    --正常游戏时
    ext.FrameCounter = ext.FrameCounter + Count
    for _ = 1, ext.FrameCounter do
        if lstg.GetSuperPause() == 0 then
            ext.OtherScreenEff:Reset()
        end
        if ext.CheckPriorMenuKilled() then
            DoFrame()
        else
            PriorMenuFrame()
        end
        ext.FrameCounter = ext.FrameCounter - 1
    end
end
local xinput = require("xinput")
local dinput = require("dinput")
local differ = 1
local offset = 0
local stopWatch = lstg.StopWatch()
local before, after = 0, 0
local timer = 0
----------------------------------------
---extra game call-back function
local debugui = require("scripts.lib.Ldebug")
local _DEBUG = DEBUG
local setting = setting
dinput.refresh()

function FrameFunc()
    _DEBUG = DEBUG
    if _DEBUG then
        debugui.update()
    end
    after = stopWatch:GetElapsed()
    differ = (after - before) * 60
    before = after
    timer = timer + 1
    Input.xUpdateTick()
    if stage and stage.current_stage and stage.current_stage.is_menu and (timer % 60) == 0 then
        xinput.refresh()
    else
        xinput.update()

    end
    dinput.update()
   -- luaSteam.SteamFrame()
    --标题设置
    ChangeGameTitle()
    ext.Debugging()

    task.Do(ext)
    local stage, lstg = stage, lstg
    --执行场景逻辑
    if ext.pause_menu:IsKilled() and not (lstg.tmpvar and lstg.tmpvar.stopFrame) then
        --处理录像速度与正常更新逻辑
        ext.eventListener:Do("frameEvent@before")
        DoFrameEx()
        ext.eventListener:Do("frameEvent@after")
        --按键弹出菜单
        if lstg.tmpvar.EscIsOccupied then
            lstg.tmpvar.EscIsOccupied = nil
        else
            local keycontrol = (GetLastKey() == setting.keysys.menu) or (Input.xGetLastKey() == setting.xkeysys.menu)
            local overlay --= luaSteam.GameOverlayActivated()
            if ((keycontrol or overlay) and not lstg.tmpvar.noPause or ext.pop_pause_menu) and not ext.StageIsMenu() then
               -- ext.pause_menu:FlyIn()
            end
        end

    end
    --暂停菜单更新
    if stage.current_stage then
        if not ext.StageIsMenu() then
            ext.pause_menu:frame()
        else
            ext.music = {}
        end
    end



    --游玩时间计算
    ext.InputDuration()

    if _DEBUG then
        debugui.layout()
    end

    if lstg.quit_flag then
        GameExit()
    end

    --退出游戏逻辑
    return lstg.quit_flag
end

function RenderFunc()
    BeginScene()
    SetViewMode("ui")

    ext.OtherScreenEff:BeforeRender()

    local stage = stage
    if stage.current_stage then
        mask_fader:BeforeRender()
        stage.current_stage:render()
        if lstg.var.init_player_data and not ext.StageIsMenu() and not ext.notUIdraw then
            ui.DrawFrame(self)
            ui.DrawScore(self)
        end
        ObjRender()
    end
    ext.OtherScreenEff:AfterRender()

    mask_fader:AfterRender()

    if _DEBUG and Collision_Checker then
        Collision_Checker.render()
    end

    SetViewMode("ui")
    PriorMenuRender()
    ext.pause_menu:render()


    SetViewMode("ui")
    if _DEBUG then
        debugui.draw()
    end
    EndScene()
    --截图（不需要，有steam帮你截
    --[[
    if GetLastKey() == setting.keysys.snapshot then
        lstg.FileManager.CreateDirectory("snapshot")
        Snapshot('snapshot\\' .. os.date("!%Y-%m-%d-%H-%M-%S", os.time()) .. '.png')
    end--]]
end

function FocusLoseFunc()
    --[[if not stage.current_stage.is_menu and ext.pause_menu:IsKilled() then
        ext.pause_menu:FlyIn()
    end--]]
end
