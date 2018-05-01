--成就数据结构
local achievement = {
    --任务ID
    id = nil,
    --任务类型
    type = nil,
    --关卡
    level = nil,
    --通关星数
    passStar = nil,
    --杀敌数
    killEnemy = nil,
    --普通关卡数
    normal = nil,
    --精英关卡数
    elite = nil,
    --BOSS关卡数
    boss = nil,
    --成就奖励
    reward = nil,
    --成就描述
    describe = nil,
}

--充值数据结构
local recharge = {
    --ID
    id = nil,
    --人民币
    money = nil,
    --金币
    gold = nil,
    --赠送金币
    giftGold = nil,
    --是否首充翻倍
    isDouble = nil,   
}

local prop = {
    --ID
    id = nil,
    --名称
    name = nil,
    --图片
    texture = nil,
    --缩放
    scale = nil,
    --效果 数值类型
    effect = nil,
    --购买价格
    price = nil,
}

local consolidate = {
    --ID
    id = nil,
    --名称
    name = nil,
    --强化等级
    level = nil,
    --要求金币
    conditionGold = nil,
    --要求星级
    conditionStar = nil,
}

local upgrade = {
    --ID
    id = nil,
    --名称
    name = nil,
    --进阶星级
    advancedStar = nil,
    --消耗金币
    gold = nil,
}

local reward = {
    --ID
    id = nil,
    --中奖金币
    gold = nil,
    --中奖龙珠数量
    ball = nil,
    --概率
    probability = nil,
}

local ball = {
    --ID
    id = nil,
    --龙珠星级
    level = nil,
    --生命加成
    life = nil,
    --攻击加成
    attack = nil,
    --支付龙珠数
    payBall = nil,
}

require "data2"

local file = io.open("dataUi.lua", "w")
local c = 1
local function table2File(t)
    file:write("{")
    for i, v in pairs(t) do
        if type(v) ~= "table" then
            if type(v) == "number" then
                file:write(i .. " = " .. v .. ", ")
            else
                file:write(i .. " = \"" .. v .. "\", ")
            end
        else
            if c == 1 then
                file:write("\n\t")
            end
            if type(i) == "number" then
                file:write("[" .. i .. "]" .. " = ")
            else
                file:write(i .. " = ")
            end
            c = c + 1
            table2File(v)
            c = c - 1
        end
    end
    if c == 1 then
        file:write("\n}\n\n")
    else
        file:write("}, ")
    end
end

file:write("local achievement = ")
table2File(ui.achievement)
file:write("local recharge = ")
table2File(ui.recharge)
file:write("local prop = ")
table2File(ui.prop)
file:write("local consolidate = ")
table2File(ui.consolidate)
file:write("local upgrade = ")
table2File(ui.upgrade)
file:write("local reward = ")
table2File(ui.reward)
file:write("local ball = ")
table2File(ui.ball)


file:write("local dataUi = {}\n\n")

file:write("function dataUi.getAchievement()\n")
file:write("\treturn clone(achievement)\n")
file:write("end\n\n")

file:write("function dataUi.getRecharge(id)\n")
file:write("\treturn clone(recharge[id])\n")
file:write("end\n\n")

file:write("function dataUi.getProp(id)\n")
file:write("\treturn clone(prop[id])\n")
file:write("end\n\n")

file:write("function dataUi.getConsolidate(id)\n")
file:write("\tif id == nil then\n")
file:write("\t\treturn clone(consolidate)\n")
file:write("\telse\n")
file:write("\t\treturn clone(consolidate[id])\n")
file:write("\tend\n")
file:write("end\n\n")

file:write("function dataUi.getUpgrade(id)\n")
file:write("\tif id == nil then\n")
file:write("\t\treturn clone(upgrade)\n")
file:write("\telse\n")
file:write("\t\treturn clone(upgrade[id])\n")
file:write("\tend\n")
file:write("end\n\n")

file:write("function dataUi.getReward(id)\n")
file:write("\treturn clone(reward[id])\n")
file:write("end\n\n")

file:write("function dataUi.getBall(id)\n")
file:write("\treturn clone(ball[id])\n")
file:write("end\n\n")

file:write("return dataUi")

file:close()
