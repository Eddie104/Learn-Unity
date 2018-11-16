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
        -- 数据层的坐标
        self.x, self.y = 0
    end
    return self
end

function DisplayObject:x(val)
    if val then
        self.x = val
        self._transform.localPosition = Vector2(keepTwoDecimalPlaces(val), localPosition.y)
        return self
    end
    return self.x
end

function DisplayObject:y(val)
    if val then
        self.y = val
        self._transform.localPosition = Vector2(localPosition.x, keepTwoDecimalPlaces(val))
        return self
    end
    return self.y
end

function DisplayObject:setXY(x, y)
    if self.x ~= x and self.y ~= y then
        self.x, self.y = x, y
        x = x and keepTwoDecimalPlaces(x) or 0
        y = y and keepTwoDecimalPlaces(y) or 0
        self._transform.localPosition = Vector2(x, y)
    end
    return self
end

function DisplayObject:getXY()
    return self.x, self.y
end

function DisplayObject:addXY(x, y)
    self.x, self.y = self.x + x, self.y + y
    x = x and keepTwoDecimalPlaces(x) or 0
    y = y and keepTwoDecimalPlaces(y) or 0
    self._transform:Translate(Vector3(x, y))
    -- self._transform.position = self._transform.position + Vector3(x or 0, y or 0, 0)
    return self
end

function DisplayObject:addTo(parent)
    self._transform:SetParent(parent)
    return self
end

function DisplayObject:onUpdate()
    -- body
end

function DisplayObject:onLateUpdate()
    -- body
end

function DisplayObject:onFixedUpdate()
    -- body
end

return DisplayObject