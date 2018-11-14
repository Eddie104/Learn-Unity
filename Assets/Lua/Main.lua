DATA_CONFIG_PACKAGE = 'app.config'
-- 地图单元格的宽度
CELL_SIZE = 0.48

--主入口函数。从这里开始lua逻辑
function Main()
	require("libra.init")
	spritePool = require("app.utils.spritePool")
	logInfo("logic start")
	resManager:LoadAssetBundle('test')

	-- animator = role:GetComponent(typeof(Animator))
	-- body, hand
	--[[
	local roleTransform = role:GetComponent(typeof(Transform))
	-- body = roleTransform:GetChild(0)
	-- hand = roleTransform:GetChild(1)
	local roleTransformArr = role:GetComponentsInChildren(typeof(Transform))
	for i = 0, roleTransformArr.Length - 1 do
		if roleTransformArr[i].name == 'Body' then
			body = roleTransformArr[i]
		elseif roleTransformArr[i].name == 'Hand' then
			hand = roleTransformArr[i]
		elseif roleTransformArr[i].name == 'Clothes_F' then
			clothesF = roleTransformArr[i]
		end
	end
	]]

	-- 角色管理
	roleManager = require("app.model.RoleManager").new()
	-- 场景管理
	sceneManager = require("app.model.SceneManager").new():init(1)
	sceneManager:test()

	-- update事件监听
	local updateHandler = UpdateBeat:CreateListener(update, self)
	UpdateBeat:AddListener(updateHandler)

	logError(display.width)
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