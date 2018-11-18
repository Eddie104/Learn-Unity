return function (obj)
    obj._rows, obj._cols = 1, 1
    obj._zorderType = 1

    obj.rows = function (self, val)
        if val then
            self._rows = val
            return self
        end
        return self._rows
    end

    obj.cols = function (self, val)
        if val then
            self._cols = val
            return self
        end
        return self._cols
    end

    obj.topCol = function (self, val)
        if val then
            self._topCol = val
            return self
        end
        return self._topCol
    end

    obj.topRow = function (self, val)
        if val then
            self._topRow = val
            return self
        end
        return self._topRow
    end

    obj.bottomCol = function (self, val)
        if val then
            self._bottomCol = val
            return self
        end
        return self._bottomCol
    end

    obj.bottomRow = function (self, val)
        if val then
            self._bottomRow = val
            return self
        end
        return self._bottomRow
    end

    obj.zorderType = function (self, val)
        if val then
            self._zorderType = val
            return self
        end
        return self._zorderType
    end

end