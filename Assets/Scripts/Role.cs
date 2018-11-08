using UnityEngine;
using System.Collections;

public class Role : MonoBehaviour
{

    private Sprite testSprite;

    void Start()
    {
        AssetBundle ab = AssetBundle.LoadFromFile(Application.dataPath + "/AssetBundles/test");
        //Texture2D texture = ab.LoadAsset("Clothes_002") as Texture2D;
        Sprite[] t = ab.LoadAssetWithSubAssets<Sprite>("Clothes_002");
        testSprite = t[0];
        //for (int i = 0; i < t.Length; i++)
        //{
        //    Debug.Log(t[i]);
        //}
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyUp(KeyCode.Space)) {
            Transform[] transformArr = gameObject.GetComponentsInChildren<Transform>();
            for (int i = 0; i < transformArr.Length; i++) {
                if (transformArr[i].name == "Clothes") {
                    transformArr[i].GetComponent<SpriteRenderer>().sprite = testSprite;
                    //transformArr[i].position = new Vector3(1.0f, 1.0f);
                    break;
                }
            }
        }
    }
}
