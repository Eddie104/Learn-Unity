local MapObject = class('MapObject', require("app.model.data.base.DisplayObject"))

function MapObject:ctor()
    MapObject.super.ctor(self)
    self._row, self._col = -1, -1
    self._dir = -1
end

function MapObject:row(val)
    if val then
        self._row = val
        return self
    end
    return self._row
end

function MapObject:col(val)
    if val then
        self._col = val
        return self
    end
    return self._col
end

function MapObject:setRowAndCol(row, col, force)
    if force or (self._row ~= row and self._col ~= col) then
        self._row, self._col = row, col
        local x, y = display45.getItemPos(row, col, CELL_SIZE, sceneManager.mapTopPointX, sceneManager.mapTopPointY)
        self:setXY(x + (self.offsetX or 0), y + (self.offsetY or 0))
    end
    return self
end

function MapObject:dir(val)
    if val then
        if self._dir ~= val then
            self._dir = val
        end
        return self
    end
    return self._dir
end

return MapObject