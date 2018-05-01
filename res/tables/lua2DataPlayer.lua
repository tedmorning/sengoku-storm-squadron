-- build hexunzhen
-- 机体，僚机，副武器的数据结构
local tample = {
    -- 武器组合1
    [1] = {
        -- 每秒子弹总数量
        bulletQuantity = nil,
        -- 激光
        laser = {
            texture = nil,
            x = nil,
            y = nil,
            scaleX = nil,
            attack = nil,
            quantity = nil,
        },
        -- 武器1
        {
            -- 首次发射时间
            shootFirstTime = nil,
            -- 发射频率
            shootFrequence = nil,
            -- 连发数量
            shootQuantity = nil,
            -- 恢复时间
            shootResumeTime = nil,
            -- 子弹排列
            bulletQueue = {
                shape = nil,
                distance = nil,
                quantity = nil,
                interval = nil,
                radius = nil,
                angle = nil
            },
            -- 子弹类型
            bulletType = {
                -- 血量
                hp = nil,
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
            time = nil 
        },
        -- 武器2
        [2] = {
        -- ...
        },
        --        ...
    },
    -- 武器组合2
    [2] = {
    --    ...
    },
    -- 武器组合3
    [3] = {
    --    ...
    },
    -- 武器组合4
    [4] = {
    --    ...
    },
    -- 武器组合5
    [5] = {
    --    ...
    },
}

-- 技能
local tampleSkill = {
    -- 技能id
    skillID = nil,
    -- 参数1
    parameter1 = nil,
    -- 参数2
    parameter2 = nil,
}

local function createWeapon(id)
    local t = {}
    local W = player.weapon[id]
    if W == nil then
        print("Oh shit! Cann't found weapon id is " .. id .. "\n")
    end
    -- 首次发射时间
    t.shootFirstTime = math.floor(W.shootFirstTime * 60)
    -- 发射频率
    t.shootFrequence = math.floor(W.shootFrequence * 60)
    -- 连射模式有效，发射子弹的次数
    t.shootQuantity = W.shootQuantity
    -- 恢复时间
    if W.shootResumeTime then
        t.shootResumeTime = math.floor(W.shootResumeTime * 60)
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
    -- 武器角度，玩家武器角度默认0度，即垂直向上
    t.angle = 0
    if W.angle then
        t.angle = W.angle
    end
    -- 是否播放特效
    t.isEfficacy = W.isEfficacy
    
    -- 子弹类型
    t.bulletType = {
        -- 是否跟踪
        isSeek = W.isSeek,
        -- 纹理
        texture = player.bulletType[W.bulletTypeID].texture,
        -- 动画帧数量
        quantity = player.bulletType[W.bulletTypeID].quantity,
        -- 缩放
        scaleX = player.bulletType[W.bulletTypeID].scaleX,
        scaleY = player.bulletType[W.bulletTypeID].scaleY,
        -- 攻击力
        attack = player.bulletType[W.bulletTypeID].attack,
        -- 速度
        rate = player.bulletType[W.bulletTypeID].rate,
        -- 血量
        hp = player.bulletType[W.bulletTypeID].hp,
        -- 子弹旋转
        rotation = player.bulletType[W.bulletTypeID].rotation,
    }
    -- 由于有一个if语句所以无法在子弹类型的表里面
    -- 子弹运动延时
    t.bulletType.delay = 0
    if W.delay then
        t.bulletType.delay = math.floor(W.delay * 60)
    end
    -- 子弹初速度
    t.bulletType.initRate = player.bulletType[W.bulletTypeID].rate
    -- 子弹加速度
    t.bulletType.acc = 0
    if player.bulletType[W.bulletTypeID].initTime and player.bulletType[W.bulletTypeID].initRate then
        t.bulletType.initRate = player.bulletType[W.bulletTypeID].initRate
        local initTime = math.floor(player.bulletType[W.bulletTypeID].initTime * 60)
        t.bulletType.acc = (player.bulletType[W.bulletTypeID].rate - 
                            player.bulletType[W.bulletTypeID].initRate) /
                            initTime
    end
    
    -- 子弹排列
    t.bulletQueue = {
        shape = player.bulletQueue[W.bulletQueueID].shape,
        distance = player.bulletQueue[W.bulletQueueID].distance,
        quantity = player.bulletQueue[W.bulletQueueID].quantity,
        interval = player.bulletQueue[W.bulletQueueID].interval,
        radius = player.bulletQueue[W.bulletQueueID].radius,
        angle = player.bulletQueue[W.bulletQueueID].angle}
    t.time = math.floor(W.shootFrequence * 60)
    
    -- 计算武器每秒发射子弹的数量
    -- 竖线，横线，圆心，不规则
    if t.bulletQueue.shape == 1 or t.bulletQueue.shape == 2 or t.bulletQueue.shape == 4 or t.bulletQueue.shape == 5 then
        t.bulletQuantity = t.bulletQueue.quantity
    -- 扇形
    elseif t.bulletQueue.shape == 3 then
        t.bulletQuantity = t.bulletQueue.quantity * t.bulletQueue.radius / t.bulletQueue.interval
    end
    if W.shootQuantity and W.shootResumeTime then
        t.bulletQuantity = t.bulletQuantity * W.shootQuantity / 
                           (W.shootFrequence * (W.shootQuantity - 1) + W.shootResumeTime)
    else
        t.bulletQuantity = t.bulletQuantity * (1 / W.shootFrequence)
    end
--    print("weapon.id = " .. id .. ", t.bulletQuantity = " .. t.bulletQuantity)
    return t
end

local function createFire(F)
    local t = {}
    for i = 1, 5 do
        local c = 1
        local WS = player.weaponSet[F["weaponSetID" .. i]]
        local weapon = {}
        -- 每个武器组合每秒子弹数量
        weapon.bulletQuantityMain = 0
        weapon.bulletQuantity = 0
        while true do
            if WS["weapon" .. c .. "ID"] then
                local w = createWeapon(WS["weapon" .. c .. "ID"])
                w.x = WS["weapon" .. c .. "X"]
                w.y = WS["weapon" .. c .. "Y"]
                table.insert(weapon, w)
                -- 累加武器子弹
                if WS["weapon" .. c .. "isMain"] then
                    weapon.bulletQuantityMain = weapon.bulletQuantityMain + w.bulletQuantity
                    w.isMain = 1
                else
                    weapon.bulletQuantity = weapon.bulletQuantity + w.bulletQuantity
                end
            else
                break
            end
            c = c + 1
        end
        local L = player.laser[WS.laserID]
        if L then
            weapon.laser = {
                texture = L.texture,
                x = WS.laserX,
                y = WS.laserY,
                scaleX = L.scaleX,
                attack = L.attack,
                quantity = L.quantity,
            }
            -- 累加武器子弹，激光武器每秒子弹数量为60
            if WS["laserIsMain"] then
                weapon.bulletQuantityMain = weapon.bulletQuantityMain + 60
                weapon.laser.isMainLaser = 1
            else
                weapon.bulletQuantity = weapon.bulletQuantity + 60
            end
        end
        table.insert(t, weapon)
    end
    return t
end

require "data2"
local file = io.open("dataPlayer.lua", "w")
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

local body = {}
file:write("local body = ")
for i, v in ipairs(player.body) do
    body[i] = createFire(v)
end
table2File(body)

file:write("local dataPlayer = {}\n\n")
file:write("function dataPlayer.getBody(id)\n")
file:write("\treturn clone(body[id])\n")
file:write("end\n\n")
file:write("return dataPlayer")
file:close()