--table's number
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

--table's keys
function table.keys(hashtable)
    local keys = {}
    for k, v in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end

--table's values
function table.values(hashtable)
    local values = {}
    for k, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end

--
function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

-- 在目标表格的指定位置插入来源表格，如果没有指定位置则连接两个表格
-- @function [parent=#table] insertto
-- @param table dest 目标表格
-- @param table src 来源表格
-- @param integer begin 插入位置,默认最后

--[[--

在目标表格的指定位置插入来源表格，如果没有指定位置则连接两个表格

~~~ lua

local dest = {1, 2, 3}
local src  = {4, 5, 6}
table.insertto(dest, src)
-- dest = {1, 2, 3, 4, 5, 6}

dest = {1, 2, 3}
table.insertto(dest, src, 5)
-- dest = {1, 2, 3, nil, 4, 5, 6}

~~~

]]
function table.insertto(dest, src, begin)
	begin = checkint(begin)
	if begin <= 0 then
		begin = #dest + 1
	end

	local len = #src
	for i = 0, len - 1 do
		dest[i + begin] = src[i + 1]
	end
end

--table dump
function table.dump(t)
    for k, v in pairs(t) do
        logGreen("--->>>key:"..tostring(k).." --->>>value:"..tostring(v))
    end
end

-- 从表格中查找指定值，返回其索引，如果没找到返回 false
-- @function [parent=#table] indexof
-- @param table array 表格
-- @param mixed value 要查找的值
-- @param integer begin 起始索引值
-- @return integer#integer

--[[--

从表格中查找指定值，返回其索引，如果没找到返回 false

~~~ lua

local array = {"a", "b", "c"}
print(table.indexof(array, "b")) -- 输出 2

~~~

]]

function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
	return false
end

-- 从表格中删除指定值，返回删除的值的个数
-- @function [parent=#table] removebyvalue
-- @param table array 表格
-- @param mixed value 要删除的值
-- @param boolean removeall 是否删除所有相同的值
-- @return integer#integer

--[[--

从表格中删除指定值，返回删除的值的个数

~~~ lua

local array = {"a", "b", "c", "c"}
print(table.removebyvalue(array, "c", true)) -- 输出 2

~~~

]]

function table.removebyvalue(array, value, removeall)
    local c, i, max = 0, 1, #array
    while i <= max do
        if array[i] == value then
            table.remove(array, i)
            c = c + 1
            i = i - 1
            max = max - 1
            if not removeall then break end
        end
        i = i + 1
    end
    return c
end

-- 对表格中每一个值执行一次指定的函数，并用函数返回值更新表格内容
-- @function [parent=#table] map
-- @param table t 表格
-- @param function fn 函数

--[[--

对表格中每一个值执行一次指定的函数，并用函数返回值更新表格内容

~~~ lua

local t = {name = "dualface", comp = "chukong"}
table.map(t, function(v, k)
    -- 在每一个值前后添加括号
    return "[" .. v .. "]"
end)

-- 输出修改后的表格内容
for k, v in pairs(t) do
    print(k, v)
end

-- 输出
-- name [dualface]
-- comp [chukong]

~~~

fn 参数指定的函数具有两个参数，并且返回一个值。原型如下：

~~~ lua

function map_function(value, key)
    return value
end

~~~

]]

function table.map(t, fn)
    for k, v in pairs(t) do
        t[k] = fn(v, k)
    end
end

-- 对表格中每一个值执行一次指定的函数，但不改变表格内容
-- @function [parent=#table] walk
-- @param table t 表格
-- @param function fn 函数

--[[--

对表格中每一个值执行一次指定的函数，但不改变表格内容

~~~ lua

local t = {name = "dualface", comp = "chukong"}
table.walk(t, function(v, k)
    -- 输出每一个值
    print(v)
end)

~~~

fn 参数指定的函数具有两个参数，没有返回值。原型如下：

~~~ lua

function map_function(value, key)

end

~~~

]]
function table.walk(t, fn)
    for k,v in pairs(t) do
        fn(v, k)
    end
end

-- 对表格中每一个值执行一次指定的函数，如果该函数返回 false，则对应的值会从表格中删除
-- @function [parent=#table] filter
-- @param table t 表格
-- @param function fn 函数

--[[--

对表格中每一个值执行一次指定的函数，如果该函数返回 false，则对应的值会从表格中删除

~~~ lua

local t = {name = "dualface", comp = "chukong"}
table.filter(t, function(v, k)
    return v ~= "dualface" -- 当值等于 dualface 时过滤掉该值
end)

-- 输出修改后的表格内容
for k, v in pairs(t) do
    print(k, v)
end

-- 输出
-- comp chukong

~~~

fn 参数指定的函数具有两个参数，并且返回一个 boolean 值。原型如下：

~~~ lua

function map_function(value, key)
    return true or false
end

~~~

]]

function table.filter(t, fn)
    for k, v in pairs(t) do
        if not fn(v, k) then t[k] = nil end
    end
end

-- 遍历表格，确保其中的值唯一
-- @function [parent=#table] unique
-- @param table t 表格
-- @param boolean bArray t是否是数组,是数组,t中重复的项被移除后,后续的项会前移
-- @return table#table  包含所有唯一值的新表格

--[[--

遍历表格，确保其中的值唯一

~~~ lua

local t = {"a", "a", "b", "c"} -- 重复的 a 会被过滤掉
local n = table.unique(t)

for k, v in pairs(n) do
    print(v)
end

-- 输出
-- a
-- b
-- c

~~~

]]

function table.unique(t, bArray)
    local check = {}
    local n = {}
    local idx = 1
    for k, v in pairs(t) do
        if not check[v] then
            if bArray then
                n[idx] = v
                idx = idx + 1
            else
                n[k] = v
            end
            check[v] = true
        end
    end
    return n
end
