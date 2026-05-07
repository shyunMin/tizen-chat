using System;
using System.Runtime.InteropServices;
using Tizen.Flutter.Embedding;

namespace Runner
{
    public class App : FlutterApplication
    {
        [DllImport("flutter_tizen.so")]
        private static extern IntPtr FlutterDesktopViewGetNativeHandle(FlutterDesktopView view);

        [DllImport("libecore_wl2.so.1")]
        private static extern void ecore_wl2_window_focus_skip_set(
            IntPtr win,
            [MarshalAs(UnmanagedType.U1)] bool skip);

        [DllImport("libecore_wl2.so.1")]
        private static extern void ecore_wl2_window_pin_mode_set(
            IntPtr win,
            [MarshalAs(UnmanagedType.U1)] bool pin);

        [DllImport("libecore_wl2.so.1")]
        private static extern void ecore_wl2_window_commit(
            IntPtr win,
            [MarshalAs(UnmanagedType.U1)] bool flush);

        protected override void OnCreate()
        {
            IsWindowTransparent = true;
            // Setting IsTopLevel = true moves the window to E_LAYER_CLIENT_NOTIFICATION_TOP.
            // It is disabled here to allow fine-grained layer control via SetTopLevelWindow().
            // IsTopLevel = true;
            IsWindowFocusable = false;
            UserPixelRatio = 1.6;

            base.OnCreate();

            GeneratedPluginRegistrant.RegisterPlugins(this);
            SetTopLevelWindow();
            RegisterWindowFocusChannel();
        }

        private void SetTopLevelWindow()
        {
            IntPtr handle = FlutterDesktopViewGetNativeHandle(View);
            if (handle != IntPtr.Zero)
            {
                ecore_wl2_window_pin_mode_set(handle, true);
                ecore_wl2_window_commit(handle, true);
            }
        }

        private void RegisterWindowFocusChannel()
        {
            var channel = new MethodChannel("app/window_focus");
            channel.SetMethodCallHandler((MethodCall call) =>
            {
                if (call.Method == "setFocusable")
                {
                    bool focusable = (bool)call.Arguments;
                    IntPtr handle = FlutterDesktopViewGetNativeHandle(View);
                    if (handle != IntPtr.Zero)
                    {
                        ecore_wl2_window_focus_skip_set(handle, !focusable);
                    }
                }
                return null;
            });
        }

        static void Main(string[] args)
        {
            var app = new App();
            app.Run(args);
        }
    }
}
