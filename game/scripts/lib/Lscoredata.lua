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

local password = { 3, 6, 11, 5, 4, 1, 2, 5, 8, 11, 9, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 100 }
---@param file file
---@param str string
local function writeEncodeData(file, str)
    for i = 1, #str do
        file:write(string.char((str:byte(i) + password[i % #password + 1] - 1) % 127 + 1))
    end
end
---@param file file
local function readDecodeData(file)
    local str = file:read("*a")
    local strs = {}
    for i = 1, #str do
        strs[i] = string.char((str:byte(i) - password[i % #password + 1] - 1) % 127 + 1)
    end
    return table.concat(strs)
end

local path = GetDataPath()
local function NewOrReadFile(name)
    lstg.FileManager.CreateDirectory(path)
    local file = ("%s/%s.dat"):format(path, name)
    --读取文件
    local data
    if not FileExist(file) then
        data = {}
    else
        local scoredata_file = io.open(file, "rb")
        local text = readDecodeData(scoredata_file)
        if pcall(DeSerialize, text) then
            data = DeSerialize(text)
            if type(data) ~= "table" then
                data = {}
            end
        else
            lstg.ExtractRes(file, ("%s/%s_error.dat"):format(path, name))
            --lstg.MsgBoxError(("读取 %s.dat 失败\n已为您保留出现错误的存档\n请及时联系作者反馈此问题"):format(name), "Warning!!", false)
            data = {}
        end
        scoredata_file:close()
        scoredata_file = nil
    end
    return data
end
local function SaveFile(data, file_name)
    lstg.FileManager.CreateDirectory(path)

    local file = ("%s/%s.dat"):format(path, file_name)
    local fake_file = ("%s/%s.dat.fake"):format(path, file_name)
    local score_data_file = assert(io.open(fake_file, "wb"))
    writeEncodeData(score_data_file, Serialize(data))
    score_data_file:close()
    os.remove(file)
    os.rename(fake_file, file)
end


--通常数据
local _initscoredata = function()
    local data = NewOrReadFile("data")
    data.Duration = data.Duration or { 0, 0, 0, 0, 0 }
    data.ContinuousLogin = data.ContinuousLogin or 1
    local d = os.date("*t")
    data.LastLoginDate = data.LastLoginDate or os.time({ day = d.day, month = d.month, year = d.year })
    data.first_language = data.first_language or false
    data._total_death = data._total_death or 0
    data._total_miss = data._total_miss or 0
    data.setting_pos1 = data.setting_pos1 or 1
    data.setting_pos2 = data.setting_pos2 or 1
    data.scene_unlock = data.scene_unlock or {}
    data.scene_pos1 = data.scene_pos1 or 1
    data.scene_pos2 = data.scene_pos2 or 1
    data.scene_diff = data.scene_diff or 1
    data.scene_tool = data.scene_tool or 1
    data.day_data = data.day_data or {}
    data.day_unlock = data.day_unlock or {}
    data.replay_name = data.replay_name or ""

    data.init_auto_save = data.init_auto_save or false
    data.init_tutorial_ask = data.init_tutorial_ask or false
    data.init_first_scene = data.init_first_scene or false
    data.init_xbox_prefer = data.init_xbox_prefer or false
    data.init_go_alchemy = data.init_go_alchemy or false

    data.tool_use = data.tool_use or {}
    data.tool_clear = data.tool_clear or {}
    data.tool_level = data.tool_level or {}
    data.tool_exp = data.tool_exp or {}
    data.tool_unlock = data.tool_unlock or {}
    data.Achievement = data.Achievement or {}
    data.AchievementGetTime = data.AchievementGetTime or {}
    data.meet_music = data.meet_music or {}

    data.user_name = data.user_name or {}

    data.diy_diffpos = data.diy_diffpos or 1
    data.diy_daypos = data.diy_daypos or 1
    data.diy_toolpos = data.diy_toolpos or 3
    data.diy_cards = data.diy_cards or ""---使用字符串存储卡组数据

    data.diy_cards_preset = data.diy_cards_preset or {}

    data.challenge_page = data.challenge_page or 0
    data.first_page0 = data.first_page0 or false
    data.first_page1 = data.first_page1 or false

    data.challenge_unlock = data.challenge_unlock or false

    data.diy_finish_time = data.diy_finish_time or 0
    data.last_played_day_index = data.last_played_day_index or 1
    data.daily_finish_time = data.daily_finish_time or 0

    CheckData(data)
    scoredata = data
end

function InitScoreData()
    _initscoredata()
end

function SaveScoreData()
    SaveFile(scoredata, "data")
    --[[
    if luaSteam.UpdateSteamServer then
        luaSteam.UpdateSteamServer()
    end--]]
end

local utf8 = require("utf8")
---@return string
---@param data number[]
function GetUserName(data)
    data = data or scoredata.user_name
    local name = {  }
    for i, code in ipairs(data) do
        name[i] = utf8.char(code)
    end
    return table.concat(name)
end
---@return number[]
function UTF8Name(str)
    local name = {}
    for _, c in utf8.codes(str) do
        name[#name + 1] = c
    end
    return name
end
---@param name string
function SaveUserName(name)
    scoredata.user_name = UTF8Name(name)
end


