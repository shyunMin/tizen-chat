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

        public enum KeyGrabMode
        {
            Topmost = 0,
            Shared,
            Exclusive,
            OverrideExclusive
        }

        [DllImport("libecore_wl2.so.1")]
        private static extern void ecore_wl2_window_keygrab_set(
            IntPtr win,
            string key,
            int modifiers,
            int not_modifiers,
            int priority,
            int mode);

        [DllImport("libecore_wl2.so.1")]
        private static extern void ecore_wl2_window_keygrab_unset(
            IntPtr win,
            string key,
            int modifiers,
            int not_modifiers);

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
            // Channel keys remain grabbed by default even with IsWindowFocusable=false and must be explicitly unset.
            UngrabChannelKeys();
            GrabBackKey();
        }

        private void GrabBackKey()
        {
            IntPtr handle = FlutterDesktopViewGetNativeHandle(View);
            if (handle != IntPtr.Zero)
            {
                ecore_wl2_window_keygrab_set(handle, "XF86Back", 0, 0, 0, (int)KeyGrabMode.Exclusive);
            }
        }

        private void UngrabChannelKeys()
        {
            IntPtr handle = FlutterDesktopViewGetNativeHandle(View);
            if (handle != IntPtr.Zero)
            {
                ecore_wl2_window_keygrab_unset(handle, "XF86RaiseChannel", 0, 0);
                ecore_wl2_window_keygrab_unset(handle, "XF86LowerChannel", 0, 0);
            }
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
            channel.SetMethodCallHandler(async (MethodCall call) =>
            {
                IntPtr handle = FlutterDesktopViewGetNativeHandle(View);
                if (handle == IntPtr.Zero) return null;

                if (call.Method == "setFocusable")
                {
                    bool focusable = (bool)call.Arguments;
                    ecore_wl2_window_focus_skip_set(handle, !focusable);
                }
                else if (call.Method == "grabKey")
                {
                    string keyName = (string)call.Arguments;
                    ecore_wl2_window_keygrab_set(handle, keyName, 0, 0, 0, (int)KeyGrabMode.Exclusive);
                }
                else if (call.Method == "ungrabKey")
                {
                    string keyName = (string)call.Arguments;
                    ecore_wl2_window_keygrab_unset(handle, keyName, 0, 0);
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
