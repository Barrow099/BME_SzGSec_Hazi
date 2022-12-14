using System.Runtime.InteropServices;

namespace PInvokeTest;

public class CAFFNative
{
    [DllImport("CAFF")]
    public static extern IntPtr CIFFLoader_from_bytes(byte[] bytes, long len);
    [DllImport("CAFF")]
    public static extern IntPtr CIFFLoader_from_file(string path);
    [DllImport("CAFF")]
    public static extern IntPtr CIFFLoader_error_message();

    [DllImport("CAFF")]
    public static extern void CIFFWriter_to_file(IntPtr image, string path);
    //[DllImport("CAFF")]
    //public static extern void CIFFWriter_to_bytes(IntPtr image, string path);
    [DllImport("CAFF")]
    public static extern IntPtr CIFFImage_new(CLong width, CLong height, string caption, IntPtr tags, CULong num_of_tags, IntPtr content, CLong content_size);
    [DllImport("CAFF")]
    public static extern void CIFFImage_delete(IntPtr image);
    [DllImport("CAFF")]
    public static extern long CIFFImage_getWidth(IntPtr image);
    [DllImport("CAFF")]
    public static extern long CIFFImage_getHeight(IntPtr image);
    [DllImport("CAFF")]
    public static extern long CIFFImage_getContentSize(IntPtr image);
    [DllImport("CAFF")]
    public static extern IntPtr CIFFImage_getContent(IntPtr image);
    [DllImport("CAFF")]
    public static extern IntPtr CIFFImage_getCaption(IntPtr image);
    [DllImport("CAFF")]
    public static extern long CIFFImage_getTagCount(IntPtr image);
    [DllImport("CAFF")]
    public static extern IntPtr CIFFImage_getTags(IntPtr image);

    [DllImport("CAFF")]
    public static extern IntPtr CAFFLoader_from_file(string path);
    [DllImport("CAFF")]
    public static extern IntPtr CAFFLoader_error_message();
    [DllImport("CAFF")]
    public static extern IntPtr CAFFAnimation_getCreator(IntPtr animationHandle);
    [DllImport("CAFF")]
    public static extern void CAFFAnimation_delete(IntPtr animationHandle);
    [DllImport("CAFF")]
    public static extern IntPtr CAFFAnimation_getFrames(IntPtr animationHandle);
    [DllImport("CAFF")]
    public static extern IntPtr CAFFAnimation_getPreview(IntPtr animationHandle);
    [DllImport("CAFF")]
    public static extern long CAFFAnimation_getPreviewSize(IntPtr animationHandle);
    [DllImport("CAFF")]
    public static extern long CAFFAnimation_getPreviewWidth(IntPtr animationHandle);
    [DllImport("CAFF")]
    public static extern long CAFFAnimation_getPreviewHeight(IntPtr animationHandle);
    [DllImport("CAFF")]
    public static extern long CAFFAnimation_getFrameCount(IntPtr animationHandle);
    [DllImport("CAFF")]
    public static extern long CAFFAnimationFrame_getDuration(IntPtr frameHandle);
    [DllImport("CAFF")]
    public static extern IntPtr CAFFAnimationFrame_getImage(IntPtr frameHandle);
    
}