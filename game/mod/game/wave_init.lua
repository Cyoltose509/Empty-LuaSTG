local lib = stage_lib
---@param class scene_class
local function NewWaveEvent(class, id, proba, luckp, chaosp, hardf, event, title, islucky, isdanger, isboss)
    ---@class wave_event
    local e = {}
    e.proba = proba
    e.inscene = class.id
    e.id = id
    e.isWave = true
    e.title = title or ""
    e.luck_power = luckp
    e.chaos_power = chaosp
    e.hard_factor = hardf
    e.islucky, e.isdangerous, e.isboss = islucky, isdanger, isboss
    e.pro_fixed = 1
    class.events[e.id] = e
    local data = stagedata.BookWave[class.id]
    data[e.id] = data[e.id] or false
    e.event = function(var)
        data[e.id] = true--开图鉴
        event(var)
    end
    e.final = function()
    end
    return e
end
stage_lib.NewWaveEvent = NewWaveEvent

local function SetWaveEventInWave(class, e, inwave)
    class.wave_events[inwave] = class.wave_events[inwave] or {}
    table.insert(class.wave_events[inwave], e)
end
stage_lib.SetWaveEventInWave = SetWaveEventInWave

---一种方式来添加波的事件
---在指定波数添加固定概率的事件
---@param inwaves table
local function NewWaveEventInWaves(class, id, inwaves, proba, luckp, chaosp, hardf, event, title, islucky, isdanger, isboss)
    local e = NewWaveEvent(class, id, proba, luckp, chaosp, hardf, event, title, islucky, isdanger, isboss)
    for _, p in ipairs(inwaves) do
        SetWaveEventInWave(class, e, p)
    end
    return e
end
stage_lib.NewWaveEventInWaves = NewWaveEventInWaves

---和NewWaveEventInWaves的参数，但是一定设置在第一波，且概率为10000
---@param inwaves table
local function NewWaveEventInTest(class, id, inwaves, proba, luckp, chaosp, hardf, event, title, islucky, isdanger, isboss)
    local e = NewWaveEvent(class, id, 10000, luckp, chaosp, hardf, event, title, islucky, isdanger, isboss)
    SetWaveEventInWave(class, e, 1)
    return e
end
stage_lib.NewWaveEventInTest = NewWaveEventInTest

---刷新怪物血量的倍率
local function RefreshHPindex()
    local v = lstg.var
    local w = lstg.weather
    local chaos = v.chaos
    local diff = v.difficulty
    local weakened = 1
    if not stage.current_stage.is_practice then
        if v.wave == 1 then
            weakened = 0.25
        elseif v.wave == 2 then
            weakened = 0.5
        elseif v.wave == 3 then
            weakened = 0.75
        end
    end
    local diffk = 0.4 + diff * 0.2
    local chaosk = 1
    local _chaos = chaos
    while _chaos > 0 do
        chaosk = chaosk * (1 + max(0, _chaos - 75) / 75 * 0.1)
        _chaos = _chaos - 75
    end
    local other = 1
    if v._season_system then
        other = other * w.enemyHP_index
        if w.LiQiu then
            other = other * ran:Float(0.1, 2)
        end
    end
    v.enemyHP_index = (1 + max(0, chaos - 40) / 60 * 0.25) * diffk * chaosk * weakened * other

end
stage_lib.RefreshHPindex = RefreshHPindex

