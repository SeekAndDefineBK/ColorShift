//
//  SwiftUIView.swift
//  
//
//  Created by Brett Koster on 3/3/22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Image(systemName: "book.closed.fill")
            .font(.largeTitle)
            .ColorShift(shiftInitialColor: true, color: .orange, width: 300, height: 300)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
