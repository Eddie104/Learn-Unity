
-- 地板
local Floor = class('Floor', require("app.model.data.base.MapObject"))

function Floor:ctor()
    Floor.super.ctor(self, 'test', 'Floor')
end

-- function Floor:type(int)
-- 	if int then
-- 		self._type = int
-- 		self._cfg = { }
-- 		return self
-- 	end
-- 	return self._type
-- end

return Floor