local j = 1
---导入音乐
function AddMusic(id, name, loopend, looplen, source_name)
    table.insert(LoadRes, function()
        id = tostring(id)
        local sourcePath = ("music\\%s.ogg"):format(source_name)
        if not musicList[id] then
            local str = "Music" .. id
            musicList[id] = { loopend, looplen, name, str, j, sourcePath }
            musicList2[name] = id
            musicRoomList[j] = { id, name, str, loopend, looplen }
            j = j + 1
        end
    end)
end


---音乐表初始化
function InitMusicList()
    musicList = {}
    musicRoomList = {}
    musicList2 = {}
    musicList["menu"] = { 93.2, 81.47, "menu", nil,nil,  "music\\menu.ogg" }
end