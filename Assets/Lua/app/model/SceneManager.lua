local Floor = require("app.model.data.Floor")
local AStar = require("libra.aStar.AStar")
local SceneManager = class("SceneManager")

function SceneManager:ctor()
    -- 地图格子的行数和列数
    self._row, self._col = 0, 0
    -- 地图的宽度和高度
    self._mapWidth, self._mapHeight = 0, 0
    self.mapTopPointX, self.mapTopPointY = display.cx, display.cy

    -- self._time = 0
end

function SceneManager:init(sceneType)
    -- 先初始化数据
    self._cfg = getConfig(sceneType, 'scene')
    self._cfg.mapData = Helper.DecodeBase64(self._cfg.mapData)
    local rowArr = string.split(self._cfg.mapData, '&')
    self._map = {}
    for row, v in ipairs(rowArr) do
        self._map[row] = string.split(v, ',')
    end
    self._row = #rowArr
    self._col = #self._map[1]
    self._mapWidth = CELL_SIZE / 2 * (self._row + self._col)
    self._mapHeight = self._mapWidth / 2
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
    return self
end

function SceneManager:test()
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

    local rowArr = {
        '1,0,0,1,1,1,1,0,0,1,1,1',
        '1,1,0,0,0,1,1,1,0,0,0,1',
        '1,0,0,1,1,1,1,0,0,1,1,1',
        '1,1,1,1,0,1,1,1,1,1,0,1',
        '1,1,1,1,0,1,1,1,1,1,0,1',
        '1,1,1,1,0,1,1,1,1,1,0,1',
        '1,1,1,1,0,1,1,1,1,1,0,1',
        '1,1,1,1,0,1,1,1,1,1,0,1',
        '1,1,1,1,0,1,1,1,1,1,0,1',
    }
    self._map = {}
    local toNumber = function (v) return checknumber(v) end
    for row, v in ipairs(rowArr) do
        self._map[row] = string.split(v, ',')
        table.map(self._map[row], toNumber)
    end
    -- 初始化a*
    self._aStar = AStar.new(self._map, 1)
    self._row = #rowArr
    self._col = #self._map[1]
    self._mapWidth = CELL_SIZE / 2 * (self._row + self._col)
    self._mapHeight = self._mapWidth / 2
    for row, rowData in ipairs(self._map) do
        for col, val in ipairs(rowData) do
            if self._map[row][col] == 1 then
                Floor.new(getFloorCategory(row - 1, col - 1, self._map))
                    :type(1)
                    :addTo(self._bgContainerTransform)
                    :setRowAndCol(row - 1, col - 1, true)
            end
        end
    end
    -- 加个角色
    self._role = roleManager:addData(1, 1):addTo(self._roomContainerTransform):setRowAndCol(1, 0)
    -- self._role1 = roleManager:addData(1, 2):addTo(self._roomContainerTransform):setRowAndCol(0, 0)

    -- 加几个家具
    self._furniture = furnitureManager:addData(1, 1):addTo(self._roomContainerTransform):setRowAndCol(0, 0, true)
end

function SceneManager:onUpdate()
    if Input.GetMouseButtonUp(0) then
        local mouseV3 = Input.mousePosition
        local row, col = display45.getItemIndex(mouseV3.x, mouseV3.y, CELL_SIZE, self.mapTopPointX, self.mapTopPointY)        
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

function SceneManager:onLateUpdate()
	-- body
end

function SceneManager:onFixedUpdate()
    -- self._time = self._time + Time.fixedDeltaTime
    -- logError('time = '.. self._time)
end

return SceneManager