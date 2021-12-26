//
//  SwiftBookSnapshot.swift
//  
//
//  Created by Hayden Pennington on 12/26/21.
//

import SwiftUI

struct SwiftBookSnapshot<Content: View>: View {
    let component: Content
    @EnvironmentObject private var appModel: SwiftBookModel
    
    public init(component: Content) {
        self.component = component
        
        #if os(macOS)
        if let snapshot = self.component.padding().renderAsImage() {
            print(snapshot)
//            let url = FileManager().homeDirectoryForCurrentUser.appendingPathComponent(NSUUID().uuidString + ".png")
//            print(url)
//            snapshot.writePNG(toURL: url)
        }
        #elseif os(iOS)
        if let snapshot = self.component.padding().renderAsImage() {
            print(snapshot)
            
        }
        #endif

    }
    
    public var body: some View {
        HStack {
            EmptyView()

        }
        .onAppear(perform: {
            self.appModel.takeSnapshot = false
        })
    }
}
