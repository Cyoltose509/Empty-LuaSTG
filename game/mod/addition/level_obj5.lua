local path = "mod\\addition\\addition_unit\\"

LoadAniFromFile("level_obj_siyuan_baby6", path .. "siyuan_baby6.png", true, 6, 3, 3)

LoadAniFromFile("level_obj_bun_cat1", path .. "bun_cat1.png", true, 6, 10, 1)
LoadAniFromFile("level_obj_bun_cat2", path .. "bun_cat2.png", true, 6, 10, 1)
LoadAniFromFile("level_obj_bun_cat3", path .. "bun_cat3.png", true, 6, 10, 1)
LoadAniFromFile("level_obj_bun_cat4", path .. "bun_cat4.png", true, 6, 10, 1)

---@class level_obj5
local class5 = {}

local rotate_cat = Class(object, {
    init = function(self, k)
        self.img = "level_obj_siyuan_baby6"
        self.A, self.B = 5, 5
        self.bound = false
        self.group = GROUP.PLAYER_BULLET
        self.layer = LAYER.PLAYER_BULLET
        self.killflag = true
        self.bound = false
        self._blend = ""
        self._a = 0
        self._r, self._g, self._b = 200, 200, 200
        self.x, self.y = ran:Float(-280, 280), ran:Float(0, 180)
        local d = (k % 2) * 2 - 1
        self.vx = d * 3
        self.vy = ran:Sign() * 2
        self.a, self.b = 20, 20
        self.hscale, self.vscale = 0.6, 0.6
        task.New(self, function()
            for i = 1, 25 do
                self._a = 255 * i / 25
                task.Wait()
            end
        end)
    end,
    frame = function(self)
        task.Do(self)
        self.dmg = player_lib.GetPlayerDmg() * 0.12
        local w = lstg.world
        if self.y > w.t then
            self.vy = -self.vy
            self.y = w.t - (self.y - w.t)
        end
        if self.y < w.b then
            self.vy = -self.vy
            self.y = w.b - (self.y - w.b)
        end
        if self.x > w.r then
            self.vx = -self.vx
            self.x = w.r - (self.x - w.r)
        end
        if self.x < w.l then
            self.vx = -self.vx
            self.x = w.l - (self.x - w.l)
        end
    end,
    render = function(self)
        SetImageState("bright", "", self._a * 0.6, 255, 255, 255)
        Render("bright", self.x, self.y, 0, 35 / 130)
        SetAnimationState(self.img, self._blend, self._a, self._r, self._g, self._b)
        DefaultRenderFunc(self)
    end,
    kill = function(self)
        enemy.death_ef(self.x, self.y, 10, 1)
    end,
    del = function(self)
        self.class.kill(self)
    end
}, true)
class5.rotate_cat = rotate_cat

local bun_cat_stack = {}
local bun_cat = Class(object, {
    init = function(self, imgid)
        self.id = imgid
        self.img = "level_obj_bun_cat" .. self.id
        self.bound = false
        self.group = GROUP.PLAYER_BULLET
        self.layer = LAYER.PLAYER_BULLET
        self.killflag = true
        self.bound = false
        self._blend = ""
        self._a = 0
        self._r, self._g, self._b = 255, 255, 255
        self.a, self.b = 10, 10
        self.hscale, self.vscale = 0.5, 0.5
        table.insert(bun_cat_stack, self)
        task.New(self, function()
            local p = player
            while true do
                while true do
                    self.x = self.x + (-self.x + self._x) * self._index
                    self.y = self.y + (-self.y + self._y) * self._index
                    if Dist(self, self._x, self._y) < 10 and p.__shoot_flag and p.nextshoot <= 0 then
                        if self.pos - 1 >= 1 and IsValid(bun_cat_stack[self.pos - 1]) then
                            if bun_cat_stack[self.pos - 1].jump then
                                player_class.findtarget(self)
                                if IsValid(self.target) then
                                    break
                                end
                            end
                        else
                            player_class.findtarget(self)
                            if IsValid(self.target) then
                                break
                            end
                        end
                    end
                    task.Wait()
                end
                self.jump = false
                if IsValid(self.target) then
                    object.SetV(self, 15, Angle(self, self.target))
                    self.shoot_out = true
                end
                while self.shoot_out do
                    task.Wait()
                end
                self.jump = true
                task.Wait()

            end
        end)
        task.New(self, function()

            for i = 1, 25 do
                self._a = 255 * i / 25
                task.Wait()
            end
        end)
    end,
    frame = function(self)
        sp:UnitListUpdate(bun_cat_stack)
        for i, b in ipairs(bun_cat_stack) do
            if b == self then
                self.pos = i
            end
        end
        local p = player
        local R = 45
        local t = self.pos * 90 + self.timer * 3
        self._x, self._y = p.x + cos(t) * R, p.y + sin(t) * R
        self._index = Forbid(20 / Dist(self, self._x, self._y), 0.00001, 1)

        if self.timer == 1 then
            self.x = self._x
            self.y = self._y
        end
        self.dmg = player_lib.GetPlayerDmg() * 0.3
        task.Do(self)
        if self.shoot_out then
            self.vx = self.vx - self.vx * 0.018
            self.vy = self.vy - self.vy * 0.018
            if abs(self.vx) < 0.1 or abs(self.vy) < 0.1 then
                self.shoot_out = false
            end
            local w = lstg.world
            if self.y > w.t then
                self.shoot_out = false
            end
            if self.y < w.b then
                self.shoot_out = false
            end
            if self.x > w.r then
                self.shoot_out = false
            end
            if self.x < w.l then
                self.shoot_out = false
            end
        end
    end,
    render = function(self)
        SetImageState("bright", "", self._a * 0.6, 255, 255, 255)
        Render("bright", self.x, self.y, 0, 35 / 130)
        SetAnimationState(self.img, self._blend, self._a, self._r, self._g, self._b)
        DefaultRenderFunc(self)
    end,
    kill = function(self)
        enemy.death_ef(self.x, self.y, 10, 1)
    end,
    del = function(self)
        self.class.kill(self)
    end
}, true)
class5.bun_cat = bun_cat

return class5
