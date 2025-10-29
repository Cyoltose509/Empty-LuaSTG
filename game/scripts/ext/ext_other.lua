--local ext = ext
local PostEffect = PostEffect
local PopRenderTarget = PopRenderTarget
local PushRenderTarget = PushRenderTarget
local SetImageState = SetImageState
local Render = Render
local Color = Color
local RenderClear = RenderClear
local SetFontState = SetFontState
local RenderText = RenderText
local lstg = lstg
local Forbid = clamp
local RenderRect = RenderRect

--游玩时长相关

function ext.InputDuration()
    --frame,second,minute,hour,day
    local time = scoredata["Duration"]
    time[1] = time[1] + 1
    for i = 1, 3 do
        if time[i] >= 60 then
            time[i] = time[i] - 60
            time[i + 1] = time[i + 1] + 1
        end
    end
    if time[4] >= 24 then
        time[4] = time[4] - 24
        time[5] = time[5] + 1
    end
end
do
    ---开发者模式
    function ext.Debugging()
        --DEBUGGER
        if DEBUG then
            local key, KEY = GetLastKey(), KEY
            if key == KEY.ADD then
                --for _ = 1, _G["FAST_DOFRAME_TIME"] do
                ext.FrameCounter = ext.FrameCounter + 120
                --end
            end--快进
            if key == KEY.G then
                ResetLanguageCache()

                InitAllClass()
                stage.Restart()

            end--快速加载
        end
    end

end



function ext.StageIsMenu()
    local stage = stage
    if stage.current_stage then
        if stage.current_stage.is_menu then
            return true
        end
    else
        return true
    end
    return false
end


CreateRenderTarget("mask_fader")
---@class mask_fader
mask_fader = {
    name = "mask_fader",
    time = 0,
    maxtime = 30,
    color = Color(255, 255, 255, 255),
    blend = "",
    tox = function(t, x)
        return t * x
    end,
    toy = function(t, y)
        return t * (540 - y)
    end,
}
function mask_fader:BeforeRender()
    if self.time > 0 then
        --PushRenderTarget(self.name)
        --RenderClear(Color(255, 0, 0, 0))
    end
end
function mask_fader:frame()
    self.time = self.time - 1
end
function mask_fader:AfterRender()
    if self.time > 0 then
        --PopRenderTarget(self.name)
        SetViewMode("ui")
        local index1
        local s = min(1, self.time / (self.maxtime - 5))
        if self.mode == "open" then
            s = task.SetMode[2](s)
            index1 = s
        elseif self.mode == "last" then
            index1 = 1
        else
            s = task.SetMode[1](s)
            index1 = 1 - s
        end
        SetImageState("white", "", 255 * index1, 0, 0, 0)
        RenderRect("white", 0, 960, 0, 540)--]]
    end
end
function mask_fader:Do(mode, time)
    self.time = time or 15
    self.time = self.time + 2
    self.maxtime = time or 15
    self.mode = mode

end

ext.OldScreenEff = OldScreenEff

---@class ext.OtherScreenEff
local OtherScreenEFF = {
    col00000000 = Color(0, 0, 0, 0),
    colFFFFFFF = Color(255, 255, 255, 255),
    flag = false, ---开启
    Event = {},
    rtcount = {},
    delayEvent = {
    }
}

---自定义全屏效果
---@param level number@优先级，数字越大优先级越高
---@param RenderOrigin boolean@是否渲染原有画面
---@param texname string@纹理名称
---@param noCapture boolean@不捕捉画面覆盖纹理
function OtherScreenEFF:Open(level, func, RenderOrigin, texname, noCapture)
    self.flag = true
    local name = texname or ("OtherScreenEff:level%d"):format(level)
    for _, e in ipairs(self.Event) do
        if e.level == level then
            e.func = func
            e.RenderOrigin = RenderOrigin
            e.Capture = not noCapture
            e.name = name
            return name
        end
    end--如果有同样的level，则更新func
    table.insert(self.Event, {
        func = func,
        level = level,
        RenderOrigin = RenderOrigin,
        Capture = not noCapture,
        name = name,
    })
    table.sort(self.Event, function(a, b)
        return a.level > b.level
    end)
    return name
end
---获取当前画面存于一个纹理
---@param texname string
function OtherScreenEFF:GetCurrentTex(texname)
    self.flag = true
    local name = texname or "OtherScreenEff:level66666"
    -- CreateRenderTarget(name)
    table.insert(self.Event, {
        func = function()
        end,
        level = 66666,
        RenderOrigin = true,
        Capture = true,
        name = name,
    })
    table.sort(self.Event, function(a, b)
        return a.level > b.level
    end)
    return name
