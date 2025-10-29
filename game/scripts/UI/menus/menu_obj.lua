local SimpleNotice = Class(object)
menu.SimpleNotice = SimpleNotice
function SimpleNotice:init(cur_menu, title, text, w, h,ex)
    self.bound = false
    self.colli = false
    object.init(self, screen.width / 2, screen.height / 2, GROUP.GHOST, LAYER.TOP)
    self.cur_menu = cur_menu
    self.title = title
    self.text = text
    self.locked = true
    self.width = w or 350
    self.height = h or 160
    self.pheight = 50
    self.select_col = 0
    self.max_select_col = 0
    self.alpha = 0
    task.New(self, function()
        task.SmoothSetValueTo("alpha", 1, 9, 2)
        while ext.mouse:isPress(1) do
            ext.mouse:frame()
            task.Wait()
        end
        self.locked = false
    end)
    self.ty = 0
    self._ty = 0
    self.texts = sp:SplitText(text, "\n")
    self.lines = #self.texts
    if not ex then
        function self:del()
            Del(self)
        end
    end
end
function SimpleNotice:frame(custom)
    task.Do(self)
    if not self.dk then
        if self.cur_menu then
            self.cur_menu.locked = true
        end
        if not self.locked then
            local line_h = 32 * 0.8 * 0.67
            local x = self.x
            local y = self.y
            local w = self.width
            local h = self.height
            local ph = self.pheight
            self._ty = self._ty + (-self._ty + clamp(self._ty, 0, max(line_h * self.lines - h * 2, 0))) * 0.3
            self.ty = self.ty + (-self.ty + self._ty) * 0.3
            self.select_col = self.select_col + (-self.select_col + self.max_select_col) * 0.2
            if custom then
                menu:Updatekey()
            end
            if menu:keyYes() or menu:keyNo() then
                self:del()
                PlaySound("ok")
            end
            if menu:keyDown() then
                self._ty = self._ty + line_h * 4
                PlaySound("select")
            end
            if menu:keyUp() then
                self._ty = self._ty - line_h * 4
                PlaySound("select")
            end
            local mouse = ext.mouse
            if sp.math.PointBoundCheck(mouse.x, mouse.y, x - w, x + w, y - h, y - h - ph) then
                self.max_select_col = 100
                if mouse:isUp(1) then
                    self:del()
                    PlaySound("ok")
                end
            else
                self.max_select_col = 0
            end
            if mouse._wheel ~= 0 then
                self._ty = self._ty - sign(mouse._wheel) * line_h * 4
                PlaySound("select")
            end
        end
    end

end
function SimpleNotice:render()
    SetViewMode("ui")
    local scrh = screen.height
    local line_h = 32 * 0.8 * 0.67
    local x = self.x
    local y = self.y
    local alpha = self.alpha
    local w = self.width * (0.6 + 0.4 * alpha)
    local h = self.height * (0.6 + 0.4 * alpha)
    local ph = self.pheight

    local pulse = self.select_col
    SetImageState("white", "", alpha * 150, 0, 0, 0)
    RenderRect("white", 0, screen.width, 0, scrh)
    SetImageState("white", "", alpha * 150, 70, 40, 40)
    RenderRect("white", x - w, x + w, y + h, y + h + ph)
    SetImageState("white", "", alpha * 150, 20, 20, 20)
    RenderRect("white", x - w, x + w, y + h, y - h)
    SetImageState("white", "", alpha * 150, 20 + pulse, 30 + pulse * 2, 30 + pulse)
    RenderRect("white", x - w, x + w, y - h, y - h - ph)
    SetImageState("white", "", alpha * 255, 255, 255, 255)
    misc.RenderOutline(x - w, x + w, y - h - ph, y + h + ph, 0, 2)
    RenderRect("white", x - w, x + w, y - h, y - h - 2)
    RenderRect("white", x - w, x + w, y + h, y + h + 2)
    ui:RenderText("big_text", self.title, x, y + h + ph / 2,
            0.7, Color(alpha * 255, 255, 255, 255), "centerpoint")
    ui:RenderText("big_text", i18n("menu-confirm-yes"), x, y - h - ph / 2,
            0.5 + pulse / 100 * 0.3, Color(alpha * 255, 255, 255, 255), "centerpoint")
    local ty = clamp(y + h, 0, scrh)
    local by = clamp(y - h, 0, scrh)
    if (-w) ~= w and (by - y) ~= (ty - y) and (x - w) ~= (x + w) and by ~= ty then
        SetRenderRect(-w, w, by - y, ty - y, x - w, x + w, by, ty)
        local Y = self.ty + h
        for _, str in ipairs(self.texts) do
            if Y > -h - line_h and Y < h + line_h then
                ui:RenderTextWithCommand("htitle", str, -w + 10, Y, 0.8, alpha * 200, "left", "top")
            end
            Y = Y - line_h
        end
    end
    SetViewMode("ui")


