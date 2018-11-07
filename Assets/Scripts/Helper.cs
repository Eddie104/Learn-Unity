using System;
using System.IO;
using System.IO.Compression;
using System.Text;
using UnityEngine;

public static class Helper
{

    public static string DecodeBase64(string code)
    {
        byte[] bytes = Convert.FromBase64String(code);
        //从byBuf数组的第三个字节开始初始化实例
        using (MemoryStream ms = new MemoryStream(bytes, 2, bytes.Length - 2))
        {
            using (DeflateStream decompressionStream = new DeflateStream(ms, CompressionMode.Decompress, true))
            {
                StreamReader streamR = new StreamReader(decompressionStream, Encoding.Default);
                string strDeompressed = streamR.ReadToEnd();
                return strDeompressed;
            }
        }
    }

    public static void Info(string content)
    {
        UnityEngine.Debug.Log("[info]-><color=#FFFFFF>" + content + "</color>");
    }

    public static void Warn(string content)
    {
        UnityEngine.Debug.Log("[warn]-><color=#FFFF00>" + content + "</color>");
    }

    public static void Debug(string content)
    {
        UnityEngine.Debug.Log("[debug]-><color=#00EEEE>" + content + "</color>");
    }

    public static void Error(string content)
    {
        UnityEngine.Debug.Log("[error]-><color=#FF0000>" + content + "</color>");
    }
}