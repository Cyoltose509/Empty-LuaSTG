--======================================
--杂项
--======================================

---@class misc
misc = {}

---震屏
---@param time number
---@param size number
function misc.ShakeScreen(time, size, interval, way, fadeout_size_mode)
    local shaker = lstg.tmpvar.shaker
    if shaker then
        shaker.time = time
        shaker.size = size
        shaker.interval = interval or 3
        shaker.way = way or 2.5
        shaker.fadeout_size_mode = fadeout_size_mode
        shaker.timer = 0
    else
        New(shaker_maker, time, size, interval or 3, way or 2.5, fadeout_size_mode)
    end
end

shaker_maker = Class(object)
function shaker_maker:init(time, size, interval, way, fadeout_size_mode)
    lstg.tmpvar.shaker = self
    self.time = time
    self.size = size
    self._size = size
    self.interval = interval
    self.way = way
    self.fadeout_size_mode = fadeout_size_mode
    self.offset = lstg.worldoffset
end
function shaker_maker:frame()
    local a = int(self.timer / self.interval) * 360 / self.way
    self.offset.dx = self.size * cos(a)
    self.offset.dy = self.size * sin(a)
    if self.fadeout_size_mode then
        self.size = self._size * task.SetMode[self.fadeout_size_mode](1 - self.timer / self.time)
    end
    if self.timer >= self.time then
        object.Del(self)
    end
end
function shaker_maker:del()
    self.offset.dx = 0
    self.offset.dy = 0
    lstg.tmpvar.shaker = nil
end
shaker_maker.kill = shaker_maker.del


--tasker
tasker = Class(object)
function tasker:init(f, group)
    self.task = {}
    self.group = group or GROUP.GHOST
    task.New(self, f)
end
function tasker:frame()
    task.Do(self)
    if self.task then
        if coroutine.status(self.task[1]) == 'dead' then
            object.Del(self)
        end
    end
end

local cos, sin = cos, sin
local RenderTexture = RenderTexture
local Render = Render
local Render4V = Render4V
local RenderRect = RenderRect
local GetTextureSize = GetTextureSize

--一些形状的渲染
---图片组渲染成环状
function misc.RenderRing(img, x, y, r1, r2, rot, n, maximgs)
    local da = 360 / n
    local a
    for i = 1, n do
        a = rot - da * i
        Render4V(img .. ((i - 1) % maximgs + 1),
                r1 * cos(a + da) + x, r1 * sin(a + da) + y, 0.5,
                r2 * cos(a + da) + x, r2 * sin(a + da) + y, 0.5,
                r2 * cos(a) + x, r2 * sin(a) + y, 0.5,
                r1 * cos(a) + x, r1 * sin(a) + y, 0.5)
    end
end

---渲染圆，扇形，环形，环扇形
function misc.SectorRender(x, y, r1, r2, a1, a2, point, rot)
    rot = rot or 0
    local ang = (a2 - a1) / point
    local angle
    for i = 1, point do
        angle = a1 + ang * i + rot
        Render4V('white',
                x + r2 * cos(angle - ang), y + r2 * sin(angle - ang), 0.5,
                x + r1 * cos(angle - ang), y + r1 * sin(angle - ang), 0.5,
                x + r1 * cos(angle), y + r1 * sin(angle), 0.5,
                x + r2 * cos(angle), y + r2 * sin(angle), 0.5)
    end
end

---渲染正矩形边框
function misc.RenderOutline(x1, x2, y1, y2, l_in, l_out)

    RenderRect("white", x1 + l_in, x1 - l_out, y1 - l_out, y2 + l_out)
    RenderRect("white", x2 - l_in, x2 + l_out, y1 - l_out, y2 + l_out)
    RenderRect("white", x1 - l_out, x2 + l_out, y1 + l_in, y1 - l_out)
    RenderRect("white", x1 - l_out, x2 + l_out, y2 - l_in, y2 + l_out)
end

function misc.RenderOutline2(x, y, w, h, rot, outl)
    local ox = w / 2 + outl / 2
    local oy = h / 2 + outl / 2
    Render("white", x + ox * cos(rot), y + ox * sin(rot), rot + 90, (h) / 16, outl / 16)
    Render("white", x + oy * sin(rot), y - oy * cos(rot), rot + 180, (w + outl * 2) / 16, outl / 16)
    Render("white", x - ox * cos(rot), y - ox * sin(rot), rot + 270, (h) / 16, outl / 16)
    Render("white", x - oy * sin(rot), y + oy * cos(rot), rot, (w + outl * 2) / 16, outl / 16)
