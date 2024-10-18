local M = {}
Game = M
function M:initGame()
    self.PointList = {}
    self.Point2DList = {}
    self.camera_z0 = -250
    self.camera_zp = -600
    self._camera_zp = self.camera_zp
    self.max_zp = -400
    self.min_zp = -800
    self.cameraRotateSpeed = 1
    self.is_connecting = false
    self.connecting_index = 0
    self.connected = {}
    self.tap_multi = 1.2--点按时触发范围倍率
    self.lR, self.lG, self.lB = 250, 128, 114
    self.success_flag = false
end
M:initGame()

local PointNormalRender = function(self)
    local c = self.cindex
    local size = self.size * (self.index + c * 0.3)
    local r = self.R * (1 - c) + M.lR * c
    local g = self.G * (1 - c) + M.lG * c
    local b = self.B * (1 - c) + M.lB * c

    SetImageState("bright", "mul+add", self.alpha * 80, r, g, b)
    Render("bright", self.x, self.y, 0, size * 5 / 150)
    SetImageState("white", "mul+add", self.alpha * 80, r, g, b)
    misc.SectorRender(self.x, self.y, 0, size * (1 + sin(self.timer * 2) * 0.1), 0, 360, 30, 0)
    SetImageState("white", "mul+add", self.alpha * 120, r, g, b)
    misc.SectorRender(self.x, self.y, 0, size / 3, 0, 360, 30, 0)
    local img = "white"
    local rot, len, x1, y1, x2, y2
    for lp in pairs(self.link) do
        if IsValid(lp) then
            x1, y1, x2, y2 = self.x, self.y, lp.x, lp.y
            x2, y2 = x2 - x1, y2 - y1
            rot = Angle(self, lp)
            len = Dist(self, lp)
            local width = size / 6
            SetImageState(img, "mul+add", self.alpha * 25, self.R, self.G, self.B)
            Render(img, x1 + x2 / 2, y1 + y2 / 2, rot, len / 16, width / 8)
        end
    end
end
M.PointNormalRender = PointNormalRender

local Point = Class(object, {
    init = function(self, x, y, z)
        self._x = x or 0
        self._y = y or 0
        self._z = z or 0
        self.R, self.G, self.B = 255, 255, 255
        self.alpha = 1
        self.bound = false
        self.group = GROUP.GHOST
        self.layer = LAYER.ENEMY_BULLET
        self.link = {}
        setmetatable(self.link, { __mode = "v" })
        self.is_decorative = false--是否是装饰性
        self.size_k = 6
        self.index = 0
        self._index = 1
        self.cindex = 0
        self.last_point = {}
        self.linking_index = 0
    end,
    frame = function(self)
        local sm = sp.math
        self.index = self.index + (-self.index + self._index) * 0.1
        if self.is_decorative then
            self._z = self._z + sin(self.timer + 222) * 0.08
            self._y = self._y + sin(self.timer * 0.7 + 90) * 0.05
            self._x = self._x + sin(self.timer * 0.6) * 0.01
        end
        self.x, self.y = sm.PerspectiveProjection(self._x, self._y, self._z, 0, 0, M.camera_z0, M.camera_zp)
        local k = self.size_k
        self.size = k * (M.camera_zp - M.camera_z0) / (self._z - M.camera_z0)
    end,
    render = PointNormalRender
}, true)

local PointToConnect = Class(object, {
    init = function(self, x, y, master, R, G, B)
        self.x, self.y = x, y
        self.R, self.G, self.B = R, G, B
        self.alpha = 1
        self.bound = false
        self.master = master
        self.group = GROUP.INDES
        self.layer = LAYER.TOP
        self.size = 10
        self.index = 0
        self._index = 0
        self.link = {}
        self.connect = {}
        setmetatable(self.link, { __mode = "v" })
        setmetatable(self.connect, { __mode = "v" })
        self.connected = false
        self.cindex = 0
        self.last_point = {}
        self.linking_index = 0
        self.timer = ran:Int(1, 1000)
    end,
    frame = function(self)
        local cindex = self.connected and 1 or 0
        self.cindex = self.cindex + (-self.cindex + cindex) * 0.1
        self.index = self.index + (-self.index + self._index) * 0.1
        if self.delete and self.index < 0.01 then
            for _, lp in ipairs(self.link) do
                lp.link[self] = nil
            end
            Del(self)
        end
    end,
    del = function()
    end,
    render = PointNormalRender
}, true)

