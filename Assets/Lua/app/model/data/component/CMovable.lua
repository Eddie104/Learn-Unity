local CELL_OFFSET_Y = CELL_SIZE / 4
return function (obj)
    obj._speed         = 1
	obj._speedPow2     = obj._speed * obj._speed
	obj._isMoving      = false
	obj._pathArr       = nil
	obj._curStep       = 1
	obj._totalStep     = 0
	obj._curPathNode   = nil
	obj._dir           = DIR.LEFT_BOTTOM
	obj._moveAngle     = nil
	obj._targetX       = nil
	obj._targetY       = nil

	obj._willMoveToDir = -1
	obj._moveToDir     = -1
	obj._moveToVX      = CELL_SIZE / 24
	obj._moveToVY      = obj._moveToVX / 2

	-- 可以行走的地形
	obj._terrain       = {1}
	-- 是不是8方向行走
    obj._isDir8        = false

    -- 可以行走的地形 是个数组
    obj.terrain = function(self, val)
        if val then
            self._terrain = val
            return self
        end
        return self._terrain
    end

    obj.startMove = function (self, path, callback)
        if path then
            self._callback = callback or nil
            self._pathArr = {}
            for node, count in path:nodes() do
                self._pathArr[count] = node
            end
            -- 标记一下，是否要走向一个新的节点了
            self._gotoNewNode = true
            self._curStep = self._isMoving and 2 or 1
            self._totalStep = #self._pathArr
            self._isMoving = true
        end
    end

    obj.move = function (self)
        if self._isMoving then
            if self._moveToDir == -1 then
                if self._curStep > self._totalStep then
                    self:stopMove()
                else
                    -- 取出目标点
                    self._curPathNode = self._pathArr[self._curStep]
                    self._targetX, self._targetY = display45.getItemPos(self._curPathNode:getY() - 1, self._curPathNode:getX() - 1, CELL_SIZE, sceneManager.mapTopPointX, sceneManager.mapTopPointY)
                    self._targetX = self._targetX + self.offsetX
                    self._targetY = self._targetY + self.offsetY
                    local curX, curY = self:getXY()
                    local speedPow2 = math.pow(self._targetY - curY, 2) + math.pow(self._targetX - curX, 2)
                    if self._speedPow2 > speedPow2 then
                        -- 走到目标点了
                        self._curStep = self._curStep + 1
                        self._gotoNewNode = true
                    else
                        -- 更新row和col
                        local row, col = display45.getItemIndex(curX - self.offsetX, curY - self.offsetY - CELL_OFFSET_Y, CELL_SIZE, sceneManager.mapTopPointX, sceneManager.mapTopPointY)
                        self:row(row):col(col)
                        -- 没有到，那就继续走
                        if self._gotoNewNode then
                            self._gotoNewNode = false
                            self._moveAngle = math.atan2(self._targetY - curY, self._targetX - curX)
                            self._vx = math.cos(self._moveAngle) * self._speed
                            self._vy = math.sin(self._moveAngle) * self._speed
                            if self._isDir8 then
                                -- 8方向行走
                                if self._moveAngle >= -0.39269908169872414 and self._moveAngle <= 0.39269908169872414 then
                                    self:dir(DIR.RIGHT)
                                elseif self._moveAngle >= 0.39269908169872414 and self._moveAngle <= 1.1780972450961724 then
                                    self:dir(DIR.RIGHT_TOP)
                                elseif self._moveAngle >= 1.1780972450961724 and self._moveAngle <= 1.9634954084936207 then
                                    self:dir(DIR.TOP)
                                elseif self._moveAngle >= 1.9634954084936207 and self._moveAngle <= 2.748893571891069 then
                                    self:dir(DIR.LEFT_TOP)
                                elseif self._moveAngle >= 2.748893571891069 or self._moveAngle <= -2.748893571891069 then
                                    self:dir(DIR.LEFT)
                                elseif self._moveAngle >= -2.748893571891069 and self._moveAngle <= -1.9634954084936207 then
                                    self:dir(DIR.LEFT_BOTTOM)
                                elseif self._moveAngle >= -1.9634954084936207 and self._moveAngle <= -1.1780972450961724 then
                                    self:dir(DIR.BOTTOM)
                                elseif self._moveAngle >= -1.1780972450961724 and self._moveAngle <= -0.39269908169872414 then
                                    self:dir(DIR.RIGHT_BOTTOM)
                                end
                            else
                                -- 4方向行走
                                if self._moveAngle > 0 and self._moveAngle <= 1.5707963267948966 then
                                    self:dir(DIR.RIGHT_TOP)
                                elseif self._moveAngle >= 1.5707963267948966 and self._moveAngle <= 3.141592653589793 then
                                    self:dir(DIR.LEFT_TOP)
                                elseif self._moveAngle >= -1.5707963267948966 and self._moveAngle <= 0 then
                                    self:dir(DIR.RIGHT_BOTTOM)
                                else
                                    self:dir(DIR.LEFT_BOTTOM)
                                end
                            end
                            self:playWalk()
                        end
                        -- local step = 30 * Time.deltaTime;
                        -- self._transform.position = Vector3.MoveTowards(self._transform.position, Vector3(self._targetX, self._targetY), step);
                        self:addXY(self._vx, self._vy)
                    end
                end
            else
                -- 摇杆行走
                if self._moveToDir == -1 then
                    self._isMoving = false
                    self:playIdle()
                else
                    self:dir(self._moveToDir)
                    self:playWalk(self._moveToDir)
                    local endRow, endCol, vx, vy = 0, 0, 0, 0
                    if self._moveToDir == DIR.TOP then
                        endRow, endCol = self:row() - 1, self:col() - 1
                        -- 向上走的时候，把速度乘以2，否则感觉走太慢
                        vx, vy = 0, self._moveToVY * 2
                    elseif self._moveToDir == DIR.LEFT_TOP then
                        endRow, endCol = self:row(), self:col() - 1
                        vx, vy = -self._moveToVX, self._moveToVY
                    elseif self._moveToDir == DIR.LEFT then
                        endRow, endCol = self:row() + 1, self:col() - 1
                        vx, vy = -self._moveToVX, 0
                    elseif self._moveToDir == DIR.LEFT_BOTTOM then
                        endRow, endCol = self:row() + 1, self:col()
                        vx, vy = -self._moveToVX, -self._moveToVY
                    elseif self._moveToDir == DIR.BOTTOM then
                        endRow, endCol = self:row() + 1, self:col() + 1
                        -- 向下走的时候，把速度乘以2，否则感觉走太慢
                        vx, vy = 0, -self._moveToVY * 2
                    elseif self._moveToDir == DIR.RIGHT_BOTTOM then
                        endRow, endCol = self:row(), self:col() + 1
                        vx, vy = self._moveToVX, -self._moveToVY
                    elseif self._moveToDir == DIR.RIGHT then
                        endRow, endCol = self:row() - 1, self:col() + 1
                        vx, vy = self._moveToVX, 0
                    elseif self._moveToDir == DIR.RIGHT_TOP then
                        endRow, endCol = self:row() - 1, self:col()
                        vx, vy = self._moveToVX, self._moveToVY
                    end
                    local isWalkable = false
                    for i, v in ipairs(self._terrain) do
                        if sceneManager._aStar[v]:isWalkableAt(endCol + 1, endRow + 1, tostring(v)) then
                            isWalkable = true
                            self:addXY(vx, vy)
                            local targetX, targetY = display45.getItemPos(endRow, endCol, CELL_SIZE, sceneManager.mapTopPointX, sceneManager.mapTopPointY)
                            if targetX == self:x() and targetY == self:y() then
                                -- print(targetX, targetY, self:x(), self:y())
                                -- self:setRowAndCol(endRow, endCol)
                                self:row(endRow):col(endCol)
                                self._moveToDir = self._willMoveToDir
                                if self._moveToDir == -1 then
                                    self._isMoving = false
                                    self:playIdle()
                                end
                            end
                            break
                        end
                    end
                    if not isWalkable then
                        print('不可行走')
                        self._moveToDir = -1
                        self._isMoving = false
                        self:playIdle()
                    end
                end
            end
        end
    end

    obj.stopMove = function (self)
        if self._isMoving then
            self._isMoving = false
            local node = self._pathArr[self._totalStep]
            if node then
                self:setRowAndCol(node:getY() - 1, node:getX() - 1, true)
            end
            self._pathArr = nil
            self._curStep = 1
            self._totalStep = 0
            self._curPathNode = nil
            self:playIdle()
            if type(self._callback) == 'function' then
                self._callback()
            end
        end
    end

    obj.moveTo = function (self, dir)
        self._willMoveToDir = dir
        if self._moveToDir == -1 then
            self._moveToDir = dir
        end
        if self._moveToDir ~= -1 then
            self._isMoving = true
        end
    end

    obj.speed = function (self, val)
        if val then
            if self._speed ~= val then
                self._speed = val
                self._speedPow2 = self._speed * self._speed
                self._speedPow2 = self._speed * self._speed
                self._speedPow2 = self._speed * self._speed
                self._moveAngle = math.atan2(self._targetY - self:y(), self._targetX - self:x())
                self._vx = math.cos(self._moveAngle) * self._speed
                self._vy = math.sin(self._moveAngle) * self._speed
            end
            return self
        end
        return self._speed
    end

end