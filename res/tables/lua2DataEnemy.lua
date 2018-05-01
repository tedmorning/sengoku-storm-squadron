-- build hexunzhen
-- 敌机数据结构
local tampleEnemy = {
    -- 纹理
    texture = {
        -- 机体纹理
        texture = nil,
        -- 喷射器纹理 与机体的X距离 Y距离 角度
        {texture = nil, x = nil, y = nil, angle = nil},
    -- 喷射器纹理
    --        ...
    },
    -- 垂直镜像
    isFlippedY = nil,
    -- 血条样式
    hpBar = nil,
    -- 缩放
    scale = nil,
    -- 血量
    hp = nil,
    -- 运动速度
    rate = nil,
    -- 运动轨迹
    trace = {
        shape = nil,
        distance = nil,
        angle = nil,
        type = nil,
    },
    -- 运动区域
    regionID = nil,
    -- 碰撞伤害
    attack = nil,
    -- 子弹是否跟随机体消失
    isDisappear = nil,
    -- 掉落
    leave = {
        {rewardID = nil, rewardProbability = nil},
    -- ...
    },
    -- 激光
    laser = {
        {
            -- 首次发射时间
            firstShootTime = nil,
            -- 发射频率
            shootFrequence = nil,
            -- 延时
            delay = nil,
            -- 纹理
            texture = nil,
            -- 动画帧数
            quantity = nil,
            -- 水平拉伸比例
            scaleX = nil,
            -- 攻击力
            attack = nil,
            -- x坐标
            x = nil,
            -- y坐标
            y = nil,
        },  
        -- ...
    },
    -- 武器
    weapon = {
        {
            -- 首次发射时间
            shootFirstTime = nil,
            -- 发射频率
            shootFrequence = nil,
            -- 连发数量
            shootQuantity = nil,
            -- 恢复时间
            shootResumeTime = nil,
            -- 散开延时
            disperseDelay = nil,
            -- 连射暂停运动
            shootWait = nil,
            -- 子弹排列
            bulletQueue = {
                -- 形状
                shape = nil,
                -- 枪口距离
                distance = nil,
                -- 数量
                quantity = nil,
                -- 间隔
                interval = nil,
                -- 半径
                radius = nil,
                -- 角度
                angle = nil,
                --子弹整体角度偏移
                rotation = nil,
                -- 圆形散开排列
                isDisperse = nil,
            },
            -- 子弹类型
            bulletType = {
                -- 纹理
                texture = nil,
                -- 动画帧数
                quantity = nil,
                -- 缩放
                scaleX = nil,
                scaleY = nil,
                -- 攻击力
                attack = nil,
                -- 速度
                rate = nil,
                -- 初速度
                initRate = nil,
                -- 加速度
                acc = nil,
                -- 血量
                hp = nil,
                -- 运动延时
                delay = nil,
                -- 是否追踪
                isSeek = nil,
            },
            -- 是否锁定
            isLock = nil,
            -- 是否散开
            isDisperse = nil,
            -- 角度
            angle = nil,
            -- 是否有特效
            isEfficacy = nil,
            -- x坐标
            x = nil,
            -- y坐标
            y = nil,
            -- 定时器
            time = nil },
    --        ...
    }
}

