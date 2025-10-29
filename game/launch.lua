-- 版本信息
_luastg_version = 0x1000
_luastg_min_support = 0x1000

function GetDataPath()
    return "User\\"
    --return lstg.Platform.GetRoamingAppDataPath()
end

for k, v in pairs(lstg) do
    _G[k] = v
end

local function print_value(t, indent, no_lead_indent)
    local T = type(t)
    if T == "table" then
        local n = 0
        local s = {}

        local i = string.rep("  ", indent)

        if not no_lead_indent then
            n = n + 1
            s[n] = i
        end

        n = n + 1
        s[n] = "{\n"

        local h = string.rep("  ", indent + 1)

        for k, v in pairs(t) do
            n = n + 1
            s[n] = h

            n = n + 1
            s[n] = "["

            n = n + 1
            s[n] = print_value(k, 0, true)

            n = n + 1
            s[n] = "] = "

            n = n + 1
            s[n] = print_value(v, indent + 1, true)

            n = n + 1
            s[n] = ","

            n = n + 1
            s[n] = "\n"
        end

        n = n + 1
        s[n] = i

        n = n + 1
        s[n] = "}"

        return table.concat(s)
    elseif T == "string" then
        return string.format("%q", t)
    elseif T == "number" or T == "boolean" then
        return tostring(t)
    else
        return string.format("%q", tostring(t))
    end
end
local function Serialize(t)
    local b, s = pcall(cjson.encode, t)
    if b then
        return s
    else
        lstg.Log(4, string.format("contant to encode = %s", print_value(t, 0, false)))
        assert(b, s)
    end
end
local function DeSerialize(s)
    local b, t = pcall(cjson.decode, s)
    if b then
        return t
    else
        lstg.Log(4, string.format("json contant %q", s))
        assert(b, t)
    end
end

_G.Serialize = Serialize
_G.DeSerialize = DeSerialize
local xinput = require('xinput')

-- 按键常量
local KEY = {
    NULL = 0x00,

    LBUTTON = 0x01,
    RBUTTON = 0x02,
    MBUTTON = 0x04,

    ESCAPE = 0x1B,
    BACKSPACE = 0x08,
    TAB = 0x09,
    ENTER = 0x0D,
    SPACE = 0x20,

    --SHIFT = 0x10,
    --CTRL = 0x11,
    --ALT = 0x12,

    --很奇怪的东西？只能自己加了
    LCTRL = 0xA2,
    RCTRL = 0xA3,
    LALT = 0xA4,
    RALT = 0xA5,
    SHIFT = 0xA0,
    NUMPADENTER = 0xE8,
    --RSHIFT = 0xA1,

    LWIN = 0x5B,
    RWIN = 0x5C,
    APPS = 0x5D,

    PAUSE = 0x13,
    CAPSLOCK = 0x14,
    NUMLOCK = 0x90,
    SCROLLLOCK = 0x91,

    PGUP = 0x21,
    PGDN = 0x22,
    HOME = 0x24,
    END = 0x23,
    INSERT = 0x2D,
    DELETE = 0x2E,

    LEFT = 0x25,
    UP = 0x26,
    RIGHT = 0x27,
    DOWN = 0x28,

    ['0'] = 0x30,
    ['1'] = 0x31,
    ['2'] = 0x32,
    ['3'] = 0x33,
    ['4'] = 0x34,
    ['5'] = 0x35,
    ['6'] = 0x36,
    ['7'] = 0x37,
    ['8'] = 0x38,
    ['9'] = 0x39,

    A = 0x41,
    B = 0x42,
    C = 0x43,
    D = 0x44,
    E = 0x45,
    F = 0x46,
    G = 0x47,
    H = 0x48,
    I = 0x49,
    J = 0x4A,
    K = 0x4B,
    L = 0x4C,
    M = 0x4D,
    N = 0x4E,
    O = 0x4F,
    P = 0x50,
    Q = 0x51,
    R = 0x52,
    S = 0x53,
    T = 0x54,
    U = 0x55,
    V = 0x56,
    W = 0x57,
    X = 0x58,
    Y = 0x59,
    Z = 0x5A,

    GRAVE = 0xC0,
    MINUS = 0xBD,
    EQUALS = 0xBB,
    BACKSLASH = 0xDC,
    LBRACKET = 0xDB,
    RBRACKET = 0xDD,
    SEMICOLON = 0xBA,
    APOSTROPHE = 0xDE,
    COMMA = 0xBC,
    PERIOD = 0xBE,
    SLASH = 0xBF,

    NUMPAD0 = 0x60,
    NUMPAD1 = 0x61,
    NUMPAD2 = 0x62,
    NUMPAD3 = 0x63,
    NUMPAD4 = 0x64,
    NUMPAD5 = 0x65,
    NUMPAD6 = 0x66,
    NUMPAD7 = 0x67,
    NUMPAD8 = 0x68,
    NUMPAD9 = 0x69,

    MULTIPLY = 0x6A,
    DIVIDE = 0x6F,
    ADD = 0x6B,
    SUBTRACT = 0x6D,
    DECIMAL = 0x6E,

    F1 = 0x70,
    F2 = 0x71,
    F3 = 0x72,
    F4 = 0x73,
    F5 = 0x74,
    F6 = 0x75,
    F7 = 0x76,
    F8 = 0x77,
    F9 = 0x78,
    F10 = 0x79,
    F11 = 0x7A,
    F12 = 0x7B,
}
_G.KEY = KEY

