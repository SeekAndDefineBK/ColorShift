# ColorShift

A ViewModifier that will constantly update the color of a SwiftUI view. The color will gradient slowly from one color to the next. By default, the initial color is randomly selected.

This ViewModifer was built for my app Sneaker Tracker. I am open sourcing this because I've seen a similar effect elsewhere and no single tutorial could get me this exact effect. So I followed several tutorials to build this and hopefully you find this useful. 

Overview:
1. This ViewModifier accepts a width, height, and Color property. 
Width and Height, these are optional values where you can define size of the frame for the SwiftUI view. For Sneaker Tracker, this is an efficiency so that I could remove the .frame modifier from each view that also needed a color shift. 

Color, this is an optional value that accepts a Color (SwiftUI Color). If no color is passed in, the Color Shift animation occurs. If a color is passed in, that color overrides the Color Shift. 
- This is useful for Sneaker Tracker because I use color to define what shoe was used. This is just a fun way to highlight to the user that the workout is not yet assigned to a shoe. But when it is defined, the color of the workout snaps to the color of the Shoe used.   
- In open sourcing this though, I will be working on making the usecase more generic. I can already see the initializer built for Sneaker Tracker is counterintuitive for a general audience. Obviously disabling the Color Shift if the initial Color is not nil is not ideal.

Usage Instruction to come

Examples to come

# Priorities of Issues to solve.
1. Generalize initializer for Non-Sneaker Tracker usecases.
- Allow a developer to pass in an initial color and it doesn't disable the color shift.
- Create an initializer where width and height are not necessary. 
- Create an initializer that defines an optional Color value that when populated, disables the color shift. This is an initializer for Sneaker Tracker. 

2. More efficiency around changing the color and invoking the body redraw less. 

3. Allow for greater customization.
- Allow the developer to define the smoothness of the transition.
- Allow the developer to define a select range of colors to shift between. 
- Allow the developer to define the gap between color 1 and color 2.  
