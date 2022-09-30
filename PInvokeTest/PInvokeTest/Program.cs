// See https://aka.ms/new-console-template for more information

using System.Runtime.InteropServices;
using PInvokeTest;

Console.WriteLine("Hello, World!");
CIFFImage image = CIFFImage.fromFile("1.ciff");
Console.WriteLine(image.Caption);
Console.WriteLine($"{image.Width}x{image.Height}");