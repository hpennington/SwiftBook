//
//  SwiftUIView.swift
//  
//
//  Created by Hayden Pennington on 1/1/22.
//

import SwiftUI

struct SwiftBookTests: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                Text("Testing")
                    .frame(minWidth: maxCanvasWidth - navigationWidth, maxWidth: .infinity, minHeight: geometry.size.height, maxHeight: .infinity)
            }
        }
    }
}
