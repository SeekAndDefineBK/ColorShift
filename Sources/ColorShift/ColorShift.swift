//
//  ColorShift.swift
//  SneakerTracker2
//
//  Created by Brett Koster on 2/26/22.
//

import SwiftUI

struct ColorShiftModifier: ViewModifier {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    let width: CGFloat?
    let height: CGFloat?
    let color: Color?
    let colorLimit: Double?
    let shiftInitialColor: Bool?
    let colorChange: Double = 0.009
    let initialHue: Double?
    
    @State var color1: Color
    @State var c1Reverse: Bool = false
    @State var c1hue: Double
    
    @State var color2: Color
    @State var c2Reverse: Bool = false
    @State var c2hue: Double
    
    init(width: CGFloat?, height: CGFloat?, color: Color?) {
        self.width = width
        self.height = height
        self.color = color
        self.colorLimit = nil
        self.shiftInitialColor = nil
        self.initialHue = nil
        
        let c1 = Double.random(in: 0...1)
        let c2 = Double.random(in: 0...1)
        
        c1hue = c1
        c2hue = c2
        
        _color1 = State(wrappedValue: Color(hue: c1, saturation: 1.0, brightness: 1.0))
        _color2 = State(wrappedValue: Color(hue: c2, saturation: 1.0, brightness: 1.0))
    }
    
    init(shiftInitialColor: Bool, color: Color, width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
        self.color = color
        self.colorLimit = 0.15
        self.shiftInitialColor = shiftInitialColor
        
        var hue: Double {
            let output = UIColor(color).hsba
            return output.h
        }
        
        let c1 = hue
        let c2 = hue + colorChange
        
        c1hue = c1
        self.initialHue = c1
        c2hue = c2
        
        _color1 = State(wrappedValue: Color(hue: c1, saturation: 1.0, brightness: 1.0))
        _color2 = State(wrappedValue: Color(hue: c2, saturation: 1.0, brightness: 1.0))
    }
    
    func body(content: Content) -> some View {

        ZStack(alignment: .topTrailing) {
            if shiftInitialColor == nil && color != nil {
                content
                    .foregroundStyle(color!)
            } else {
                content
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [color1, color2]),
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                    )
                    .onReceive(timer) { _ in
                        updateColors()
                    }
            }
        }
        .frame(width: width ?? .infinity, height: height ?? .infinity)
    }
    
    //MARK: Color shifting methods
    enum colorChoice {
        case c1, c2
    }
    
    func updateColors() {
        withAnimation {
            color1 = changeColor(colorChoice: .c1)
            color2 = changeColor(colorChoice: .c2)
        }
    }
    
    func changeColor(colorChoice: colorChoice) -> Color {
        //this is needed to instruct the direction block which color to inspect
        var initialHue: Double {
            switch colorChoice {
            case .c1:
                return c1hue
            case .c2:
                return c2hue
            }
        }
        
        //handle when to reverse the color gradient direction
        if colorLimit != nil {
            colorLimitReverse(targetHue: initialHue, colorChoice: colorChoice)
        } else {
            defaultLimitReverse(initialHue: initialHue, colorChoice: colorChoice)
        }
        
        //execute the change in color by changing the hue
        switch colorChoice {
        case .c1:
            if c1Reverse {
                c1hue -= colorChange
            } else {
                c1hue += colorChange
            }
        case .c2:
            if c2Reverse {
                c2hue -= colorChange
            } else {
                c2hue += colorChange
            }
        }
        
        //return a new color by using the newly changed hue
        switch colorChoice {
        case .c1:
            return Color(hue: c1hue, saturation: 1, brightness: 1)
        case .c2:
            return Color(hue: c2hue, saturation: 1, brightness: 1)
        }
    }
    
    func defaultLimitReverse(initialHue: Double, colorChoice: colorChoice) {
        //determine direction of hue should shift
        //Hue is not allowed to be higher than 0.99 or lower than 0.02.
        //this block will tell the next block if the animation is being reversed
        if initialHue >= 0.99 {
            switch colorChoice {
            case .c1:
                c1Reverse = true
            case .c2:
                c2Reverse = true
            }
        } else if initialHue <= 0.02 {
            switch colorChoice {
            case .c1:
                c1Reverse = false
            case .c2:
                c2Reverse = false
            }
        }
    }
    
    func colorLimitReverse(targetHue: Double, colorChoice: colorChoice) {
        //initialHue +/- colorLimit is the range of colors the hue is allowed to span
        if targetHue >= initialHue! + colorLimit! {
            //if yes trigger the reverse
            switch colorChoice {
            case .c1:
                c1Reverse = true
                print("c1reverse = true")
            case .c2:
                c2Reverse = true
                print("c2reverse = true")
            }
            
        } else if targetHue <= initialHue! - colorLimit!{
            switch colorChoice {
            case .c1:
                c1Reverse = false
                print("c1reverse = false")
            case .c2:
                c2Reverse = false
                print("c2reverse = false")
            }
        }
        
//        print("initialHue = \(initialHue), targetHue = \(targetHue), colorLimit = \(colorLimit!), combined = \(targetHue + colorLimit!)")
    }
}

extension UIColor {
    var hsba: (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }
}

extension View {
    /// This ViewModifier will constantly update the color of a SwiftUI view. The color will gradient slowly from one color to the next. By default, the initial color is randomly selected.
    /// - Parameters:
    ///   - width: Optional desired width of the View.
    ///   - height: Optional desired height of the View.
    ///   - color: Optional non-color shifting color. If this is not nil, the color shift will be disabled and the color passed in will display.
    /// - Returns: some View
    public func ColorShift(width: CGFloat?, height: CGFloat?, color: Color?) -> some View {
        modifier(ColorShiftModifier(width: width, height: height, color: color))
    }
    
    
    /// This ViewModifier will apply a constantly updating gradient foreground effect to a SwiftUI view. The color will slowly gradient from one color to the next and will start as a random color each time. This initializer is used when you do not need to specify any of the other ColorShift properties.
    /// - Returns: some View
    public func ColorShift() -> some View {
        modifier(ColorShiftModifier(width: nil, height: nil, color: nil))
    }
    
    /// This ViewModifier will apply a constantly updating gradient foreground effect to a SwiftUI view. Unlike the other initializers, this one will limit the range of color gradients to be similar to the original color passed in.
    /// - Parameters:
    ///   - shiftInitialColor: Provide `true` if you want to limit the range of color shift to the original color. Providing `false` is effectively unnecessary.
    ///   - color: This is the original `Color` where the gradient will start shifting from.
    ///   - width: Optional desired width of the View.
    ///   - height: Optional desired height of the View.
    /// - Returns: some View
    public func ColorShift(shiftInitialColor: Bool, color: Color, width: CGFloat?, height: CGFloat?) -> some View {

        //modifier(ColorShiftModifier(width: nil, height: nil, color: nil))
        modifier(ColorShiftModifier(shiftInitialColor: shiftInitialColor, color: color, width: width, height: height))
    }
}
