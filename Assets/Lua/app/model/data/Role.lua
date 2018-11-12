local Role = class("Role", require("app.model.data.base.AnimationObject"))

function Role:ctor()
    Role.super.ctor(self, 'test', 'Role')
    self:setXY(display.cx, display.cy)

    local transformArr = self._displayObject:GetComponentsInChildren(typeof(Transform))
    local l = transformArr.Length
    for i = 0, l - 1 do
        if transformArr[i].name == 'Body' then
            self._bodyTransform = transformArr[i]
            self._bodySpriteRenderer = self._bodyTransform:GetComponent(typeof(SpriteRenderer))
        elseif transformArr[i].name == 'Hand' then
            self._handTransform = transformArr[i]
            self._handSpriteRenderer = self._handTransform:GetComponent(typeof(SpriteRenderer))
        elseif transformArr[i].name == 'Clothes' then
            self._clothesTransform = transformArr[i]
            -- 衣服是不会变化的，所以暂时不需要取到SpriteRenderer组件
            -- self._clothesSpriteRenderer = self._clothesTransform:GetComponent(typeof(SpriteRenderer))
        elseif transformArr[i].name == 'Clothes_F' then
            self._clothesFTransform = transformArr[i]
            self._clothesFSpriteRenderer = self._clothesFTransform:GetComponent(typeof(SpriteRenderer))
        end
    end
end

function Role:type(val)
    self._animationFrameArr = require(string.format("app.config.roleAnimation_%03d", val))
    self:play('walk3')
end

function Role:updateSprite()
    local frame = self._animationFrame[self._curFrame]
    self._bodyTransform.localPosition = frame.body.vector2
    self._bodySpriteRenderer.sprite = spritePool.get('test', 'role_001', frame.body.name)
    self._handTransform.localPosition = frame.hand.vector2
    self._handSpriteRenderer.sprite = spritePool.get('test', 'role_001', frame.hand.name)
end

return Role