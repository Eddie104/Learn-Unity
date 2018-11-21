local Scene = require("app.model.data.scene.Scene")

local SceneManager = class("SceneManager")

function SceneManager:ctor()
    self.mapTopPointX, self.mapTopPointY = display.cx, display.cy
end

function SceneManager:init(sceneType)
    if self._scene then
        self._scene:reset()
    else
        self._scene = Scene.new()
    end
    self._scene:type(sceneType)
end

function SceneManager:onUpdate()
    if self._scene then
        self._scene:onUpdate()
    end
end

function SceneManager:onLateUpdate()
	-- 相机跟随
    if self._scene then
        self._scene:onLateUpdate()
    end
end

function SceneManager:onFixedUpdate()
    if self._scene then
        self._scene:onFixedUpdate()
    end
end

return SceneManager