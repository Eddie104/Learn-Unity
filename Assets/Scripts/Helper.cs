using System;
using System.IO;
using System.IO.Compression;
using System.Security.Cryptography;
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

    public static int Random(int min, int max)
    {
        return UnityEngine.Random.Range(min, max);
    }

    /// <summary>
    /// 查找子对象
    /// </summary>
    public static GameObject Child(GameObject go, string subnode)
    {
        return Child(go.transform, subnode);
    }

    /// <summary>
    /// 查找子对象
    /// </summary>
    public static GameObject Child(Transform go, string subnode)
    {
        Transform tran = go.Find(subnode);
        if (tran == null) return null;
        return tran.gameObject;
    }

    /// <summary>
    /// 取平级对象
    /// </summary>
    public static GameObject Peer(GameObject go, string subnode)
    {
        return Peer(go.transform, subnode);
    }

    /// <summary>
    /// 取平级对象
    /// </summary>
    public static GameObject Peer(Transform go, string subnode)
    {
        Transform tran = go.parent.Find(subnode);
        if (tran == null) return null;
        return tran.gameObject;
    }

    /// <summary>
    /// 计算字符串的MD5值
    /// </summary>
    public static string md5(string source)
    {
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        byte[] data = System.Text.Encoding.UTF8.GetBytes(source);
        byte[] md5Data = md5.ComputeHash(data, 0, data.Length);
        md5.Clear();

        string destString = "";
        for (int i = 0; i < md5Data.Length; i++)
        {
            destString += System.Convert.ToString(md5Data[i], 16).PadLeft(2, '0');
        }
        destString = destString.PadLeft(32, '0');
        return destString;
    }

    /// <summary>
    /// 计算文件的MD5值
    /// </summary>
    public static string md5file(string file)
    {
        try
        {
            FileStream fs = new FileStream(file, FileMode.Open);
            MD5 md5 = new MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(fs);
            fs.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex)
        {
            throw new Exception("md5file() fail, error:" + ex.Message);
        }
    }

    /// <summary>
    /// 清除所有子节点
    /// </summary>
    public static void ClearChild(Transform go)
    {
        if (go == null) return;
        for (int i = go.childCount - 1; i >= 0; i--)
        {
            GameObject.Destroy(go.GetChild(i).gameObject);
        }
    }

    #region log

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
    #endregion
}