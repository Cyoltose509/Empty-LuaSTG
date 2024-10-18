local M = {}
Level = M

M.class = {}

function M:define(id, name, event, start_say, finish_say, perfect_say)
    local level = {}
    level.id = id
    level.name = name
    level.event = event
    level.start_say = start_say
    level.finish_say = finish_say
    level.perfect_say = perfect_say
    M.class[id] = level
end

require("mod.levels.1")