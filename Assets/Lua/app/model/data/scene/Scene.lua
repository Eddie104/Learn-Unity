local Floor = require("app.model.data.scene.Floor")
local AStar = require("libra.aStar.AStar")

local Scene = class('Scene', require("libra.data.Object"))

function Scene:ctor()
    Scene.super.ctor(self)

    self._camera = Camera.main
    self._cameraTransform = self._camera:GetComponent(typeof(Transform))

    -- 地图格子的行数和列数
    self._row, self._col = 0, 0
    -- 地图的宽度和高度
    self._mapWidth, self._mapHeight = 0, 0
end

function Scene:reset()
    -- body
end

function Scene:type(val)
    if val then
        self._type = val
        self:createMap(val)
        self:createRole(1, 1)
        -- 加几个家具
        -- self:createFurniture(1, 10, 15, 20, DIR.LEFT_BOTTOM)
        -- self:createFurniture(1, 20, 17, 21, DIR.LEFT_TOP)
        -- self:createFurniture(1, 30, 19, 20, DIR.RIGHT_TOP)
        -- self:createFurniture(2, 100, 17, 16, DIR.RIGHT_BOTTOM)
        return self
    end
    return self._type
end

function Scene:createMap(sceneType)
    -- 先初始化数据
    -- 根据地图索引获取地板应该用哪张图
    local function getFloorCategory(row, col, map)
        --[[
            1 左上侧和右上侧都没有描黑边，但是顶点处有个小黑点
            2 只有左上侧描了黑边的
            3 只有右上侧描了黑边的
            4 左上侧和右上侧都要描黑边的
            5 没有描黑边的
        ]]
        if row > 0 and col > 0 then
            if map[row][col] == 0 then
                if map[row][col + 1] > 0 then
                    if map[row + 1][col] > 0 then
                        return 1
                    end
                    return 2
                else
                    if map[row + 1][col] > 0 then
                        return 3
                    end
                end
                return 4
            end
            if map[row][col + 1] == 0 then return 3 end
            if map[row + 1][col] == 0 then return 2 end
        else
            if row == 0 and col == 0 then
                return 4
            elseif row == 0 then
                if map[row + 1][col] == 0 then return 4 end
                return 3
            elseif col == 0 then
                if map[row][col + 1] == 0 then return 4 end
                return 2
            end
        end
        return 5
    end
    self._cfg = getConfig(sceneType, 'publicScene')
    self._mapCfg = getConfig(self._cfg.scene_id, 'scene')
    -- 初始化地图
    self._mapCfg.mapData = Helper.DecodeBase64(self._mapCfg.mapData)
    local rowArr = string.split(self._mapCfg.mapData, '&')
    self._map = {}
    local toNumber = function (v) return checknumber(v) end
    for row, v in ipairs(rowArr) do
        self._map[row] = string.split(v, ',')
        table.map(self._map[row], toNumber)
    end
    self._row = #rowArr
    self._col = #self._map[1]
    self._mapWidth = CELL_SIZE / 2 * (self._row + self._col)
    self._mapHeight = self._mapWidth / 2
    -- 初始化a*
    self._aStar = AStar.new(self._map, 1)

    -- 场景本身是最外面的容器，其中包括了
    -- -- 背景容器
    -- -- -- 背景图、地板、墙纸、挂饰
    -- -- 房间容器，要参与排序的物品都放这一层
    -- -- -- 人物、动物、NPC、家具等等
    self._bgContainer = GameObject()
    self._bgContainer.name = 'FloorContainer'
    self._bgContainerTransform = self._bgContainer:GetComponent(typeof(Transform))
    self._bgContainerTransform.localPosition = Vector3(0, 0, 100)

    self._roomContainer = GameObject()
    self._roomContainer.name = 'RoomContainer'
    self._roomContainerTransform = self._roomContainer:GetComponent(typeof(Transform))
    self._roomContainerTransform.localPosition = Vector3(0, 0, 50)
    -- 生成地图
    self._row = #rowArr
    self._col = #self._map[1]
    self._mapWidth = CELL_SIZE / 2 * (self._row + self._col)
    self._mapHeight = self._mapWidth / 2
    sceneManager.mapTopPointX, sceneManager.mapTopPointY = display.cx, display.cy + self._mapHeight / 2
    if self._mapCfg.sub_type == 1 then
        -- 这是地图模式
        -- TODO
        local ab = resManager:LoadAssetBundle('test')
        local texture2D = ab:LoadAsset('scene_012')
        local spriteRenderer = self._bgContainer:AddComponent(typeof(SpriteRenderer))
        spriteRenderer.sortingLayerName = 'Background'
        local sprie = Sprite.Create(texture2D, Rect(0, 0, texture2D.width, texture2D.height), Vector2(0.5, 0.5), 1)
        spriteRenderer.sprite = sprie
        self._bgContainer:GetComponent(typeof(Transform)).position = Vector2(display.cx, display.cy)
        -- 2012 / 2 - 1136 / 2 - 568
        self._cameraMinX = display.width - texture2D.width / 2
        self._cameraMaxX = texture2D.width / 2
        self._cameraMinY = display.height - texture2D.height / 2
        self._cameraMaxY = texture2D.height / 2
    elseif self._mapCfg.sub_type == 2 then
        -- 这是格子模式
        for row, rowData in ipairs(self._map) do
            for col, val in ipairs(rowData) do
                if self._map[row][col] == 1 then
                    Floor.new(getFloorCategory(row - 1, col - 1, self._map))
                        -- TODO 临时值
                        :type(11)
                        :addTo(self._bgContainerTransform)
                        :setRowAndCol(row - 1, col - 1, true)
                end
            end
        end
    end
