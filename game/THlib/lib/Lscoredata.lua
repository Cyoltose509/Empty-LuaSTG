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

    CheckData(data)
    scoredata = data
end


function InitScoreData()
    _initscoredata()
end

function SaveScoreData()
    SaveFile(scoredata, "data")
end


