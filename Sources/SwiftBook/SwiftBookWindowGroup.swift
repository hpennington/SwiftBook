//
//  SwiftBookWindowGroup.swift
//  
//
//  Created by Hayden Pennington on 1/1/22.
//

import SwiftUI

#if os(iOS)
import UIKit

extension View {
    fileprivate func withHostingWindow(_ callback: @escaping (UIWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

fileprivate struct HostingWindowFinder: UIViewRepresentable {
    let callback: (UIWindow?) -> ()

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
            
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}
#endif

public struct SwiftBookWindowGroup<Content: View>: Scene {
    let content: Content
    
    public init(_ content: () -> (Content)) {
        self.content = content()
    }
    
    @available(iOS 14.0, *)
    @available(macCatalyst 14.0, *)
    @available(macOS 11.0, *)
    public var body: some Scene {
        #if os(macOS)
        WindowGroup {
            self.content
                .toolbar {
                    Text("SwifttBook")
                }
        }.windowStyle(DefaultWindowStyle())
    
        #else
        WindowGroup {
            self.content
            .withHostingWindow { window in
                #if targetEnvironment(macCatalyst)
                if let titlebar = window?.windowScene?.titlebar {
                    let toolbar = NSToolbar()
                    toolbar.displayMode = .iconOnly
                    titlebar.titleVisibility = .hidden
                    titlebar.toolbar = toolbar
                }
                #endif
            }
        }
        #endif
    }
}
