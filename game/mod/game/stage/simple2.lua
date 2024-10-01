local function GetWaveEvent(wave, events)
    local v = lstg.var
    local w = lstg.weather
    local target
    local self = stage.current_stage
    if v.next_wave_id then
        target = self.scene_class.events[v.next_wave_id]
        v.next_wave_id = nil
    else
        if not events[wave] or #events[wave] == 0 then
            return
        end
        --计算概率
        local pro = {}
        local lastp = 0
        for _, p in ipairs(events[wave]) do
            if not (w.QingLang and (p.islucky or p.isdangerous or p.isboss)) then
                local nowp = max(p.proba + p.luck_power * player_lib.GetLuck()  / 100 + p.chaos_power * v.chaos / 100, 0)
                if v.difficulty == 2 then
                    nowp = nowp * p.hard_factor
                end
                table.insert(pro, { p, lastp, lastp + nowp })
                lastp = lastp + nowp
            end
        end
        if lastp == 0 then
            local scene_class = self.scene_class
            for _, p in ipairs(scene_class.events) do
                if not (p.islucky or p.isdangerous or p.isboss) then
                    local nowp = max(p.proba + p.luck_power * player_lib.GetLuck()  / 100 + p.chaos_power * v.chaos / 100, 0)
                    if v.difficulty == 2 then
                        nowp = nowp * p.hard_factor
                    end
                    table.insert(pro, { p, lastp, lastp + nowp })
                    lastp = lastp + nowp
                end
            end
        end--晴朗天气的最后检测
        local n = ran:Float(0, lastp)

        for _, p in ipairs(pro) do
            if p[2] <= n and n < p[3] then
                target = p[1]
                break
            end
        end
        for i = wave + 1, #events do
            if events[i] then
                for k = #events[i], 1, -1 do
                    if events[i][k].id == target.id then
                        table.remove(events[i], k)
                        break
                    end
                end
            end
        end
        --  target.event(lstg.var.chaos, lstg.var.difficulty)
    end
    return target


end

local CheckAddition_Submenu = ext.CheckAddition_Submenu
local CheckWeather_Submenu = ext.CheckWeather_Submenu
local j = 0
local passCheck = function()
    --menu:Updatekey()
    local flag = menu:keyYes() or ext.mouse:isUp(1)
    if not flag then
        j = 0
    end
    return flag and (j == 0)
end

stage.group.New('attr_select', {}, "Simple2", false)

local SimpleStage1 = stage.group.AddStage("Simple2", "Simple2@1", false)
function SimpleStage1:init()
    local var = lstg.var
    local scene_class = SceneClass[var.scene_id]
    stage_lib.StageInit(self)
    local placetotal = stage_lib.NewStagePath(scene_class, var.maxwave)
    self.start_function = function(init_w)
        var.maxwave = scene_class._maxwave
        task.New(self, function()
            local y = init_w
            while var.now_path_y < 30 do
                if y > 1 then
                    local selecting = New(stage_lib.ShowPath, placetotal)
                    while IsValid(selecting) do
                        task.Wait()
                    end
                end
                var.frame_counting = true
                local cur = placetotal[var.now_path_y][var.now_path_x]
                var.chaos = stage_lib.DangerToChaos(cur.danger)
                stage_lib.DoNodeEvent(self, y, cur.node, cur.weather)
                stage_lib.PassCheck()
                cur.passed = true
                var.frame_counting = false
                local waiting = New(stage_lib.WaitForSpace)
                while IsValid(waiting) and waiting.flag do
                    task.Wait()
                end
                stage_lib.ClearScreen()
                if cur.node.state <= 3 and lstg.tmpvar.level_up_count > 0 then
                    local slib = stg_levelUPlib
                    for _, u in pairs(slib.AdditionTotalList) do
                        if u.RefreshFunc then
                            u:RefreshFunc()
                        end--刷新高级裨益说明
                    end
                    ext.level_menu:FlyIn(slib.GetAdditionList(nil, function(p)
                        return p.spBENEFIT
                    end))
                end
                cur.node.final()
                self.eventListener:Do("waveEvent@after", self, self)
                var.stop_getting = false--每波结束开启
                task.Wait()
                y = y + 1
            end
            task.Wait(30)
            lstg.tmpvar.noPause = true
            New(stage.stage_clear_object, (var.difficulty == 1) and 1000000 or 1500000)
            task.Wait(60)
            lstg.tmpvar.StopMusic = true
            task.Wait(60)
            mask_fader:Do("close", 15)
            task.Wait(15)
            stage_lib.saveWaveData()
            stage.group.NextStage()
        end)

    end

    task.New(self, function()
        task.Wait(60)
        self.start_function(1)
    end)
end

local function _t(str)
    return Trans("sth", str) or ""
end
local Summary = stage.group.AddStage("Simple2", "Simple2@2", false)
Summary.init = StageSummary.init
Summary.frame = StageSummary.frame
Summary.render = StageSummary.render

