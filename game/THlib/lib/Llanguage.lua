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
    DoFile("THlib\\background\\background.lua")
    DoFile("THlib\\UI\\menu.lua")
    DoFile("THlib\\UI\\UI.lua")
    InitAllClass()
    stage.Restart()
end

---或许还可以返回成一个表？？
---极简化翻译函数
function Trans(module, str)
    return languageCache[currentLanguage][module][str]
end