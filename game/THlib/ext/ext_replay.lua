---======================================
---luastg replay
---======================================

----------------------------------------
---replay
local replay = {}
ext.replay = replay


function stage.RefreshHiscore(lost)
    local v = lstg.var
    local diff = v.difficulty + 1
    local data = stagedata
    data.hiscore[v.scene_id][diff] = max(data.hiscore[v.scene_id][diff], v.score)
    if not lost then
        local stgpass = data.stagePass
        stgpass[v.scene_id][diff] = stgpass[v.scene_id][diff] + 1
        if stgpass[1][4] > 0 and stgpass[2][4] > 0 then
            mission_lib.GoMission(50)
        end
        if stgpass[1][2] > 0 then
            ext.achievement:get(45)
        end
        if stgpass[2][2] > 0 then
            ext.achievement:get(46)
        end
        if stgpass[1][3] > 0 then
            ext.achievement:get(110)
        end
        if stgpass[2][3] > 0 then
            ext.achievement:get(111)
        end
        if stgpass[1][4] > 0 then
            ext.achievement:get(93)
        end
        if stgpass[2][4] > 0 then
            ext.achievement:get(94)
        end

    end
end


----------------------------------------
---关卡切换增强功能
---用于支持replay

---设置场景
---当mode="none"时，参数stage用于表明下一个跳转的场景
---当mode="load"时，参数path有效，指明从path录像文件中加载场景stage的录像数据
---当mode="save"时，参数path无效，使用stage指定场景名称并开始录像
---@param mode string @none, load, save录像模式
---@param path string @录像文件路径（可选）
---@param stageName string @关卡名称
function stage.Set(mode, path, stageName)
    if mode == "load" and stage.next_stage then
        return
    end --防止放replay时转场两次
    -- 刷新最高分
    --stage.RefreshHiscore()

    -- 转场
    if mode == "save" then
        assert(stageName == nil)
        stageName = path
        -- 设置随机数种子
        local v = lstg.var
        v.ran_seed = ((os.time() % 65536) * 877) % 65536
        stage.next_stage = stage.stages[stageName]--by OLC
        lstg.var.stage_name = stageName
    elseif mode == "load" then

    else
        assert(mode == "none")
        assert(stageName == nil)
        stageName = path

        -- 转场
        lstg.var.stage_name = stageName
        stage.next_stage = stage.stages[stageName]
    end
end

---重新开始场景
function stage.Restart()
    stage.preserve_res = true  -- 保留资源在转场时不清空
    stage.Set("save", lstg.var.stage_name)
end