end

function Scene:createRole(type, id)
    -- 加个角色
    local enterData = self._mapCfg.enterData
    self._role = roleManager:addData(type, id)
        :addTo(self._roomContainerTransform)
        :setRowAndCol(enterData.row, enterData.col)
        :dir(enterData.dir)
        :playIdle()
end

function Scene:createFurniture(type, id, row, col, dir)
    local f = furnitureManager:addData(type, id)
        :addTo(self._roomContainerTransform)
        :row(row):col(col):dir(dir)
    if f:isCovered() then
        -- 如果占地，需要修改地图信息
		for c = f:topCol(), f:bottomCol() do
            for r = f:topRow(), f:bottomRow() do
                if f:isCovered(r - f:row() + 1, c - f:col() + 1) then
                    self._aStar:setWalkableAt(c + 1, r + 1, 0)
                end
			end
		end
    end
    -- 添加到排序队列中
    sort45:addItem(f, false)
    return f
end

-- function Scene:findPath(startCol, startRow, endcol, endRow)
--     self._aStar:find(startCol, startRow, endcol, endRow)
-- end

function Scene:onUpdate()
    if Input.GetMouseButtonUp(0) then
        local mousePosition = Input.mousePosition
        local ray = Camera.main:ScreenPointToRay(mousePosition)
        -- local flag, hit = UnityEngine.Physics.Raycast(ray, RaycastHit.out, 1000)
        -- if flag then
		-- 	print('mouse down => ' .. tostring(hit.point))
		-- else
		-- 	print('nonono')
		-- end
        local hitArr = UnityEngine.Physics.RaycastAll(ray)
        local f, p
        for i = 0, hitArr.Length - 1 do
            f = furnitureManager:getDataByCollider(hitArr[i].collider)
            if f then
                p = hitArr[i].point
                if f:checkTouch(p) then
                    logInfo(f:name(), '被点击了')
                    break
                end
            end
        end
        if not f then
            -- 没有点到家具，那么就看看能不能行走吧
            local position = self._cameraTransform.position
            local row, col = display45.getItemIndex(mousePosition.x - display.cx + position.x, mousePosition.y - display.cy + position.y, CELL_SIZE, sceneManager.mapTopPointX, sceneManager.mapTopPointY)
            local path = self._aStar:find(self._role:col() + 1, self._role:row() + 1, col + 1, row + 1)
            if path then
                self._role:startMove(path, function ()
                    print('walk done')
                end)
            else
                print('no way')
            end
        end
    end
end

function Scene:onLateUpdate()
    local interpolation = 4 * Time.deltaTime
    local position = self._cameraTransform.position
    local targetX, targetY = self._role:getXY()
    -- position.y = math.min(self._cameraMaxY, math.max(self._cameraMinY, Mathf.Lerp(position.y, targetY, interpolation)))
    -- position.x = math.min(self._cameraMaxX, math.max(self._cameraMinX, Mathf.Lerp(position.x, targetX, interpolation)))
    position.y = math.min(self._cameraMaxY, math.max(self._cameraMinY, targetY))
    position.x = math.min(self._cameraMaxX, math.max(self._cameraMinX, targetX))
    self._cameraTransform.position = position
end

function Scene:onFixedUpdate() end

return Scene