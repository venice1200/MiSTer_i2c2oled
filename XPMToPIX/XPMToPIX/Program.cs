using System;
using System.IO;
using System.Text.RegularExpressions;

namespace XPMToPIX
{
  class Program
  {
    static void Main(string[] args)
    {
      // Set folder (application path or first argument)
      string folder = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
      if (args.Length > 0)
      {
        if (Directory.Exists(args[0]))
          folder = args[0];
        else
        {
          Console.WriteLine("Path does not exist!");
          Environment.Exit(0);
        }
      }

      Console.WriteLine("------------------------------------------------------------");
      Console.WriteLine("Path: " + folder);
      Console.WriteLine("Converting all XPM images to PIX...");

      // Convert all files in folder
      string [] files = Directory.GetFiles(folder, "*.xpm");
      foreach (string file in files)
      {
        Console.Write("Converting: \"" + Path.GetFileName(file) + "\"..."); 

        string xpm = File.ReadAllText(file);
        string pix = xpm.Replace("\r\n", "\n");
        string [] pixLines = pix.Split('\n');
        bool error = false;

        try
        {
          // Find last line to use (the one with };)
          int lineMax = pixLines.Length - 1;
          for (int i = lineMax; i >= 0; i--)
          {
            if (pixLines[i].Contains("};"))
            {
              lineMax = i;
              break;
            }
          }

          // Replace }; with ) of last line
          pixLines[lineMax] = pixLines[lineMax].Replace("};", ")");

          // Write "header"
          pix = "#!/bin/bash\nlogo=(";

          // Write all lines
          for (int i = 5; i <= lineMax; i++)
            pix += pixLines[i].Replace(".", "0").Replace(" ", "1") + "\n";

          // Save the PIX to the same folder with the same name (with .pix extension)
          File.WriteAllText(Path.Combine(Path.GetDirectoryName(file), Path.GetFileNameWithoutExtension(file)) + ".pix", pix);
        }
        catch (Exception)
        {
          Console.WriteLine(" failed!");
          error = true;
        }
        if(!error)
          Console.WriteLine(" done!");
      }

      Console.WriteLine("------------------------------------------------------------");

    }
  }
}
