using System.Runtime.InteropServices;

namespace PInvokeTest;

public class CIFFImage
{
    private readonly IntPtr _handle;

    public Int64 Width {get; set; }
    public Int64 Height {get; set; }
    public string Caption {get; set; }

    internal CIFFImage(IntPtr handle)
    {
        this._handle = handle;

        Width = CAFFNative.CIFFImage_getWidth(_handle);
        Height = CAFFNative.CIFFImage_getHeight(_handle);
        Caption = Marshal.PtrToStringUTF8(CAFFNative.CIFFImage_getCaption(_handle))!;
    }

    public static CIFFImage fromFile(string path)
    {
        IntPtr handle = CAFFNative.CIFFLoader_from_file(path);
        if (handle == IntPtr.Zero)
        {
            var msg = Marshal.PtrToStringUTF8(CAFFNative.CIFFLoader_error_message());
            throw new Exception("CIFFImage loading failed:" + msg);
        }

        return new CIFFImage(handle);
    }
    
    public static CIFFImage fromBytes(byte[] bytes)
    {
        IntPtr handle = CAFFNative.CIFFLoader_from_bytes(bytes, (long)bytes.Length);
        if (handle == IntPtr.Zero)
        {
            var msg = Marshal.PtrToStringUTF8(CAFFNative.CIFFLoader_error_message());
            throw new Exception("CIFFImage loading failed:" + msg);
        }

        return new CIFFImage(handle);
    }

    ~CIFFImage()
    {
        if (IntPtr.Zero != _handle)
        {
            CAFFNative.CIFFImage_delete(_handle);
        }  
    }
}