local Floor = require("app.model.data.Floor")
local SceneManager = class("SceneManager")

function SceneManager:ctor()
    -- 地图格子的行数和列数
    self._row, self._col = 0, 0
    -- 地图的宽度和高度
    self._width, self._height = 0, 0
end

function SceneManager:init(sceneType)
    self._cfg = getConfig(sceneType, 'scene')
    self._cfg.mapData = Helper.DecodeBase64(self._cfg.mapData)
    local rowArr = string.split(self._cfg.mapData, '&')
    self._map = {}
    for row, v in ipairs(rowArr) do
        self._map[row] = string.split(v, ',')
    end
    self._row = #rowArr
    self._col = #self._map[1]
    self._width = CELL_SIZE / 2 * (self._row + self._col)
    self._height = self._width / 2
    return self
end

function SceneManager:test()
    roleManager:addData(1, 1):setXY(display.cx, display.cy)

    local floor = Floor.new():type(1)
    floor:setRowAndCol(0, 0)
    floor = Floor.new():type(1)
    floor:setRowAndCol(1, 0)
    floor = Floor.new():type(1)
    floor:setRowAndCol(1, 1)
end

function SceneManager:onUpdate()
    -- body
end

return SceneManager