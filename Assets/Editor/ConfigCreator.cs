using UnityEngine;
using UnityEditor;

public class ConfigCreator : MonoBehaviour
{
    [MenuItem("Libra/Create Game Config")]
    private static void CreateGameConfig()
    {
        EditorHelper.RunPython(Application.dataPath + "/../tools/createConfig.py");
    }

    [MenuItem("Libra/Create Animation Config")]
    private static void CreateAnimationConfig()
    {
        EditorHelper.RunPython(Application.dataPath + "/../tools/createAnimationConfig.py");
    }
}