local Show_WaveCount = Class(object)
function Show_WaveCount:init(wave, title, lucky, dangerous, isboss)
    self.black_h = 0
    self.alpha = 1
    self.y = 140
    self.talpha = 0
    self.wave = wave
    self.title = title
    self.bound = false
    self.colli = false
    self.layer = 0
    if isboss and lucky then
        self.text = "Lucky Boss Wave?!"
        self._r, self._g, self._b = 255, 227, 132
        PlaySound("bonus2")
    elseif isboss and dangerous then
        self.text = "Hard Boss Wave!!"
        self._r, self._g, self._b = 250, 64, 64
        PlaySound("hyz_warning")
    elseif dangerous then
        self.text = "Hard Wave"
        self._r, self._g, self._b = 218, 112, 214
        PlaySound("hyz_warning")
    elseif isboss then
        self.text = "Boss Wave"
        self._r, self._g, self._b = 220, 100, 100
        PlaySound("alert")
    elseif lucky then
        self.text = "Lucky Wave!!"
        self._r, self._g, self._b = 100, 220, 100
        PlaySound("bonus2")
    else
        self.text = "Wave"
        self._r, self._g, self._b = 200, 200, 200
        PlaySound("heal")
    end
    task.New(self, function()
        for i = 1, 15 do
            self.black_h = i / 15 * 16
            task.Wait()
        end
        for i = 1, 16 do
            self.talpha = i / 16
            task.Wait()
        end
        if isboss or dangerous then
            for _ = 1, 8 do
                self.talpha = 1
                task.Wait(10)
                self.talpha = 0
                task.Wait(10)
            end
        else
            task.Wait(100)
        end
        for i = 1, 30 do
            self.alpha = 1 - i / 30
            task.Wait()
        end
        Del(self)
    end)

    local w = lstg.weather
    if w.now_weather ~= 0 then
        local wu = weather_lib.weather[w.now_weather]
        local describes = sp:SplitText(wu.describe, "\n")
        self.describe = {  }
        for i = 1, 2 do
            self.describe[i] = describes[i]
        end
        if #describes > 2 then
            self.describe[2] = self.describe[2] .. "..."
        end
    end
end
function Show_WaveCount:frame()
    task.Do(self)
end
function Show_WaveCount:render()
    local y = self.y
    local A = self.alpha
    local w = lstg.weather
    local dy = 0
    if w.now_weather ~= 0 then
        dy = self.black_h * 3.4
    end
    SetImageState("white", "", A * 150, 0, 0, 0)
    RenderRect("white", -320, 320, y - self.black_h - dy, y + self.black_h)
    ui:RenderText("title", ("%s %d %s"):format(self.text, self.wave, self.title), 0, y, 1,
            Color(A * self.talpha * 255, self._r, self._g, self._b), "centerpoint")
    if w.now_weather ~= 0 then
        ---@type weather_unit
        local wu = weather_lib.weather[w.now_weather]
        ui:RenderText("pretty_title", ("%s"):format(wu.name), 0, y - self.black_h * 1.3, 1,
                Color(A * self.talpha * 255, wu.R, wu.G, wu.B), "centerpoint")
        ui:RenderText("title", ("%s"):format(wu.subtitle), 0, y - self.black_h * 2.4, 0.6,
                Color(A * self.talpha * 255, wu.R, wu.G, wu.B), "centerpoint")
        for i, t in ipairs(self.describe) do
            ui:RenderTextWithCommand("title", t, 0, y - self.black_h * 2.8 - i * 10 + 3, 0.5,
                    A * self.talpha * 150, "centerpoint")
        end
    end
end

function SetWave(wave, wait, title, lucky, dangerous, isboss)
    local var = lstg.var
    var.wave_luck = lucky
    var.wave_hard = dangerous
    var.wave_boss = isboss
    New(Show_WaveCount, wave, title, lucky, dangerous, isboss)
    if lstg.var._season_system then
        wait = wait + 60
    end
    task.Wait(wait)
end

