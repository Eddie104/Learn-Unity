
-- 地板
local Floor = class('Floor', require("app.model.data.base.MapObject"))

function Floor:ctor()
    Floor.super.ctor(self)
    self:name('Floor')
end

function Floor:type(val)
    if val then
        self._type = val
        local typeStr = string.format('floor_%03d', val)
        self._spriteRenderer.sprite = spritePool.get('test', typeStr, string.format('%s_%d', typeStr, 1))
        return self
    end
    return self._type
end

return Floor