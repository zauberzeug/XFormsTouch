using System;
using Xamarin.Forms;

namespace Sample
{
    public class App : Application
    {
        public App()
        {
            MainPage = new ContentPage()
            {
                Content = new Label() { Text = "XFormsTouch", Margin = 40, }
            };
        }
    }
}
