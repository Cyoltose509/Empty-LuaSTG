local lib = {}
mission_lib = lib
lib.MissionList = {}
lib.MissionMap = {}
local truefunc = function()
    return true
end

---添加任务
---@param id number@任务id
---@param master number@母任务
---@param toolid number@要解锁的道具
local function AddMission(id, master, x, y, toolid, hide, show_condition)
    local data = {
        progress = 0, --满为100
        new = false, --new感叹号
        open = false, --已经开启的flag
        unlock_flag = true,
    }
    ---@class mission_unit
    local tmp = {
        id = id,
        master_id = master,

        x = x, y = y,
        R = 255, G = 255, B = 255,
        Rb = 0, Gb = 0, Bb = 0,
        size = 1,
        ratio = 1, --比例系数
        show_condition = show_condition or truefunc,
        hide = hide or false,
        index = 0,
        toolid = toolid,
        data = data,
    }
    scoredata.mission_data[id] = scoredata.mission_data[id] or data
    tmp.data = scoredata.mission_data[id]
    lib.MissionList[id] = tmp
    lib.MissionMap[toolid] = tmp

    return tmp
end
lib.AddMission = AddMission

local function GoMission(id, t, sp)
    if not sp and IsSpecialMode() then
        return
    end--特殊情况时不能解锁任务
    t = t or 100
    ---@type mission_unit
    local unit = lib.MissionList[id]
    local toolid = unit.toolid
    local data = scoredata
    if not unit.data.open then
        if (not unit.master_id) or data.mission_data[unit.master_id].open then
            if unit.data.progress == 100 and not unit.unlock_flag then
                return false
            end
            unit.data.progress = min(unit.data.progress + t, 100)
            if unit.data.progress == 100 then
                if unit.data.unlock_flag then
                    unit.data.open = true
                    unit.data.new = true
                    ext.achievement:getMission(toolid)
                    data.new_unlock = id
                    do
                        data._total_mission = data._total_mission + 1
                        if not data.Achievement[16] then
                            ext.achievement:get(33)
                            if data._total_mission >= 7 then
                                ext.achievement:get(52)
                            end
                            if data._total_mission >= 15 then
                                ext.achievement:get(79)
                            end
                            if data._total_mission >= 30 then
                                ext.achievement:get(16)
                            end
                        end
                    end
                    ---
                    return true
                else
                    unit.data.new = true
                    return false
                end
            end
        end
    else
        return true
    end
end
lib.GoMission = GoMission

