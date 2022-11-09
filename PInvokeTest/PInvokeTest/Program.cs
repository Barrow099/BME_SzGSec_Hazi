// See https://aka.ms/new-console-template for more information

using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using PInvokeTest;

Console.WriteLine("Hello, World!");
CIFFImage image = CIFFImage.fromFile("1.ciff");
Console.WriteLine(image.Caption);
Console.WriteLine($"{image.Width}x{image.Height}");
CAFFAnimation anim = CAFFAnimation.fromFile("2.caff");
Console.WriteLine(anim.Creator);
Console.WriteLine(anim.Frames[1].Image.Caption);

var preview = anim.GetPreview()!;
Bitmap bitmap = new Bitmap((int)anim.GetPreviewWidth(), (int)anim.GetPreviewHeight(), PixelFormat.Format24bppRgb);
Rectangle dimension = new Rectangle(0, 0, (int)anim.GetPreviewWidth(), (int)anim.GetPreviewHeight());
BitmapData picData = bitmap.LockBits(dimension, ImageLockMode.ReadWrite, bitmap.PixelFormat);
Marshal.Copy(preview, 0, picData.Scan0,  preview.Length);
bitmap.UnlockBits(picData);
