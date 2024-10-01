DEBUG = true
LoadTexture("Collision_render", "render_colli.png")
LoadImage("collision_rect", "Collision_render", 0, 0, 128, 128)
LoadImage("collision_rect1", "Collision_render", 0, 0, 32, 128)
LoadImage("collision_rect2", "Collision_render", 32, 0, 64, 128)
LoadImage("collision_rect3", "Collision_render", 96, 0, 32, 128)
LoadImage("collision_ring", "Collision_render", 130, 0, 128, 128)

local function match_base(class, match)
    if class == match then
        return true
    elseif class.base then
        return match_base(class.base, match)
    end
end

do
    local toggle, show_pos, test, KeyDown192, KeyDown123, KeyDown121, KeyDown116, KeyDown117
    local img, l1, l2, l3, l, w, x, y, tx, ty, dx, dy, wx, wy, x1, y1, x2, y2, x3, y3, x4, y4
    Collision_Checker = {}
    Collision_Checker.list = {
        { GROUP.PLAYER, Color(255, 50, 255, 50) },
        { GROUP.PLAYER_BULLET, Color(255, 127, 127, 192) },
        { GROUP.SPELL, Color(255, 255, 50, 255) },
        { GROUP.NONTJT, Color(255, 128, 255, 255) },
        { GROUP.ENEMY, Color(255, 255, 255, 128) },
        { GROUP.ENEMY_BULLET, Color(255, 255, 50, 50) },
        { GROUP.INDES, Color(255, 255, 165, 10) },
        { GROUP.LASER, Color(255, 135, 206, 235) },
        { GROUP.ITEM, Color(255, 189, 252, 201) },
        { GROUP.ITEM2, Color(255, 189, 252, 201) },
        { GROUP.GHOST, Color(255, 125, 125, 125) }
    }
    function Collision_Checker.init()
        toggle = false
        test = false
        KeyDown192 = false
        KeyDown123 = false
        KeyDown121 = false
        KeyDown116 = false
        KeyDown117 = false
    end
    function Collision_Checker.render()
        SetViewMode('world')
        if GetKeyState(117) then
            if not KeyDown117 then
                KeyDown117 = true
                NoteInfo_Show = not NoteInfo_Show
            end
        else
            KeyDown117 = false
        end
        if GetKeyState(116) then
            if not KeyDown116 then
                KeyDown116 = true
                show_pos = not show_pos
            end
        else
            KeyDown116 = false
        end
        if GetKeyState(192) then
            if not KeyDown192 then
                KeyDown192 = true
                toggle = not toggle
            end
        else
            KeyDown192 = false
        end
        if GetKeyState(123) then
            if not KeyDown123 then
                KeyDown123 = true
                cheat = not cheat
            end
        else
            KeyDown123 = false
        end
        if GetKeyState(121) then
            if not KeyDown121 then
                KeyDown121 = true
                auto = not auto
            end
        else
            KeyDown121 = false
        end

        if toggle then
            for i = 1, #Collision_Checker.list do
                SetImageState("collision_rect", "", Collision_Checker.list[i][2])
                SetImageState("collision_rect1", "", Collision_Checker.list[i][2])
                SetImageState("collision_rect2", "", Collision_Checker.list[i][2])
                SetImageState("collision_rect3", "", Collision_Checker.list[i][2])
                SetImageState("collision_ring", "", Collision_Checker.list[i][2])
                for _, unit in ObjList(Collision_Checker.list[i][1]) do
                    if unit.colli then
                        if match_base(unit.class, laser) and unit.alpha > 0.999 then
                            l1 = unit.l1 or 0
                            l2 = unit.l2 or 0
                            l3 = unit.l3 or 0
                            l = l1 + l2 + l3
                            w = unit.w or 0
                            x, y = unit.x, unit.y
                            dx, dy = cos(unit.rot), sin(unit.rot)
                            tx, ty = x + l * dx, y + l * dy
                            wx, wy = w * cos(unit.rot + 90), w * sin(unit.rot + 90)
                            x1, y1 = x + l1 * dx + wx, y + l1 * dy + wy
                            x2, y2 = x + l1 * dx - wx, y + l1 * dy - wy
                            x3, y3 = x + (l1 + l2) * dx + wx, y + (l1 + l2) * dy + wy
                            x4, y4 = x + (l1 + l2) * dx - wx, y + (l1 + l2) * dy - wy
                            Render4V("collision_rect1",
                                    x, y, 0.5, x1, y1, 0.5,
                                    x2, y2, 0.5, x, y, 0.5)
                            Render4V("collision_rect2",
                                    x1, y1, 0.5, x3, y3, 0.5,
                                    x4, y4, 0.5, x2, y2, 0.5)
                            Render4V("collision_rect3",
                                    x3, y3, 0.5, tx, ty, 0.5,
                                    tx, ty, 0.5, x4, y4, 0.5)
                        else
                            if unit.rect then
                                img = "collision_rect"
                            else
                                img = "collision_ring"
                            end
                            Render(img, unit.x, unit.y, unit.rot,
                                    unit.a / 64, unit.b / 64)
                        end
                    end
                end
            end
        end
        if cheat then
            ui:RenderText('title', "Cheat", lstg.world.r - 8, lstg.world.b + 32,
                    1, Color(255, 255, 255, 255), "right", "bottom")
        end
        if show_pos then
            SetViewMode("ui")
            ext.mouse:frame()
            local mx, my = ext.mouse:get()
            ui:RenderText("title", ("%0.1f, %0.1f"):format(mx, my), mx + 1, my + 1,
                    0.6, Color(255, 255, 255, 255), "bottom", "left")
            SetImageState("white", "", 255, 255, 255, 255)
            RenderRect("white", mx - 0.5, mx + 0.5, 0, screen.height)
            RenderRect("white", 0, screen.width, my - 0.5, my + 0.5)
        end
    end

    Collision_Checker.init()
