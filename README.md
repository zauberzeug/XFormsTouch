# XFormsTouch

This NuGet library provides touch event notifications for Android and iOS via Xamarin.Forms.Effect mechanism as shown in one of the xamarin samples.

The code is copied from https://github.com/xamarin/xamarin-forms-samples/tree/master/Effects/TouchTrackingEffect and adapted to be used as a separate library.
Xamarin explains how it works at https://docs.microsoft.com/en-us/xamarin/xamarin-forms/app-fundamentals/effects/touch-tracking.

Original copyright is owned by Xamarin Inc (see LICENSE and NOTICE).


## Example

```csharp
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
```
