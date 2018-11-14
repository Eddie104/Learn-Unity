local MapObject = class("MapObject", require("app.model.data.base.DisplayObject"))

function MapObject:ctor()
    MapObject.super.ctor(self)
    self._row, self._col = -1, -1
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

function MapObject:setRowAndCol(row, col)
    if self._row ~= row and self._col ~= col then
        self._row, self._col = row, col
        local x, y = display45.getItemPos(row, col, CELL_SIZE, display.width / 2, display.height / 2)
        self:setXY(x, y)
    end
    return self
end

return MapObject