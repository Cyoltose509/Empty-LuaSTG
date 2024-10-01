local ice_bg = Class(_SC_BG)
function ice_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "img_void")
    function b:Beforerender()
        _SC_BG.PolarCoordinatesRender("th14_1", 0, 120, 0, 500,
                0, 512, 2, self.timer, "mul+rev",
                Color(self._cur_alpha * 255,
                        150 + sin(self.timer) * 100,
                        150 + sin(self.timer / 2) * 100,
                        150 + sin(self.timer / 3) * 100))
    end
    b = _SC_BG.AddLayer(self, "th14_0", true, 0, 0, 0, 0, 0.3, 0, "")
    b.r, b.g, b.b = 150, 150, 150
end
function ice_bg:frame()
    _SC_BG.frame(self)
    self.alpha = min(0.5, self.alpha)
end
_editor_class.ice_bg = ice_bg

local ice_black_bg = Class(_SC_BG)
function ice_black_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "img_void")
    function b:Beforerender()
        _SC_BG.PolarCoordinatesRender("th14_1", 0, 120, 0, 500,
                0, 512, 2, self.timer, "mul+rev",
                Color(self._cur_alpha * 255,
                        150 + sin(self.timer) * 100,
                        150 + sin(self.timer / 2) * 100,
                        150 + sin(self.timer / 3) * 100))
    end
    b = _SC_BG.AddLayer(self, "th14_0", true, 0, 0, 0, 0, 0.3, 0, "")
    b.r, b.g, b.b = 100, 100, 100
end
function ice_black_bg:frame()
    _SC_BG.frame(self)
end
_editor_class.ice_black_bg = ice_black_bg

local medicine_bg = Class(_SC_BG)
function medicine_bg:init()
    _SC_BG.init(self)

    local b = _SC_BG.AddLayer(self, "th09_3", true, 0, 0, 0,
            0, 1.8, 0, "", 1, 1)
    b.a = 150
    _SC_BG.AddLayer(self, "th09_2", false, 0, 0, 0,
            0, 0, -0.2, "", 3.2, 3.2)

end
_editor_class.medicine_bg = medicine_bg

local kogasa_bg = Class(_SC_BG)
function kogasa_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "th12_3", false, 0, 224, 0,
            0, 0, 0.1, "", 2, 2)
    b.a = 100
    b = _SC_BG.AddLayer(self, "th12_3", false, 0, -224, 0,
            0, 0, 0.1, "", 2, 2)
    b.a = 100
    _SC_BG.AddLayer(self, "th12_2", true, 0, 0, 0, 0, 1.2)
end
_editor_class.kogasa_bg = kogasa_bg

local neet_bg = Class(_SC_BG)
function neet_bg:init()
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th08_17", false, 0, 0, 0,
            0, 0, 0.5, "mul+add", 1.5, 1.5,
            function(unit)
                unit.a = 150
            end,
            function(unit)
                unit.g, unit.b = sin(unit.timer / 2) * 255 / 2 + 255 / 2, sin(unit.timer / 2) * 255 / 2 + 255 / 2
            end)
    _SC_BG.AddLayer(self, "th08_20", true, 0, 0, 0,
            0, 2, 0, "mul+add", 1, 1,
            function(unit)
                unit.r = 150
                unit.g = 150
                unit.b = 150
            end,
            function(unit)
                unit.a = sin(unit.timer / 2) * 100 + 155
            end)
    _SC_BG.AddLayer(self, "th08_15_n", false, 0, 0, 0,
            0, 0, 0, "", 1, 1,
            nil,
            function(unit)
                local o = cos(unit.timer / 2) * 100 + 155
                unit.r = o
                unit.g = o
                unit.b = o
            end)
end
_editor_class.neet_bg = neet_bg

local yagokoro_bg = Class(_SC_BG)
function yagokoro_bg:init()
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th08_14", true, 0, 0, 0,
            0, 2, 0, "mul+add", 1, 1,
            function(unit)
                unit.a = 150
            end)
    _SC_BG.AddLayer(self, "th08_13_n", false, 0, 0, 0,
            0, 0, 0, "", 1, 1)
end
_editor_class.yagokoro_bg = yagokoro_bg

local clownpiece_bg = Class(_SC_BG)
function clownpiece_bg:init()
    _SC_BG.init(self)
    local b = _SC_BG.AddLayer(self, "th08_13_n", false, 0, 0, 0,
            0, 0, 0, "", 1, 1)
    b.a = 120
    b = _SC_BG.AddLayer(self, "th15_8", false, 0, 0, 0,
            0, 0, 0, "", 1, 1)
    b.blend = "mul+rev"
    function b:Beforeframe()
        self.r = 170 + sin(self.timer / 3) * 20
        self.g = self.r
        self.b = self.r
    end
    b = _SC_BG.AddLayer(self, "th15_9", false, 0, 0, 0, 0, 0, -0.5, "", 1.6, 1.6)

end
_editor_class.clownpiece_bg = clownpiece_bg

