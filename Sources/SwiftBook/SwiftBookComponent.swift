//
//  SwiftBookComponent.swift
//  
//
//  Created by Hayden Pennington on 12/26/21.
//

import SwiftUI

#if os(macOS)

final class VerticalScrollingFixHostingView<Content: View>: NSHostingView<Content> {
    override func wantsForwardedScrollEvents(for axis: NSEvent.GestureAxis) -> Bool {
        return axis == .vertical
    }
}

struct VerticalScrollingFixViewRepresentable<Content: View>: NSViewRepresentable {
  
    let content: Content

    func makeNSView(context: Context) -> NSHostingView<Content> {
        return VerticalScrollingFixHostingView<Content>(rootView: content)
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
        nsView.rootView = content
    }

}

struct VerticalScrollingFixWrapper<Content: View>: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VerticalScrollingFixViewRepresentable(content: self.content())
    }
}
#endif

extension View {
    @ViewBuilder
    func workaroundForVerticalScrollingBugInMacOS() -> some View {
    #if os(macOS)
        VerticalScrollingFixWrapper { self }
    #else
        self
    #endif
    }
}

struct Device {
    let iPad: Bool
    let portrait: Bool
    
    init() {
        #if os(iOS)
        self.iPad = UIDevice.current.userInterfaceIdiom == .pad
        self.portrait = UIDevice.current.orientation == .portrait
        #else
        self.iPad = false
        self.portrait = false
        #endif
    }
}

public struct SwiftBookComponent<Content: View> : View {
    let component: Content
    @EnvironmentObject private var appModel: SwiftBookModel
    
    public init(_ component: () -> (Content)) {
        self.component = component()
    }
  
    public var body: some View {
        HStack(alignment: .center) {
            ScrollView(.horizontal) {
                component
                    .padding()
            }
            .frame(maxWidth: Device().iPad && Device().portrait ? maxCanvasWidthIPadPortrait : maxCanvasWidth)
            .fixedSize()
            .workaroundForVerticalScrollingBugInMacOS()
        }.frame(maxWidth: maxCanvasWidth)
        
        if appModel.takeSnapshot {
            SwiftBookSnapshot(component: self.component)
        }
    }
}

