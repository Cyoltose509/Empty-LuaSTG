local function _t(str)
    return Trans("scene", str) or ""
end

local lib = stage_lib
local class = lib.NewSceneClass(3, "scene3_pic", BG_5,
        { "3_1", "3_2", "3_3", "3_4" }, "3_end",
        30, _t("scene3"), _t("scene3_des"), function()
            local var = lstg.var
            var.level_exp_index = 8
            var._pathlike = true
            var._season_system = true
            var.level_offset = var.level_offset + 1
        end, 4800, {
            NewLockFunction("tool:82"),
            NewLockFunction("scene:2"),
        }, _t("pathlike") .. "+" .. _t("weaSys"))
class.inStageID = 2

loadLanguageModule("scene3", "mod\\game\\scene3")
local path = "mod\\game\\scene3\\"
LoadTexture("scene3_pic", path .. "pic.png")

DoFile(path .. "tutorial.lua")
DoFile(path .. "1.lua")
DoFile(path .. "2.lua")