end
function SimpleNotice:del()
    if self.cur_menu then
        self.cur_menu.locked = false
    end
    object.Preserve(self)
    self.dk = true
    task.New(self, function()
        task.SmoothSetValueTo("alpha", 0, 9, 1)
        object.RawDel(self)
    end)
end

local SimpleChoose = Class(object)
menu.SimpleChoose = SimpleChoose
function SimpleChoose:init(cur_menu, yes, no, title, text, w, h, ex)
    self.bound = false
    self.colli = false
    object.init(self, screen.width / 2, screen.height / 2, GROUP.GHOST, LAYER.TOP)
    self.cur_menu = cur_menu
    self.title = title
    self.text = text
    self.locked = true
    self.width = w or 350
    self.height = h or 160
    self.pheight = 50
    self.pos = 1
    self.yes_func = yes
    self.no_func = no
    self.alpha = 0

    task.New(self, function()
        task.SmoothSetValueTo("alpha", 1, 9, 2)
        while ext.mouse:isPress(1) do
            ext.mouse:frame()
            task.Wait()
        end
        self.locked = false
    end)
    self.ty = 0
    self._ty = 0
    self.texts = sp:SplitText(text, "\n")
    self.lines = #self.texts
    self.col1, self.col2 = 30, 30
    if not ex then
        function self:del()
            Del(self)
        end
    end
end
---一个很奇葩的老bug我不好评价这个老bug
function SimpleChoose:frame(custom)
    task.Do(self)
    if not self.dk then
        if self.cur_menu then
            self.cur_menu.locked = true
        end
        if not self.locked then
            local line_h = 32 * 0.8 * 0.67
            local x = self.x
            local y = self.y
            local w = self.width
            local h = self.height
            local ph = self.pheight
            self._ty = self._ty + (-self._ty + clamp(self._ty, 0, max(line_h * self.lines - h * 2, 0))) * 0.3
            self.ty = self.ty + (-self.ty + self._ty) * 0.3
            if custom then
                menu:Updatekey()
            end
            if menu:keyYes() then
                if self.pos == 1 then
                    self:del()
                    self.yes_func()
                    PlaySound("ok")
                else
                    self:del()
                    self.no_func()
                    PlaySound("select")
                end
            end
            if menu:keyNo() then
                self:del()
                self.no_func()

                PlaySound("select")
            end
            if menu:keyDown() then
                self._ty = self._ty + line_h * 4
                PlaySound("select")
            end
            if menu:keyUp() then
                self._ty = self._ty - line_h * 4
                PlaySound("select")
            end
            if menu:keyLeft() or menu:keyRight() then
                self.pos = self.pos % 2 + 1
                PlaySound("select")
            end
            local mouse = ext.mouse
            local flag1 = false
            local flag2 = false
            if sp.math.PointBoundCheck(mouse.x, mouse.y, x - w, x, y - h, y - h - ph) then
                flag1 = true
                if mouse:isUp(1) then
                    self:del()
                    self.pos = 1
                    self.yes_func()

                    PlaySound("ok")
                end
            elseif sp.math.PointBoundCheck(mouse.x, mouse.y, x + w, x, y - h, y - h - ph) then
                flag2 = true
                if mouse:isUp(1) then
                    self:del()
                    self.pos = 2
                    self.no_func()

                    PlaySound("select")
                end
            end
            if mouse._wheel ~= 0 then
                self._ty = self._ty - sign(mouse._wheel) * line_h * 4
                PlaySound("select")
            end
            local _col1 = self.pos == 1 and 150 or 30
            local _col2 = self.pos == 2 and 150 or 30
            if flag1 or flag2 then
                _col1 = flag1 and 150 or 30
                _col2 = flag2 and 150 or 30
            end
            self.col1 = self.col1 + (-self.col1 + _col1) * 0.1
            self.col2 = self.col2 + (-self.col2 + _col2) * 0.1
        end
    end

