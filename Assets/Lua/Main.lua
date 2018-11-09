
--主入口函数。从这里开始lua逻辑
function Main()
	require("libra.init")
	logInfo("logic start")
	-- local ab = AssetBundle.LoadFromFile(Application.dataPath .. "/AssetBundles/test")
	resManager:LoadAssetBundle('test')
	-- local hong = ab:LoadAsset("hong")
	-- local go = GameObject()
	-- go.name = 'test'
	-- local spriteRenderer = go:AddComponent(typeof(SpriteRenderer))
	-- spriteRenderer.sprite = Sprite.Create(hong, Rect(0, 0, hong.width, hong.height), Vector2(0.5, 0.5))

	-- 动画测试
	-- local npc = ab:LoadAsset('NPC_001')
	-- GameObject.Instantiate(npc)

	-- local furniture = ab:LoadAsset('furni_003')
	-- GameObject.Instantiate(furniture)


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
	-- dump(body)
	-- print(typeof(hand))
	-- for i, v in ipairs(roleTransformArr) do
	-- 	print(i,v.name)
	-- end

	roleManager = require("app.model.RoleManager").new()
	roleManager:addData(1, 1)

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
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end