local xKEY = {
    NULL = xinput.Null,
    UP = xinput.Up,
    DOWN = xinput.Down,
    LEFT = xinput.Left,
    RIGHT = xinput.Right,
    START = xinput.Start,
    BACK = xinput.Back,
    LeftThumb = xinput.LeftThumb,
    RightThumb = xinput.RightThumb,
    LSHOULDER = xinput.LeftShoulder,
    RSHOULDER = xinput.RightShoulder,
    A = xinput.A,
    B = xinput.B,
    X = xinput.X,
    Y = xinput.Y,
    --- 手柄左扳机（在左肩键旁边），有的手柄可能没有
    LeftTrigger = 0x0400,
    --- 手柄右扳机（在右肩键旁边），有的手柄可能没有
    RightTrigger = 0x0800,
    ["LeftThumb X+"] = 0x10000,
    ["LeftThumb Y+"] = 0x20000,
    ["RightThumb X+"] = 0x40000,
    ["RightThumb Y+"] = 0x80000,
    ["LeftThumb X-"] = 0x100000,
    ["LeftThumb Y-"] = 0x200000,
    ["RightThumb X-"] = 0x400000,
    ["RightThumb Y-"] = 0x800000,
}
_G.xKEY = xKEY

local resx, resy = GetFullScreenResolution()
---@class setting
default_setting = {
    reso_value = math.floor(resy * 0.8),
    window = {
        allow_title_bar_auto_hide = false,
    },
    graphics_system = {
        width = math.floor(resx * 0.8),
        height = math.floor(resy * 0.8),
        fullscreen = false,
        vsync = false,
    },

    sevolume = 80,
    bgmvolume = 80,
    language = 1,
    xbox_slot = 0, --检测手柄
    keys = {
        up = KEY.UP,
        down = KEY.DOWN,
        left = KEY.LEFT,
        right = KEY.RIGHT,
        slow = KEY.SHIFT,
        shoot = KEY.Z,
        spell = KEY.X,
        special = KEY.C,
    },
    keysys = {
        menu = KEY.ESCAPE,
        repfast = KEY.LCTRL,
        repslow = KEY.SHIFT,
        retry = KEY.R,
    },
    xkeys = {
        up = xKEY.UP,
        down = xKEY.DOWN,
        left = xKEY.LEFT,
        right = xKEY.RIGHT,
        slow = xKEY.LSHOULDER,
        shoot = xKEY.RightTrigger,
        spell = xKEY.LeftTrigger,
        special = xKEY.RSHOULDER,
    },
    xkeysys = {
        confirm = xKEY.A,
        menu = xKEY.B,
        repfast = xKEY.A,
        repslow = xKEY.B,
        retry = xKEY.START,

    },
}

local function format_json(str)
    local ret = ''
    local indent = '	'
    local level = 0
    local in_string = false
    for i = 1, #str do
        local s = string.sub(str, i, i)
        if s == '{' and (not in_string) then
            level = level + 1
            ret = ret .. '{\n' .. string.rep(indent, level)
        elseif s == '}' and (not in_string) then
            level = level - 1
            ret = string.format(
                    '%s\n%s}', ret, string.rep(indent, level))
        elseif s == '"' then
            in_string = not in_string
            ret = ret .. '"'
        elseif s == ':' and (not in_string) then
            ret = ret .. ': '
        elseif s == ',' and (not in_string) then
            ret = ret .. ',\n'
            ret = ret .. string.rep(indent, level)
        elseif s == '[' and (not in_string) then
            level = level + 1
            ret = ret .. '[\n' .. string.rep(indent, level)
        elseif s == ']' and (not in_string) then
            level = level - 1
            ret = string.format(
                    '%s\n%s]', ret, string.rep(indent, level))
        else
            ret = ret .. s
        end
    end
    return ret
end
_G.format_json = format_json

local settingfile_dir = GetDataPath()
local settingfile = settingfile_dir .. "/setting.json"
_G.settingfile = settingfile

function loadConfigure()
    local f, msg
    f, msg = io.open(settingfile, 'r')
    if f == nil then
        ---@type setting
        setting = DeSerialize(Serialize(default_setting))
    else
        setting = DeSerialize(f:read('*a'))
        f:close()
    end
    for k, v in pairs(default_setting) do
        if setting[k] == nil then
            setting[k] = v
        elseif type(v) == 'table' then
            for k2, v2 in pairs(v) do
                if setting[k][k2] == nil then
                    setting[k][k2] = v2
                end
            end
        end
    end-- 补全配置项

end

function save_setting()
    lstg.FileManager.CreateDirectory(settingfile_dir)
    local f = assert(io.open(settingfile, 'w'))
    f:write(format_json(Serialize(setting)))
    f:close()
end

loadConfigure()-- 先装载一次配置


if #args >= 2 then
    loadstring(args[2])()
end



