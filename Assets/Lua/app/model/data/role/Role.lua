local Body = require("app.model.data.role.Body")

local Role = class("Role", require("app.model.data.base.AnimationObject"))

function Role:ctor()
    Role.super.ctor(self)
    -- 设置offsetX和offsetY，让角色正好可以站在格子里
    self.offsetX, self.offsetY = 0, 28 -- 28 是通过 40 - CELL_SIZE / 4 算出来的
    -- 添加组件
    require("app.model.data.component.CMovable")(self)
    require("app.model.data.component.CSorting")(self)

    self._dir = DIR.LEFT_BOTTOM
end

function Role:init()
    if not self._inited then
        self._inited = true
        self._displayObject = GameObject()
        self._displayObject.name = 'Role'
        -- 拿到Transform组件
        self._transform = self._displayObject:GetComponent(typeof(Transform))
        --[[
        -- 添加SpriteRenderer组件
        -- 角色还得加个SpriteRenderer组件，否则不能动态排序了。。。
        self._spriteRenderer = self._displayObject:AddComponent(typeof(SpriteRenderer))
        ]]
        -- 初始化身体
        self._bodyDisplayObject = Body.new(self._transform, 10):name('Body')
        self._handDisplayObject = Body.new(self._transform, 20):name('Hand')

        sort45:addItem(self, true)
    end
    return self
end

function Role:type(val)
    if val then
        self._type = val
        self._animationFrameArr = require(string.format("app.config.roleAnimation_%03d", val))
        self._dir = DIR.RIGHT_BOTTOM
        self:playIdle()
        return self
    end
    return self._type
end

function Role:getAnimationDir()
    local animationDir = self._dir
    if self._dir == DIR.LEFT_BOTTOM then
        self:flipX(false)
    elseif self._dir == DIR.TOP_RIGHT then
        self:flipX(false)
    elseif self._dir == DIR.RIGHT_BOTTOM then
        self:flipX(true)
        animationDir = DIR.LEFT_BOTTOM
    elseif self._dir == DIR.TOP_LEFT then
        self:flipX(true)
        animationDir = DIR.TOP_RIGHT
    end
    return animationDir
end

-- 待机
function Role:playIdle()
    self:play('idle' .. self:getAnimationDir())
end

-- 行走
function Role:playWalk()
    self:play('walk' .. self:getAnimationDir())
end

function Role:updateSprite()
    local frame = self._animationFrame[self._curFrame]
    self._bodyDisplayObject:updateSprite(frame.body)
    self._handDisplayObject:updateSprite(frame.hand)
end

function Role:onFixedUpdate()
    Role.super.onFixedUpdate(self)
    self:move()
end

function Role:dispose()
    Role.super.dispose(self)
    sort45:removeItem(self, true)
end

return Role