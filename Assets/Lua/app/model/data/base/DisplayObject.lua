local DisplayObject = class("DisplayObject", require("libra.data.Object"))

function DisplayObject:ctor(abName, prefabName)
    resManager:LoadPrefab(abName, { prefabName }, function (prefabs)
        self._displayObject = GameObject.Instantiate(prefabs[0])
        self._transform = self._displayObject:GetComponent(typeof(Transform))
        -- 获取SpriteRenderer组件
        -- 并不是所有gameObject都有SpriteRenderer的，得看prefab里是否添加了SpriteRenderer组件
        self._spriteRenderer = self._displayObject:GetComponent(typeof(SpriteRenderer))
    end)
end

function DisplayObject:x(val)
    local localPosition = self._transform.localPosition
    if val then
        self._transform.localPosition = Vector2(val, localPosition.y)
        return self
    end
    return localPosition.x
end

function DisplayObject:y(val)
    local localPosition = self._transform.localPosition
    if val then
        self._transform.localPosition = Vector2(localPosition.x, val)
        return self
    end
    return localPosition.y
end

function DisplayObject:setXY(x, y)
    x = x or 0
    y = y or 0
    self._transform.localPosition = Vector2(x, y)
end

function DisplayObject:addXY(x, y)
    x = x or 0
    y = y or 0
    self._transform:Translate(Vector3(x, y))
end

function DisplayObject:onUpdate()
    -- body
end

return DisplayObject