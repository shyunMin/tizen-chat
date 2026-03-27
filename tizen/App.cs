using Tizen.Flutter.Embedding;

namespace Runner
{
    public class App : FlutterApplication
    {
        protected override void OnCreate()
        {
            // Set window properties before calling base.OnCreate()
            IsWindowTransparent = true;
            IsTopLevel = true;

            base.OnCreate();

            GeneratedPluginRegistrant.RegisterPlugins(this);
        }

        static void Main(string[] args)
        {
            var app = new App();
            app.Run(args);
        }
    }
}
