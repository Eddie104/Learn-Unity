--
-- Author: hongjie
-- Date: 2018-01-12 21:25:57
--

local sort45 = class('Sort45')

function sort45:ctor()
	self._itemList = {}
	self._movingItemList = {}
	-- 帧数的间隔，没有必要每一帧都排一次序
	-- 10帧一排，也是可以的
	self._interval = 10
	-- 当前帧数，每帧自加1，当等于_interval时，排一次序，然后_curFrame设为0
	self._curFrame = 0
end

--  * 判定两个物体的前后关系
--  * @param	item 未判定物体
--  * @param	target 参考物
--  * @param	isMoving 未判定物体是否会动
--  * 如果会动，那么就先根据两者的Toppoint来判定先后，如果TopPoint相等，那么item在target之上
--  * 否则按常规来判断
local function isJustBack(item, target, isMoveable)
	if isMoveable then
		if item:topCol() == target:topCol() then
			if item:topRow() == target:topRow() then
				-- 可行走对象和目标对象在一个块上了
				-- 目标对象如果永远在最下层，那么行走对象就在上层
				-- 否则行走对象就在下层
				return target:zorderType() > -1
			end
		end
	end
	-- zorderType更小的在后面
	local itemZorderType, targetZorderType = item:zorderType(), target:zorderType()
	if itemZorderType ~= targetZorderType then
		return itemZorderType < targetZorderType
	end
	-- return (item:bottomCol() <= target:topCol() and item:topRow() <= target:bottomRow()) or (item:bottomRow() < target:topRow())
	return (item:bottomCol() <= target:topCol() and item:topRow() <= target:bottomRow()) or (item:bottomRow() < target:topRow() and item:topCol() < target:bottomCol())
end

--  * 获取物品在队列中的唯一深度
--  * 原理很简单，默认物品在最上层，然后遍历之前已经排好序的队列，直到找到在深度目标物品深度以下的，break
--  * 即可获得目标物品的正确深度了
--  * @param target 目标物品
--  * @param itemList 已经排好序的物品队列
--  * @return  目标物品在队列中的深度
local function getDepth(target, itemList)
	local l = #itemList
	local index = l
	local item = nil
	while l > 0 do
		item = itemList[l]
		if isJustBack(item, target) then
			break
		else
			index = index - 1
		end
		l = l - 1
	end
	-- lua的索引是从1开始的，所以这里加1
	return index + 1
end

-- 每帧排序
function sort45:sort()
	self._curFrame = self._curFrame + 1
	if self._curFrame < self._interval then
		return
	end
	self._curFrame = 0

	local list = clone(self._itemList)
	local l, counter, added = 0, 0, false
	for _, item in ipairs(self._movingItemList) do
		added = false
		l = #list
		if l == 0 then
			list[1] = item
		else
			counter = 1
			while counter <= l do
				if isJustBack(item, list[counter], true) then
					table.insert(list, counter, item)
					added = true
					break
				end
				counter = counter + 1
			end
			if not added then
				table.insert(list, item)
			end
		end
	end
	l = #list
	counter = 1
	local displayObject = nil
	-- while counter <= l do
	-- 	displayObject = list[counter]
	-- 	displayObject:zorder(counter)
	-- 	counter = counter + 1
	-- end
end

function sort45:addItem(item, isMoveable)
	if isMoveable then
		table.insert(self._movingItemList, item)
	else
		local index = getDepth(item, self._itemList)
		table.insert(self._itemList, index, item)
	end
end

function sort45:removeItem(item, isMoveable)
	if isMoveable then
		table.removebyvalue(self._movingItemList, item)
	else
		table.removebyvalue(self._itemList, item)
	end
end

return sort45
