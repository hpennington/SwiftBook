//
//  SwiftUIView.swift
//  
//
//  Created by Hayden Pennington on 1/1/22.
//

import SwiftUI

struct SwiftBookTests: View {
    var body: some View {
        ScrollView {
            Text("Testing")
                .frame(minWidth: maxCanvasWidth - navigationWidth, maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
