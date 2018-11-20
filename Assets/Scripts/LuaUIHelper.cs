﻿using System;
using FairyGUI.Utils;
using LuaInterface;

namespace FairyGUI
{
    /// <summary>
    /// 
    /// </summary>
    public sealed class LuaUIHelper
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="luaClass"></param>
        public static void SetExtension(string url, System.Type baseType, LuaFunction extendFunction)
        {
            UIObjectFactory.SetPackageItemExtension(url, () =>
            {
                GComponent gcom = (GComponent)Activator.CreateInstance(baseType);
                gcom.data = extendFunction;
                return gcom;
            });
        }

        [NoToLuaAttribute]
        public static LuaTable ConnectLua(GComponent gcom)
        {
            LuaTable peerTable = null;
            LuaFunction extendFunction = gcom.data as LuaFunction;
            if (extendFunction != null)
            {
                gcom.data = null;

                extendFunction.BeginPCall();
                extendFunction.Push(gcom);
                extendFunction.PCall();
                peerTable = extendFunction.CheckLuaTable();
                extendFunction.EndPCall();
            }

            return peerTable;
        }
    }

    public class GLuaComponent : GComponent
    {
        LuaTable _peerTable;

        [NoToLuaAttribute]
        public override void ConstructFromXML(XML xml)
        {
            base.ConstructFromXML(xml);

            _peerTable = LuaUIHelper.ConnectLua(this);
        }

        public override void Dispose()
        {
            base.Dispose();

            if (_peerTable != null)
            {
                _peerTable.Dispose();
                _peerTable = null;
            }
        }
    }

    public class GLuaLabel : GLabel
    {
        LuaTable _peerTable;

        [NoToLuaAttribute]
        public override void ConstructFromXML(XML xml)
        {
            base.ConstructFromXML(xml);

            _peerTable = LuaUIHelper.ConnectLua(this);
        }

        public override void Dispose()
        {
            base.Dispose();

            if (_peerTable != null)
            {
                _peerTable.Dispose();
                _peerTable = null;
            }
        }
    }

    public class GLuaButton : GButton
    {
        LuaTable _peerTable;

        [NoToLuaAttribute]
        public override void ConstructFromXML(XML xml)
        {
            base.ConstructFromXML(xml);

            _peerTable = LuaUIHelper.ConnectLua(this);
        }

        public override void Dispose()
        {
            base.Dispose();

            if (_peerTable != null)
            {
                _peerTable.Dispose();
                _peerTable = null;
            }
        }
    }

    public class GLuaProgressBar : GProgressBar
    {
        LuaTable _peerTable;

        [NoToLuaAttribute]
        public override void ConstructFromXML(XML xml)
        {
            base.ConstructFromXML(xml);

            _peerTable = LuaUIHelper.ConnectLua(this);
        }

        public override void Dispose()
        {
            base.Dispose();

            if (_peerTable != null)
            {
                _peerTable.Dispose();
                _peerTable = null;
            }
        }
    }

    public class GLuaSlider : GSlider
    {
        LuaTable _peerTable;

        [NoToLuaAttribute]
        public override void ConstructFromXML(XML xml)
        {
            base.ConstructFromXML(xml);

            _peerTable = LuaUIHelper.ConnectLua(this);
        }

        public override void Dispose()
        {
            base.Dispose();

            if (_peerTable != null)
            {
                _peerTable.Dispose();
                _peerTable = null;
            }
        }
    }

    public class GLuaComboBox : GComboBox
    {
        LuaTable _peerTable;

        [NoToLuaAttribute]
        public override void ConstructFromXML(XML xml)
        {
            base.ConstructFromXML(xml);

            _peerTable = LuaUIHelper.ConnectLua(this);
        }

        public override void Dispose()
        {
            base.Dispose();

            if (_peerTable != null)
            {
                _peerTable.Dispose();
                _peerTable = null;
            }
        }
    }

    public class LuaWindow : Window
    {
        LuaTable _peerTable;
        LuaFunction _OnInit;
        LuaFunction _DoHideAnimation;
        LuaFunction _DoShowAnimation;
        LuaFunction _OnShown;
        LuaFunction _OnHide;

        public void ConnectLua(LuaTable peerTable)
        {
            _peerTable = peerTable;
            _OnInit = peerTable.GetLuaFunction("OnInit");
            _DoHideAnimation = peerTable.GetLuaFunction("DoHideAnimation");
            _DoShowAnimation = peerTable.GetLuaFunction("DoShowAnimation");
            _OnShown = peerTable.GetLuaFunction("OnShown");
            _OnHide = peerTable.GetLuaFunction("OnHide");
        }

        public override void Dispose()
        {
            base.Dispose();

            if (_peerTable != null)
            {
                _peerTable.Dispose();
                _peerTable = null;
            }
            if (_OnInit != null)
            {
                _OnInit.Dispose();
                _OnInit = null;
            }
            if (_DoHideAnimation != null)
            {
                _DoHideAnimation.Dispose();
                _DoHideAnimation = null;
            }
            if (_DoShowAnimation != null)
            {
                _DoShowAnimation.Dispose();
                _DoShowAnimation = null;
            }
            if (_OnShown != null)
            {
                _OnShown.Dispose();
                _OnShown = null;
            }
            if (_OnHide != null)
            {
                _OnHide.Dispose();
                _OnHide = null;
            }
        }

        protected override void OnInit()
        {
            if (_OnInit != null)
            {
                _OnInit.BeginPCall();
                _OnInit.Push(this);
                _OnInit.PCall();
                _OnInit.EndPCall();
            }
        }

        protected override void DoHideAnimation()
        {
            if (_DoHideAnimation != null)
            {
                _DoHideAnimation.BeginPCall();
                _DoHideAnimation.Push(this);
                _DoHideAnimation.PCall();
                _DoHideAnimation.EndPCall();
            }
            else
                base.DoHideAnimation();
        }

        protected override void DoShowAnimation()
        {
            if (_DoShowAnimation != null)
            {
                _DoShowAnimation.BeginPCall();
                _DoShowAnimation.Push(this);
                _DoShowAnimation.PCall();
                _DoShowAnimation.EndPCall();
            }
            else
                base.DoShowAnimation();
        }

        protected override void OnShown()
        {
            base.OnShown();

            if (_OnShown != null)
            {
                _OnShown.BeginPCall();
                _OnShown.Push(this);
                _OnShown.PCall();
                _OnShown.EndPCall();
            }
        }

        protected override void OnHide()
        {
            base.OnHide();

            if (_OnHide != null)
            {
                _OnHide.BeginPCall();
                _OnHide.Push(this);
                _OnHide.PCall();
                _OnHide.EndPCall();
            }
        }
    }
}