end

----------------------------------------
---辅助工具

camera_setter = Class(object)

function camera_setter:init()
    player.lock = true
    player.realrealreal_lock = true
    self.group = GROUP.GHOST
    self.layer = 233
    self.text = { 'eye', 'at', 'up', 'fovy', 'z', 'fog', 'color' }
    self.nitem = { 3, 3, 3, 1, 2, 2, 3 }
    self.pos = 1
    self.posx = 1
    self.pos_changed = 0
    self.edit = false
end

function camera_setter:frame()
    local key = GetLastKey()
    if key == setting.keys.shoot then
        self.edit = true
        PlaySound('select00', 0.3)
        if not self.edit then
            self.posx = 1
        end
    end
    if key == setting.keys.spell then
        self.edit = false
        PlaySound('cancel00', 0.3)
    end
    if self.pos_changed > 0 then
        self.pos_changed = self.pos_changed - 1
    end
    if self.edit then
        local step = 0.1
        if KeyIsDown 'slow' then
            step = 0.01
        end
        if key == setting.keys.left then
            self.posx = self.posx - 1
            PlaySound('select00', 0.3)
        end
        if key == setting.keys.right then
            self.posx = self.posx + 1
            PlaySound('select00', 0.3)
        end
        self.posx = (self.posx - 1 + self.nitem[self.pos]) % self.nitem[self.pos] + 1
        if self.pos <= 3 or self.pos == 5 then
            local item = lstg.view3d[self.text[self.pos]]
            if key == setting.keys.up then
                item[self.posx] = item[self.posx] + step
                PlaySound('select00', 0.3)
            end
            if key == setting.keys.down then
                item[self.posx] = item[self.posx] - step
                PlaySound('select00', 0.3)
            end
        elseif self.pos == 6 then
            if key == setting.keys.up then
                lstg.view3d.fog[self.posx] = lstg.view3d.fog[self.posx] + step
                PlaySound('select00', 0.3)
                if lstg.view3d.fog[1] < -0.0001 then
                    if lstg.view3d.fog[1] > -0.9999 then
                        lstg.view3d.fog[1] = 0
                    elseif lstg.view3d.fog[1] > -1.9999 then
                        lstg.view3d.fog[1] = -1
                    end
                end
            end
            if key == setting.keys.down then
                lstg.view3d.fog[self.posx] = lstg.view3d.fog[self.posx] - step
                if lstg.view3d.fog[1] < -1.0001 then
                    lstg.view3d.fog[1] = -2
                elseif lstg.view3d.fog[1] < -0.0001 then
                    lstg.view3d.fog[1] = -1
                end
                PlaySound('select00', 0.3)
            end
            if abs(lstg.view3d.fog[1]) < 0.0001 then
                lstg.view3d.fog[1] = 0
            end
            if abs(lstg.view3d.fog[2]) < 0.0001 then
                lstg.view3d.fog[2] = 0
            end
        elseif self.pos == 7 then
            local c = {}
            local alpha
            step = 10
            if KeyIsDown('slow') then
                step = 1
            end
            alpha, c[1], c[2], c[3] = lstg.view3d.fog[3]:ARGB()
            if key == setting.keys.up then
                c[self.posx] = c[self.posx] + step
                PlaySound('select00', 0.3)
            end
            if key == setting.keys.down then
                c[self.posx] = c[self.posx] - step
                PlaySound('select00', 0.3)
            end
            c[self.posx] = max(0, min(c[self.posx], 255))
            lstg.view3d.fog[3] = Color(alpha, unpack(c))
        elseif self.pos == 4 then
            if key == setting.keys.up then
                lstg.view3d.fovy = lstg.view3d.fovy + step
                PlaySound('select00', 0.3)
            end
            if key == setting.keys.down then
                lstg.view3d.fovy = lstg.view3d.fovy - step
                PlaySound('select00', 0.3)
            end
        end
    else
        if key == setting.keys.up then
            self.pos = self.pos - 1
            self.pos_changed = ui.menu.shake_time
            PlaySound('select00', 0.3)
        end
        if key == setting.keys.down then
            self.pos = self.pos + 1
            self.pos_changed = ui.menu.shake_time
            PlaySound('select00', 0.3)
        end
        self.pos = (self.pos + 6) % 7 + 1
    end
    if KeyIsPressed 'special' then
        Print("--set camera")
        Print(string.format("Set3D('eye',%.2f,%.2f,%.2f)", unpack(lstg.view3d.eye)))
        Print(string.format("Set3D('at',%.2f,%.2f,%.2f)", unpack(lstg.view3d.at)))
        Print(string.format("Set3D('up',%.2f,%.2f,%.2f)", unpack(lstg.view3d.up)))
        Print(string.format("Set3D('fovy',%.2f)", lstg.view3d.fovy))
        Print(string.format("Set3D('z',%.2f,%.2f)", unpack(lstg.view3d.z)))
        Print(string.format("Set3D('fog',%.2f,%.2f,Color(%d,%d,%d,%d))", lstg.view3d.fog[1], lstg.view3d.fog[2], lstg.view3d.fog[3]:ARGB()))
        Print("--")
    end
