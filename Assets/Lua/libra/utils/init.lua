--
-- 一些功能性的全局方法
-- Author: zhouhongjie@apowo.com
-- Date: 2015-03-20 10:25:49
--

DATA_CONFIG_PACKAGE = DATA_CONFIG_PACKAGE or "app.config."

require('libra.utils.dateTimeUtil')
display45 = require("libra.utils.display45")
sort45 = require('libra.utils.sort45').new()

--===========================================================================================

--- 根据type读取相应的配置文件
-- @param propType 物品Type
-- @param configName 配置文件，取lua文件名
-- @return 返回配置文件中物品的配置信息
-- function getConfig(propType, configName, compareStr)
-- 	compareStr = compareStr and compareStr or 'id'
-- 	local config = require(DATA_CONFIG_PACKAGE .. configName)
-- 	if config then
-- 		return queryByType(config, compareStr, checkint(propType))
-- 	end
-- end

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