do
    local wave = Class(object, {
        init = function(unit, x, y, w, sr, time, r, g, b, ir)
            unit.x, unit.y = x, y
            unit.layer = 1
            unit.group = GROUP.GHOST
            unit.w = w
            unit.sr = sr
            unit.time = time
            unit.ir = ir or 0
            unit.nr = unit.ir
            unit.smear = {}
            unit.alpha = 255
            unit.colli = false
            unit._r, unit._g, unit._b = r or 255, g or 255, b or 255
        end,
        frame = function(unit)

            unit.lr = unit.nr
            unit.alpha = max(0, 255 * (1 - unit.timer / unit.time))
            unit.nr = unit.ir + task.SetMode[2](unit.timer / unit.time) * (unit.sr - unit.ir)
            if unit.timer > unit.time then
                if #unit.smear == 0 then
                    Del(unit)
                end
            else
                table.insert(unit.smear, { alpha = unit.alpha / 2, r = unit.nr, w = (unit.nr - unit.lr) })
            end
            local s
            for i = #unit.smear, 1, -1 do
                s = unit.smear[i]
                s.alpha = max(s.alpha - 15, 0)
                if s.alpha == 0 then
                    table.remove(unit.smear, i)
                end
            end
        end,
        render = function(unit)
            SetImageState("white", "mul+add", unit.alpha, unit._r, unit._g, unit._b)
            misc.SectorRender(unit.x, unit.y, unit.nr - unit.w / 2, unit.nr + unit.w / 2,
                    0, 360, int(Forbid(unit.nr / 4, 20, 80)))
            for _, s in ipairs(unit.smear) do
                SetImageState("white", "mul+add", s.alpha, unit._r, unit._g, unit._b)
                misc.SectorRender(unit.x, unit.y, s.r - s.w, s.r, 0, 360,
                        int(Forbid(s.r / 4, 20, 80)))
            end
        end
    })
    local wave2 = Class(object, {
        init = function(unit, x, y, w, ir, sr, time, r, g, b, dealpha, interval)
            unit.x, unit.y = x, y
            unit.layer = 1
            unit.group = GROUP.GHOST
            unit.w = w
            unit.sr = sr
            unit.time = time
            unit.ir = ir or 0
            unit.nr = unit.ir
            unit.smear = {}
            unit.alpha = 255
            unit.colli = false
            unit._r, unit._g, unit._b = r or 255, g or 255, b or 255
            unit.dealpha = dealpha or 2
            unit.interval = interval or 1
        end,
        frame = function(unit)

            unit.lr = unit.nr
            unit.alpha = max(0, 255 * (1 - unit.timer / unit.time))
            unit.nr = unit.ir + task.SetMode[2](unit.timer / unit.time) * (unit.sr - unit.ir)
            if unit.timer > unit.time then
                if #unit.smear == 0 then
                    Del(unit)
                end
            else
                if unit.timer % unit.interval == 0 then
                    table.insert(unit.smear, { alpha = unit.alpha / 2, r = unit.nr, w = unit.w })
                end
            end
            local s
            for i = #unit.smear, 1, -1 do
                s = unit.smear[i]
                s.alpha = max(s.alpha - unit.dealpha, 0)
                if s.alpha == 0 then
                    table.remove(unit.smear, i)
                end
            end
        end,
        render = function(unit)
            SetImageState("white", "mul+add", unit.alpha, unit._r, unit._g, unit._b)
            misc.SectorRender(unit.x, unit.y, unit.nr - unit.w / 2, unit.nr + unit.w / 2,
                    0, 360, int(Forbid(unit.nr / 4, 20, 80)))
            for _, s in ipairs(unit.smear) do
                SetImageState("white", "mul+add", s.alpha, unit._r, unit._g, unit._b)
                misc.SectorRender(unit.x, unit.y, s.r - s.w, s.r, 0, 360,
                        int(Forbid(s.r / 4, 20, 80)))
            end
        end
    })
    local bon = Class(object, {
        init = function(self, x, y, time, radius, r, g, b, count)
            self.x, self.y = x, y
            self.layer = LAYER.ENEMY + 1
            self.group = GROUP.GHOST
            self.colli = false
            self.lifetime = time
            self.r = radius
            self.alpha = 1
            self._r, self._g, self._b = r, g, b
            self.particle = {}
            count = count or 30
            for _ = 1, count * (0.5 + setting.rdQual * 0.1) do
                local a = ran:Float(0, 360)
                local v = ran:Float(3, 6)
                table.insert(self.particle, {
                    x = self.x, y = self.y,
                    vx = cos(a) * v, vy = sin(a) * v,
                    alpha = ran:Float(150, 250), timer = 0,
                })
            end
            task.New(self, function()
                task.SmoothSetValueTo("alpha", 0, time, 0)
            end)
        end,
        frame = function(self)
            task.Do(self)
            local p
            local maxtime = max(10, self.lifetime - 20)
            for i = #self.particle, 1, -1 do
                p = self.particle[i]
                p.x = p.x + p.vx
                p.y = p.y + p.vy
                p.vx = p.vx - p.vx * 0.04
                p.vy = p.vy - p.vy * 0.04
                if p.timer > maxtime then
                    p.alpha = max(p.alpha - 5, 0)
                    if p.alpha == 0 then
                        table.remove(self.particle, i)
                    end
                end
                p.timer = p.timer + 1
            end
            if self.timer >= self.lifetime and #self.particle == 0 then
                object.Del(self)
            end
        end,
        render = function(self)
            for _, p in ipairs(self.particle) do
                SetImageState("bright", "mul+add", p.alpha, self._r, self._g, self._b)
                Render("bright", p.x, p.y, 0, 8 / 150)
            end
            if self.alpha > 0 then
                SetImageState("bright", "mul+add", self.alpha * 255, self._r, self._g, self._b)
                Render("bright", self.x, self.y, 0, self.r / 75)
            end
        end
    })

    function M:NewBon(x, y, time, radius, r, g, b, count)
        return New(bon, x, y, time, radius, r, g, b, count)
    end
    function M:NewWave(x, y, width, maxr, time, r, g, b, ir)
        return New(wave, x, y, width, maxr, time, r, g, b, ir)
    end
    function M:NewWave2(x, y, w, ir, sr, time, r, g, b, dealpha, interval)
        return New(wave2, x, y, w, ir, sr, time, r, g, b, dealpha, interval)
    end
