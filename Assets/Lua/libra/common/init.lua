require("libra.common.class")
require("libra.common.string")
require("libra.common.table")
-- local lz = require("zlib")

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

-- -- 压缩字符串
-- function compress(str)
-- 	local deflated, eof, bytes_in,bytes_out = lz.deflate()(str, 'finish')
-- 	return crypto.encodeBase64(deflated)
-- end

-- -- 解压缩字符串
-- function uncompress(str)
-- 	return lz.inflate()(crypto.decodeBase64(str))
-- end