local display45 = { }

-- --- 从45度显示坐标换算为90度数据坐标
-- -- @param {Number} x 横坐标
-- -- @param {Number} y 纵坐标
-- -- @return {{x: Number, y: Number}} 结果
-- function display45.trans45To90(x, y)
-- 	return x + (y * 2), y - (x / 2)
-- end

-- --- 从90度数据坐标换算为45度显示坐标
-- -- @param {Number} x 横坐标
-- -- @param {Number} y 纵坐标
-- -- @return {{x: Number, y: Number}} 结果
-- function display45.trans90To45(x, y)
-- 	return (x - (y * 2)) / 2, ((x / 2) + y) / 2
-- end

-- --- 获得屏幕上点的方块索引坐标
-- -- @param {Number} x 横坐标
-- -- @param {Number} y 纵坐标
-- -- @param {Number} cellWidth 格子宽度
-- -- @return {{x: Number, y: Number}} 结果
-- function display45.getItemPointAtPoint(x, y, cellWidth)
-- 	x, y = display45.trans45To90(x, y)
-- 	return math.floor(x / cellWidth), math.floor(y / (cellWidth / 2))
-- end

--- 获得鼠标位置所在方块的索引值
-- @param {Number} mouseX 鼠标横坐标
-- @param {Number} mouseY 鼠标纵坐标
-- @param {Number} cellWidth 格子宽度
-- @param {Number} topPointX 顶点横坐标
-- @param {Number} topPointY 顶点纵坐标
-- @return {{col: Number, row: Number}} 结果
function display45.getItemIndex(mouseX, mouseY, cellWidth, topPointX, topPointY)
	mouseX = mouseX - topPointX
	mouseY = topPointY - mouseY
	local row = (mouseY / (cellWidth / 2)) - (mouseX / cellWidth)
	local col = (mouseX / cellWidth) + (mouseY / (cellWidth / 2))
	row = row < 0 and -1 or row
	col = col < 0 and -1 or col
	-- print(row, col)
	-- return math.floor(row + 0.00001), math.floor(col + 0.00001)
	return math.floor(row), math.floor(col)
	--[[
	mouseX -= topPointX
    mouseY -= topPointY
    let row = (mouseY / (cellWidth / 2)) - (mouseX / cellWidth)
    let col = (mouseX / cellWidth) + (mouseY / (cellWidth / 2))
    row = row < 0 ? -1 : row
    col = col < 0 ? -1 : col
    // row = row < 0 ? 0 : row
    // col = col < 0 ? 0 : col
    return {
        row: parseInt(row, 10),
        col: parseInt(col, 10),
    }
	]]
end

--- 根据方块的索引值获取方块的屏幕坐标
-- @param {Number} row 行数
-- @param {Number} col列数
-- @param {Number} cellWidth 格子宽度
-- @param {Number} topPointX 顶点横坐标
-- @param {Number} topPointY 顶点纵坐标
-- @return {{x: Number, y: Number}} 结果
function display45.getItemPos(row, col, cellWidth, topPointX, topPointY)
	return ((col - row) * (cellWidth * 0.5)) + topPointX, topPointY - ((col + row) * (cellWidth / 4))
end

return display45