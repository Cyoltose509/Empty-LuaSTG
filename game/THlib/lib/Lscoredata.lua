---冒出来的null太可恶了
local function CheckData(_data)
    for k, v in pairs(_data) do
        if type(v) == "table" then
            CheckData(v)
        elseif type(v) == "userdata" then
            _data[k] = false
        end
    end
end

local function NewOrReadFile(name)
    if not plus.DirectoryExists("User") then
        plus.CreateDirectory("User")
    end
    local file = ("User\\%s.dat"):format(name)
    --读取文件
    local data
    if not FileExist(file) then
        data = {}
    else
        local scoredata_file = io.open(file, "rb")
        local text = sp:UnLockString(scoredata_file:read("*a"))
        if pcall(DeSerialize, text) then
            data = DeSerialize(text)
            if data.version and data.version:sub(2, 2) and tonumber(data.version:sub(2, 2)) >= 5 then
            end
        else
            lstg.ExtractRes(file, ("User\\%s_error.dat"):format(name))
            lstg.MsgBoxError(("读取 %s.dat 失败\n已为您保留出现错误的存档\n请及时联系作者反馈此问题"):format(name), "Warning!!", false)
            data = {}
        end
        scoredata_file:close()
        scoredata_file = nil
    end
    return data
end
local function SaveFile(data, file_name)
    if not plus.DirectoryExists("User") then
        plus.CreateDirectory("User")
    end
    local score_data_file = io.open(("User\\%s.dat"):format(file_name), "wb")
    score_data_file:write(sp:LockString(Serialize(data)))
    score_data_file:close()
end

--通常数据
local _initscoredata = function()
    local data = NewOrReadFile("Score1")
    data.Duration = data.Duration or { 0, 0, 0, 0, 0 }
    data.ContinuousLogin = data.ContinuousLogin or 1
    local d = os.date("*t")
    data.LastLoginDate = data.LastLoginDate or os.time({ day = d.day, month = d.month, year = d.year })

    data.money = data.money or 0
    ---成就数据
    data.Achievement = data.Achievement or {}
    data.AchievementGetTime = data.AchievementGetTime or {}
    ---加成数据
    data.BookAddition = data.BookAddition or {}--在图鉴里显示
    data.ShowNewAddition = data.ShowNewAddition or {}--选择加成时的new图标
    data.initialAddition = data.initialAddition or {}--是否可以初始携带
    data.NoticeinitialAddition = data.NoticeinitialAddition or {}--初次解锁初始携带的flag
    data.UnlockAddition = data.UnlockAddition or {}--是否解锁加成
    ---主动道具数据
    data.ShowNewActive = data.ShowNewActive or {}--选择主动时的new图标
    data.BookActive = data.BookActive or {}--在图鉴里显示
    data.UnlockActive = data.UnlockActive or {}--是否解锁主动道具
    ---天气数据
    data.Weather = data.Weather or {}
    data.FirstWeather = data.FirstWeather or false--初遇天气
    data.First5Season = data.First5Season or false--初遇里季节
    ---抽卡数据
    data.pearlGetIndex = data.pearlGetIndex or 0
    data.pearlGet = data.pearlGet or 0
    data.nowPearls = data.nowPearls or 0
    data.totalPearls = data.totalPearls or 0
    data.rewarded = data.rewarded or {}
    data.rewardedRecord = data.rewardedRecord or {}
    data.baodi_tool = data.baodi_tool or 0
    data.baodi_chara = data.baodi_chara or 0
    ---任务数据
    data.mission_data = data.mission_data or {}
    data.new_unlock = data.new_unlock or nil
    ---其他数据
    data._total_miss = data._total_miss or 0
    data._total_bomb = data._total_bomb or 0
    data._total_kill_enemy = data._total_kill_enemy or 0
    data._total_death = data._total_death or 0
    data._total_gongfeng = data._total_gongfeng or 0
    data._total_gongfeng_tool = data._total_gongfeng_tool or 0
    data._total_gongfeng_chara = data._total_gongfeng_chara or 0
    data._total_mission = data._total_mission or 0
    data._total_miss_exp = data._total_miss_exp or 0
    data.NeetQuestions = data.NeetQuestions or { 0, 0, 0, 0, 0, 0 }
    data.guide_flag = data.guide_flag or 0
    data.infinite_clock = data.infinite_clock or false--无间之钟
    data.chargeMode_show = data.chargeMode_show or false
    data.inside_pro = data.inside_pro or 0.05--里季节概率
    data.siyuan_baby_count = data.siyuan_baby_count or 0

    data.stop_0_tool = data.stop_0_tool or false

    CheckData(data)
    scoredata = data
end

--关卡数据（包括菜单选择，通关状态，最高分等）
local _initstagedata = function()
    local data = NewOrReadFile("Score2")
    data.player_pos = data.player_pos or 1
    data.spell_pos = data.spell_pos or {}
    data.SceneSelection = data.SceneSelection or 1
    data.DiffSelection = data.DiffSelection or {}
    data.stagePass = data.stagePass or {}
    data.hiscore = data.hiscore or {}
    data.unlockInitialPos = data.unlockInitialPos or { true, false, false, false, false }
    data.chooseInitial = data.chooseInitial or { 0, 0, 0, 0, 0 }
    data.presetInitial = data.presetInitial or {}
    data.scene_unlock = data.scene_unlock or {}
    data.challenge_unlock = data.challenge_unlock or {}
    data.challenge_finish = data.challenge_finish or {}
    data.challenge_time = data.challenge_time or {}
    ---波图鉴数据
    data.BookWave = data.BookWave or {}
    CheckData(data)
    stagedata = data
end

--玩家养成数据
local _initplayerdata = function()
    local data = NewOrReadFile("Score3")
    CheckData(data)
    playerdata = data
end

function InitScoreData()
    _initscoredata()
    _initstagedata()
    _initplayerdata()
end

function SaveScoreData()
    SaveFile(scoredata, "Score1")
    SaveFile(stagedata, "Score2")
    SaveFile(playerdata, "Score3")
end


