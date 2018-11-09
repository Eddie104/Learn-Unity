using System;
using LuaInterface;
using UnityEngine;

/// <summary>
/// tolua 启动入口，将此脚本动态绑定到一个不销毁的 GameObject 上
/// </summary>
public class Client : LuaClient
{
    protected override void Init()
    {
        // 设置为切换场景不被销毁的属性
        DontDestroyOnLoad(gameObject);
        App.ResourceManager = gameObject.AddComponent<ResourceManager>();
        App.ResourceManager.Initialize();
        base.Init();
        // 让屏幕永远亮着
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
    }

    protected override LuaFileUtils InitLoader()
    {
        return new LuaResLoader();
    }

    /// <summary>
    /// 可添加或修改搜索 lua 文件的目录
    /// </summary>
    protected override void LoadLuaFiles()
    {
#if UNITY_EDITOR
        // 添加编辑器环境下获取 lua 脚本的路径（Assets/lua）
        luaState.AddSearchPath(Application.dataPath + "/lua");
#endif
        base.LoadLuaFiles();
    }
}
