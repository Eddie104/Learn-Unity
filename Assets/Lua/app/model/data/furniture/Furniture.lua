local Furniture = class("Furniture", require("app.model.data.base.AnimationObject"))

function Furniture:ctor()
    Furniture.super.ctor(self)
    self._spriteRenderer.sortingLayerName = 'Room'
    require("app.model.data.component.CSorting")(self)
end

function Furniture:type(val)
    if val then
        self._type = val
        -- cfg的数据格式如下
        --[[
            -- 是否随着季节的变化而变化
            seasonal = false,
            offsetY7 = 34,
            offsetY3 = 34,
            underside = {
                {
                    1
                }
            },
            id = 1,
            size =
            {
                width = 32,
                height = 56
            },
            functions = {

                {
                    offsetY7 = 104,
                    offsetY3 = 102,
                    tool = -1,
                    key = 'sit',
                    offsetX3 = 81,
                    hasMask3 = false,
                    offsetX7 = 74,
                    hasMask7 = true
                }
            },
            zorder_type = 0,
            num_mask = 0,
            offsetX3 = 15,
            offsetX7 = 15,
            dirs = {
                1,3,5,7
            },
            animation_loops = 0,
            interaction_point = {

                {
                    offsetCol = 0,
                    offsetRow = 1,

                }
            },
            touch_area_3 = {

                {
                    y = 56,
                    x = 14,

                },
            },
            touch_area_7 = {

                {
                    y = 47,
                    x = 1,

                },
            },
            animation_auto_play = false,
            name = '宅时光椅子',
            des = '从宅时光那里拿来的',
            animation_total_frame = 1,
            is_covered = true,
            is_touch_able = true,
        ]]
        self._cfg = getConfig(val, 'furniture')
        self:name(self._cfg.name)
        self._zorderType = self._cfg.zorder_type
        -- 处理底面占地数据
        local underside = self._cfg.underside
        self._rows3 = #underside
		self._cols3 = underside[1] and #underside[1] or 0
		self._rows5 = self._cols3
        self._cols5 = self._rows3
        -- 触摸点范围
        self._touchArea3 = self._cfg.touch_area_3 or {}
        self._touchArea7 = self._cfg.touch_area_7 or {}
        local size = self._cfg.size
		self._touchArea5 = {}
		for i, v in ipairs(self._touchArea3) do
			self._touchArea5[i] = {
				x = size.width - v.x,
				y = v.y
			}
		end
		self._touchArea1 = {}
		for i, v in ipairs(self._touchArea7) do
			self._touchArea1[i] = {
				x = size.width - v.x,
				y = v.y
			}
		end
        return self
    end
    return self._type
end

-- 是否占地
function Furniture:isCovered()
    return self._cfg.is_covered
end

function Furniture:checkTouch(v3)
    -- 获取触摸范围
    local touchArea
    if self._dir == DIR.LEFT_BOTTOM then
        touchArea = self._touchArea3
    elseif self._dir == DIR.LEFT_TOP then
        touchArea = self._touchArea1
    elseif self._dir == DIR.RIGHT_TOP then
        touchArea = self._touchArea7
    elseif self._dir == DIR.RIGHT_BOTTOM then
        touchArea = self._touchArea5
    end
    if touchArea then
        if #touchArea > 0 then
            local size = self._cfg.size
            local x, y = v3.x - (self._x - size.width / 2), size.height / 2 - self._y + v3.y
            return pointInRegion(x, y, touchArea)
        end
    end
    return true
end

-- 重写setRowAndCol方法
function Furniture:setRowAndCol(row, col, force)
    if force or (row ~= self._row and col ~= slef._col) then
        self._row, self._col = row, col
        local x, y = display45.getItemPos(row, col, CELL_SIZE, sceneManager.mapTopPointX, sceneManager.mapTopPointY)
        local size = self._cfg.size
        if self._dir == DIR.LEFT_TOP then
            self:flipX(true)
            x = x - size.width / 2 + self._cfg.offsetX7
            y = y + self._cfg.offsetY7 - size.height / 2
        elseif self._dir == DIR.LEFT_BOTTOM then
            self:flipX(false)
            x = x + size.width / 2 - self._cfg.offsetX3
            y = y - size.height / 2 + self._cfg.offsetY3
        elseif self._dir == DIR.RIGHT_BOTTOM then
            self:flipX(true)
            x = x - size.width / 2 + self._cfg.offsetX3
            y = y + self._cfg.offsetY3 - size.height / 2
        elseif self._dir == DIR.RIGHT_TOP then
            self:flipX(false)
            x = x + size.width / 2 - self._cfg.offsetX7
            y = y - size.height / 2 + self._cfg.offsetY7
        end
        self:setXY(x, y)
    end
    return self
end

function Furniture:dir(val)
    if val then
        if self._dir ~= val then
            self._dir = val
            if val == DIR.LEFT_TOP or val == DIR.RIGHT_BOTTOM then
                self._bottomRows, self._bottomCols = self._rows5 - 1, self._cols5 - 1
            elseif val == DIR.LEFT_BOTTOM or val == DIR.RIGHT_TOP then
                self._bottomRows, self._bottomCols = self._rows3 - 1, self._cols3 -1
            end
            -- 更新图片
            self:updateSprite()
            -- 更新位置
            self:setRowAndCol(self._row, self._col, true)
        end
        return self
    end
    return self._dir
end

function Furniture:updateSprite()
    local typeStr = string.format('furni_%03d', self._type)
    local dir = self._dir
    if self._dir == DIR.RIGHT_BOTTOM then
        dir = DIR.LEFT_BOTTOM
    elseif self._dir == DIR.LEFT_TOP then
        dir = DIR.RIGHT_TOP
    end
    self._spriteRenderer.sprite = spritePool.get('test', typeStr, string.format('%s_%d_1', typeStr, dir))
    -- 试图增加碰撞体组件
    if self._cfg.is_touch_able then
        if not self._boxCollider then
            -- 可以几点的家具需要添加一个碰撞体组件
            self._boxCollider = self._displayObject:AddComponent(typeof(BoxCollider))
        end
    end
end

function Furniture:getBoxCollider()
    return self._boxCollider
end

-- 获取互动点信息
function Furniture:interactonPoint()
    local result = {}
    local interactionPoint = self._cfg.interaction_point
	if self._dir == DIR.LEFT_BOTTOM then
		for i, interactionData in ipairs(interactionPoint) do
			result[i] = { row = self._row + interactionData.offsetRow, col = self._col + interactionData.offsetCol }
		end
	elseif self._dir == DIR.RIGHT_BOTTOM then
		for i, interactionData in ipairs(interactionPoint) do
			result[i] = { row = self._row + interactionData.offsetCol, col = self._col + interactionData.offsetRow }
		end
	elseif self._dir == DIR.RIGHT_TOP then
		for i, interactionData in ipairs(interactionPoint) do
			result[i] = { row = self._row - interactionData.offsetRow, col = self._col - interactionData.offsetCol }
		end
	elseif self._dir == DIR.LEFT_TOP then
		for i, interactionData in ipairs(interactionPoint) do
			result[i] = { row = self._row - interactionData.offsetCol, col = self._col - interactionData.offsetRow }
		end
	end
	return result
end

function Furniture:dispose()
    Furniture.super.dispose(self)
    sort45:removeItem(self, false)
end

return Furniture