local function createWeapon(id, argv)
    local t = {}
    local W = enemy.weapon[id]
    local oldBulletTypeID = W.bulletTypeID
    local oldBulletQueueID = W.bulletQueueID
    if W == nil then
        print("Oh shit! Cann't found the weapon id is " .. id .. "\n")
    end
    if argv.bulletTypeID then
        W.bulletTypeID = argv.bulletTypeID
    end
    if argv.bulletQueueID then
        W.bulletQueueID = argv.bulletQueueID
    end
    
    -- 首次发射时间
    t.shootFirstTime = math.floor(W.shootFirstTime * 60)
    if argv.shootFirstTime then
        t.shootFirstTime = t.shootFirstTime + math.floor(argv.shootFirstTime * 60)
    end
    -- 发射频率
    t.shootFrequence = math.floor(W.shootFrequence * 60)
    -- 连射模式的数量
    if W.shootQuantity then
        t.shootQuantity = W.shootQuantity
        if argv.shootQuantity then
            t.shootQuantity = t.shootQuantity + argv.shootQuantity
        end
    end
    if W.shootResumeTime then
        t.shootResumeTime = math.floor(W.shootResumeTime * 60)
    end
    if argv.shootResumeTime then
        t.shootResumeTime = t.shootResumeTime + math.floor(argv.shootResumeTime * 60)
    end
    -- 处于连射模式有效，是否停顿
    t.shootWait = 0
    if W.shootWait then
        t.shootWait = W.shootWait
    end
    -- 是否锁定
    t.isLock = W.isLock
    -- 是否散开
    t.isDisperse = W.isDisperse
    -- 散开延时，说白就是改变子弹发现
    t.disperseDelay = 0
    if W.disperseDelay then
        t.disperseDelay = math.floor(W.disperseDelay * 60)
    end
    -- 武器角度，如果没有设置，默认180，即垂直向下
    t.angle = 180
    if W.angle then
        t.angle = W.angle
    end
    -- 是否播放特效
    t.isEfficacy = W.isEfficacy
    
    -- 子弹类型
    t.bulletType = {
        -- 素材名字
        texture = enemy.bulletType[W.bulletTypeID].texture,
        -- 动画帧数量
        quantity = enemy.bulletType[W.bulletTypeID].quantity,
        -- 单颗子弹攻击力
        attack = enemy.bulletType[W.bulletTypeID].attack,
        -- 子弹速度
        rate = enemy.bulletType[W.bulletTypeID].rate,
        -- 子弹血量
        hp = enemy.bulletType[W.bulletTypeID].hp,
        -- 缩放倍数
        scaleX = enemy.bulletType[W.bulletTypeID].scaleX,
        scaleY = enemy.bulletType[W.bulletTypeID].scaleY,
        -- 是否跟踪
        isSeek = W.isSeek,
        -- 子弹旋转
        rotation = enemy.bulletType[W.bulletTypeID].rotation,
    }
    -- 特殊子弹轨迹
    if enemy.bulletType[W.bulletTypeID].bulletTraceID then
        t.bulletType.bulletTrace = enemy.bulletTrace[enemy.bulletType[W.bulletTypeID].bulletTraceID]
    end
    -- 由于有一个if语句所以无法在子弹类型的表里面
    -- 子弹运动延时
    t.bulletType.delay = 0
    if W.delay then
        t.bulletType.delay = math.floor(W.delay * 60)
    end
    -- 子弹初速度
    t.bulletType.initRate = enemy.bulletType[W.bulletTypeID].rate
    -- 子弹加速度
    t.bulletType.acc = 0
    if enemy.bulletType[W.bulletTypeID].initTime and enemy.bulletType[W.bulletTypeID].initRate then
        t.bulletType.initRate = enemy.bulletType[W.bulletTypeID].initRate
        local initTime = math.floor(enemy.bulletType[W.bulletTypeID].initTime * 60)
        t.bulletType.acc = (enemy.bulletType[W.bulletTypeID].rate -
                            enemy.bulletType[W.bulletTypeID].initRate) /
                            initTime
    end
    
    -- 子弹排列
    t.bulletQueue = {
        -- 排列形状
        shape = enemy.bulletQueue[W.bulletQueueID].shape,
        -- 枪口距离
        distance = enemy.bulletQueue[W.bulletQueueID].distance,
        -- 数量
        quantity = enemy.bulletQueue[W.bulletQueueID].quantity,
        -- 子弹间隔，不同形状不同含义
        interval = enemy.bulletQueue[W.bulletQueueID].interval,
        -- 半径
        radius = enemy.bulletQueue[W.bulletQueueID].radius,
        -- 角度
        angle = enemy.bulletQueue[W.bulletQueueID].angle,
        -- 角度偏移
        rotation = enemy.bulletQueue[W.bulletQueueID].rotation,
        -- 圆形散开排列
        isDisperse = enemy.bulletQueue[W.bulletQueueID].isDisperse,
    }
    
    -- 计时器，辅助用的
    t.time = math.floor(W.shootFrequence * 60)
    
    -- 还原
    if argv.bulletTypeID then
        W.bulletTypeID = oldBulletTypeID
    end
    if argv.bulletQueueID then
        W.bulletQueueID = oldBulletQueueID
    end
    
    -- 新加的组合
    if W.unitAngle and W.unitQuantity and W.unitTime and W.unitWait then
        t.unitAngle = W.unitAngle
        t.unitQuantity = W.unitQuantity
        t.unitTime = math.floor(W.unitTime * 60)
        t.unitWait = W.unitWait
        t.shootQuantity = t.shootQuantity + 1
        
        -- 辅助计算
        t.unitInitAngle = W.angle
        t.unitShootState = 1
        t.unitTempTime = t.unitTime - 1
        t.unitTempQuantity = 0
        
        if argv.unitAngle then
            if t.unitAngle > 0 then
                t.unitAngle = t.unitAngle + argv.unitAngle
            else
                t.unitAngle = t.unitAngle - argv.unitAngle
            end
        end
        if argv.unitQuantity then
            t.unitQuantity = t.unitQuantity + argv.unitQuantity
        end
    end
    
    return t
end

local function createWeaponSet(id)
    local WEAPONSET = enemy.weaponSet[id]
    local weaponSet = {}
    local t = {}
    t.bulletTypeID = WEAPONSET.bulletTypeID
    t.bulletQueueID = WEAPONSET.bulletQueueID
    t.shootFirstTime = WEAPONSET.shootFirstTime
    t.shootResumeTime = WEAPONSET.shootResumeTime
    t.shootQuantity = WEAPONSET.shootQuantity
    t.unitAngle = WEAPONSET.unitAngle
    t.unitQuantity = WEAPONSET.unitQuantity
    for i = WEAPONSET.id1, WEAPONSET.id2 do
        local weapon = createWeapon(i, t)
        table.insert(weaponSet, weapon)
    end
    return weaponSet