end
---传入纹理，在矩形范围内渲染拼合图像
function misc.RenderTexInRect(tex, x1, x2, y1, y2, offx, offy, rot, hscale, vscale, blend, color)
    local uw, uh = GetTextureSize(tex)
    local cx, cy = -offx, offy
    cx, cy = cx * cos(rot) - cy * sin(rot), cy * cos(rot) + cx * sin(rot)
    cx, cy = cx + uw / 2, cy + uh / 2
    uw, uh = abs(x2 - x1) / 2 / hscale, abs(y2 - y1) / 2 / vscale
    local c, s = cos(-rot), sin(-rot)
    RenderTexture(tex, blend,
            { x1, y2, 0.5, cx - uw * c - uh * s, cy - uh * c + uw * s, color },
            { x2, y2, 0.5, cx + uw * c - uh * s, cy - uh * c - uw * s, color },
            { x2, y1, 0.5, cx + uw * c + uh * s, cy + uh * c - uw * s, color },
            { x1, y1, 0.5, cx - uw * c + uh * s, cy + uh * c + uw * s, color })
end

function misc.RenderTexInCircle(tex, x, y, ux, uy, radius, rot, scale, blend, color, cut)
    local angle
    local ang = 360 / cut / 2
    local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
    uv2[1], uv2[2], uv2[4], uv2[5], uv2[6] = x, y, ux, uy, color
    uv3[1], uv3[2], uv3[4], uv3[5], uv3[6] = x, y, ux, uy, color
    uv1[6] = color
    uv4[6] = color
    local uradius = radius / scale
    for a = 1, cut do
        angle = rot + 360 / cut * a
        uv1[1], uv1[2] = x + radius * cos(angle + ang), y + radius * sin(angle + ang)
        uv1[4], uv1[5] = ux + uradius * cos(angle + ang), uy - uradius * sin(angle + ang)
        uv4[1], uv4[2] = x + radius * cos(angle - ang), y + radius * sin(angle - ang)
        uv4[4], uv4[5] = ux + uradius * cos(angle - ang), uy - uradius * sin(angle - ang)
        RenderTexture(tex, blend, uv1, uv2, uv3, uv4)
    end
end

local DefaultColor = Color(255, 255, 255, 255)
local DefaultBlend = ""
local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
---极坐标扩散渲染
---@param count number@一圈的图片数
---@param color lstg.Color@圆心颜色或整体颜色
---@param color2 lstg.Color@扩散颜色
function misc.PolarCoordinatesRender(tex, x, y, r1, r2, rot, n, count, spread, blend, color, color2)
    blend = blend or DefaultBlend
    color = color or DefaultColor
    color2 = color2 or color
    local texl = GetTextureSize(tex)
    local da = 360 / n
    local h = 0
    local _h = texl / n * count
    local height = r2 - r1
    uv1[5], uv1[6] = spread, color
    uv2[5], uv2[6] = spread, color
    uv3[5], uv3[6] = spread + height, color2
    uv4[5], uv4[6] = spread + height, color2
    for _ = 1, n do
        uv1[1], uv1[2], uv1[4] = x + r1 * cos(rot), y + r1 * sin(rot), h
        uv2[1], uv2[2], uv2[4] = x + r1 * cos(rot - da), y + r1 * sin(rot - da), h + _h
        uv3[1], uv3[2], uv3[4] = x + r2 * cos(rot - da), y + r2 * sin(rot - da), h + _h
        uv4[1], uv4[2], uv4[4] = x + r2 * cos(rot), y + r2 * sin(rot), h
        RenderTexture(tex, blend, uv1, uv2, uv3, uv4)
        rot = rot - da
        h = h + _h
    end
end

---用纹理以Render的形式渲染
function misc.RenderTexInSize(tex, x, y, rot, hscale, vscale, blend, color)
    blend = blend or DefaultBlend
    color = color or DefaultColor
    local w, h = GetTextureSize(tex)
    local cosr, sinr = cos(rot), sin(rot)
    local _w, _h = w * hscale / 2, h * vscale / 2
    uv1[1], uv1[2], uv1[4], uv1[5], uv1[6] = x - cosr * _w - sinr * _h, y + cosr * _h - sinr * _w, 0, 0, color
    uv2[1], uv2[2], uv2[4], uv2[5], uv2[6] = x + cosr * _w - sinr * _h, y + cosr * _h + sinr * _w, w, 0, color
    uv3[1], uv3[2], uv3[4], uv3[5], uv3[6] = x + cosr * _w + sinr * _h, y - cosr * _h + sinr * _w, w, h, color
    uv4[1], uv4[2], uv4[4], uv4[5], uv4[6] = x - cosr * _w + sinr * _h, y - cosr * _h - sinr * _w, 0, h, color
    RenderTexture(tex, blend, uv1, uv2, uv3, uv4)
end

