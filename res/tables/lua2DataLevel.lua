-- 关卡数据结构
local tampleLevel = {
    -- 第一关
    {
        sceneID = nil,
        -- 第一波
        {
            -- 血量系数
            hpFactor = nil,
            -- 子弹攻击系数
            bulletAttackFactor = nil,
            -- 敌机
            {
                -- 敌机出现时间
                time = nil,
                -- 敌机ID
                enemyID = nil,
                -- 敌机位置ID
                positionID = nil
            },
        -- 敌机
        --  ...
        },
    -- 第二波
    --  ...
    },
-- 第二关
--    ...
}

-- 特殊波次数据结构
local specialWave = {
    time = nil,
    probability1 = nil,
    probability2 = nil,
    probability = nil,
    -- 第一波
    {
        -- 敌机
        {
            -- 敌机出现时间
            time = nil,
            -- 敌机ID
            enemyID = nil,
            -- 敌机位置ID
            positionID = nil
        }
        --  ...
    }
    -- 第二波
    --  ...
}

--关卡介绍
local data4 = {
    -- 关卡名称
    name = nil,
    -- 消耗体力
    engine = nil,
    -- 敌方战斗力
    enemyPower = nil,
    -- 次数上限
    timeLimit = nil,
    -- 进入条件
    condition = nil,
    --关卡介绍
    information = nil,
    -- boss模型
    bossTexture = nil,
    -- 三星通关奖励
    reward = nil,
    -- 掉落物品上限
    leaveLimit = nil,
    -- 掉落道具
    prop = {
        {propID = nil, propProbability = nil},
    --        ...
    }
}

--关卡战斗掉落
local data8 = {
    --关数ID
    id = nil,
    --星钻小、中、大；升级小、大；护盾；回血
    prop_1 = nil,
    prop_2 = nil,
    prop_3 = nil,
    prop_4 = nil,
    prop_5 = nil,
    prop_6 = nil,
    prop_7 = nil,
}

--掉落配置
local data9 = {
    --配置ID
    id = nil,
    --掉落总数，最小值，最大值
    num = nil,
    min = nil,
    max = nil,
}

local data10 = {
    --ID
    id = nil,
    --星钻数
    diamond = nil,
    --充值价格
    price = nil,
}

local data11 = {
    --关卡ID
    id = nil,
    gold1 = nil,
    probability1 = nil,
    --...总共6组
    rangeLow = nil,
    rangeHight = nil,
}

require "data2"

local function createLeave(id)
    local t = {}
    local L = enemy.leave[id]
    if L == nil then
        return t
    end
    local c = 1
    while(1) do
        if L["reward" .. c .. "ID"] then
            table.insert(t, {rewardID = L["reward" .. c .. "ID"], rewardProbability = L["reward" .. c .. "Probability"]})
        else
            break
        end
        c = c + 1
    end
    return t
end

local function createWave(id, time)
    local t = {}
    local W = level.wave[id]
    if W == nil then
        print("Oh shit! Cann't find " .. id .. "'wave!\n")
    end
    local c = 1
    while true do
        if W["enemy" .. c .. "ID"] then
            for i = 1, W["enemy" .. c .. "Quantity"] do
                local e = {}
                if time then
                    e.time = W["enemy" .. c .. "Time"] * 60 + (i - 1) * time + 60
                else
                    e.time = W["enemy" .. c .. "Time"] * 60 + (i - 1) * 30 + 60
                end
                e.enemyID = W["enemy" .. c .. "ID"]
                e.positionID = W["enemy" .. c .. "PositionID"]
                table.insert(t, e)
            end
        else
            break
        end
        c = c + 1
    end
    return t
end

local function createLevel(id)
    local t = {}
    local L = level.level[id]
    t.sceneID = L.sceneID
    local c = 1
    while true do
        if L["wave" .. c .. "ID"] then
            local w = createWave(L["wave" .. c .. "ID"])
            w.hpFactor = L["wave" .. c .. "HpFactor"]
            w.bulletAttackFactor = L["wave" .. c .. "BulletAttackFactor"]
            w.bulletRateFactor = L["wave" .. c .. "BulletRateFactor"]
            table.insert(t, w)
        else
            break
        end
        c = c + 1
    end
    return t
end

local function createLevelInfo(id)
    local t = {}
    local l = level.levelInfo[id]
    t.name = l.name
    t.engine = l.engine
    t.enemyPower = l.enemyPower
    t.timeLimit = l.timeLimit
    t.condition = l.condition
    t.information = l.information
    t.bossTexture = l.bossTexture
    t.reward = l.reward
    t.leaveLimit = l.leaveLimit
    t.bossInfo = l.bossInfo
    
    t.prop = {}
    local c = 1
    while true do
        if l["prop" .. c .. "ID"] then
            table.insert(t.prop, {propID = l["prop" .. c .. "ID"],propProbability = l["prop" .. c .. "Probability"]})
        else
            break
        end
        c = c + 1
    end
    return t
