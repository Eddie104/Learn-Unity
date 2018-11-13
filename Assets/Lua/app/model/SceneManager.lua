local Floor = require("app.model.data.Floor")
local SceneManager = class("SceneManager")

function SceneManager:ctor()

end

function SceneManager:init(sceneType)
    self._cfg = getConfig(sceneType, 'scene')
    self._cfg.mapData = Helper.DecodeBase64(self._cfg.mapData)
    local rowArr = string.split(self._cfg.mapData, '&')
    self._map = {}
    for row, v in ipairs(rowArr) do
        self._map[row] = string.split(v, ',')
    end
    return self
end

function SceneManager:test()
    local floor = Floor.new()
    floor:setRowAndCol(0, 0)
    floor = Floor.new()
    floor:setRowAndCol(1, 0)
    floor = Floor.new()
    floor:setRowAndCol(1, 1)
end

function SceneManager:onUpdate()
    -- body
end

return SceneManager