local M = {}
Game = M
function M:initGame()
    self.PointList = {}
    self.camera_z0 = -250
    self.camera_zp = -600
    self._camera_zp = self.camera_zp
    self.max_zp = -400
    self.min_zp = -800
    self.cameraRotateSpeed = 1
end
M:initGame()
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
        self.is_decorative = false--是否是装饰性
    end,
    frame = function(self)
        local sm = sp.math
        self.x, self.y = sm.PerspectiveProjection(self._x, self._y, self._z, 0, 0, M.camera_z0, M.camera_zp)
        local k = 6
        self.size = k * (M.camera_zp - M.camera_z0) / (self._z - M.camera_z0)
    end,
    render = function(self)

        local size = self.size

        SetImageState("bright", "mul+add", self.alpha * 80, self.R, self.G, self.B)
        Render("bright", self.x, self.y, 0, size * 5 / 150)
        SetImageState("white", "mul+add", self.alpha * 80, self.R, self.G, self.B)
        misc.SectorRender(self.x, self.y, 0, size, 0, 360, 30, 0)
        SetImageState("white", "mul+add", self.alpha * 120, self.R, self.G, self.B)
        misc.SectorRender(self.x, self.y, 0, size / 3, 0, 360, 30, 0)
    end
}, true)

local function createPoint(x, y, z)
    local p = New(Point, x, y, z)
    sp:UnitListUpdate(M.PointList)
    sp:UnitListAppend(M.PointList, p)
    return p
end
M.createPoint = createPoint

local function LinkPoints(p1, p2)
    p1.link[p2] = true
    p2.link[p1] = true

end
M.LinkPoints = LinkPoints

local function LinkPointsInLine(close, points)
    for i = 1, #points - 1 do
        LinkPoints(points[i], points[i + 1])
    end
    if close then
        LinkPoints(points[#points], points[1])
    end
end
M.LinkPointsInLine = LinkPointsInLine

---@param mx number@mouse x
---@param my number@mouse y
function M:updatePointPosition(point, mx, my)
    local rotateSpeed = self.cameraRotateSpeed
    local theta = -mx * rotateSpeed
    local phi = -my * rotateSpeed
    local x, y, z = point._x, point._y, point._z
    x, z = x * cos(theta) - z * sin(theta), z * cos(theta) + x * sin(theta)
    y, z = y * cos(phi) - z * sin(phi), z * cos(phi) + y * sin(phi)
    point._x, point._y, point._z = x, y, z
end

function M:frameEvent()
    menu:Updatekey()
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

function M:renderEvent()
    ---注意渲染线的时候其实是2个点之间有2条线的
    ---所以渲染的透明度要高点

    local img = "white"
    for _, p in ipairs(self.PointList) do
        local rot, len, x1, y1, x2, y2
        for link in pairs(p.link) do
            x1, y1, x2, y2 = p.x, p.y, link.x, link.y
            x2, y2 = x2 - x1, y2 - y1
            rot = Angle(p, link)
            len = Dist(p, link)
            local width = p.size / 6
            SetImageState(img, "mul+add", p.alpha * 25, p.R, p.G, p.B)
            Render(img, x1 + x2 / 2, y1 + y2 / 2, rot, len / 16, width / 8)
        end
    end
end