local function SetWeather()
    local w = lstg.weather
    local selected
    if w.next_weather then
        selected = weather_lib.weather[w.next_weather]
        w.next_weather = nil
    else
        local nowc = {}
        local j = 0
        for _, p in ipairs(weather_lib.season[w.now_season].weathers) do
            local pro = p.pro()
            if p.state == 1 and w.TwiceXiangRui then
                pro = pro * 1.25
            end
            table.insert(nowc, { p, j, j + pro })
            j = j + pro
        end
        local c = ran:Float(0, j)
        for _, unit in ipairs(nowc) do
            if c >= unit[2] and c < unit[3] then
                selected = unit[1]
                break
            end
        end
    end
    if selected then
        if w.now_weather ~= 0 then
            weather_lib.weather[w.now_weather].final()
        end
        w.now_weather = selected.id
        weather_lib.weather[w.now_weather].init()
        table.insert(w.total_weather, w.now_weather)
    end
end
stage_lib.SetWeather = SetWeather

local function SetSeason()
    local weather = lstg.weather
    local j = 0
    if weather.now_season == 0 or weather.season_wave >= weather.season_last[weather.now_season] then
        weather.now_season = 0
        weather.season_wave = 0
        local flag = true
        for _, p in ipairs(weather.selected_season) do
            if p then
                j = j + 1
            end
            flag = flag and p
        end
        if flag then
            weather.selected_season = { false, false, false, false }
        end
    end
    if weather.now_season == 0 then
        if j == 3 then
            lstg.weather.next_season = 1
        end
        ext.season_set:SetSeason(lstg.weather.next_season)
        lstg.weather.next_season = nil
    end
end

local function saveWaveData()
    local _lib = player_lib
    local p = player
    _lib._last_cache_player = _lib._cache_player
    _lib._last_cache_var = _lib._cache_var
    _lib._last_cache_weather = _lib._cache_weather
    _lib._last_cache_active_data = _lib._cache_active_data
    if _lib._last_cache_var.rewind_CD then
        lstg.var.rewind_CD = false
    end
    _lib._cache_var = sp:CopyTable(lstg.var)
    _lib._cache_weather = sp:CopyTable(lstg.weather)
    _lib._cache_player = {}
    _lib._cache_active_data = {}
    for _, v in ipairs(lstg.var.active_item) do
        ---@type active_unit
        local Active = activeItem_lib.ActiveTotalList[v]
        _lib._cache_active_data[v] = {
            energy = Active.energy,
            charge_c = Active.charge_c,
            type = Active.type,
            energy_max = Active.energy_max,
        }
    end
    for _, v in ipairs(_lib.__must_save_data) do
        local value = p[v]
        if type(value) == "table" then
            value = sp:CopyTable(value)
        end
        _lib._cache_player[v] = value
    end
end
stage_lib.saveWaveData = saveWaveData

local function DoWaveEvent(self, wave, getwavefunc, events, event)
    local var = lstg.var
    local weather = lstg.weather

    if var._season_system then
        SetSeason()
        task.Wait()
        weather.season_wave = weather.season_wave + 1
        SetWeather()
    end
    event = event or getwavefunc(wave, events)
    if event then
        var.wave = wave
        var.now_wave_id = event.id
        saveWaveData()
        if wave ~= 1 then
            activeItem_lib.AddActiveChargeByWave()
            local addv = { 1, 3, 4, 4, var.challenge_addchaos or 4, 3 }
            local k = addv[var.difficulty + 1]
            if var.chaos >= 50 then
                k = k * 0.8
            end
            if var.chaos >= 100 then
                k = k * 0.9
            end
            if self.scene_class then
                if var.wave > self.scene_class._maxwave then
                    k = k * 1.5
                end
            end
            player_lib.AddChaos(k)
        end--chaos增长
        if event.islucky then
            ext.achievement:get(12)
        end
        if event.isdangerous and lstg.tmpvar.MarisaSkill2 then
            var.energy = var.maxenergy * var.energy_stack
        end
        lstg.tmpvar.get_pearl = 0
        lstg.tmpvar.level_up_count = 0
        self.eventListener:Do("waveEvent@before", self, self)
        SetWave(wave, 45, event.title, event.islucky, event.isdangerous, event.isboss)
        event.event(var)
    end
