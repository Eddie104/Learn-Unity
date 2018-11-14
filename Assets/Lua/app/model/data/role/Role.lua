local Body = require("app.model.data.role.Body")
local Role = class("Role", require("app.model.data.base.AnimationObject"))

function Role:ctor()
    Role.super.ctor(self)
end

function Role:init()
    self._displayObject = GameObject()
    self._displayObject.name = 'Role'
    -- 拿到Transform组件
    self._transform = self._displayObject:GetComponent(typeof(Transform))
    -- 初始化身体
    self._bodyDisplayObject = Body.new(self._transform, 10):name('Body')
    self._handDisplayObject = Body.new(self._transform, 20):name('Hand')
    return self
end

function Role:type(val)
    self._animationFrameArr = require(string.format("app.config.roleAnimation_%03d", val))
    self:play('walk3')
end

function Role:updateSprite()
    local frame = self._animationFrame[self._curFrame]
    self._bodyDisplayObject:updateSprite(frame.body)
    self._handDisplayObject:updateSprite(frame.hand)
end

return Role