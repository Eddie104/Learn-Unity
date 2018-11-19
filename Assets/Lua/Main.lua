DATA_CONFIG_PACKAGE = 'app.config'
-- 地图单元格的宽度
CELL_SIZE = 48
-- 方向
DIR = {
	TOP = 0,
	TOP_LEFT = 1,
	LEFT_TOP = 1,
	LEFT = 2,
	LEFT_BOTTOM = 3,
	BOTTOM_LEFT = 3,
	BOTTOM = 4,
	RIGHT_BOTTOM = 5,
	BOTTOM_RIGHT = 5,
	RIGHT = 6,
	TOP_RIGHT = 7,
	RIGHT_TOP = 7,
}

--主入口函数。从这里开始lua逻辑
function Main()
	require("libra.init")
	logInfo("logic start")
	spritePool = require("app.utils.spritePool")
	-- 资源管理器 C#里的, 先加载测试资源
	resManager:LoadAssetBundle('test')

	-- 角色管理
	roleManager = require("app.model.RoleManager").new()
	-- 家具管理
	furnitureManager = require("app.model.FurnitureManager").new()
	-- 场景管理
	sceneManager = require("app.model.SceneManager").new()
	-- TODO 测试，先写死，10是农场
	sceneManager:init(10)

	-- update事件监听
	UpdateBeat:AddListener(UpdateBeat:CreateListener(update, self))
	FixedUpdateBeat:AddListener(FixedUpdateBeat:CreateListener(fixedUpdate, self))
	LateUpdateBeat:AddListener(LateUpdateBeat:CreateListener(lateUpdate, self))
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
	sceneManager:onUpdate()
	roleManager:onUpdate()
	furnitureManager:onUpdate()
end

function lateUpdate()
	sceneManager:onLateUpdate()
	roleManager:onLateUpdate()
	furnitureManager:onLateUpdate()
end

function fixedUpdate()
	sceneManager:onFixedUpdate()
	roleManager:onFixedUpdate()
	furnitureManager:onFixedUpdate()
	sort45:sort()
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end