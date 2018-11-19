local DisplayObject = class("DisplayObject", require("libra.data.Object"))

function DisplayObject:ctor()
    self._inited = false
    self._flipX = false
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
        -- 数据层的坐标
        self._x, self._y, self._z = 0, 0, 0
    end
    return self
end

function DisplayObject:x(val)
    if val then
        self._x = val
        self._transform.localPosition = Vector3(val, self._y, self._z)
        return self
    end
    return self.x
end

function DisplayObject:y(val)
    if val then
        self._y = val
        self._transform.localPosition = Vector3(self._x, val, self._z)
        return self
    end
    return self._y
end

function DisplayObject:z(val)
    if val then
        self._z = val
        self._transform.localPosition = Vector3(self._x, self._y, val)
        return self
    end
    return self._z
end


function DisplayObject:setXY(x, y)
    self._x, self._y = x or 0, y or 0
    self._transform.localPosition = Vector3(self._x, self._y, self._z)
    return self
end

function DisplayObject:getXY()
    local localPosition = self._transform.localPosition
    return localPosition.x, localPosition.y
end

function DisplayObject:addXY(x, y)
    x = x and x or 0
    y = y and y or 0
    self._x, self._y = self._x + x, self._y + y
    self._transform:Translate(Vector2(x, y))
    -- self._transform.position = self._transform.position + Vector3(x or 0, y or 0, 0)
    return self
end

function DisplayObject:addTo(parent)
    self._transform:SetParent(parent)
    return self
end

function DisplayObject:flipX(val)
    if type(val) == 'boolean' then
        -- self._spriteRenderer.flipX = val
        self._flipX = val
        self._transform.localScale = Vector2(val and -1 or 1, 1)
        return self
    end
    return self._flipX
    -- return self._spriteRenderer.flipX
end

function DisplayObject:onUpdate() end

function DisplayObject:onLateUpdate() end

function DisplayObject:onFixedUpdate() end

return DisplayObject