DATA_CONFIG_PACKAGE = 'app.config'
-- 地图单元格的宽度
CELL_SIZE = 0.48

--主入口函数。从这里开始lua逻辑
function Main()
	require("libra.init")
	logInfo("logic start")
	spritePool = require("app.utils.spritePool")
	-- 资源管理器 C#里的, 先加载测试资源
	resManager:LoadAssetBundle('test')

	-- 角色管理
	roleManager = require("app.model.RoleManager").new()
	-- 场景管理
	sceneManager = require("app.model.SceneManager").new():init(1)
	sceneManager:test()

	-- update事件监听
	local updateHandler = UpdateBeat:CreateListener(update, self)
	UpdateBeat:AddListener(updateHandler)
end

function update()
	--[[
	-- 检测鼠标左键是否点击
	if Input.GetMouseButtonDown(0) then
		-- local mousePosition = Input.mousePosition
		-- print(tostring(mousePosition))
		-- local ray = Camera.main:ScreenPointToRay(mousePosition);
		-- local flag, hit = UnityEngine.Physics.Raycast(ray, RaycastHit.out)
		-- print(tostring(flag))
		-- dump(hit)
		-- if flag then
		-- 	print('mouse down => ' .. tostring(hit.point))
		-- else
		-- 	print('nonono')
		-- end
	end
	]]
	roleManager:onUpdate()
	sceneManager:onUpdate()
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end