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

require "data2"

local function createWave(id, time)
    local t = {}
    local W = endlessLevel.wave[id]
    t.total = 0
    t.isWarning = W.isWarning
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
                    e.time = W["enemy" .. c .. "Time"] * 60 + (i - 1) * 12 + 60
                end
                e.enemyID = W["enemy" .. c .. "ID"]
                e.positionID = W["enemy" .. c .. "PositionID"]
                table.insert(t, e)
                t.total = t.total + 1
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
    local L = endlessLevel.level[id]
    t.sceneID = L.sceneID
    t.enemyPower = L.enemyPower
    t.bossDiamond = L.bossDiamond
    t.levelDiamond = L.levelDiamond
    t.levelProtect = L.levelProtect
    t.levelAddHp = L.levelAddHp
    t.levelWeaponUp1 = L.levelWeaponUp1
    t.levelWeaponUp2 = L.levelWeaponUp2
    t.extendDiamond = L.extendDiamond
    t.total = 0
    local c = 1
    while true do
        if L["wave" .. c .. "ID"] then
            local w = createWave(L["wave" .. c .. "ID"])
            t.total = t.total + w.total
            w.hpFactor = L["wave" .. c .. "HpFactor"]
            w.bulletAttackFactor = L["wave" .. c .. "BulletAttackFactor"]
            table.insert(t, w)
        else
            break
        end
        c = c + 1
    end
--    print("level[" .. id .. "].total = " .. t.total)
    return t
end

local function createRandomWave(id)
    local t = {}
    local L1 = endlessLevel.rWave1[id]
    local L2 = endlessLevel.rWave2 
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
            c = c + 1
        end
        t[i] = t1
    end
    return t
end

local file = io.open("dataEndlessLevel.lua", "w")
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
for i, v in pairs(endlessLevel.level) do
    lt[i] = createLevel(i)
end
table2File(lt)

local li = {}
file:write("local rWave = ")
for i,v in pairs(endlessLevel.rWave1) do
    li[i] = createRandomWave(i)
end
table2File(li)

--file:write("local AIChart = ")
--table2File(endlessLevel.AIChart)

file:write("local dataLevel = {}\n\n")
file:write("function dataLevel.getLevel(id)\n")
file:write("\treturn clone(level[id])\n")
file:write("end\n\n")
file:write("function dataLevel.getRWave(id)\n")
file:write("\treturn clone(rWave[id])\n")
file:write("end\n\n")
--file:write("function dataLevel.getAIChart()\n")
--file:write("\treturn clone(AIChart)\n")
--file:write("end\n\n")

file:write("return dataLevel")

file:close()