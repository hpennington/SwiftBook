//
//  SwiftBookComponent.swift
//  
//
//  Created by Hayden Pennington on 12/26/21.
//

import SwiftUI

public struct SwiftBookComponent<C: View> : View {
    let component: C
    @EnvironmentObject private var appModel: SwiftBookModel
    
    public init(_ component: () -> (C)) {
        self.component = component()
    }
  
    public var body: some View {
        HStack(alignment: .center) {
            component
                .frame(maxWidth: maxCanvasWidth, alignment: .center)
                .padding()
            if appModel.takeSnapshot {
                SwiftBookSnapshot(component: self.component)
            }
        }
        
    }
}
