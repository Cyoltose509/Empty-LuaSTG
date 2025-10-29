---=====================================
---luastg input
---=====================================

----------------------------------------
---按键状态更新
local xinput = require('xinput')
local xinput_ex = require("scripts.lib.adapter.Xinput")
local dinput_ex = require("scripts.lib.adapter.DirectInput")
local dinput = require('dinput')

local M = {}
Input = M

local KeyState = {}
local KeyStatePre = {}
_G.KeyState = KeyState
_G.KeyStatePre = KeyStatePre

---是否按下
function M.KeyIsDown(key)
    return KeyState[key]
end

---是否在当前帧按下
function M.KeyIsPressed(key)
    return KeyState[key] and (not KeyStatePre[key])
end

---是否在当前帧放开
function M.KeyIsUp(key)
    return KeyStatePre[key] and (not KeyState[key])
end

function M.GetKeyState(name)
    local result = false
    if setting.keys[name] then
        result = result or GetKeyState(setting.keys[name])
    end
    if setting.keysys[name] then
        result = result or GetKeyState(setting.keysys[name])
    end
    if not result then
        if setting.xbox_slot ~= 0 then
            local i = setting.xbox_slot
            if xinput.isConnected(i) then
                local state = xinput_ex.mapKeyStateFromIndex(i)
                if setting.xkeys[name] then
                    result = result or xinput_ex.getKeyState(state, setting.xkeys[name])
                end
                if setting.xkeysys[name] then
                    result = result or xinput_ex.getKeyState(state, setting.xkeysys[name])
                end
            end
        else
            for i = 1, 4 do
                if result then
                    break
                end
                if xinput.isConnected(i) then
                    local state = xinput_ex.mapKeyStateFromIndex(i)
                    if setting.xkeys[name] then
                        result = result or xinput_ex.getKeyState(state, setting.xkeys[name])
                    end
                    if setting.xkeysys[name] then
                        result = result or xinput_ex.getKeyState(state, setting.xkeysys[name])
                    end
                end
            end
        end
    end
    return result
end

---将按键二进制码转换为字面值，用于设置界面
function M.KeyCodeToName()
    local key2name = {}
    for k, v in pairs(KEY) do
        key2name[v] = k
    end
    for i = 0, 255 do
        key2name[i] = key2name[i] or '?'
    end
    return key2name
end
function M.xKeyCodeToName()
    local key2name = {}
    for k, v in pairs(xKEY) do
        key2name[v] = k
    end
    for i = 0, 255 do
        key2name[i] = key2name[i] or '?'
    end
    return key2name
end

---获取输入
function M.GetInput()
    local keys = setting.keys
    local xkeys = setting.xkeys

    if stage.next_stage then
        KeyStatePre = {}
    elseif ext.pause_menu:IsKilled() then
        -- 刷新KeyStatePre
        for k in pairs(keys) do
            KeyStatePre[k] = KeyState[k]
            KeyState[k] = false
        end
    end

    -- 不是录像时更新按键状态
        for k, v in pairs(keys) do
            KeyState[k] = KeyState[k] or GetKeyState(v)
        end
        if setting.xbox_slot ~= 0 then
            local i = setting.xbox_slot
            if xinput.isConnected(i) then
                local state = xinput_ex.mapKeyStateFromIndex(i)
                for k, v in pairs(xkeys) do
                    KeyState[k] = KeyState[k] or xinput_ex.getKeyState(state, v)
                end
            end
        else
            for i = 1, 4 do
                if xinput.isConnected(i) then
                    local state = xinput_ex.mapKeyStateFromIndex(i)
                    for k, v in pairs(xkeys) do
                        KeyState[k] = KeyState[k] or xinput_ex.getKeyState(state, v)
                    end
                end
            end
        end
        --[[
        local dinput_refresh = false
        for i = 1, dinput.count() do
            local state = dinput_ex.mapKeyStateFromIndex(i)
            if state then
                for k, v in pairs(keys) do
                    KeyState[k] = KeyState[k] or dinput_ex.getKeyState(state, v)
                end
            else
                dinput_refresh = true
            end
        end
        if dinput_refresh then
            dinput.refresh()
            --ext.pausemenu.requestPauseAuto() -- 暂停游戏，看看发生什么事了
        end--]]
end


-- 初始化数据结构
local keyState = {} -- [key] = { down = false, tickDown = 0, repeatTick = 0 }

-- 可调参数
local initialRepeatDelay = 30  -- 按住多久开始重复触发（帧）
local repeatInterval = 2       -- 之后每隔多少帧重复一次
local currentTick = 0
function M.xUpdateTick()
    currentTick = currentTick + 1
end

-- 输入主函数，每帧调用一次，传入当前帧编号
function M.xGetLastKey()
    local latestKey = nil
    local latestTime = -1

    for _, key in pairs(xKEY) do
        local isDown = false

        -- === 检测按键是否被按下 ===
        if setting.xbox_slot ~= 0 then
            if xinput.isConnected(setting.xbox_slot) then
                local state = xinput_ex.mapKeyStateFromIndex(setting.xbox_slot)
                isDown = xinput_ex.getKeyState(state, key)
            end
        else
            for i = 1, 4 do
                if xinput.isConnected(i) then
                    local state = xinput_ex.mapKeyStateFromIndex(i)
                    isDown = xinput_ex.getKeyState(state, key)
                end
                if isDown then
                    break
                end
            end
        end

        local state = keyState[key] or { down = false, tickDown = 0, repeatTick = 0 }

        if isDown then
            if not state.down then
                -- 第一次按下
                state.down = true
                state.tickDown = currentTick
                state.repeatTick = 0
                -- 立刻可以触发一次（优先）
                if currentTick > latestTime then
                    latestKey = key
                    latestTime = currentTick
                end
            else
                -- 持续按住中
                local heldTime = currentTick - state.tickDown
                state.repeatTick = state.repeatTick + 1
                if heldTime >= initialRepeatDelay and state.repeatTick % repeatInterval == 0 then
                    if state.tickDown > latestTime then
                        latestKey = key
                        latestTime = state.tickDown
                    end
                end
            end
        else
            -- 松开按键，清空状态
            state.down = false
            state.tickDown = 0
            state.repeatTick = 0
        end

        keyState[key] = state
    end

    return latestKey or 0
end