end

local function _str(num)
    return string.format('%.2f', num)
end

function camera_setter:render()
    local y = 340
    SetViewMode 'ui'
    SetImageState('white', '', 64, 20, 20, 20)
    RenderRect('white', 424, 632, 256, 464)
    RenderTTF('sc_menu', 'camera setting', 528, y + 4.5 * ui.menu.sc_pr_line_height,
            Color(255, unpack(ui.menu.title_color)), 'centerpoint')
    ui:DrawMenuTTF('sc_menu', '', self.text, self.pos, 432, y, 1, self.timer, 'left')
    local _, _r, _g, _b = lstg.view3d.fog[3]:ARGB()
    local v = lstg.view3d
    ui:DrawMenuTTF('sc_menu', '', {
        _str(v.eye[1]),
        _str(v.at[1]),
        _str(v.up[1]),
        _str(v.fovy),
        _str(v.z[1]),
        _str(v.fog[1]),
        tostring(_r)
    }, self.pos, 496, y, 1, self.timer, 'right')
    ui:DrawMenuTTF('sc_menu', '', {
        _str(v.eye[2]),
        _str(v.at[2]),
        _str(v.up[2]),
        '',
        _str(v.z[2]),
        _str(v.fog[2]),
        tostring(_g)
    }, self.pos, 560, y, 1, self.timer, 'right')
    ui:DrawMenuTTF('sc_menu', '', {
        _str(v.eye[3]),
        _str(v.at[3]),
        _str(v.up[3]),
        '',
        '',
        '',
        tostring(_b)
    }, self.pos, 624, y, 1, self.timer, 'right')
    if self.edit and self.timer % 30 < 15 then
        RenderTTF('sc_menu', '_', 432 + self.posx * 64, y + (4 - self.pos) * ui.menu.sc_pr_line_height,
                Color(255, unpack(ui.menu.title_color)), 'right', 'vcenter', 'noclip')
    end
    SetViewMode 'world'
end