local seiran_bg = Class(_SC_BG)
function seiran_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "th15_0", true, -64, 0, 0, 0, 0.6, 0, "mul+rev", 0.8, 0.8)
    b = _SC_BG.AddLayer(self, "th15_1", false, 0, 0, 0, 0, 0, 0.5, "", 1.6, 1.6)
    b.a = 190
    _SC_BG.AddLayer(self, "th15_1", false, 0, 0, 0, 0, 0, -0.4, "", 1.6, 1.6)
end
_editor_class.seiran_bg = seiran_bg

local ringo_bg = Class(_SC_BG)
function ringo_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "th15_2", true, -64, 0, 0, 0, 0.6, 0, "mul+rev", 0.8, 0.8)
    b = _SC_BG.AddLayer(self, "th15_3", false, 0, 0, 0, 0, 0, 0.5, "", 1.6, 1.6)
    b.a = 190
    _SC_BG.AddLayer(self, "th15_3", false, 0, 0, 0, 0, 0, -0.4, "", 1.6, 1.6)
end
_editor_class.ringo_bg = ringo_bg

local spring_bg = Class(_SC_BG)
function spring_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "th16_5", true, 0, 0, 90, 0.2, -0.2, 0, "mul+rev", 0.6, 0.6)
    function b:Beforeframe()
        self.r = cos(self.timer / 2) * 100 + 150
        self.g = cos(self.timer / 3) * 100 + 150
        self.b = sin(self.timer / 4) * 100 + 150
    end
    b = _SC_BG.AddLayer(self, "th16_5", true, 0, 0, 0, -0.2, -0.2)
    b = _SC_BG.AddLayer(self, "th16_4", true, 0, 0, 0, 0, 0.15)
end
_editor_class.spring_bg = spring_bg

local yukari_bg = Class(_SC_BG)
function yukari_bg:init()
    _SC_BG.init(self)
    local b

    b = _SC_BG.AddLayer(self, "th07_9", false, 0, 0, 0, 0, 0,
            0.4, "", 1.3, 1.3)
    b = _SC_BG.AddLayer(self, "th08_14", true, 0, 0, 0,
            0, -1, 0, "mul+rev", 1, 1)
    b.a = 150
    b = _SC_BG.AddLayer(self, "th07_9_n", false, 0, 0, 0, 0, 0, 0, "", 0.5, 0.5)
    function b:Beforeframe()
        local k = sin(self.timer) * 30 + 160
        self.r, self.g, self.b = k, k, k
    end
end
_editor_class.yukari_bg = yukari_bg

local junko_bg = Class(_SC_BG)
function junko_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "img_void", false, 0, 144)
    function b:Beforerender()
        _SC_BG.PolarCoordinatesRender("th15_10", self.x, self.y, 0, 800, 0, 512,
                1, -self.timer, "mul+rev",
                Color(self._cur_alpha * (100 + 25 * sin(self.timer * 2)), 255, 255, 255))
    end
    b = _SC_BG.AddLayer(self, "th15_11", true, 0, 0, 0, 0, 1)

end
_editor_class.junko_bg = junko_bg

local yousei_bg = Class(_SC_BG)
function yousei_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "th12_8_0")
    b.blend = "mul+add"
    b.a = 180
    b.hscale, b.vscale = 1.2, 1.2
    b = _SC_BG.AddLayer(self, "th12_8_1", true, 0, 0, 0, 0, 1)
    b.a = 100
    b = _SC_BG.AddLayer(self, "th12_8_1", true, 0, 0, 0, -0.6, -0.7)
    b.Beforeframe = function(self)
        self.r = 150 + sin(self.timer / 3) * 100
        self.g = 150 + sin(self.timer / 6) * 100
        self.b = 150 + sin(self.timer / 9) * 100
    end
end
_editor_class.yousei_bg = yousei_bg

local yamame_bg = Class(_SC_BG)
function yamame_bg:init()
    _SC_BG.init(self)
    _SC_BG.AddLayer(self, "th11_3", true, 0, 0, 0, 0, 1, 0, "mul+add", 1, 1,
            nil,
            function(unit)
                unit.g = 155 + sin(unit.timer) * 100
            end)
    _SC_BG.AddLayer(self, "th11_4", true, 0, 0, 0, 1, -1)
end
_editor_class.yamame_bg = yamame_bg

local murasa_bg = Class(_SC_BG)
function murasa_bg:init()
    _SC_BG.init(self)
    local b
    b = _SC_BG.AddLayer(self, "th12_7", true, 0, 0, 0, 0.7, -0.5, 0, "mul+add", 0.8, 0.8)
    b.a = 100
    b.Beforeframe = function(self)
        self.g = 100 + sin(self.timer / 4) * 80
    end
    b = _SC_BG.AddLayer(self, "th12_7", true, 0, 0, 0, 0.8, -0.5, 0, "mul+rev")
    b.a = 200
    b.Beforeframe = function(self)
        self.g = 100 + sin(self.timer / 2) * 80
    end

    b = _SC_BG.AddLayer(self, "th12_6", false, 0, 0, 0, 0, 0, 0.2, "", 2, 2)
    b.r, b.g, b.b = 200, 200, 200
end
_editor_class.murasa_bg = murasa_bg
