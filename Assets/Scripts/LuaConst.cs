using UnityEngine;

public static class LuaConst
{
    // lua逻辑代码目录
    public static string luaDir = Application.dataPath + "/Lua";
    // tolua lua文件目录
    public static string toluaDir = Application.dataPath + "/ToLua/Lua";
    // 应用程序名称
    public static string appName = "LuaFramework";
    // 素材目录
    public static string assetDir = "StreamingAssets";
    public static bool debugMode = true;

#if UNITY_STANDALONE
    public static string osDir = "Win";
#elif UNITY_ANDROID
    public static string osDir = "Android";            
#elif UNITY_IPHONE
    public static string osDir = "iOS";        
#else
    public static string osDir = "";        
#endif

    // 手机运行时lua文件下载目录    
    public static string luaResDir = string.Format("{0}/{1}/Lua", Application.persistentDataPath, osDir);

    //ZeroBraneStudio目录
#if UNITY_EDITOR_WIN || UNITY_STANDALONE_WIN    
    public static string zbsDir = "D:/ZeroBraneStudio/lualibs/mobdebug";
#elif UNITY_EDITOR_OSX || UNITY_STANDALONE_OSX
    public static string zbsDir = "/Applications/ZeroBraneStudio.app/Contents/ZeroBraneStudio/lualibs/mobdebug";
#else
    public static string zbsDir = luaResDir + "/mobdebug/";
#endif    

    // 是否打开Lua Socket库
    public static bool openLuaSocket = true;
    // 是否连接lua调试器
    public static bool openLuaDebugger = false;

}