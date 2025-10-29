--======================================
--luastg stage
--======================================

----------------------------------------
--单关卡

---@class stage
stage = { stages = {} }

function stage:init()
end
function stage:frame()
end
function stage:render()
end
function stage:del()
end

---@return stage
function stage.New(stage_name, as_entrance, is_menu)
    local result = {
        init = stage.init,
        del = stage.del,
        render = stage.render,
        frame = stage.frame,
    }
    setmetatable(result, { __index = stage })
    if as_entrance then
        stage.next_stage = result
    end
    result.is_menu = is_menu
    result.stage_name = tostring(stage_name)
    stage.stages[stage_name] = result
    return result
end

function stage.SetTimer(t)
    stage.current_stage.timer = t - 1
end

function stage.QuitGame()
    lstg.quit_flag = true
end

function stage.Set(stageName)
    ext.ResetTicker() -- 重置计数器
    -- 转场
    lstg.var.stage_name = stageName
    stage.next_stage = stage.stages[stageName]
end

---重新开始场景
function stage.Restart()
    stage.preserve_res = true  -- 保留资源在转场时不清空
    stage.Set("none", lstg.var.stage_name)
end

