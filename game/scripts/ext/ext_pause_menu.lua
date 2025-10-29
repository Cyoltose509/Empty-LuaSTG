
local pausemenu = {  }





function pausemenu:init()

    self.kill=true
end

function pausemenu:frame()


end
function pausemenu:render()

end

function pausemenu:FlyIn()
end

function pausemenu:FlyOut()

end

function pausemenu:IsKilled()
    return self.kill
end

---@class ext.pausemenu @暂停菜单对象
ext.pause_menu = pausemenu
ext.pause_menu:init()



