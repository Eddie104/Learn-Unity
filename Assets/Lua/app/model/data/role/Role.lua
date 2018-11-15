local Body = require("app.model.data.role.Body")

local Role = class("Role", require("app.model.data.base.AnimationObject"))

function Role:ctor()
    Role.super.ctor(self)
    -- 设置offsetX和offsetY，让角色正好可以站在格子里
    self.offsetX, self.offsetY = 0, 0.3
    -- 添加组件
    require("app.model.data.component.CMapObject")(self)
end

function Role:init()
    if not self._inited then
        self._inited = true
        self._displayObject = GameObject()
        self._displayObject.name = 'Role'
        -- 拿到Transform组件
        self._transform = self._displayObject:GetComponent(typeof(Transform))
        -- 添加SpriteRenderer组件
        -- 角色还得加个SpriteRenderer组件，否则不能动态排序了。。。
        self._spriteRenderer = self._displayObject:AddComponent(typeof(SpriteRenderer))
        -- 初始化身体
        self._bodyDisplayObject = Body.new(self._transform, 10):name('Body')
        self._handDisplayObject = Body.new(self._transform, 20):name('Hand')
    end
    return self
end

function Role:type(val)
    self._animationFrameArr = require(string.format("app.config.roleAnimation_%03d", val))
    self:play('idle3')
end

function Role:updateSprite()
    local frame = self._animationFrame[self._curFrame]
    self._bodyDisplayObject:updateSprite(frame.body)
    self._handDisplayObject:updateSprite(frame.hand)
end

return Role