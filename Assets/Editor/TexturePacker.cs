using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;

[System.Serializable]
public class V4
{
    public int x;
    public int y;
    public int w;
    public int h;

    public V4() { }
}

[System.Serializable]
public class V2
{
    public int w;
    public int h;

    public V2() { }
}

[System.Serializable]
public class Frame
{
    public string filename;
    public V4 frame;
    public bool rotated;
    public bool trimmed;
    public V4 spriteSourceSize;
    public V2 sourceSize;

    public Frame() { }
}

[System.Serializable]
public class Meta
{
    public string image;
    public V2 size;
}

[System.Serializable]
public class Frames
{
    public List<Frame> frames = new List<Frame>();
    public Meta meta;
    public Frames() { }
}

public class TexturePackerImporterEditor
{
    Frames frames = null;
    Texture2D texFile = null;

    [MenuItem("Assets/TexturePacker-->UnitySprite")]
public static void ShowWindow()
    {
        if (Selection.activeObject == null)
            return;

        Texture2D t = Selection.activeObject as Texture2D;
        if (t == null)
        {
            EditorUtility.DisplayDialog("错误", "只能转换Png文件！", "ok");
            return;
        }

        TexturePackerImporterEditor tpie = new TexturePackerImporterEditor
        {
            texFile = t
        };

        string path = AssetDatabase.GetAssetPath(tpie.texFile);
        var jsonFile = AssetDatabase.LoadAssetAtPath(System.IO.Path.ChangeExtension(path, "txt"), typeof(TextAsset)) as TextAsset;
        if (jsonFile == null)
        {
            EditorUtility.DisplayDialog("提示", "Json 文件必须放在 Png 文件同目录下", "ok");
            return;
        }
        EditorHelper.RunPython(Application.dataPath + "/../tools/texturePackerJsonFormat.py");
        AssetDatabase.Refresh();

        tpie.frames = JsonUtility.FromJson<Frames> (jsonFile.text);
        tpie.ImportTexture ();
    }

    void ImportTexture()
    {
        string _texPath = AssetDatabase.GetAssetPath(texFile);
        TextureImporter ti = AssetImporter.GetAtPath(_texPath) as TextureImporter;

        // 生成Sprite
        List<SpriteMetaData> sps = new List<SpriteMetaData>();
        foreach (Frame f in frames.frames)
        {
            SpriteMetaData md = new SpriteMetaData();

            int width = f.rotated ? f.frame.h : f.frame.w;
            int height = f.rotated ? f.frame.w : f.frame.h;

            int x = f.frame.x;

            // TexturePacker以左上为原点，Unity以左下为原点
            int y = frames.meta.size.h - height - f.frame.y;

            md.rect = new Rect(x, y, width, height);
            md.pivot = md.rect.center;
            md.name = System.IO.Path.ChangeExtension(f.filename, null);

            sps.Add(md);
        }

        ti.textureType = TextureImporterType.Sprite;
        ti.spriteImportMode = SpriteImportMode.Multiple;
        ti.spritePixelsPerUnit = 1;
        ti.filterMode = FilterMode.Point;
        ti.spritesheet = sps.ToArray();

        AssetDatabase.ImportAsset(_texPath, ImportAssetOptions.ForceUncompressedImport);
    }

}
