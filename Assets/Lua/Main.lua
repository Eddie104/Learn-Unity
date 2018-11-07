
--主入口函数。从这里开始lua逻辑
function Main()
	require("libra.init")
	logInfo("logic start")

	local ab = AssetBundle.LoadFromFile(Application.dataPath .. "/AssetBundles/test")
	local hong = ab:LoadAsset("hong")
	local go = GameObject()
	go.name = 'test'
	local spriteRenderer = go:AddComponent(typeof(SpriteRenderer))
	spriteRenderer.sprite = Sprite.Create(hong, Rect(0, 0, hong.width, hong.height), Vector2(0.5, 0.5))

	-- update事件监听
	local updateHandler = UpdateBeat:CreateListener(update, self)
	UpdateBeat:AddListener(updateHandler)
end

function update()
	logInfo('update')
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end