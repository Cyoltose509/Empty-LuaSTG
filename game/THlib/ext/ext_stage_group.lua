---=====================================
---stage group
---=====================================

----------------------------------------
---关卡组
local stage = stage
local stg = {}
stage.group = stg
stage.groups = {}

---新建关卡组
function stg.New(title, stages, name, allow_practice, difficulty)
    local sg = { title = title, number = #stages, _name = name }
    for i = 1, #stages do
        sg[i] = stages[i]
        local s = stage.New(stages[i])
        s.frame = stage.group.frame
        s.render = stage.group.render
        s.number = i
        s.group = sg
        sg[stages[i]] = s
        s.x, s.y = 0, 0
        s.name = stages[i]
    end
    if name then
        if stage.groups[name] then
            return stage.groups[name]
        end
        stage.groups[name] = sg
        local flag
        for _, c in ipairs(stage.groups) do
            if c == name then
                flag = true
                break
            end
        end
        if not flag then
            table.insert(stage.groups, name)
        end
    end
    sg.allow_practice = allow_practice or false
    sg.difficulty = difficulty or 1
    return sg
end

---为关卡组添加关卡
function stg.AddStage(groupname, stagename, allow_practice)
    if stage.stages[stagename] then
        return stage.stages[stagename]
    end
    if stage.groups[groupname] then
        local sg = stage.groups[groupname]
        sg.number = sg.number + 1
        table.insert(sg, stagename)
        local s = stage.New(stagename)
        s.frame = stage.group.frame
        s.render = stage.group.render
        s.number = sg.number
        s.group = sg
        sg[stagename] = s
        s.x, s.y = 0, 0
        s.name = stagename
        s.allow_practice = allow_practice or false
        return s
    end
end

---为关卡的对应key赋值
function stg.DefStageValue(stagename, key, value)
    stage.stages[stagename][key] = value
end

local function SettingInPause()
    local lstg = lstg
    local var = lstg.var
    local tvar = lstg.tmpvar
    tvar.stopFrame = true
    tvar.pause_menu_text = nil
    var.timeslow = nil
    tvar.noPause = true
    tvar.noresumeSound = true
    ext.DefaultMusic()
    for _, m in ipairs(ext.PriorMenu) do
        m.kill = true
        task.New(ext, function()
            for i = 1, 10 do
                m.alpha = min(1 - i / 10, m.alpha)
                task.Wait()
            end
        end)
    end
end
function stg.ActionDo(order)
    local lstg = lstg
    local var = lstg.var
    local tvar = lstg.tmpvar
    if order == "重新开始" then
        SettingInPause()
        mask_fader:Do("last")
        task.New(ext, function()

            task.Wait(10 + 1)
            tvar.stopFrame = false
            --stg.ReturnToTitle()
            stage.Set('save', stage.current_stage.group[1])
        end)
    end
    if order == "直接结束游玩" then
        SettingInPause()
        task.New(ext, function()
            mask_fader:Do("close")
            task.Wait(15 + 1)
            tvar.stopFrame = false
            stg.ReturnToTitle()
            lstg.var.chargeMode_cost = nil
        end)
    end
    if order == "进入结算" then
        SettingInPause()
        task.New(ext, function()
            mask_fader:Do("close")
            task.Wait(15 + 1)
            tvar.stopFrame = false
            var.lost = true
            stage_lib.saveWaveData()
            stg.NextStage()
        end)
    end
end

ext.ExecuteFlag = false
function stg.frame()
end

function stg.render()
    SetViewMode 'world'
    RenderClearViewMode(Color(255, 0, 0, 0))
end

function stg.Start(group)
    lstg.var.is_practice = false
    stage.Set('save', group[1])
    stage.stages[group.title].save_replay = { group[1] }
    ext.ExecuteFlag = nil
end

function stg.NextStage()
    local self = stage.current_stage
    local group = self.group
    stage.Set('save', group[self.number + 1])
end

function stg.ReturnToTitle()
    for _, v in pairs(EnumRes2('bgm')) do
        if GetMusicState2(v) == "playing" then
            StopMusic2(v)
        end
    end
    stage.Set('none', stage.current_stage.group.title)
end






