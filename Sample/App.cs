using System;
using Xamarin.Forms;
using XFormsTouch;

namespace Sample
{
    public class App : Application
    {
        public App()
        {
            var label = new Label()
            {
                Text = "Touch Me",
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center,
                FontSize = 42
            };

            var touchEffect = new TouchEffect();
            touchEffect.TouchAction += (s, e) =>
            {
                label.Text = e.Type.ToString("f");
                Console.WriteLine(e.Type.ToString());
            };

            label.Effects.Add(touchEffect);

            MainPage = new ContentPage()
            {
                Content = label
            };
        }
    }
}
