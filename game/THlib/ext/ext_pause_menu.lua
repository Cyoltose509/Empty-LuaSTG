----------------------------------------
---暂停菜单
local pausemenu = {  }
local TIP = {
  "1",
  "2"
}
_G.TIP = TIP



function pausemenu:init()
    self.kill = true

end

function pausemenu:frame()

    if self.kill then
        return "killed"
    end



end
function pausemenu:render()
    if self.kill then
        return "killed"
    end
    SetViewMode 'ui'

end

function pausemenu:FlyIn()
end

function pausemenu:FlyOut()
end
function pausemenu:IsKilled()
    return self.kill
end

pausemenu:init()
ext.pause_menu = pausemenu


