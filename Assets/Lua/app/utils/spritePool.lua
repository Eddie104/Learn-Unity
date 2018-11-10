local Pool = {}

Pool._spriteMap = {}

function Pool.get(abName, assetName, spriteName)
    local sprite = Pool._spriteMap[spriteName]
    if not sprite then
        resManager:LoadSpritesWithAsset(abName, assetName, function (spriteArr)
            local l = spriteArr.Length
            for i = 0, l - 1 do
                Pool._spriteMap[spriteArr[i].name] = spriteArr[i]
            end
        end)
        sprite = Pool._spriteMap[spriteName]
    end
    return sprite
end

return Pool