end
function SimpleChoose:render()
    SetViewMode("ui")
    local scrh = screen.height
    local line_h = 32 * 0.8 * 0.67
    local x = self.x
    local y = self.y
    local alpha = self.alpha
    local w = self.width * (0.6 + 0.4 * alpha)
    local h = self.height * (0.6 + 0.4 * alpha)
    local ph = self.pheight

    SetImageState("white", "", alpha * 150, 0, 0, 0)
    RenderRect("white", 0, screen.width, 0, scrh)
    SetImageState("white", "", alpha * 150, 0, 0, 0)
    misc.RenderRoundedRect(x - w, x + w, y - h - 2, y + h + ph, 10)

    SetImageState("white", "", alpha * 150, 20, self.col1, 30)
    misc.RenderRoundedRect(x - w, x, y - h - ph, y - h, 10)
    SetImageState("white", "", alpha * 150, 20, self.col2, 30)
    misc.RenderRoundedRect(x, x + w, y - h - ph, y - h, 10)

    SetImageState("white", "", alpha * 150, 255, 255, 255)
    misc.RenderRoundedRectOutline(x - w, x, y - h - ph, y - h, 10, 2)
    misc.RenderRoundedRectOutline(x, x + w, y - h - ph, y - h, 10, 2)
    misc.RenderRoundedRectOutline(x - w, x + w, y - h, y + h + ph, 10, 2)
    RenderRect("white", x - w, x + w, y + h, y + h + 2)
    ui:RenderText("big_text", self.title, x, y + h + ph / 2,
            0.7, Color(alpha * 255, 255, 255, 255), "centerpoint")
    ui:RenderText("big_text", i18n("menu-confirm-yes"), x - w / 2, y - h - ph / 2,
            0.7, Color(alpha * 255, 255, 255, 255), "centerpoint")
    ui:RenderText("big_text", i18n("menu-confirm-no"), x + w / 2, y - h - ph / 2,
            0.7, Color(alpha * 255, 255, 255, 255), "centerpoint")
    local ty = clamp(y + h, 0, scrh)
    local by = clamp(y - h, 0, scrh)
    if (-w) ~= w and (by - y) ~= (ty - y) and (x - w) ~= (x + w) and by ~= ty then
        SetRenderRect(-w, w, by - y, ty - y, x - w, x + w, by, ty)
        local Y = self.ty + h
        for _, str in ipairs(self.texts) do
            if Y > -h - line_h and Y < h + line_h then
                ui:RenderTextWithCommand("htitle", str, -w + 10, Y, 0.8, alpha * 200, "left", "top")
            end
            Y = Y - line_h
        end
    end
    SetViewMode("ui")
end
function SimpleChoose:del()

    object.Preserve(self)
    self.dk = true
    task.New(self, function()
        if self.cur_menu then
            self.cur_menu.locked = false
        end
        task.SmoothSetValueTo("alpha", 0, 9, 1)
        object.RawDel(self)
    end)
end


local ExitButton = plus.Class()
menu.ExitButton = ExitButton
function ExitButton:init(x, y, func)
    self.x, self.y = x, y
    self.func = func
    self.index = 0
    self.timer = 0
    self.r = 14
    self.selected = false
    self.img = "menu_exiticon"
end
function ExitButton:frame(nokey)
    self.timer = self.timer + 1
    local mouse = ext.mouse
    if not nokey then
        if menu:keyNo() then
            self.index = self.index + 1
            PlaySound("select")
            self.func()
        end
    end
    if Dist(self.x, self.y, mouse.x, mouse.y) < self.r then
        self.index = self.index + (-self.index + 1) * 0.1
        if not self.selected then
            self.selected = true
            PlaySound("select")
        end
    else
        self.index = self.index - self.index * 0.1
        self.selected = false
    end
    if self.selected then
        if mouse:isUp(1) then
            self.index = self.index + 0.5
            PlaySound("select")
            self.func()
        end
    end
