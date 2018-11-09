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
    local position = self._transform.position
    if val then
        self._transform.position = Vector2(val, position.y)
        return self
    end
    return position.x
end

function DisplayObject:y(val)
    local position = self._transform.position
    if val then
        self._transform.position = Vector2(position.x, val)
        return self
    end
    return position.y
end

function DisplayObject:setXY(x, y)
    x = x or 0
    y = y or 0
    self._transform.position = Vector2(x, y)
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