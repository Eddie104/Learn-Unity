local DisplayObject = class("DisplayObject", require("libra.data.Object"))

function DisplayObject:ctor()
    self._inited = false
    self:init()
end

function DisplayObject:name(val)
    if val then
        self._name = val
        self._displayObject.name = val
        return self
    end
    return self._name
end

function DisplayObject:init()
    if not self._inited then
        self._inited = true
        self._displayObject = GameObject()
        -- 拿到Transform组件
        self._transform = self._displayObject:GetComponent(typeof(Transform))
        -- 添加SpriteRenderer组件
        self._spriteRenderer = self._displayObject:AddComponent(typeof(SpriteRenderer))
    end
    return self
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
    self._transform.localPosition = Vector2(x or 0, y or 0)
    return self
end

function DisplayObject:addXY(x, y)
    self._transform:Translate(Vector3(x or 0, y or 0))
    return self
end

function DisplayObject:addTo(parent)
    self._transform:SetParent(parent)
    return self
end

function DisplayObject:onUpdate()
    -- body
end

return DisplayObject