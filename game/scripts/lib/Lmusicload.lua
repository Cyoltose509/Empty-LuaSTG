local j = 1
---导入音乐
function AddMusic(id,  loopend, looplen, source_name)
    table.insert(LoadRes, function()
        id = tostring(id)
        local sourcePath = ("assets\\music\\%s.ogg"):format(source_name)
        if not musicList[id] then
            musicList[id] = { loopend, looplen, sourcePath }
            table.insert(musicRoomList, {
                id = id,
                name = ("music-name-%s"):format(id),
                by = ("music-by-%s"):format(id),
                desc = ("music-desc-%s"):format(id),
            })
            scoredata.meet_music[id] = scoredata.meet_music[id] or false
            j = j + 1
        end
    end)
end

---音乐表初始化
function InitMusicList()
    musicList = {}
    musicRoomList = {}
end