end

function M:createPoint(x, y, z)
    local p = New(Point, x, y, z)
    sp:UnitListUpdate(self.PointList)
    sp:UnitListAppend(self.PointList, p)
    return p
end

function M:createDecorativePoints(num, r, g, b)
    local p
    for _ = 1, num or 155 do
        local R = 640
        local x, y, z = ran:Float(-R, R), ran:Float(-R, R), ran:Float(1000, M.camera_zp + 100)
        p = self:createPoint(x, y, z)
        p.size_k = 3
        p.alpha = 0.5
        p.R, p.G, p.B = r or 135, g or 206, b or 235
        p.is_decorative = true
        p.timer = ran:Int(1, 12222)

    end
    if num == 1 then
        return p
    end

end

function M:LinkPoints(p1, p2)
    p1.link[p2] = true
    p2.link[p1] = true

end

function M:UnlinkPoints(p1, p2)
    p1.link[p2] = nil
    p2.link[p1] = nil
end

function M:LinkPointsInLine(close, points)
    for i = 1, #points - 1 do
        self:LinkPoints(points[i], points[i + 1])
    end
    if close then
        self:LinkPoints(points[#points], points[1])
    end
end

function M:rotatePoint(point, a1, a2, a3)
    local x, y, z = point._x, point._y, point._z
    x, y = x * cos(a1) - y * sin(a1), y * cos(a1) + x * sin(a1)
    x, z = x * cos(a2) - z * sin(a2), z * cos(a2) + x * sin(a2)
    y, z = y * cos(a3) - z * sin(a3), z * cos(a3) + y * sin(a3)
    point._x, point._y, point._z = x, y, z
end

function M:updatePointPosition(point, mx, my)
    local rotateSpeed = self.cameraRotateSpeed
    local theta = -mx * rotateSpeed
    local phi = -my * rotateSpeed
    self:rotatePoint(point, 0, theta, phi)
end

---@param offset number 误差范围
function M:pointInSegment(mp, p1, p2, offset)
    local x1, y1 = p1.x, p1.y
    local x2, y2 = p2.x, p2.y
    local x0, y0 = mp.x, mp.y
    -- 计算线段的长度平方
    local dx, dy = x2 - x1, y2 - y1
    local lengthSquared = dx * dx + dy * dy
    --[[
    -- 特殊情况：线段长度为0
    if lengthSquared == 0 then
        -- 直接计算点到起点的距离
        return Dist(mp, p1) <= offset
    end--]]
    -- 计算点到线段的投影
    local t = ((x0 - x1) * dx + (y0 - y1) * dy) / lengthSquared
    -- 限制t在区间[0, 1]
    t = Forbid(t, 0, 1)
    -- 计算最近点的坐标
    local closestX = x1 + t * dx
    local closestY = y1 + t * dy
    -- 计算点到该投影点的距离
    local distance = hypot(x0 - closestX, y0 - closestY)--Dist(mp, { x = closestX, y = closestY })
    -- 检查距离是否在误差范围内
    return distance <= offset
end

function M:To2Dpoints()
    local offset = 10 * (self.camera_zp / (-600))
    for _, p in ipairs(self.PointList) do
        if not p.is_decorative then
            local x, y = p.x, p.y
            local point2D = New(PointToConnect, x, y, p, p.R, p.G, p.B)
            sp:UnitListUpdate(self.Point2DList)
            sp:UnitListAppend(self.Point2DList, point2D)
        end
    end
    for _, p1 in ipairs(self.Point2DList) do
        for _, p2 in ipairs(self.Point2DList) do
            if p1 ~= p2 then
                for lp in pairs(p1.master.link) do
                    if lp == p2.master then
                        self:LinkPoints(p1, p2)
                    end
                end--先连接点
                if Dist(p1, p2) < offset * 2 and not (p1.ToDelete or p2.ToDelete) then
                    for lp in pairs(p1.link) do
                        p2.link[lp] = true--合并连接
                    end
                    p1.ToDelete = true--标记删除
                    p2.R, p2.G, p2.B = (p1.R + p2.R) / 2, (p1.G + p2.G) / 2, (p1.B + p2.B) / 2--颜色平均
                end--距离过短的点要合并
            end
        end
    end--普通的点连接，由3d的坐标转为2d的坐标
    for i = #self.Point2DList, 1, -1 do
        local p = self.Point2DList[i]
        if p.ToDelete then
            Del(p)
            table.remove(self.Point2DList, i)
            for _, lp in ipairs(self.Point2DList) do
                lp.link[p] = nil
            end
        end
    end--删除标记的点
    for _, main_p in ipairs(self.Point2DList) do
        for _, p in ipairs(self.Point2DList) do
            if p ~= main_p then
                for lp in pairs(p.link) do
                    if lp ~= main_p then
                        if self:pointInSegment(main_p, p, lp, offset) then
                            self:LinkPoints(p, main_p)
                            self:LinkPoints(lp, main_p)
                            self:UnlinkPoints(p, lp)
                        end
                    end
                end
            end
        end
    end--高级的点连接，检测点是否在别的点的连线上，若是则也连接左右端点，并断开左右端点的连接
    self.connected = {}

end

function M:Del2Dpoints()
    for _, p in ipairs(self.Point2DList) do
        p._index = 0
        p.delete = true
        p.connected = false
        p.last_point = { }
    end
    for _, p in ipairs(self.connected) do
        p.alive = false
    end
    self.Point2DList = {}
end

function M:ConnectPoints(p1, p2)
    p1.connect[p2] = true
    p2.connect[p1] = true
end

function M:DisconnectPoints(p1, p2)
    p1.connect[p2] = nil
    p2.connect[p1] = nil
end

function M:WhenConnecting()
    for _, p in ipairs(self.PointList) do
        if not p.is_decorative then
            p._index = 0
        end
    end
    for _, p in ipairs(self.Point2DList) do
        p._index = 1
    end
    local mouse = ext.mouse
    local mx, my = UIToWorld(mouse.x, mouse.y)
    local ptable = self.Point2DList
    if #self.connected > 0 then
        ptable = {  }
        local nowp = self.connected[#self.connected].point
        for lp in pairs(nowp.link) do
            local flag = true
            for p in pairs(nowp.connect) do
                if p == lp then
                    flag = false
                    break
                end
            end
            if flag then
                table.insert(ptable, lp)
            end
        end
    end
    for _, p in ipairs(ptable) do
        if Dist(mx, my, p.x, p.y) <= p.size * self.tap_multi then
            p._index = 2
            if mouse:isPress(1) then
                p.connected = true

                if #self.connected > 0 then
                    local lastp = self.connected[#self.connected].point
                    self:ConnectPoints(lastp, p)
                end
                table.insert(self.connected, {
                    point = p, alpha = 0,
                    alive = true
                })
                self:NewBon(p.x, p.y, 20, 20, 250, 128, 114)
                self:NewWave(p.x, p.y, 2, p.size * 6, 30, 250, 128, 114, p.size * p.index)
            end
        end
    end
    if not self.success_flag then
        if KeyIsDown("spell") and #self.connected > 1 then
            local lastc = self.connected[#self.connected - 1]
            local nowc = self.connected[#self.connected]
            local lastp = lastc.point
            local nowp = nowc.point
            self:DisconnectPoints(lastp, nowp)
            nowp.connected = false
            table.remove(self.connected)
            self:NewBon(nowp.x, nowp.y, 20, 20, nowp.R, nowp.G, nowp.B)
        end--撤回
    end
end

function M:WhenWatching()

    for _, p in ipairs(self.PointList) do
        p._index = 1
    end
    local mouse = ext.mouse
    if mouse:isPress(1) then
        local dx, dy = mouse.dx, mouse.dy
        for _, p in ipairs(self.PointList) do
            self:updatePointPosition(p, dx, dy)
        end
    end
    if mouse._wheel ~= 0 then
        self._camera_zp = Forbid(self._camera_zp - sign(mouse._wheel) * 25, self.min_zp, self.max_zp)

    end
    self.camera_zp = self.camera_zp + (-self.camera_zp + self._camera_zp) * 0.1
end

function M:checkSuccess()
    if not self.success_flag then
        local success = true
        if #self.Point2DList > 0 then
            for _, p in ipairs(self.Point2DList) do
                for lp in pairs(p.link) do
                    success = success and p.connect[lp]
                end
            end
        else
            success = false
        end
        if success then
            for _, p in ipairs(self.Point2DList) do
                M:NewWave(p.x, p.y, 2, 500, 60, 189, 252, 201, 0)
            end
            self.success_flag = true
        end
    end
end

function M:connectedFrame()
    for i = #self.connected, 1, -1 do
        local p = self.connected[i]
        local _alpha = p.alive and 1 or 0
        p.alpha = p.alpha + (-p.alpha + _alpha) * 0.1
        if p.alpha < 0.01 then
            table.remove(self.connected, i)
        end
    end
end

function M:frameEvent()
    menu:Updatekey()
    local keyname = "shoot"
    if not self.success_flag then
        if KeyIsDown(keyname) then
            self:To2Dpoints()
        end
        if KeyIsUp(keyname) then
            self:Del2Dpoints()
        end
    end
    self.is_connecting = self.success_flag or KeyIsPressed(keyname)
    local index = 0
    if self.is_connecting then
        self:WhenConnecting()
        index = 1
    else
        self:WhenWatching()
        index = 0
    end
    self.connecting_index = self.connecting_index + (-self.connecting_index + index) * 0.1
    self:connectedFrame()
    self:checkSuccess()
    if self.success_flag then
        local tR, tG, tB = 189, 252, 201
        self.lR = self.lR + (-self.lR + tR) * 0.1
        self.lG = self.lG + (-self.lG + tG) * 0.1
        self.lB = self.lB + (-self.lB + tB) * 0.1
    end
end

function M:renderEvent()
    local img = "white"
    local rot, len, x1, y1, x2, y2
    for i = 1, #self.connected - 1 do
        local p1, p2 = self.connected[i].point, self.connected[i + 1].point
        if IsValid(p1) and IsValid(p2) then
            x1, y1, x2, y2 = p1.x, p1.y, p2.x, p2.y
            x2, y2 = x2 - x1, y2 - y1
            rot = Angle(p1, p2)
            len = Dist(p1, p2)
            local width = (p1.size + p2.size) / 2 / 6
            local r, g, b = self.lR, self.lG, self.lB
            local alpha = (p1.alpha + p2.alpha) / 2 * self.connected[i + 1].alpha
            SetImageState(img, "mul+add", alpha * 100, r, g, b)
            Render(img, x1 + x2 / 2, y1 + y2 / 2, rot, len / 16, width / 8)
        end
    end
    local mouse = ext.mouse
    local mx, my = UIToWorld(mouse.x, mouse.y)
    if #self.connected > 0 and not self.success_flag then
        local nowp = self.connected[#self.connected].point
        x1, y1, x2, y2 = nowp.x, nowp.y, mx, my
        x2, y2 = x2 - x1, y2 - y1
        rot = Angle(0, 0, x2, y2)
        len = Dist(0, 0, x2, y2)
        local width = 12 / 6
        local r, g, b = 200, 200, 200
        local alpha = self.connecting_index
        SetImageState(img, "mul+add", alpha * 100, r, g, b)
        Render(img, x1 + x2 / 2, y1 + y2 / 2, rot, len / 16, width / 8)
    end
end

function M:Start(id)
    Level.class[id].event()
end


