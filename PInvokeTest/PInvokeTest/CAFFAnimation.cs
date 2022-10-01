using System.Runtime.InteropServices;

namespace PInvokeTest;

public class CAFFAnimation
{
    private readonly IntPtr _handle;
    public string Creator { get; private set; }
    public List<CAFFAnimationFrame> Frames { get; private set; }

    public static CAFFAnimation fromFile(string path)
    {
        IntPtr animHandle = CAFFNative.CAFFLoader_from_file(path);
        if (animHandle == IntPtr.Zero)
        {
            var msg = Marshal.PtrToStringUTF8(CAFFNative.CIFFLoader_error_message());
            throw new Exception("CAFFAnimation loading failed:" + msg);
        }

        return new CAFFAnimation(animHandle);
    }

    public CAFFAnimation(IntPtr handle)
    {
        _handle = handle;
        Creator = Marshal.PtrToStringUTF8(CAFFNative.CAFFAnimation_getCreator(_handle))!;
        long frame_count = CAFFNative.CAFFAnimation_getFrameCount(_handle);
        IntPtr framesPtr = CAFFNative.CAFFAnimation_getFrames(_handle);
        List<CAFFAnimationFrame> frames = new List<CAFFAnimationFrame>();
        for (int i = 0; i < frame_count; i++)
        {
            long duration = Marshal.ReadInt64(IntPtr.Add(framesPtr, 16 * i));
            IntPtr imageHandle = Marshal.ReadIntPtr(IntPtr.Add(framesPtr, (16 * i) + 8));
            frames.Add(new CAFFAnimationFrame() {Duration = duration, Image = new CIFFImage(imageHandle)});
        }

        Frames = frames;
    }

    ~CAFFAnimation()
    {
        if (_handle != IntPtr.Zero)
        {
            CAFFNative.CAFFAnimation_delete(_handle);
        }
    }
}

public class CAFFAnimationFrame
{
    public long Duration { get; set; }
    public CIFFImage Image { get; set; }
}