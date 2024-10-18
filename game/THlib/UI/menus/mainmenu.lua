---主菜单设计
local tR, tG, tB = 189, 252, 201
local PointToPress = plus.Class()
function PointToPress:init(x, y, size, R, G, B, text, func)
    self.x, self.y = x, y
    self.R, self.G, self.B = R, G, B
    self.alpha = 0.6
    self.bound = false
    self.group = GROUP.INDES
    self.layer = LAYER.TOP
    self.size = size
    self.index = 0
    self._index = 1
    self.timer = ran:Int(1, 1000)
    self.text = text
    self.func = func
    self.cindex = 0
    self._cindex = 0
end
function PointToPress:frame()
    self.timer = self.timer + 1
    self.index = self.index + (-self.index + self._index) * 0.1
    self.cindex = self.cindex + (-self.cindex + self._cindex) * 0.1
    local mouse = ext.mouse
    if Dist(mouse.x, mouse.y, self.x, self.y) < self.size then
        self._index = 1.5
        if mouse:isUp(1) then
            self.func()
            self._cindex = 1
        end
    else
        self._index = 1
    end

end
function PointToPress:render()
    local c = self.cindex
    local size = self.size * (self.index + c * 0.3) * (1 + sin(self.timer * 2) * 0.02)
    local r = self.R * (1 - c) + tR * c
    local g = self.G * (1 - c) + tG * c
    local b = self.B * (1 - c) + tB * c
    SetImageState("bright", "mul+add", self.alpha * 80, r, g, b)
    Render("bright", self.x, self.y, 0, size * 5 / 150)
    SetImageState("bright_circleOutline", "mul+add", self.alpha * (80 + self.index * 80), r, g, b)
    Render("bright_circleOutline", self.x, self.y, 0, size / 200)

    local fsize = size * 0.006
    RenderTTF3("big_text", self.text, self.x, self.y, 0, fsize, fsize,
            "mul+add", Color(self.alpha * (80 + self.index * 80), 200, 200, 200), "centerpoint")
end

local Buttons = {}
local function createButton(x, y, size, R, G, B, text, func)
    local button = PointToPress(x, y, size, R, G, B, text, func)
    table.insert(Buttons, button)
    return button
end

mainmenu = stage.New("main", false, true)
function mainmenu:init()
    lastmenu = self

    FUNDAMENTAL_MENU = self
    mask_fader:Do("open")
    if scoredata.version ~= ui.version then
        --更新版本初始化
        scoredata.version = ui.version
    end
    do
        local d = os.date("*t")
        local date = os.time({ day = d.day, month = d.month, year = d.year })
        if date - scoredata.LastLoginDate >= 172800 then
            scoredata.ContinuousLogin = 1
        elseif date - scoredata.LastLoginDate >= 86400 then
            scoredata.ContinuousLogin = scoredata.ContinuousLogin + 1
        end
        scoredata.LastLoginDate = date
    end--登录天数计算
    Buttons = {}
    createButton(480, 270, 90, 250, 136, 254, "Go", function()
        task.New(self, function()
            mask_fader:Do("close")
            task.Wait(15)
            stage.Set("none", "game")
        end)


    end)
end
function mainmenu:frame()
    menu:Updatekey()
    for _, button in ipairs(Buttons) do
        button:frame()
    end
end
function mainmenu:render()

    SetViewMode "ui"
    for _, button in ipairs(Buttons) do
        button:render()
    end

end

