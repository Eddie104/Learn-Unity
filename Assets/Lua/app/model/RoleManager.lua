--
-- Author: zhouhongjie@apowo.com
-- Date: 2018-11-08 17:59:01
--

local RoleManager = class("RoleManager", require('libra.data.Emitter'))

function RoleManager:ctor()
	RoleManager.super.ctor(self)
	logError('RoleManager is done')
end

function RoleManager:onUpdate()
    logError('RoleManager update' .. Time.deltaTime)
end

return RoleManager