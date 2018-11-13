--
-- 一些功能性的全局方法
-- Author: zhouhongjie@apowo.com
-- Date: 2015-03-20 10:25:49
--

DATA_CONFIG_PACKAGE = DATA_CONFIG_PACKAGE or "app.config"

require('libra.utils.dateTimeUtil')
display45 = require("libra.utils.display45")
sort45 = require('libra.utils.sort45').new()

--[[--

检查并尝试转换为数值，如果无法转换则返回 0

@param mixed value 要检查的值
@param [integer base] 进制，默认为十进制

@return number

]]
function checknumber(value, base)
    return tonumber(value, base) or 0
end

--[[--

检查并尝试转换为整数，如果无法转换则返回 0

@param mixed value 要检查的值

@return integer

]]
function checkint(value)
    return Mathf.Round(checknumber(value))
end

--[[--

检查并尝试转换为布尔值，除了 nil 和 false，其他任何值都会返回 true

@param mixed value 要检查的值

@return boolean

]]
function checkbool(value)
    return (value ~= nil and value ~= false)
end

--[[--

检查值是否是一个表格，如果不是则返回一个空表格

@param mixed value 要检查的值

@return table

]]
function checktable(value)
    if type(value) ~= "table" then value = {} end
    return value
end

--[[--

如果表格中指定 key 的值为 nil，或者输入值不是表格，返回 false，否则返回 true

@param table hashtable 要检查的表格
@param mixed key 要检查的键名

@return boolean

]]
function isset(hashtable, key)
    local t = type(hashtable)
    return (t == "table" or t == "userdata") and hashtable[key] ~= nil
end

--[[--

深度克隆一个值

~~~ lua

-- 下面的代码，t2 是 t1 的引用，修改 t2 的属性时，t1 的内容也会发生变化
local t1 = {a = 1, b = 2}
local t2 = t1
t2.b = 3    -- t1 = {a = 1, b = 3} <-- t1.b 发生变化

-- clone() 返回 t1 的副本，修改 t2 不会影响 t1
local t1 = {a = 1, b = 2}
local t2 = clone(t1)
t2.b = 3    -- t1 = {a = 1, b = 2} <-- t1.b 不受影响

~~~

@param mixed object 要克隆的值

@return mixed

]]
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function handler(obj, method)
    return function(...)
        return method(obj, ...)
    end
end

--- 使用二分法查找
-- @param table 数据表
-- @param key 查找的键，默认是type
-- @param val 查找的值
-- @return 数据表中的元素
function queryByType(table, key, val)
	if table then
		key = key or 'type'
		local leftIndex = 1
		local middleIndex = 1
		local rightIndex = #table

		while leftIndex <= rightIndex do
			midIndex= math.floor((leftIndex + rightIndex)/2)
			local midItem = table[midIndex]

			if midItem[key] == val then
				return midItem
			elseif val < midItem[key] then
				rightIndex = midIndex - 1
			else
				leftIndex = midIndex + 1
			end
		end
	end
end

--- 序列化一个对象
function serialize(obj)
	local lua = ""
	local t = type(obj)
	if t == "number" then
		lua = lua .. obj
	elseif t == "boolean" then
		lua = lua .. tostring(obj)
	elseif t == "string" then
		lua = lua .. string.format("%q", obj)
	elseif t == "table" then
		lua = lua .. "{"
		local key = nil
		for k, v in pairs(obj) do
			if type(k) == "table" then
				key = serialize(k)
			else
				key = k
			end
			if type(key) == "number" then
				lua = lua .. serialize(v) .. ","
			else
				lua = lua .. key .. "=" .. serialize(v) .. ","
			end
		end
		-- 去掉最后一个逗号
		if string.sub(lua, -1) == ',' then
			lua = string.sub(lua, 1, -2)
		end
		local metatable = getmetatable(obj)
		if metatable ~= nil and type(metatable.__index) == "table" then
			for k, v in pairs(metatable.__index) do
				lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
			end
		end
		lua = lua .. "}"
	elseif t == "nil" then
		return nil
	else
		error("can not serialize a " .. t .. " type.")
	end
	return lua
end

--- 反序列化一个对象
function unserialize(lua)
	local t = type(lua)
	if t == "nil" or lua == "" then
		return nil
	elseif t == "number" or t == "string" or t == "boolean" then
		lua = tostring(lua)
	else
		error("can not unserialize a " .. t .. " type.")
	end
	lua = "return " .. lua
	local func = loadstring(lua)
	if func then
		return func()
	end
end

