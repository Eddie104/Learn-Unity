return function (obj)
    obj._row, obj._col = -1, -1

    obj.row = function (self, val)
        if val then
            self._row = val
            return self
        end
        return self._row
    end

    obj.col = function (self, val)
        if val then
            self._col = val
            return self
        end
        return self._col
    end

    obj.setRowAndCol = function (self, row, col, force)
        if force or (self._row ~= row and self._col ~= col) then
            self._row, self._col = row, col
            local x, y = display45.getItemPos(row, col, CELL_SIZE, sceneManager.mapTopPointX, sceneManager.mapTopPointY)
            self:setXY(x + (self.offsetX or 0), y + (self.offsetY or 0))
        end
        return self
    end
end