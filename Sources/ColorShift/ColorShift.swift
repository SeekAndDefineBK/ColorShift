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
        
        let c1 = Double.random(in: 0...1)
        let c2 = Double.random(in: 0...1)
        
        c1hue = c1
        c2hue = c2
        
        _color1 = State(wrappedValue: Color(hue: c1, saturation: 1.0, brightness: 1.0))
        _color2 = State(wrappedValue: Color(hue: c2, saturation: 1.0, brightness: 1.0))
    }
    
    func body(content: Content) -> some View {

        ZStack(alignment: .topTrailing) {
            if color != nil {
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
        
        //execute the change in color by changing the hue
        switch colorChoice {
        case .c1:
            if c1Reverse {
                c1hue -= 0.009
            } else {
                c1hue += 0.009
            }
        case .c2:
            if c2Reverse {
                c2hue -= 0.009
            } else {
                c2hue += 0.009
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
