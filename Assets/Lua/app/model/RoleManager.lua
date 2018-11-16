--
-- Author: zhouhongjie@apowo.com
-- Date: 2018-11-08 17:59:01
--

local Role = require("app.model.data.role.Role")

local RoleManager = class("RoleManager", require('libra.data.managers.DataManager'))

function RoleManager:ctor()
	RoleManager.super.ctor(self)
end

function RoleManager:onUpdate()
	-- logError('RoleManager update' .. Time.deltaTime)
	for i, v in ipairs(self._dataList) do
		v:onUpdate()
	end
end

function RoleManager:onLateUpdate()
	for i, v in ipairs(self._dataList) do
		v:onLateUpdate()
	end
end

function RoleManager:onFixedUpdate()
	for i, v in ipairs(self._dataList) do
		v:onFixedUpdate()
	end
end

function RoleManager:getDataType()
	return Role
end

return RoleManager