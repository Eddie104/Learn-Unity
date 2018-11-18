using System.Diagnostics;

public class EditorHelper
{

    public static void RunPython(string arguments)
    {
        ProcessStartInfo psi = new ProcessStartInfo();
        psi.FileName = "python";
        psi.UseShellExecute = false;
        psi.RedirectStandardOutput = true;
        psi.Arguments = arguments;

        Process p = Process.Start(psi);
        string strOutput = p.StandardOutput.ReadToEnd();
        p.WaitForExit();
        UnityEngine.Debug.Log(strOutput);
    }

}