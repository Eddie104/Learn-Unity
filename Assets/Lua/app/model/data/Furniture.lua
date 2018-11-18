local Furniture = class("Furniture", require("app.model.data.base.AnimationObject"))

function Furniture:ctor()
    Furniture.super.ctor(self)
    self._spriteRenderer.sortingLayerName = 'Room'
end

function Furniture:type(val)
    if val then
        self._type = val
        self._cfg = getConfig(val, 'furniture')
        -- TODO
        self._size = { width = 32, height = 56 }
        self._offsetX3, self._offsetY3 = self._cfg.offsetX3, self._cfg.offsetY3
        self._offsetX7, self._offsetY7 = self._cfg.offsetX7, self._cfg.offsetY7
        self:dir(DIR.LEFT_BOTTOM)
        return self
    end
    return self._type
end

function Furniture:offset()
    if self._dir == DIR.LEFT_BOTTOM then
        return self._offsetX3, self._offsetY3
    end
    return 0, 0
end

function Furniture:dir(val)
    if self._dir ~= val then
        self._dir = val
        -- 更新图片
        self:updateSprite()
        -- 更新位置
        self.offsetX, self.offsetY = self:offset()
        self:setRowAndCol(self._row, self._col, true)
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
end

-- 重写setRowAndCol方法
function Furniture:setRowAndCol(row, col, force)
    if force or (row ~= self._row and col ~= slef._col) then
        self._row, self._col = row, col
        local x, y = display45.getItemPos(row, col, CELL_SIZE, sceneManager.mapTopPointX, sceneManager.mapTopPointY)
        if self._dir == DIR.LEFT_TOP then
            self:flipX(true)
            x = x - self._size.width / 2 + self._offsetX7
            y = y + self._offsetY7 - self._size.height / 2
        elseif self._dir == DIR.LEFT_BOTTOM then
            self:flipX(false)
            x = x + self._size.width / 2 - self._offsetX3
            y = y - self._size.height / 2 + self._offsetY3
        elseif self._dir == DIR.RIGHT_BOTTOM then
            self:flipX(true)
            x = x - self._size.width / 2 + self._offsetX3
            y = y + self._offsetY3 - self._size.height / 2
        elseif self._dir == DIR.RIGHT_TOP then
            self:flipX(false)
            x = x + self._size.width / 2 - self._offsetX7
            y = y - self._size.height / 2 + self._offsetY7
        end
        self:setXY(x, y)
    end
end

return Furniture