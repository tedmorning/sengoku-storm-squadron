local WelcomeScene = class("WelcomeScene",function()
    return cc.Scene:create()
end)

function WelcomeScene:ctor()
    isEnter = false
    local WelcomeLayer = require("src/app/layers/WelcomeLayer")
    self:addChild(WelcomeLayer.new())
end

return WelcomeScene