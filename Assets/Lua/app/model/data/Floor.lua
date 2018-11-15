
-- 地板
local Floor = class('Floor', require("app.model.data.base.DisplayObject"))

function Floor:ctor(category)
    Floor.super.ctor(self)
    -- 地板图片高度为34px，这里offsetY要设为高度的一半.这样在setRowAndCol方法里设置坐标才是准确的
    self.offsetX, self.offsetY = 0, -0.17
    -- 类型，根据地形需要用到不同的图片
    self._category = category
    -- 添加组件
    require("app.model.data.component.CMapObject")(self)
    self:name('Floor')
end

function Floor:type(val)
    if val then
        self._type = val
        local typeStr = string.format('floor_%03d', val)
        self._spriteRenderer.sprite = spritePool.get('test', typeStr, string.format('%s_%d', typeStr, self._category))
        return self
    end
    return self._type
end

return Floor