end

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

local function createEnemy(id)
    local t = {}
    local E = enemy.enemy[id]
    
    --add liuchao 尾部喷射火焰
    local function createJet()
        local tab = {}
        local a = enemy.texture[E.texture]
        tab.texture = a.texture
        tab.isAction = a.isAction
        local c = 1
        while a["jet" .. c .. "Texture"] ~= nil do
            local temp = {texture = a["jet" .. c .. "Texture"],x = a["jet" .. c .. "X"],y = a["jet" .. c .. "Y"],angle = a["jet" .. c .. "Angle"]}
            c = c + 1
            table.insert(tab,temp)
        end
        return tab
    end
    t.texture = createJet()
    
    t.isFlippedY = E.isFlippedY
    
    -- 是否boss
    t.isBoss = E.isBoss
    -- 变身id
    t.nextID = E.nextID
    -- 血条样式
    t.hpBar = E.hpBar
    -- 素材缩放
    t.scale = E.scale
    -- 血量
    t.hp = E.hp
    -- 运动速度
    t.rate = E.rate
    -- 初速度
    t.initRate = E.rate
    if E.initRate then
        t.initRate = E.initRate
    end
    if E.initTime then
        t.initTime = math.floor(E.initTime * 60)
    end
    t.trace = {
        shape = enemy.trace[E.traceID].shape,
        distance = enemy.trace[E.traceID].distance,
        angle = enemy.trace[E.traceID].angle,
        type = enemy.trace[E.traceID].type,
    }
    -- 运动区域
    t.regionID = E.regionID
    -- 碰撞攻击力
    t.attack = E.factor * E.hp  
    -- 子弹是否跟随机体消失
    t.isDisappear = E.isDisappear
    t.leave = createLeave(id)
    t.weapon = {}
    local c = 1
    while true do
        if E["weaponSet" .. c .. "ID"] then
            local weaponSet = {id = E["weaponSet" .. c .. "ID"], x = E["weaponSet" .. c .. "X"], y = E["weaponSet" .. c .. "Y"]}
            table.insert(t.weapon, weaponSet)
        else
            break
        end
        c = c + 1
    end
    t.laser = {}
    c = 1
    while true do
        if E["laser" .. c .. "ID"] then
            local lt = {}
            local L = enemy.laser[E["laser" .. c .. "ID"]]
            -- 首次发射时间
            lt.firstShootTime = math.ceil(L.firstShootTime * 60)
            -- 发射频率
            lt.shootFrequence = math.ceil(L.shootFrequence * 60)
            -- 延时
            lt.delay = math.ceil(L.delay * 60)
            -- 纹理
            lt.texture = L.texture
            -- 动画帧数
            lt.quantity = L.quantity
            -- 水平拉伸比例
            lt.scaleX = L.scaleX
            -- 攻击力
            lt.attack = L.attack
            -- x坐标
            lt.x = E["laser" .. c .. "X"]
            -- y坐标
            lt.y = E["laser" .. c .. "Y"]
            table.insert(t.laser, lt)
        else
            break
        end
        c = c + 1
    end
    return t
end

require "data2"
local file = io.open("dataEnemy.lua", "w")
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

local f = io.open("data1.lua", "r")
for line in f:lines() do
    file:write(line .. "\n")
end
f:close()

local et = {}
file:write("local enemy = ")
for i, v in pairs(enemy.enemy) do
    et[i] = createEnemy(i)
end
table2File(et)

local wst = {}
file:write("local weaponSet = ")
for i, v in pairs(enemy.weaponSet) do
    wst[i] = createWeaponSet(i)
end
table2File(wst)

local w = {}
local function createWarning(id)
    local t = {}
    local d = enemy.warning[id]
    t.firstTime = math.floor(d.firstTime * 60)
    t.showTime = d.showTime
    t.cd = math.floor(d.cd * 60)
    t.x = d.x
    t.y = d.y
    t.scale = d.scale
    t.texture = d.texture
    t.quantity = d.quantity
    
    return t
end
file:write("local warning = ")
for i, v in pairs(enemy.warning) do
    w[i] = createWarning(i)
end
table2File(w)

file:write("local dataEnemy = {}\n\n")
file:write("function dataEnemy.getEnemy(id)\n")
file:write("\treturn clone(enemy[id])\n")
file:write("end\n\n")
file:write("function dataEnemy.getWeaponSet(id)\n")
file:write("\treturn clone(weaponSet[id])\n")
file:write("end\n\n")
file:write("function dataEnemy.getRegion(id)\n")
file:write("\treturn clone(region[id])\n")
file:write("end\n\n")
file:write("function dataEnemy.getPosition(id)\n")
file:write("\treturn clone(position[id])\n")
file:write("end\n\n")
file:write("function dataEnemy.getWarning(id)\n")
file:write("\treturn clone(warning[id])\n")
file:write("end\n\n")
file:write("return dataEnemy")
file:close()