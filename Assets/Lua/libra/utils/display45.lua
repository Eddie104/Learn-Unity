local display45 = { }

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
	return math.floor(row), math.floor(col)
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