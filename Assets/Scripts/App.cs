using System;
using UnityEngine;

public static class App
{


    public static ResourceManager ResourceManager
    {
        get; set;
    }

    public static bool EditorMode
    {
        get
        {
#if UNITY_EDITOR
            return true;
#else
            return false;
#endif
        }
    }

    public static string Platform
    {
        get
        {
#if UNITY_STANDALONE
            return "win";
#elif UNITY_ANDROID
    return "android";
#elif UNITY_IPHONE
    return "iOS";
#endif
        }
    }

    /// <summary>
    /// 取得数据存放目录
    /// </summary>
    public static string DataPath
    {
        get
        {
            string game = LuaConst.appName.ToLower();
            if (Application.isMobilePlatform)
            {
                return Application.persistentDataPath + "/" + game + "/";
            }
            if (LuaConst.debugMode)
            {
                return Application.dataPath + "/" + LuaConst.assetDir + "/";
            }
            if (Application.platform == RuntimePlatform.OSXEditor)
            {
                int i = Application.dataPath.LastIndexOf('/');
                return Application.dataPath.Substring(0, i + 1) + game + "/";
            }
            return "c:/" + game + "/";
        }
    }

    public static string GetRelativePath()
    {
        if (Application.isEditor)
            return "file://" + System.Environment.CurrentDirectory.Replace("\\", "/") + "/Assets/" + LuaConst.assetDir + "/";
        else if (Application.isMobilePlatform || Application.isConsolePlatform)
            return "file:///" + DataPath;
        else // For standalone player.
            return "file://" + Application.streamingAssetsPath + "/";
    }
}