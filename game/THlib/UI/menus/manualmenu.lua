local function loadtxt()
    local list1, list2 = {}, {}
    loadLanguageModule("manual", "THlib\\UI\\lang")
    for i = 1, 9 do
        local title = Trans("manual", i * 2 - 1)
        local content = Trans("manual", i * 2)
        table.insert(list1, title)
        table.insert(list2, sp:SplitText(content, "\n"))
    end
    return list1, list2
end
local function _t(str)
    return Trans("sth", str) or ""
end

local manualmenu = stage.New("manual", false, true)
function manualmenu:changeState(c)
    task.New(self, function()
        if c == "out" then
            for i = 1, 20 do
                self.tri_alpha = 1 - sin(i * 4.5)
                task.Wait()
            end
        else
            for i = 1, 20 do
                self.tri_alpha = sin(i * 4.5)
                task.Wait()
            end
        end
    end)
end
function manualmenu:init()
    self.top_bar = top_bar_Class(self, _t("manual"))
    self.exit_func = function()
        task.New(self, function()
            self.locked = true
            mask_fader:Do("close")
            task.Wait(15)
            stage.Set("none", "main")
        end)
    end
    self.top_bar:addReturnButton(self.exit_func)
    mask_fader:Do("open")

    self.x, self.y = screen.width / 2, screen.height / 2
    self.locked = true
    self.text_hscale = 0
    self.text_vscale = 0
    self.text, self.content = loadtxt()
    self.pos = 1
    self.tri_alpha = 1
    self.state = 1
    self.pos_pre = 1
    self.pos_changed = 0
    self.no_pos_change = false
    self.timer = 0
    task.New(self, function()
        task.Wait(30)
        while GetKeyState(KEY.Z) do
            task.Wait()
        end
        self.locked = false
    end)
end
function manualmenu:frame()
    self.timer = self.timer + 1
    if self.locked then
        return
    end
    menu:Updatekey()
    if menu:keyNo() then
        if self.state == 2 then
            PlaySound("cancel00", 0.3)
            task.New(self, function()
                self.locked = true
                self:changeState("out")
                task.MoveToForce(screen.width / 2, screen.height / 2, 20, 2)
                self.state = 1
                self.locked = false
            end)
        else

            PlaySound("cancel00")
            self.exit_func()

        end
    elseif menu:keyYes() and self.state ~= 2 then
        self.state = 2
        task.New(self, function()
            self.locked = true
            self:changeState()
            task.MoveToForce(-screen.width / 2, screen.height / 2, 20, 2)
            self.locked = false
        end)
        PlaySound("ok00", 0.3)
    else
        if menu:keyUp() and (not self.no_pos_change) then
            self.pos = sp:TweakValue(self.pos - 1, #self.text, 1)
            self:changeState()
            PlaySound('select00', 0.3)
        end
        if menu:keyDown() and (not self.no_pos_change) then
            self.pos = sp:TweakValue(self.pos + 1, #self.text, 1)
            self:changeState()
            PlaySound('select00', 0.3)
        end
        local mouse = ext.mouse
        if mouse:isUp(1) then
            if self.state == 2 then
            else
                local height = ui.menu.line_height
                local selected = menu:mouseCheck(self.y + (#self.text + 1) * height * 0.5, 0, height, #self.text)
                if selected then
                    if selected ~= self.pos then
                        PlaySound("select00")
                        self.pos = selected
                        self:changeState()
                    else
                        self.state = 2
                        task.New(self, function()
                            self.locked = true
                            self:changeState()
                            task.MoveToForce(-screen.width / 2, screen.height / 2, 20, 2)
                            self.locked = false
                        end)
                        PlaySound("ok00", 0.3)
                    end
                end
            end
        end
        if mouse._wheel ~= 0 then
            self.pos = sp:TweakValue(self.pos - sign(mouse._wheel), #self.text, 1)
            self:changeState()
            PlaySound("select00")
        end
    end
    if self.pos_changed > 0 then
        self.pos_changed = self.pos_changed - 1
    end
    if self.pos_pre ~= self.pos then
        self.pos_changed = ui.menu.shake_time
    end
    self.pos_pre = self.pos
    self.top_bar:frame()

end
function manualmenu:render()
    ui:DrawBack(1, self.timer)
    ui:DrawMenu("", self.text, self.pos, self.x - 150, self.y,
            1, self.timer, self.pos_changed, "left", self.tri_alpha)
    if self.state == 2 then

        ui:RenderTextWithCommand("small_text", ("--%s"):format(self.text[self.pos]),
                self.x + 700, 400 + 60, 0.9, self.tri_alpha * 255, "left")
        for i, str in ipairs(self.content[self.pos]) do
            ui:RenderTextWithCommand("small_text", str,
                    self.x + 700, 400 + 50 - i * 18, 0.9, self.tri_alpha * 255, "left")
        end
    end
    self.top_bar:render()
end