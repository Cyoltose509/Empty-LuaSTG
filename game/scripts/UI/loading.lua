

local function GetLoadingFile()
    local list = {}
    for _, v in ipairs(lstg.FindFiles('assets\\se\\', 'wav', '')) do
        local name = string.sub(v[1], 11, -5)
        table.insert(list, function()
            LoadSound(name, 'assets\\se\\' .. name .. '.wav')
        end)
    end
    for _, v1 in ipairs(LoadRes) do
        table.insert(list, v1)
    end
    table.insert(list, function()
        InitAllClass()

    end)

    return list
end

local string = string
local clock = os.clock

local Color = Color
--0.016666666666
local time = 1 / 60

local stage_init = stage.New('init', false, true)
function stage_init:init()
    math.randomseed(os.time())
    self.start_time = clock()
    self.res = GetLoadingFile()
    self.index = 1
    self.maxindex = #self.res
    self.settime = self.timer
    self.alpha = 0
    SetResourceStatus("global")
    task.New(self, function()
        while not self.jump do
            task.Wait()
        end
        SetResourceStatus("stage")
        --   Print("\n\n\n\n" .. (clock() - self.start_time) .. "\n\n\n\n")
        mask_fader:Do("close", 60)
        GlobalLoading = true
        GlobalAddAchievement = true
        task.Wait(60)
      --  if #scoredata.user_name == 0 then
      --      stage.Set('none', "input_name")
       -- else
            stage.Set( "main")
      --  end
        self.stop_render = true
        for i = 1, 2 do
            lstg.RemoveResource("global", i, "loading")
            --lstg.RemoveResource("global", i, "load_warning1")
            -- lstg.RemoveResource("global", i, "load_warning2")
        end
    end)
end
function stage_init:frame()
    self.alpha = self.alpha + (-self.alpha + 1) * 0.05
    self.timer = int((clock() - self.start_time) * 60)
    if self.index > self.maxindex then
        self.jump = true
    elseif not self.jump then
        local resFunc
        local start_time, end_time = clock(), clock()
        while end_time - start_time <= time do
            if self.index > self.maxindex then
                break
            end
            resFunc = self.res[self.index]
            if resFunc then
                resFunc()
            end
            self.index = self.index + 1
            end_time = clock()
        end
    end
end
function stage_init:render()
    if self.stop_render then
        return
    end
    ui:RenderText("big_text", "这是加载画面",
            480, 270, 1, Color(255, 255, 255, 255),"centerpoint")
end

local utf8 = require("utf8")
local function sub(s, i, j)
    i = i or 1
    j = j or -1
    if i < 0 or j < 0 then
        local len = utf8.len(s)
        if not len then
            return ""
        end
        if i < 0 then
            i = len + 1 + i
        end
        if j < 0 then
            j = len + 1 + j
        end
    end
    local start_pos = utf8.offset(s, i)
    local end_pos = utf8.offset(s, j + 1)
    if start_pos and end_pos then
        return s:sub(start_pos, end_pos - 1)
    elseif start_pos then
        return s:sub(start_pos)
    else
        return ""
    end
end

local Window = require("lstg.Window")
local input_name = stage.New('input_name', false, true)
function input_name:init()
    self.input_name = ""
    self.max_name_len = 20
    ---@type lstg.Window
    local main_window = Window.getMain()
    ---@type lstg.Window.TextInputExtension
    self.text_input_ext = main_window:queryInterface("lstg.Window.TextInputExtension")
    ---@type lstg.Window.InputMethodExtension
    self.input_method_ext = main_window:queryInterface("lstg.Window.InputMethodExtension")
    self.text_input_ext:setEnabled(true)
    self.input_method_ext:setInputMethodEnabled(true)
    self.shake = 0
    self.cursor_pos = 0
    self.finish = false
    self.text_size = 0.56
    self.ok_button = {
        x = 480, y = 150, index = 0,
        w = 230, h = 48,
        scale = 0.3,
        selected = false,
        text = i18n("input-confirm"),
        func = function()
            local validname = CheckValidName(self.input_name)
            if validname == true then
                self.finish = true
            else
                New(menu.info, validname, 480, 200)
                self.shake = 10
                PlaySound("invalid")
            end
        end,
        frame = menu.general_buttonFrame,
        render = menu.general_buttonRender,
    }
    self.steam_button = {
        x = 480, y = 100, index = 0,
        w = 250, h = 48,
        scale = 0.3,
        selected = false,
        text = i18n("input-steam-name"),
        func = function()
            --self.input_name = ""
            self.text_input_ext:clear()
            local name = luaSteam.GetPersonaName()
            for _, c in utf8.codes(name) do
                self.text_input_ext:insert(utf8.char(c))
                self.text_input_ext:setCursorPosition(self.text_input_ext:getCursorPosition() + 1)
            end
        end,
        frame = menu.general_buttonFrame,
        render = menu.general_buttonRender,
    }
    self.finishable = false
    self.ok_alpha = 0
    task.New(self, function()
        while not self.finish do
            task.Wait()
        end
        self.input_method_ext:setInputMethodEnabled(false)
        mask_fader:Do("close", 60)
        SaveUserName(self.input_name)
        task.Wait(60)
        stage.Set( "main")
    end)

end
function input_name:frame()
    if not self.finish then
        self.finishable = #self.input_name > 0
        self.shake = self.shake - self.shake * 0.1
        if self.finishable then
            self.ok_alpha = self.ok_alpha + (-self.ok_alpha + 1) * 0.1
        else
            self.ok_alpha = self.ok_alpha + (-self.ok_alpha + 0) * 0.1
        end
        menu:Updatekey()
        local size = self.text_size
        local ttf = "huge"
        local len = menu:GetTXTlen(ttf, size, self.input_name)
        self.input_name, self.cursor_pos = menu:InputControl(self.text_input_ext, self.input_name, ttf, size,
                self.max_name_len, 480 - len / 2, 270 - 25, 50, self.input_method_ext)
        if self.finishable then
            self.ok_button:frame()
        end
        self.steam_button:frame()
    end
end
function input_name:render()
    ui:RenderText("big_text", i18n("input-name"), 480, 390, 0.5,
            Color(255, 230, 230, 230), "centerpoint")
    ui:RenderText("big_text", i18n("show-at-leaderboard"), 480, 360, 0.4,
            Color(255, 200, 227, 132), "centerpoint")
    local name = self.input_name
    local ttf = "huge"
    local size = self.text_size
    local s = self.shake
    local cx, cy = 480 + sin(s * 65) * s, 270
    ui:RenderText("huge", name, cx, cy, size, Color(255, 200, 200 - s * 10, 200 - s * 10), "centerpoint")
    local cursor = "|"
    local len = menu:GetTXTlen(ttf, size, self.input_name)
    local name1 = sub(name, 1, self.cursor_pos)
    local len1 = menu:GetTXTlen(ttf, size, name1)
    local wrinkle = (self.timer % 60 < 30 and 1 or 0)
    ui:RenderText(ttf, cursor, cx - len / 2 + len1 + 1, cy, size, Color(255 * wrinkle, 255, 255, 255), "centerpoint")
    self.ok_button:render(self.ok_alpha)
    self.steam_button:render()
end