---描点连线
---@param img string@建议"white"
---@param line table@由obj组成的一个数组
---@param width number@线条宽度
---@param close boolean@封闭图形
---@param tracing_alpha number@是否追踪透明度
function misc.RenderPointLine(img, line, width, close, tracing_alpha, blend, A, R, G, B)
    local n = #line
    if n < 2 then
        return
    end

    local z = 0.5
    local hw = width * 0.5

    local function get_tangent(i)
        local p_prev = line[max(1, i - 1)]
        local p_next = line[min(n, i + 1)]
        local dx = p_next.x - p_prev.x
        local dy = p_next.y - p_prev.y
        local len = sqrt(dx * dx + dy * dy)
        if len == 0 then
            return 0, 1
        end
        return dx / len, dy / len
    end

    for i = 1, n - 1 do
        local p1 = line[i]
        local p2 = line[i + 1]

        local tx1, ty1 = get_tangent(i)
        local tx2, ty2 = get_tangent(i + 1)

        local nx1, ny1 = -ty1, tx1
        local nx2, ny2 = -ty2, tx2

        local x1l = p1.x - nx1 * hw
        local y1l = p1.y - ny1 * hw
        local x1r = p1.x + nx1 * hw
        local y1r = p1.y + ny1 * hw
        local x2l = p2.x - nx2 * hw
        local y2l = p2.y - ny2 * hw
        local x2r = p2.x + nx2 * hw
        local y2r = p2.y + ny2 * hw
        if tracing_alpha and p1._a and p2._a then
            SetImageState(img, blend, A / 255 * (p1._a + p2._a) / 2, R, G, B)
        end
        Render4V(img, x1l, y1l, z, x1r, y1r, z, x2r, y2r, z, x2l, y2l, z)
    end
    if close then
        misc.RenderPointLine(img, { line[#line], line[1] }, width, false)
    end
end

---简易翻转屏幕
---@param texname string@所用的rendertarget
---@param from number@初图层，默认BG-1
---@param to number@末图层，默认TOP-1
---@return object@任意操控x,y,hscale,vscale,rot等的对象
function misc.RotateWorld(texname, from, to)
    CreateRenderTarget(texname)
    local begin = New({
        function(self)
            self.layer = from or -702
            self.tex = texname
        end,
        function()
        end,
        function()
        end,
        function(self)
            PushRenderTarget(self.tex)
            RenderClear(Color(255, 0, 0, 0))
        end,
        function()
        end,
        function()
        end,
        is_class = true,
        base = object
    })
    local final = New({
        function(self)
            self.bound = false
            self.layer = to or -1
            self.hscale = 1
            self.vscale = 1
            self.tex = texname
            self.rot = 0
            self.uv1, self.uv2, self.uv3, self.uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
            local color = Color(255, 255, 255, 255)
            local k = screen.scale
            local w = lstg.world
            self.uv1[4], self.uv1[5] = WorldToScreen(w.l, w.t)
            self.uv2[4], self.uv2[5] = WorldToScreen(w.r, w.t)
            self.uv3[4], self.uv3[5] = WorldToScreen(w.r, w.b)
            self.uv4[4], self.uv4[5] = WorldToScreen(w.l, w.b)
            self.uv1[6] = color
            self.uv2[6] = color
            self.uv3[6] = color
            self.uv4[6] = color
        end,
        function()
            object.RawDel(begin)
        end,
        function()
        end,
        function(self)
            PopRenderTarget(self.tex)
            local x, y = self.x, self.y
            local w = lstg.world
            local cosr, sinr = cos(self.rot), sin(self.rot)
            local _w, _h = self.hscale * w.r, self.vscale * w.t
            self.uv1[1], self.uv1[2] = x - cosr * _w - sinr * _h, y + cosr * _h - sinr * _w
            self.uv2[1], self.uv2[2] = x + cosr * _w - sinr * _h, y + cosr * _h + sinr * _w
            self.uv3[1], self.uv3[2] = x + cosr * _w + sinr * _h, y - cosr * _h + sinr * _w
            self.uv4[1], self.uv4[2] = x - cosr * _w + sinr * _h, y - cosr * _h - sinr * _w
            RenderTexture(self.tex, "one", self.uv1, self.uv2, self.uv3, self.uv4)
        end,
        function()
        end,
        function()
            object.RawDel(begin)
        end,
        is_class = true,
        base = object
    })
    --object.Connect(final, begin, 0, true)
    return final
end

function misc.RenderBrightOutline(x1, x2, y1, y2, ws, alpha, r, g, b, blend)
    blend = blend or "mul+add"
    local col1 = Color(0, r, g, b)
    local col2 = Color(alpha, r, g, b)
    SetImageState("white", "mul+add", 666, 0, 0, 0)--刷新存储列表
    lstg.SetImageState("white", blend, col1, col1, col2, col2)
    RenderRect("white", x1, x2, y1, y1 + ws)
    RenderRect("white", x1, x2, y2, y2 - ws)
    lstg.SetImageState("white", blend, col2, col1, col1, col2)
    RenderRect("white", x1, x1 + ws, y1, y2)
    RenderRect("white", x2, x2 - ws, y1, y2)

end

---渲染圆角矩形
function misc.RenderRoundedRect(x1, x2, y1, y2, rr, point)
    point = point or 1

    RenderRect("white", x1 + rr, x2 - rr, y1 + rr, y2 - rr)
    RenderRect("white", x1 + rr, x2 - rr, y1, y1 + rr)
    RenderRect("white", x1 + rr, x2 - rr, y2 - rr, y2)
    RenderRect("white", x1, x1 + rr, y1 + rr, y2 - rr)
    RenderRect("white", x2 - rr, x2, y1 + rr, y2 - rr)
    misc.SectorRender(x1 + rr, y2 - rr, 0, rr, 90, 180, point, 0)
    misc.SectorRender(x2 - rr, y2 - rr, 0, rr, 0, 90, point, 0)
    misc.SectorRender(x1 + rr, y1 + rr, 0, rr, 180, 270, point, 0)
    misc.SectorRender(x2 - rr, y1 + rr, 0, rr, 270, 360, point, 0)
end

---渲染圆角矩形描边
function misc.RenderRoundedRectOutline(x1, x2, y1, y2, rr, outline, point)
    point = point or 1
    RenderRect("white", x1 + rr, x2 - rr, y1, y1 + outline)
    RenderRect("white", x1 + rr, x2 - rr, y2 - outline, y2)
    RenderRect("white", x1, x1 + outline, y1 + rr, y2 - rr)
    RenderRect("white", x2 - outline, x2, y1 + rr, y2 - rr)
    misc.SectorRender(x1 + rr, y2 - rr, rr - outline, rr, 90, 180, point, 0)
    misc.SectorRender(x2 - rr, y2 - rr, rr - outline, rr, 0, 90, point, 0)
    misc.SectorRender(x1 + rr, y1 + rr, rr - outline, rr, 180, 270, point, 0)
    misc.SectorRender(x2 - rr, y1 + rr, rr - outline, rr, 270, 360, point, 0)
end

---目前只适用于point为1的情况
function misc.RenderTextureInRoundedRect(tex, blend, color, l, r, b, t, rr, offx, offy, size)
    blend = blend or DefaultBlend
    color = color or DefaultColor
    uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
    local tw, th = lstg.GetTextureSize(tex)
    offx = offx or (tw / 2)
    offy = offy or (th / 2)
    size = size or 1
    local w = (r - l) / size / 2
    local h = (t - b) / size / 2
    local _rr = rr / size

    uv1[1], uv1[2], uv1[4], uv1[5] = l + rr, t, offx - w + _rr, offy - h
    uv2[1], uv2[2], uv2[4], uv2[5] = r - rr, t, offx + w - _rr, offy - h
    uv3[1], uv3[2], uv3[4], uv3[5] = r - rr, b, offx + w - _rr, offy + h
    uv4[1], uv4[2], uv4[4], uv4[5] = l + rr, b, offx - w + _rr, offy + h
    RenderTexture(tex, blend, uv1, uv2, uv3, uv4)

    uv1[1], uv1[2], uv1[4], uv1[5] = l, t - rr, offx - w, offy - h + _rr
    uv2[1], uv2[2], uv2[4], uv2[5] = l + rr, t, offx - w + _rr, offy - h
    uv3[1], uv3[2], uv3[4], uv3[5] = l + rr, b, offx - w + _rr, offy + h
    uv4[1], uv4[2], uv4[4], uv4[5] = l, b + rr, offx - w, offy + h - _rr
    RenderTexture(tex, blend, uv1, uv2, uv3, uv4)

    uv1[1], uv1[2], uv1[4], uv1[5] = r - rr, t, offx + w - _rr, offy - h
    uv2[1], uv2[2], uv2[4], uv2[5] = r, t - rr, offx + w, offy - h + _rr
    uv3[1], uv3[2], uv3[4], uv3[5] = r, b + rr, offx + w, offy + h - _rr
    uv4[1], uv4[2], uv4[4], uv4[5] = r - rr, b, offx + w - _rr, offy + h
    RenderTexture(tex, blend, uv1, uv2, uv3, uv4)

end

----------------------------------------
local path = "assets\\misc\\"
--预制粒子特效图片
LoadTexture("particles", path .. "particles.png")
LoadImageGroup("parimg", 'particles', 0, 0, 32, 32, 4, 4)
--空图片
LoadImageFromFile("img_void", path .. "img_void.png")
LoadImageFromFile("white", path .. "white.png")
LoadImageFromFile("white_bright", path .. "white_bright.png")
