// See https://aka.ms/new-console-template for more information

using System.Runtime.InteropServices;
using PInvokeTest;

Console.WriteLine("Hello, World!");
CIFFImage image = CIFFImage.fromFile("1.ciff");
Console.WriteLine(image.Caption);
Console.WriteLine($"{image.Width}x{image.Height}");
CAFFAnimation anim = CAFFAnimation.fromFile("2.caff");
Console.WriteLine(anim.Creator);
Console.WriteLine(anim.Frames[1].Image.Caption);