using UnityEngine;

public class NPC : MonoBehaviour
{

    bool Walking = false;

    int WalkingId = -1;

    int Dir = 3;

    //int DirId = -1;

    Animator animator;

    // Use this for initialization
    void Start()
    {
        WalkingId = Animator.StringToHash("Walking");
        //DirId = Animator.StringToHash("Dir");
        animator = GetComponent<Animator>();
        animator.speed = 0.5f;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyUp(KeyCode.Space))
        {
            //Walking = !Walking;
            //animator.SetBool(WalkingId, Walking);
            Dir = Dir == 3 ? 7 : 3;
            //animator.SetInteger(DirId, Dir);
            animator.SetInteger("Dir", Dir);
        }
    }
}