end
function ExitButton:render(A)
    A = A or 1
    SetImageState(self.img, "", A * (100 + self.index * 100), 255, 255, 255)
    Render(self.img, self.x, self.y, self.index * 180, (self.r + self.index * 2) / 48)
end

local ex_SimpleChoose = plus.Class()
function ex_SimpleChoose:init(cur_menu, yes, no, title, text, w, h)
    SimpleChoose.init(self, cur_menu, yes, no, title, text, w, h, true)
    self.cur_menu.choosemenu = self
end
function ex_SimpleChoose:frame()
    SimpleChoose.frame(self, true)

end
function ex_SimpleChoose:render()
    SimpleChoose.render(self)
end
function ex_SimpleChoose:del()
    self.dk = true

    task.New(self, function()
        if self.cur_menu then
            self.cur_menu.locked = false
        end
        task.SmoothSetValueTo("alpha", 0, 9, 1)
        self.cur_menu.choosemenu = nil
    end)
end
menu.ex_SimpleChoose = ex_SimpleChoose

local ex_SimpleNotice = plus.Class()
function ex_SimpleNotice:init(cur_menu, title, text, w, h)
    SimpleNotice.init(self, cur_menu, title, text, w, h, true)
    self.cur_menu.choosemenu = self
end
function ex_SimpleNotice:frame()
    SimpleNotice.frame(self, true)

end
function ex_SimpleNotice:render()
    SimpleNotice.render(self)
end
function ex_SimpleNotice:del()
    self.dk = true

    task.New(self, function()
        if self.cur_menu then
            self.cur_menu.locked = false
        end
        task.SmoothSetValueTo("alpha", 0, 9, 1)
        self.cur_menu.choosemenu = nil
    end)
end
menu.ex_SimpleNotice = ex_SimpleNotice

local FlyInNotice = Class(object)
menu.FlyInNotice = FlyInNotice
function FlyInNotice:init(cur_menu, text, h)
    self.bound = false
    self.colli = false
    object.init(self, screen.width / 2, screen.height / 2, GROUP.GHOST, LAYER.TOP)
    self.cur_menu = cur_menu
    self.text = text
    self.locked = true
    self.height = h or 80
    self.pheight = 50
    self.select_col = 0
    self.max_select_col = 0
    self.alpha = 0
    task.New(self, function()
        task.SmoothSetValueTo("alpha", 1, 30, 10)
        self.locked = false
    end)
end
function FlyInNotice:frame()
    task.Do(self)
    if not self.dk then
        if self.cur_menu then
            self.cur_menu.locked = true
        end
        if not self.locked then
            --menu:Updatekey()
            if menu:keyYes() or menu:keyNo() then
                Del(self)
                PlaySound("ok")
            end
            if ext.mouse:isUp(1) then
                Del(self)
                PlaySound("ok")
            end
        end
    end

end
function FlyInNotice:render()
    SetViewMode("ui")
    local alpha = self.alpha
    local h = self.height * (0.6 + 0.4 * alpha)
    local cy = screen.height / 2
    SetImageState("white", "", alpha * 150, 0, 0, 0)
    RenderRect("white", 0, screen.width, cy - h / 2, cy + h / 2)
    lstg.SetImageState("white", "", Color(alpha * 0, 0, 0, 0), Color(alpha * 0, 0, 0, 0),
            Color(alpha * 150, 0, 0, 0), Color(alpha * 150, 0, 0, 0))
    RenderRect("white", 0, screen.width, cy + h / 2, cy + h)
    RenderRect("white", 0, screen.width, cy - h / 2, cy - h)
    local size = 0.8
    local tlen = menu:GetTXTlen("huge", size, self.text)
    size = size / max(1, tlen / (945))
    ui:RenderTextWithCommand("huge", self.text, self.x + 150 * (1 - alpha), cy, size, alpha * 255, "centerpoint")


end
function FlyInNotice:del()
    if self.cur_menu then
        self.cur_menu.locked = false
    end
    object.Preserve(self)
    self.dk = true
    task.New(self, function()
        task.SmoothSetValueTo("alpha", 0, 15, 1)
        object.RawDel(self)
    end)
end