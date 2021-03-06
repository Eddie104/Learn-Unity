﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class AppWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("App");
		L.RegFunction("GetRelativePath", GetRelativePath);
		L.RegVar("ResourceManager", get_ResourceManager, set_ResourceManager);
		L.RegVar("EditorMode", get_EditorMode, null);
		L.RegVar("Platform", get_Platform, null);
		L.RegVar("NetAvailable", get_NetAvailable, null);
		L.RegVar("IsWifi", get_IsWifi, null);
		L.RegVar("DataPath", get_DataPath, null);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetRelativePath(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = App.GetRelativePath();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ResourceManager(IntPtr L)
	{
		try
		{
			ToLua.Push(L, App.ResourceManager);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_EditorMode(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, App.EditorMode);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Platform(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushstring(L, App.Platform);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_NetAvailable(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, App.NetAvailable);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsWifi(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, App.IsWifi);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DataPath(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushstring(L, App.DataPath);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ResourceManager(IntPtr L)
	{
		try
		{
			ResourceManager arg0 = (ResourceManager)ToLua.CheckObject<ResourceManager>(L, 2);
			App.ResourceManager = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

