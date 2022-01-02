//
//  SwiftUIView.swift
//  
//
//  Created by Hayden Pennington on 1/1/22.
//

import SwiftUI

struct SwiftBookDocs: View {
    let documentsTable: [(String, AnyView)]
    let selectedIndex: Int
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            Spacer(minLength: 100)
            if self.documentsTable.count > self.selectedIndex {
                self.documentsTable[self.selectedIndex].1
                    .frame(idealWidth: maxCanvasWidth - navigationWidth, maxWidth: .infinity, maxHeight: .infinity)
            }
            Spacer(minLength: 100)
        }
    }
}
