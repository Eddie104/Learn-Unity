--
-- Author: zhouhongjie@apowo.com
-- Date: 2018-11-08 17:59:01
--

local Furniture = require("app.model.data.furniture.Furniture")

local FurnitureManager = class("FurnitureManager", require('libra.data.managers.DataManager'))

function FurnitureManager:ctor()
	FurnitureManager.super.ctor(self)
end

function FurnitureManager:getDataByCollider(collider)
	for i, v in ipairs(self._dataList) do
		if v:getBoxCollider() == collider then
			return v
		end
	end
end

function FurnitureManager:onUpdate()
	for i, v in ipairs(self._dataList) do
		v:onUpdate()
	end
end

function FurnitureManager:onLateUpdate()
	for i, v in ipairs(self._dataList) do
		v:onLateUpdate()
	end
end

function FurnitureManager:onFixedUpdate()
	for i, v in ipairs(self._dataList) do
		v:onFixedUpdate()
	end
end

function FurnitureManager:getDataType()
	return Furniture
end

return FurnitureManager