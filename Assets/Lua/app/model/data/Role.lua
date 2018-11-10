local roleAnimationConfig = require("app.config.roleAnimation")

local Role = class("Role", require("app.model.data.base.AnimationObject"))

function Role:ctor()
    Role.super.ctor(self, 'test', 'Role')
    self:setXY(display.cx, display.cy)
    -- self:addXY(1, -1)
    local transformArr = self._displayObject:GetComponentsInChildren(typeof(Transform))
    local l = transformArr.Length
    for i = 0, l - 1 do
        if transformArr[i].name == 'Body' then
            self._bodyTransform = transformArr[i]
            self._bodySpriteRenderer = self._bodyTransform:GetComponent(typeof(SpriteRenderer))
        elseif transformArr[i].name == 'Hand' then
            self._handTransform = transformArr[i]
            self._handSpriteRenderer = self._handTransform:GetComponent(typeof(SpriteRenderer))
        end
    end

    -- 加载人物裸模的所有sprite
    --[[
    self._animationSpriteMap = {}
    resManager:LoadSpritesWithAsset('test', 'role_001', function (spriteArr)
        local l = spriteArr.Length
        for i = 0, l - 1 do
            self._animationSpriteMap[spriteArr[i].name] = spriteArr[i]
        end
    end)
    ]]
    self._animationFrameArr = roleAnimationConfig
    -- self._animationFrameArr = {
    --     {
    --         name = 'idle3',
    --         frame = {
    --             { bodyName = 'role_001_3_01', handName = 'role_001_3_hand_01' }
    --         },
    --     },
    --     {
    --         name = 'walk3',
    --         frame = {
    --             { bodyName = 'role_001_3_01', handName = 'role_001_3_hand_01' },
    --             { bodyName = 'role_001_3_02', handName = 'role_001_3_hand_02' },
    --             { bodyName = 'role_001_3_01', handName = 'role_001_3_hand_01' },
    --             { bodyName = 'role_001_3_03', handName = 'role_001_3_hand_04' },
    --         },
    --     }
    -- }

    self:play('walk3')
end

function Role:updateSprite()
    local frame = self._animationFrame[self._curFrame]
    self._bodyTransform.localPosition = Vector2(frame.body.offsetX, frame.body.offsetY)
    self._bodySpriteRenderer.sprite = spritePool.get('test', 'role_001', frame.body.name)
    self._handTransform.localPosition = Vector2(frame.hand.offsetX, frame.hand.offsetY)
    self._handSpriteRenderer.sprite = spritePool.get('test', 'role_001', frame.hand.name)
end

return Role