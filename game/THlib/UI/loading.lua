local function EnumPNG(list, searchPath, func)
    for _, v in ipairs(lstg.FileManager.EnumFiles(searchPath, "png", true)) do
        local path = v[1]
        local name = path:sub(searchPath:len() + 1, -5)
        table.insert(list, function()
            func(name, path)
        end)
    end
end

local function GetLoadingFile()
    local list = {}

    --EnumPNG(list, "Resources\\BossBackGround\\", LoadTexture2)
    --EnumPNG(list, "Resources\\BossImage\\", LoadTexture)
    EnumPNG(list, "Resources\\Special\\", LoadImageFromFile)
    for _, v1 in ipairs(LoadRes) do
        table.insert(list, v1)
    end
    table.insert(list, function()
        InitAllClass()
    end)

    return list
end

--LoadImageFromFile("loading", "THlib\\UI\\loading.png")

local string = string
local clock = os.clock

local Color = Color
--0.016666666666
local time = 1 / 60

local Text = TIP

local stage_init = stage.New('init', false, true)
function stage_init:init()
    math.randomseed(os.time())
    self.start_time = clock()
    self.res = GetLoadingFile()
    self.index = 1
    self.maxindex = #self.res
    self.textindex = math.random(1, #Text)
    self.text = Text[self.textindex]
    self.settime = self.timer
    self.alpha = 1
    SetResourceStatus("global")
    task.New(self, function()
        while not self.jump do
            task.Wait()
        end
        SetResourceStatus("stage")
        --   Print("\n\n\n\n" .. (clock() - self.start_time) .. "\n\n\n\n")
        mask_fader:Do("close")
        GlobalLoading = true
        GlobalAddAchievement = true
        task.Wait(15)
        stage.Set('none', "intro")
        self.stop_render = true
        for i = 1, 2 do
            lstg.RemoveResource("global", i, "loading")
            --lstg.RemoveResource("global", i, "load_warning1")
            -- lstg.RemoveResource("global", i, "load_warning2")
        end
    end)
end
function stage_init:frame()
    self.timer = int((clock() - self.start_time) * 60)
    if self.timer - self.settime > 150 then
        local t = self.textindex
        while self.textindex == t do
            self.textindex = math.random(1, #Text)
        end
        self.text = Text[self.textindex]
        self.settime = self.timer
    end
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
    if self.stop_render or true then
        return--现在加载太快，不渲染loading界面了
    end
    SetImageState("white", "", 255, 0, 0, 0)
    RenderRect("white", 0, screen.width, 0, screen.height)
    --SetImageState("loading", "", self.alpha * 255, 255, 255, 255)
    --Render("loading", 480, 270, 0, 960 / 1600)
    ui:RenderText("big_text", "这是加载页面", 480, 270, 1, Color(255, 255, 255, 255), "centerpoint")
    local length = min(self.index / self.maxindex, 1)
    SetImageState("white", "", 255 * self.alpha, 255, 255, 255)
    RenderRect("white", 220, 740, 63, 82)
    SetImageState("white", "", 255 * self.alpha, 0, 0, 0)
    RenderRect("white", 222, 738, 65, 80)
    SetImageState("white", "",
            Color(180 * self.alpha, 255 - 155 * length, 255 * length, 0 + 100 * length))
    RenderRect("white", 222, 222 + length * 516, 65, 80)
    SetFontState("Score", "",
            Color(255 * self.alpha, 255 * length, 255 - 28 * length, 100 + 32 * length))
    RenderText("Score", ("%0.2f%%"):format(length * 100), 480, 80, 0.3, "center")

    ui:RenderText("title", "loading" .. string.rep(".", int(self.timer / 20 % 6) + 1),
            480, 45, 1, Color(self.alpha * 255, 255, 227, 132), "centerpoint")
    ui:RenderText("small_text", "Tips : " .. self.text,
            480, 170, 1.15, Color(self.alpha * 255, 250, 128, 114 + 50 * sin(self.timer * 2)), "centerpoint")
end


