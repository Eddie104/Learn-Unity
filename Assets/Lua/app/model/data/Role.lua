local Role = class("Role", require("app.model.data.base.AnimationObject"))

function Role:ctor()
    Role.super.ctor(self, 'test', 'Role')
    -- self:setXY(1, 1)
    -- self:addXY(1, -1)
    local transformArr = self._displayObject:GetComponentsInChildren(typeof(Transform))
    local l = transformArr.Length
    for i = 0, l - 1 do
        if transformArr[i].name == 'Body' then
            self._bodySpriteRenderer = transformArr[i]:GetComponent(typeof(SpriteRenderer))
        elseif transformArr[i].name == 'Hand' then
            self._handSpriteRenderer = transformArr[i]:GetComponent(typeof(SpriteRenderer))
        end
    end

    -- 加载人物裸模的所有sprite
    self._animationSpriteMap = {}
    resManager:LoadSpritesWithAsset('test', 'role_001', function (spriteArr)
        local l = spriteArr.Length
        for i = 0, l - 1 do
            self._animationSpriteMap[spriteArr[i].name] = spriteArr[i]
        end
    end)

    self._animationFrameArr = {
        {
            name = 'idle3',
            frame = {
                { bodyName = 'role_001_3_01', handName = 'role_001_3_hand_01' }
            },
        },
        {
            name = 'walk3',
            frame = {
                { bodyName = 'role_001_3_01', handName = 'role_001_3_hand_01' },
                { bodyName = 'role_001_3_02', handName = 'role_001_3_hand_02' },
                { bodyName = 'role_001_3_01', handName = 'role_001_3_hand_01' },
                { bodyName = 'role_001_3_03', handName = 'role_001_3_hand_04' },
            },
        }
    }

    self:play('walk3')
end

function Role:updateSprite()
    local frame = self._animationFrame[self._curFrame]
    self._bodySpriteRenderer.sprite = self._animationSpriteMap[frame.bodyName]
    self._handSpriteRenderer.sprite = self._animationSpriteMap[frame.handName]
end

return Role