local function InitMission()
    ---任务列表

    lib.MissionList = {}
    ---根据道具id得到任务id
    lib.MissionMap = {}
    --一个单位的半径大小大概是100

    local function AfterWeather()
        return scoredata.FirstWeather
    end--知道有天气后
    local function After5season()
        return scoredata.First5Season
    end--知道有里季节后
    local s
    --特殊隐藏
    AddMission(2, nil, 1877, 545, 28, true)--历经伤痛之心

    --杀敌数
    AddMission(4, nil, 2360, 1020, 48)--Blood Magic
    AddMission(45, nil, 2260, 1020, 127)--疯狂的火炬
    AddMission(46, nil, 2160, 1020, 47)--妖精联结
    --擦弹
    AddMission(13, nil, 3248, 1200, 62)--ToDo清单
    AddMission(35, nil, 3248, 1300, 73)--极欲的暴食

    --天气相关
    AddMission(5, nil, 3020, 600, 56, false, After5season)--天地有用
    AddMission(6, nil, 2900, 600, 102, false, After5season)--秘神的指引
    AddMission(29, nil, 2960, 480, 103)--公转轨道异常
    AddMission(41, nil, 3080, 480, 116, false, AfterWeather)--中子星
    AddMission(47, nil, 3140, 600, 58, false, AfterWeather)--樱花结界

    --杂乱
    AddMission(9, nil, 3000, 1500, 17)--金刚不灭之身
    AddMission(40, nil, 3120, 1500, 112)--生之残梦

    --小boss
    AddMission(52, nil, 3300, 1500, 164)--向侧之月
    AddMission(53, nil, 3400, 1500, 159)--小小星之伞

    --冰
    AddMission(8, nil, 2909, 1668, 92)--寂静的冬天
    AddMission(14, nil, 2843, 1768, 45)--⑨之祝福
    AddMission(15, nil, 2784, 1668, 24)--冰之妖精
    AddMission(43, nil, 2843, 1888, 124)--冰之鳞

    --死亡
    AddMission(7, nil, 2625, 1183, 79)--以血还血
    AddMission(16, nil, 2700, 1100, 74)--不死的尾羽
    AddMission(32, nil, 2775, 1183, 55)--见血封喉术
    AddMission(33, nil, 2850, 1100, 128)--玻璃大炮

    --chaos
    AddMission(12, nil, 2166, 1293, 44)--漏洞修复仪
    AddMission(17, nil, 2166, 1406, 89)--破碎的护身符

    --符卡
    AddMission(11, nil, 2560, 1620, 30)--魔力护瓶
    AddMission(1, nil, 2560, 1520, 80)--硝酸甘油
    AddMission(18, nil, 2560, 1420, 96)--灵力槽
    AddMission(36, nil, 2510, 1720, 2)--轻量储能包
    AddMission(44, 11, 2610, 1720, 113)--河取牌能量盾

    --紫妈
    AddMission(19, nil, 3687, 757, 54)--便携式隙间
    AddMission(20, nil, 3687, 877, 60)--损坏的空间
    AddMission(21, nil, 3807, 877, 119)--虚与实的境界
    AddMission(22, nil, 3807, 757, 50)--生与死的境界
    AddMission(23, 20, 3567, 997, 82)--月与海的传送门

    --其他
    AddMission(3, nil, 2350, 1300, 39)--疏与密的境界
    AddMission(34, nil, 2350, 1420, 71)--便携式后户
    AddMission(42, nil, 2350, 1540, 106)--九代稗谷


    --五难题
    local cx, cy = 2423, 600
    AddMission(24, nil, cx + cos(90) * 125, cy + sin(90) * 125, 97, false, AfterWeather)--龙颈之玉
    AddMission(25, nil, cx + cos(162) * 125, cy + sin(162) * 125, 117, false, AfterWeather)--佛的御石钵
    AddMission(26, nil, cx + cos(234) * 125, cy + sin(234) * 125, 99, false, AfterWeather)--火鼠的皮衣
    AddMission(27, nil, cx + cos(306) * 125, cy + sin(306) * 125, 114, false, AfterWeather)--燕的子安贝
    AddMission(28, nil, cx + cos(18) * 125, cy + sin(18) * 125, 101, false, AfterWeather)--蓬莱的玉枝

    --玩家升级
    AddMission(30, nil, 2702, 854, 52)--一对的自我
    AddMission(31, nil, 2812, 854, 76)--向神山的贡品

    --关卡升级
    AddMission(10, nil, 2812, 734, 26)--经验探测仪
    AddMission(37, nil, 2922, 734, 81)--经验血袋
    AddMission(38, nil, 3032, 734, 85)--EXHP
    AddMission(39, nil, 3142, 734, 125)--贤者之石

    --梅蒂欣
    AddMission(48, nil, 3028, 978, 90)--甘美之毒

    --纯狐
    AddMission(49, nil, 3148, 978, 86, false, AfterWeather)--阴晴圆缺

    --铃瑚
    AddMission(51, nil, 3268, 978, 161, false, AfterWeather)--团子生命力
    AddMission(59, nil, 3361, 880, 168, false, AfterWeather)--黄豆包
    AddMission(60, nil, 3481, 880, 169, false, AfterWeather)--红豆包
    AddMission(61, nil, 3481, 760, 170, false, AfterWeather)--绿豆包
    AddMission(62, nil, 3361, 760, 171, false, AfterWeather)--蓝豆包


    AddMission(50, nil, 4000, 978, 133)--封之术法

    --挑战
    AddMission(54, nil, 3377, 538, 160)--Game Killer
    AddMission(55, nil, 3477, 538, 152)--Mimichan
    AddMission(56, nil, 3577, 538, 163)--摆烂小孩
    AddMission(57, nil, 3677, 538, 155)--深海七花
    AddMission(58, nil, 3777, 538, 154)--梅露兰的小号
end
lib.InitMission = InitMission