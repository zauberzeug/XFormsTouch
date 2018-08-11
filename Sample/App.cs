using System;
using Xamarin.Forms;
using XFormsTouch;
using System.Security.Cryptography;

namespace Sample
{
    public class App : Application
    {
        public App()
        {
            var label = new Label()
            {
                Text = "Touch Me",
                Margin = new Thickness(20, 50),
            };

            var touchEffect = new TouchEffect();
            touchEffect.TouchAction += (s, e) => label.Text = e.Type.ToString("f");

            label.Effects.Add(touchEffect);

            MainPage = new ContentPage()
            {
                Content = label
            };
        }
    }
}