-- 判断一个点在不在多边形里
function pointInRegion(x, y, regionPoints)
	-- 定义变量，统计目标点向右画射线与多边形相交次数
	local cross = 0
	local p1, p2, tmpX
	local l = #regionPoints
	-- 遍历多边形每一个节点
	for i = 1, l do
		-- p1是这个节点，p2是下一个节点，两点连线是多边形的一条边
		p1 = regionPoints[i]
		p2 = regionPoints[i == l and 1 or i + 1]
		-- 如果这条边是水平的，跳过
		-- 如果目标点低于这个线段，跳过
		-- 如果目标点高于这个线段，跳过
		-- 那么下面的情况就是：如果过p1画水平线，过p2画水平线，目标点在这两条线中间
		if p1.y ~= p2.y and y >= math.min(p1.y, p2.y) and y < math.max(p1.y, p2.y) then
			-- 这段的几何意义是 过目标点，画一条水平线，tmpX是这条线与多边形当前边的交点x坐标
			tmpX = (y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x
			if tmpX > x then
				-- 如果交点在右边，统计加一。这等于从目标点向右发一条射线（ray），与多边形各边的相交（crossing）次数
				cross = cross + 1
			end
		end
	end
	-- 如果是奇数，说明在多边形里
	-- 否则在多边形外 或 边上
	return cross % 2 == 1
end

--===========================================================================================

--- 根据type读取相应的配置文件
-- @param propType 物品Type
-- @param configName 配置文件，取lua文件名
-- @return 返回配置文件中物品的配置信息
function getConfig(propType, configName, compareStr)
	compareStr = compareStr and compareStr or 'id'
	local config = require(DATA_CONFIG_PACKAGE .. '.' .. configName)
	if config then
		return queryByType(config, compareStr, checkint(propType))
	end
end

--===========================================================================================

-- function strToTable(str)
-- 	if str == "" then
-- 		return { }, { }
-- 	end
-- 	local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
-- 	local strLen = #str
-- 	local index = strLen
-- 	local indexList = { }
-- 	local strList = { }
-- 	for i = 1, string.len(str) do
-- 		local tmp = string.byte(str, -index)
-- 		local arrLen = #arr
-- 		while arr[arrLen] do
-- 			if tmp == nil then
-- 				break
-- 			end
-- 			if tmp >= arr[arrLen] then
-- 				index = index - arrLen
-- 				break
-- 			end
-- 			arrLen = arrLen - 1
-- 		end
-- 		tmp = strLen - index
-- 		if table.indexof(indexList, tmp) == false then
-- 			indexList[#indexList + 1] = tmp
-- 			if #indexList == 1 then
-- 				strList[#strList + 1] = string.sub(str, 1, tmp)
-- 			else
-- 				strList[#strList + 1] = string.sub(str, indexList[#indexList - 1] + 1, indexList[#indexList])
-- 			end
-- 		end
-- 	end
-- 	return strList, indexList
-- end

--- 获取带有中文的string的长度
-- function getStringLength(str)
-- 	local strTable, indexTable = strToTable(str)
-- 	return #indexTable
-- end

--===========================================================================================

--- 从 package.path 中查找指定模块的文件名，如果失败返回 nil
-- function findModulePath(moduleName)
-- 	for k, v in pairs(package.loaded) do
-- 		if string.find(k, moduleName) then
-- 			return k
-- 		end
-- 	end
-- end

--- 获取目标目录下所有的文件列表
-- function getpathes(rootpath, pathes)
-- 	require "lfs"
-- 	local pathes = pathes or { }
-- 	local ret, files, iter = pcall(lfs.dir, rootpath)
-- 	if not ret then
-- 		return pathes
-- 	end
-- 	for entry in files, iter do
-- 		local next = false
-- 		if entry ~= '.' and entry ~= '..' then
-- 			local path = rootpath .. '/' .. entry
-- 			local attr = lfs.attributes(path)
-- 			if attr == nil then
-- 				next = true
-- 			end

-- 			if next == false then
-- 				if attr.mode == 'directory' then
-- 					getpathes(path, pathes)
-- 				else
-- 					table.insert(pathes, path)
-- 				end
-- 			end
-- 		end
-- 		next = false
-- 	end
-- 	return pathes
-- end

--===========================================================================================

-- function getNumberLength(num)
-- 	if num == 0 then return 0 end
-- 	return 1 + getNumberLength(checkint(num / 10))
-- end

--===========================================================================================


--字符串中每个字符后加换行符"\n", 包括其中含有中文字符

-- function addLineBreak(obj)
-- 	local res = ""

-- 	if "string" == type(obj) then
-- 		local pos = 1
-- 		while pos <= #obj do
-- 			local tmp = ""
-- 			if string.byte(obj,pos) > 127 then -- 判断是否是中文字符
-- 				tmp = string.sub(obj, pos, pos + 2)
-- 				pos = pos + 3
-- 			else
-- 				tmp = string.sub(obj, pos, pos)
-- 				pos = pos + 1
-- 			end
-- 			res = res .. tmp .. "\n"
-- 		end
-- 	end
-- 	return res
-- end

-- function degrees2radians(angle)
-- 	return angle * 0.01745329252
-- end

-- function radians2degrees(angle)
-- 	return angle * 57.29577951
-- end


-- function getDistance(x1, y1, x2, y2)
-- 	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
-- end
