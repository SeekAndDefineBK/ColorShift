//
//  ColorShift.swift
//  SneakerTracker2
//
//  Created by Brett Koster on 2/26/22.
//

import SwiftUI

struct ColorShiftModifier: ViewModifier {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var color1Counter:Int = 0
    @State var color2Counter: Int = 1
    
    let width: CGFloat?
    let height: CGFloat?
    let color: Color?
    
    @State var c1Reverse: Bool = false
    @State var c1hue: Double = Double.random(in: 0...1)
    
    @State var c2Reverse: Bool = false
    @State var c2hue: Double = Double.random(in: 0...1)
    
    @State var color1 = Color.blue
    @State var color2 = Color.cyan
    
    func body(content: Content) -> some View {

        return ZStack(alignment: .topTrailing) {
            if color != nil {
                content
                    .foregroundStyle(color!)
            }
            
            if color == nil {
                content
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .topTrailing, endPoint: .bottomLeading))
                    .onReceive(timer) { _ in
                        updateColors()
                    }
            }
        }
        .frame(width: width ?? .infinity, height: height ?? .infinity)
    }
    
    func updateColors() {
        withAnimation {
            color1 = createColor(colorChoice.c1)
            color2 = createColor(colorChoice.c2)
        }
    }
    
    func createColor(_ colorChoice: colorChoice) -> Color {
        
        switch colorChoice {
            
        case .c1:
            
            //determine direction of hue
            if c1hue >= 0.99 {
                c1Reverse = true
            } else if c1hue <= 0.02 {
                c1Reverse = false
            }
            
            //execute direction
            if c1Reverse {
                c1hue -= 0.009
            } else {
                c1hue += 0.009
            }

            return Color(hue: c1hue, saturation: 1, brightness: 1)
        case .c2:
            
            //determine direction of hue
            if c2hue >= 0.99 {
                c2Reverse = true
            } else if c2hue <= 0.02 {
                c2Reverse = false
            }
            
            //c2 changes slower to make the gradient effect stronger
            //execute direction
            if c2Reverse {
                c2hue -= 0.0075
            } else {
                c2hue += 0.0075
            }

            return Color(hue: c2hue, saturation: 1, brightness: 1)
        }
        
    }
    
    enum colorChoice {
        case c1, c2
    }
    
    func displayColor() -> Color {
        if color != nil {
            return color!
        } else {
            return Color.gray
        }
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
}
