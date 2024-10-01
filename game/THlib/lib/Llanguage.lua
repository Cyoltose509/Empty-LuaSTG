local currentLanguage = setting.language or 1
local languageCache = {}
local languageMap = { "ch", "en", "jp" }
function ResetLanguageCache()
    languageCache = {}
end

function loadLanguageModule(module, fpath)
    if not languageCache[currentLanguage] then
        languageCache[currentLanguage] = {}
    end

    if not languageCache[currentLanguage][module] then
        local path = ("%s\\%s_%s.lua"):format(fpath, module, languageMap[currentLanguage])

        languageCache[currentLanguage][module] = DoFile(path)
    end

    return languageCache[currentLanguage][module]
end

function switchLanguage(language)
    currentLanguage = language
    languageCache[currentLanguage] = {}
    loadLanguageModule("ext", "THlib\\ext\\lang")
    loadLanguageModule("lockfunc", "THlib\\lib\\lang")
    ext.achievement.getcount = 0
    for p in pairs(_editor_class) do
        _editor_class[p] = nil
    end
    for p in pairs(_editor_boss) do
        _editor_boss[p] = nil
    end
    for p in pairs(_sc_list) do
        _sc_list[p] = nil
    end
    --DoFile("mod\\active\\init.lua")
    DoFile("mod\\addition\\stg_level.lua")
    --DoFile("THlib\\ext\\ext_pause_menu.lua")
    DoFile("THlib\\player\\player.lua")
    DoFile("THlib\\background\\background.lua")
    DoFile("mod\\_editor_output.lua")
    DoFile("THlib\\UI\\menu.lua")
    DoFile("THlib\\UI\\UI.lua")
    DoFile("THlib\\enemy\\boss.lua")
    DoFile("THlib\\lib\\Lmission.lua")
    stg_levelUPlib.DefineAddition()
    activeItem_lib.DefineActive()
    mission_lib.InitMission()
    InitPlayer()
    InitAllClass()
    stage.Restart()
    ext.CheckProblem()

end

---或许还可以返回成一个表？？
---极简化翻译函数
function Trans(module, str)
    return languageCache[currentLanguage][module][str]
end