end
stage_lib.DoWaveEvent = DoWaveEvent

local function DoWaveEventFake(self, wave, title, islucky, isdangerous, isboss)
    local var = lstg.var
    local weather = lstg.weather

    if var._season_system then
        SetSeason()
        task.Wait()
        weather.season_wave = weather.season_wave + 1
        SetWeather()
    end
    var.wave = wave
    saveWaveData()
    if wave ~= 1 then
        activeItem_lib.AddActiveChargeByWave()
        local addv = { 1, 3, 4, 4, var.challenge_addchaos or 4, 3 }
        local k = addv[var.difficulty + 1]
        if var.chaos >= 50 then
            k = k * 0.8
        end
        if var.chaos >= 100 then
            k = k * 0.9
        end
        if self.scene_class then
            if var.wave > self.scene_class._maxwave then
                k = k * 1.5
            end
        end
        player_lib.AddChaos(k)
    end
    if islucky then
        ext.achievement:get(12)
    end
    if isdangerous and lstg.tmpvar.MarisaSkill2 then
        var.energy = var.maxenergy * var.energy_stack
    end
    lstg.tmpvar.get_pearl = 0
    lstg.tmpvar.level_up_count = 0
    self.eventListener:Do("waveEvent@before", self, self)

    SetWave(wave, 45, title, islucky, isdangerous, isboss)

end
stage_lib.DoWaveEventFake = DoWaveEventFake

local function InitMusicEvent(scene_class)
    local self = stage.current_stage
    scene_class = scene_class or self.scene_class
    self.bgmlist = scene_class._bgmlist
    self.bgm_volumes = { 0, 0, 0, 0 }
    for i, m in ipairs(scene_class._bgmlist) do
        PlayMusic2(m, self.bgm_volumes[i])
    end
    self.otherMusic_volume = 0
    self.cur_otherMusic = nil
    self.global_music_volume = {  }
    self.music_text_show = {}
end
stage_lib.InitMusicEvent = InitMusicEvent

local function GetGlobalMusicVolume()
    local self = stage.current_stage
    local v = 1
    for o, p in pairs(self.global_music_volume) do
        if IsValid(o) then
            v = v * p
        else
            self.global_music_volume[o] = nil
        end

    end
    return v
end

local function SetGlobalMusicVolume(unit, s)
    local self = stage.current_stage
    if IsValid(unit) then
        self.global_music_volume[unit] = s
    else
        self.global_music_volume[unit] = nil
    end
end
stage_lib.SetGlobalMusicVolume = SetGlobalMusicVolume

local function DoMusicEvent()
    local self = stage.current_stage
    local tvar = lstg.tmpvar
    local Color = { 255, 255, 255 }
    if self.bgmlist then
        for i, m in ipairs(self.bgmlist) do

            local A, B = (i - 1) * 50, i * 50
            local chaos = lstg.var.chaos
            local flag = (A <= chaos) and (chaos < B)
            if i == #self.bgmlist then
                flag = A <= chaos
            end
            if not self.StopMusic and not tvar.otherMusic and flag then
                self.bgm_volumes[i] = min(self.bgm_volumes[i] + 1 / 60, 1)
                if self.bgm_volumes[i] == 1 and not self.music_text_show[m] then
                    self.music_text_show[m] = true
                    SimpleText.MusicSign(("BGM : %s"):format(musicList[m][3]), Color)
                end
            else
                self.bgm_volumes[i] = max(self.bgm_volumes[i] - 1 / 60, 0)
                self.music_text_show[m] = nil
            end
            if GetMusicState2(m) == "playing" then
                SetBGMVolume(m, self.bgm_volumes[i] * GetGlobalMusicVolume())
            end
        end
        if not self.StopMusic and tvar.otherMusic then
            if GetMusicState2(tvar.otherMusic) ~= "playing" then
                self.cur_otherMusic = tvar.otherMusic
                self.otherMusic_volume = 0
                PlayMusic2(tvar.otherMusic, 0, tvar.otherMusic_start_time)
            end
            SetBGMVolume(tvar.otherMusic, self.otherMusic_volume * GetGlobalMusicVolume())
            self.otherMusic_volume = min(self.otherMusic_volume + 1 / 60, 1)
            if self.otherMusic_volume == 1 and not self.music_text_show[self.cur_otherMusic] then
                self.music_text_show[self.cur_otherMusic] = true
                SimpleText.MusicSign(("BGM : %s"):format(musicList[self.cur_otherMusic][3]), Color)
            end
        else
            self.otherMusic_volume = max(self.otherMusic_volume - 1 / 60, 0)
            if self.otherMusic_volume == 0 and self.cur_otherMusic then
                StopMusic2(self.cur_otherMusic)
                self.music_text_show[self.cur_otherMusic] = nil
                self.cur_otherMusic = nil

            end
        end
    end