end

local function createSpecialWave()
    local t = {}
    local function create(id)
        local t = {}
        local SW = level.specialWave[id]
        if SW.time then
            t.time = math.floor(SW.time * 60)
        end
        t.probability = SW.probability
        t.probability1 = SW.probability1
        t.probability2 = SW.probability2
        t.wave = {}
        local c = 1
        while true do
            if SW["wave" .. c .. "ID"] then
                local w = createWave(SW["wave" .. c .. "ID"], t.time)
                table.insert(t.wave, w)
            else
                break
            end
            c = c + 1
        end
        return t
    end
    for i, v in pairs(level.specialWave) do
        t[i] = create(i)
    end
    return t
end

local function createRandomWave(id)
    local t = {}
    local L1 = level.rWave1[id]
    local L2 = level.rWave2
  --  print(L1["wave1"],L1["wave2"],L1["wave3"],L1["wave4"],#L2)    
    for i,v in pairs(L1) do
        local t1 = {}
        t1.rate = L2[v].rate
        local c = 1
        while true do
            if L2[v]["enemy" .. c] then
                local t2 = {}
                t2["enemy"..c] = L2[v]["enemy" .. c]
                t2["num"..c] = L2[v]["num"..c]
                
                table.insert(t1,t2)
            else
                break
            end
     --       print(t1.rate,c)
            c = c + 1
        end
   --     print("i = "..i)
        t[i] = t1 
    --    print(t[i].rate)
     
    end
    return t
end

local function createLevelActivity(n)
    local AL = level.activityLevel[n]
	local t = {}
    t.levelID = AL.levelID
    t.engine = AL.engine
    t.enemyPower = AL.enemyPower
    t.playerPower = AL.playerPower
    t.showProbability = AL.showProbability
    local c = 1
    t.reward = {}
    while true do
        if AL["rewardID" .. c] then
            table.insert(t.reward, {rewardID = AL["rewardID" .. c], probability = AL["probability" .. c]})
        else
            break
        end
        c = c + 1
    end
    return t
end

local file = io.open("dataLevel.lua", "w")
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

local lt = {}
file:write("local level = ")
for i, v in pairs(level.level) do
    lt[i] = createLevel(i)
end
table2File(lt)

local li = {}
file:write("local levelInfo = ")
for i,v in pairs(level.levelInfo) do
    li[i] = createLevelInfo(i)
end
table2File(li)

file:write("local levelLeave = ")
table2File(level.levelLeave)

file:write("local leaveChild = ")
table2File(level.leaveChild)

file:write("local diaPrice = ")
table2File(level.diaPrice)

file:write("local specialWave = ")
table2File(createSpecialWave())

local li = {}
file:write("local rWave = ")
for i,v in pairs(level.rWave1) do
    li[i] = createRandomWave(i)
end
table2File(li)

local al = {}
file:write("local activityLevel = ")
for i,v in pairs(level.activityLevel) do
    al[i] = createLevelActivity(i)
end
table2File(al)

file:write("local bossLeave = ")
table2File(level.bossLeave)

file:write("local card = ")
table2File(level.card)

file:write("local dataLevel = {}\n\n")
file:write("function dataLevel.getLevel(id)\n")
file:write("\treturn clone(level[id])\n")
file:write("end\n\n")
file:write("function dataLevel.getLevelInfo(id)\n")
file:write("\treturn clone(levelInfo[id])\n")
file:write("end\n\n")
file:write("function dataLevel.getLevelLeave(id)\n")
file:write("\treturn clone(levelLeave[id])\n")
file:write("end\n\n")
file:write("function dataLevel.getLeaveChild(id)\n")
file:write("\treturn clone(leaveChild[id])\n")
file:write("end\n\n")
file:write("function dataLevel.getDiaPrice()\n")
file:write("\treturn clone(diaPrice)\n")
file:write("end\n\n")
file:write("function dataLevel.getSpecialWave(id)\n")
file:write("\treturn clone(specialWave[id])\n")
file:write("end\n\n")

file:write("function dataLevel.getRWave(id)\n")
file:write("\treturn clone(rWave[id])\n")
file:write("end\n\n")

file:write("function dataLevel.getActivityLevel(id)\n")
file:write("\treturn clone(activityLevel[id])\n")
file:write("end\n\n")

file:write("function dataLevel.getBossLeave(id)\n")
file:write("\treturn clone(bossLeave[id])\n")
file:write("end\n\n")

file:write("function dataLevel.getCard(id)\n")
file:write("\treturn clone(card[id])\n")
file:write("end\n\n")

file:write("return dataLevel")

file:close()