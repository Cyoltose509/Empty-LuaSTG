local game_stage = stage.New("game", false, true)
function game_stage:init()
    mask_fader:Do("open")
    Game:Start(1)
end
function game_stage:frame()
    Game:frameEvent()
end
function game_stage:render()
    SetViewMode("world")
    Game:renderEvent()

end