end
function OtherScreenEFF:ResetUV()
    local scr = screen
    local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
    local w, h = scr.width, scr.height
    uv1[6], uv2[6], uv3[6], uv4[6] = self.colFFFFFFF, self.colFFFFFFF, self.colFFFFFFF, self.colFFFFFFF
    uv1[4], uv1[5] = UIToScreen(0, h)
    uv2[4], uv2[5] = UIToScreen(w, h)
    uv3[4], uv3[5] = UIToScreen(w, 0)
    uv4[4], uv4[5] = UIToScreen(0, 0)
    uv1[1], uv1[2] = 0, h
    uv2[1], uv2[2] = w, h
    uv3[1], uv3[2] = w, 0
    uv4[1], uv4[2] = 0, 0
    self.uv1, self.uv2, self.uv3, self.uv4 = uv1, uv2, uv3, uv4

end
function OtherScreenEFF:GetScreenUV(copy)
    if not (self.uv1 and self.uv2 and self.uv3 and self.uv4) then
        self:ResetUV()
    end
    if copy then
        return sp:CopyTable(self.uv1), sp:CopyTable(self.uv2), sp:CopyTable(self.uv3), sp:CopyTable(self.uv4)
    else
        return self.uv1, self.uv2, self.uv3, self.uv4
    end
end
function OtherScreenEFF:CreateRenderTarget(name)
    if not self.rtcount[name] then
        self.rtcount[name] = 1--初始时多计一次
        CreateRenderTarget(name)
    end
    self.rtcount[name] = self.rtcount[name] + 1

end
---下一帧再移除纹理，避免冗余处理
function OtherScreenEFF:RemoveRenderTarget(name)
    if self.rtcount[name] then
        self.rtcount[name] = self.rtcount[name] - 1
        if self.rtcount[name] <= 0 then
            local resType = 1
            local respool = lstg.CheckRes(resType, name)
            if respool then
                lstg.RemoveResource(respool, resType, name)
            end
            self.rtcount[name] = nil
        end
    end
end
function OtherScreenEFF:BeforeRender()
    if self.flag then
        local e
        for i = #self.Event, 1, -1 do
            e = self.Event[i]
            if e.Capture then
                self:CreateRenderTarget(e.name)
                PushRenderTarget(e.name)
                RenderClear(self.col00000000)
            end
        end
    end
end
function OtherScreenEFF:AfterRender()
    if self.flag then
        SetViewMode("ui")
        for _, e in ipairs(self.Event) do
            if e.Capture then
                PopRenderTarget(e.name)
            end
            if e.RenderOrigin then
                RenderTexture(e.name, "", self:GetScreenUV())
            end
            e.func(e)
        end
    end
    for n in pairs(self.rtcount) do
        self:RemoveRenderTarget(n)
    end
end
function OtherScreenEFF:Reset()
    self.flag = false
    for k in ipairs(self.Event) do
        self.Event[k] = nil
    end

end
ext.OtherScreenEff = OtherScreenEFF

---获取分离rgb的执行函数，要配合ext.OtherScreenEff
---@return fun(index:number, cx:number, cy:number):fun(self:ext.OtherScreenEff)
local GetDepartRGBFunc = function(col)
    local scr = screen
    local uv1, uv2, uv3, uv4 = { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }, { [3] = 0.5 }
    local w, h = scr.width, scr.height
    uv1[4], uv1[5] = UIToScreen(0, h)
    uv2[4], uv2[5] = UIToScreen(w, h)
    uv3[4], uv3[5] = UIToScreen(w, 0)
    uv4[4], uv4[5] = UIToScreen(0, 0)
    col = col or { { 255, 0, 0 }, { 0, 255, 0 }, { 0, 0, 255 } }
    return function(index, cx, cy)
        cx = cx or w / 2
        cy = cy or h / 2
        local w1, w2 = cx, w - cx
        local h1, h2 = cy, h - cy
        ---@param self ext.OtherScreenEff
        return function(self)
            SetImageState("white", "", 255, 0, 0, 0)
            RenderRect("white", 0, w, 0, h)
            for z = -1, 1 do
                local scale = 1 + index / 333 * z
                local color = Color(255, col[z + 2][1], col[z + 2][2], col[z + 2][3])
                uv1[6], uv2[6], uv3[6], uv4[6] = color, color, color, color
                uv1[1], uv1[2] = cx - w1 * scale + 0 * index, cy + h2 * scale
                uv2[1], uv2[2] = cx + w2 * scale + 0 * index, cy + h2 * scale
                uv3[1], uv3[2] = cx + w2 * scale + 0 * index, cy - h1 * scale
                uv4[1], uv4[2] = cx - w1 * scale + 0 * index, cy - h1 * scale
                RenderTexture(self.name_fake or self.name, "mul+add", uv1, uv2, uv3, uv4)
            end
        end
    end
end
ext.GetDepartRGBFunc = GetDepartRGBFunc

