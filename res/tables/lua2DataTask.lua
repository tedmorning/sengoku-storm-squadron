local t1 = {
    id = nil,
    type = nil,
    level = nil,
    star = nil,
    diamond = nil,
    describe = nil,
}
local t2 = {
    id = nil,
    type = nil,
    level = nil,
    star = nil,
    diamond = nil,
    describe = nil,
}
local t3 = {
    id = nil,
    type = nil,
    level = nil,
    diamond = nil,
    describe = nil,
}
local t4 = {
    id = nil,
    type = nil,
    num = nil,
    diamond = nil,
    describe = nil,
}
local t5 = {
    id = nil,
    type = nil,
    num = nil,
    energy = nil,
    describe = nil,
}

require "data2"

local file = io.open("dataTask.lua", "w")
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

file:write("local task1 = ")
table2File(task.task1)

file:write("local task2 = ")
table2File(task.task2)

file:write("local task3 = ")
table2File(task.task3)

file:write("local task4 = ")
table2File(task.task4)

file:write("local task5 = ")
table2File(task.task5)

file:write("local dataTask = {}\n\n")

file:write("function dataTask.getTask1(id)\n")
file:write("\treturn clone(task1[id])\n")
file:write("end\n\n")

file:write("function dataTask.getTask2(id)\n")
file:write("\treturn clone(task2[id])\n")
file:write("end\n\n")

file:write("function dataTask.getTask3(id)\n")
file:write("\treturn clone(task3[id])\n")
file:write("end\n\n")

file:write("function dataTask.getTask4(id)\n")
file:write("\treturn clone(task4[id])\n")
file:write("end\n\n")

file:write("function dataTask.getTask5(id)\n")
file:write("\treturn clone(task5[id])\n")
file:write("end\n\n")

file:write("return dataTask")

file:close()