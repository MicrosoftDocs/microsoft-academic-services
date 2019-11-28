---
title: Language Similarity Sample
description: Language Similarity Sample (C#)
services: microsoft-academic-services
ms.topic: extra
ms.service: microsoft-academic-services
ms.date: 11/28/2019
---
# Language Similarity Sample (C#)

Language Similarity Package includes a C# demo project in LanguageSimilarityExample folder.
It contains sample.txt as a input for the demo project, where each line contains the parameter(s) for an API call.

## System Requirements

1. Microsoft Windows 7 (or above) 64-bit OS
2. .NET Framework version 4.5.2+
3. Visual Studio 2015 (or above)

## Running the Program

1. Open LanguageSimilarityExample solution.
2. Start LanguageSimilarityExample project. The parameters are pre-populated in the project file.

This demo is a console program which takes a resource directory and sample.txt path as input parameters.

It first creates a LanguageSimilarity instance with resource directory to initialize the models.

  ```C#
  string resourceDir = args[0];
  LanguageSimilarity languageSimilarity = new LanguageSimilarity(resourceDir);
  ```

Then it reads the sample.txt. Each line is a command to an API call. Three examples are illustrated below:

  ```C#
  string sampleFilePath = args[1];
  using (StreamReader sr = new StreamReader(sampleFilePath))
  {
      string line;
      while ((line = sr.ReadLine()) != null)
      {
          try
          {
              Console.WriteLine(line);

              var tokens = line.Split('\t');
              if (tokens.Length < 2)
              {
                  continue;
              }

              switch (tokens[0])
              {
                  case "1":
                      var score1 = languageSimilarity.ComputeSimilarity(tokens[1], tokens[2]);
                      Console.WriteLine("=>\t{0}", Math.Round(score1, 4));
                      break;
                  case "2":
                      var score2 = languageSimilarity.ComputeSimilarity(tokens[2], long.Parse(tokens[1]));
                      Console.WriteLine("=>\t{0}", Math.Round(score2, 4));
                      break;
                  case "3":
                      var foses = languageSimilarity.GetTopFieldsOfStudy(tokens[3], int.Parse(tokens[1]), float.Parse(tokens[2]));
                      int count = 0;
                      foreach (var fos in foses)
                      {
                          Console.WriteLine("=>\t{0}\t{1}\t{2}", ++count, fos.Item1, Math.Round(fos.Item2, 4));
                      }
                      break;
              }
          }
          catch (ArgumentException e)
          {
              Console.WriteLine(e.Message);
          }
      }
  }
  ```
