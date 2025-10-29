local currentLanguage = setting.language or 1
local languageCache = {}
local languageMap = { "ch", "cht", "en", "jp", "kr" }
local jargons = {}
function ResetLanguageCache()
    languageCache = {}
    languageCache[currentLanguage] = {}
    local loads = {
        "bossname", "tool", "bosscard",
        "saying", "level", "tutorial", "menu", "achv", "music",
        "day1", "day2", "day3", "day4", "day5", "day6", "day7", "day8", "day9", "day10",
    }
    for _, load in ipairs(loads) do
        loadLanguageModule(load)
    end
    local jargon_path=("lang\\%s\\%s.lua"):format(languageMap[currentLanguage], "jargon")
    if lstg.FileManager.FileExist(jargon_path, true) then
        jargons = DoFile(jargon_path)

    end
end

function loadLanguageModule(module)
    if not languageCache[currentLanguage] then
        languageCache[currentLanguage] = {}
    end
    if not languageCache[currentLanguage][module] then
        local path = ("lang\\%s\\%s.lua"):format(languageMap[currentLanguage], module)
        if lstg.FileManager.FileExist(path, true) then
            local langlist = DoFile(path)
            for k, v in pairs(langlist) do
                languageCache[currentLanguage][k] = v
            end
        end
    end
end
ResetLanguageCache()

function switchLanguage(language)
    currentLanguage = language
    ResetLanguageCache()
    DoFile("scripts\\UI\\menu.lua")
    DoFile("scripts\\UI\\UI.lua")
    DoFile("scripts\\game\\root.lua")
    InitAllClass()

end

function WesternLang()
    return languageMap[currentLanguage] == "en"
end

---@return string
function i18n(str)
    local k = languageCache[currentLanguage][str]
    return k or str
end

function Checki18n(str)
    if languageCache[currentLanguage][str] then
        return true
    else
        return false
    end
end
local kname = Input.KeyCodeToName()
local xkname = Input.xKeyCodeToName()
local xinput = require("xinput")
---@param str string
---替换文本中的命令
function ReplaceTextWithCommand(str)
    if not str then
        return ""
    end
    return str
end

