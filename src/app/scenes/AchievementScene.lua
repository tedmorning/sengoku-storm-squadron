local AchievementScene = class("AchievementScene",function()
    return cc.Scene:create()
end)

function AchievementScene:ctor()
    isEnter = false

    local AchievementLayer = require("src/app/layers/AchievementLayer")
    local TopLayer = require("src/app/layers/TopLayer")

    self:addChild(AchievementLayer.new())

    local topLayer = TopLayer.new()
    self:addChild(topLayer)
    topLayer:setName("TopLayer")
end

return AchievementScene