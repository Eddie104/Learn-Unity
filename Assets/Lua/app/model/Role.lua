local Role = class("Role")

function Role:ctor(prefab)
	local role = GameObject.Instantiate(prefab)
end

function Role:test()
    logError('pppp')
end

return Role