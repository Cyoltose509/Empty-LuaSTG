
Level:define(1, "Level 1", function()
    local bottom = {
        Game:createPoint(-80, 80, -50),
        Game:createPoint(80, 80, -50),
        Game:createPoint(80, -80, -50),
        Game:createPoint(-80, -80, -50),
    }
    local top = Game:createPoint(0, 0, 40)
    Game:LinkPointsInLine(true, bottom)
    for _, p in ipairs(bottom) do
        Game:LinkPoints(p, top)
    end
    Game:createDecorativePoints()
end, "", "", "")
