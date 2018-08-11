using System;
using Xamarin.Forms;
using XFormsTouch;

namespace Sample
{
    public class App : Application
    {
        public App()
        {
            var label = new Label() { Text = "XFormsTouch", Margin = new Thickness(20, 50), };

            var touchEffect = new TouchEffect();
            touchEffect.TouchAction += (s, e) => label.Text = e.Id.ToString("f");


            label.Effects.Add(touchEffect);

            MainPage = new ContentPage()
            {
                Content = label
            };
        }
    }
}
