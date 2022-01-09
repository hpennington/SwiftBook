//
//  SwiftBookDocs.swift
//  
//
//  Created by Hayden Pennington on 1/1/22.
//

import SwiftUI

struct SwiftBookDocs: View {
    let documentsTable: [(String, AnyView)]
    let selectedIndex: Int
    
    #if os(macOS)
    let spacer: CGFloat = 100
    #else
    let spacer: CGFloat = 60
    #endif
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            Spacer(minLength: spacer)
            if self.documentsTable.count > self.selectedIndex {
                self.documentsTable[self.selectedIndex].1
                    .frame(idealWidth: maxCanvasWidth - navigationWidth, maxWidth: .infinity, maxHeight: .infinity)
            }
            Spacer(minLength: spacer)
        }
    }
}
