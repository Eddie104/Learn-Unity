return function (obj)
    obj._rows, obj._cols = 1, 1
    obj._zorderType = 0
    obj._bottomRows, obj._bottomCols = 0, 0

    -- obj.rows = function (self, val)
    --     if val then
    --         self._rows = val
    --         return self
    --     end
    --     return self._rows
    -- end

    -- obj.cols = function (self, val)
    --     if val then
    --         self._cols = val
    --         return self
    --     end
    --     return self._cols
    -- end

    obj.topCol = function (self, val)
        return self:col(val)
    end

    obj.topRow = function (self, val)
        return self:row(val)
    end

    obj.bottomCol = function (self)
        return self._bottomCols + self._col
    end

    obj.bottomRow = function (self)
        return self._bottomRows + self._row
    end

    obj.zorderType = function (self, val)
        if val then
            self._zorderType = val
            return self
        end
        return self._zorderType
    end

end