end
stage_lib.DoMusicEvent = DoMusicEvent

local function StageInit(self)
    self.eventListener = eventListener()
    LoadBossTex()
    mask_fader:Do("open")
    local var = lstg.var
    New(player_list[var.player_select].class)
    ---@type scene_class
    local scene_class = SceneClass[var.scene_id]
    self.scene_class = scene_class
    background.Create(scene_class._bg)
    if var.difficulty == 3 then
        var.maxwave = scene_class._maxwave * 2
    else
        var.maxwave = scene_class._maxwave
    end
    var.chaos = ({ 0, 100, 0 })[var.difficulty]
    var._off_chaos = var.chaos
    scene_class.init_set()
    stage_lib.InitMusicEvent()
    if not IsSpecialMode() then
        local slib = stg_levelUPlib
        if scoredata.infinite_clock then
            slib.SetAddition(slib.AdditionTotalList[137], true)
        end
        if scoredata.siyuan_baby_count > 0 then

            local othercond = function(tool)
                return slib.SearchToolTag(tool, "baby") and slib.SearchToolTag(tool, "siyuan")
            end
            for _ = 1, scoredata.siyuan_baby_count do
                local p = slib.GetAdditionList(1, othercond)
                if p[1] then
                    slib.SetAddition(p[1])
                end
            end
            scoredata.siyuan_baby_count = 0
        end
    end
    if GetChargeCost() then
        if scoredata.money > GetChargeCost() then
            AddMoney(-GetChargeCost())
        else
            PlaySound("invalid")
            New(info, "资金力不足，自动退出充钱模式", 120, 14, true)
            lstg.var.chargeMode_cost = nil
            scoredata.chargeMode_show = false
            RefreshInitialSelect()
        end
    end
    for _, p in ipairs(stagedata.chooseInitial) do
        if p ~= 0 then
            stg_levelUPlib.SetAddition(stg_levelUPlib.AdditionTotalList[p])
        end
    end

end
stage_lib.StageInit = StageInit

local function PassCheck()
    while true do
        local flag
        for _, o in ObjList(GROUP.ENEMY) do
            if not o.pass_check then
                flag = true
                break
            end
        end
        if not flag then
            for _, o in ObjList(GROUP.NONTJT) do
                if not o.pass_check then
                    flag = true
                    break
                end
            end
        end
        if not flag then
            break
        end
        task.Wait()
    end
end
stage_lib.PassCheck = PassCheck

local function testItem(k, count)
    local p = stg_levelUPlib.AdditionTotalList[k]
    for _ = 1, count or 1 do
        stg_levelUPlib.SetAddition(p)
    end
end
stage_lib.testItem = testItem
local function testWeather(id)

    local w = lstg.weather
    w.next_weather = id
    w.next_season = weather_lib.weather[w.next_weather].inseason

end
stage_lib.testWeather = testWeather
local function testWave(id)
    lstg.var.next_wave_id = id
end
stage_lib.testWave = testWave
