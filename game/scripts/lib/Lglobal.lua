---=====================================
---luastg user global value
---=====================================
----------------------------------------
---user  global value

---退出游戏
lstg.quit_flag = false

---暂停
lstg.paused = false

---跨关全局变量表
---@class lstg.var
lstg.var = {
    day_id = 1,
    scene_id = 1,
    difficulty = 1,
    tool_select = 1,
    tool_level = 1, ---新版加入
    ran_seed = 0,
    stage_name = '',
    stage_finish = false,
    no_tool = true,
    use_count = 0,
    use_count_fake = 0,
    valid_score = true,
    extra_mode = false,
    lost = false,
    score = 0,
    running_timer = 0,
    real_running_timer = 0,
    diy_cards = "",
    diy_maxscore = 0,
    diy_score = 0,
}

---关卡内全局变量表
---@type table
lstg.tmpvar = {}

---播放录像时用来临时保存lstg.var的表，默认为nil
---@type lstg.var|nil
lstg.nextvar = nil

---设置一个全局变量
---@param k number|string
---@param v any
function lstg.SetGlobal(k, v)
    lstg.var[k] = v
end

---获取一个全局变量
---@param k number|string
---@return any
function lstg.GetGlobal(k)
    return lstg.var[k]
end

SetGlobal = lstg.SetGlobal
GetGlobal = lstg.GetGlobal

---重置关卡内全局变量表
function lstg.ResetLstgtmpvar()
    lstg.tmpvar = {}
end