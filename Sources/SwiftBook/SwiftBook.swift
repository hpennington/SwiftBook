//
//  SwiftBook
//  SwiftBook.swift
//
//  Created by Hayden Pennington on 11/27/21.
//

import SwiftUI

let windowMinWidth: CGFloat = 1100
let windowMinHeight: CGFloat = 700
let argsTableWidth: CGFloat = 400

#if os(macOS)
let navigationWidth: CGFloat = 200
let maxCanvasWidth: CGFloat = 1000
#else
let navigationWidth: CGFloat = 300
let maxCanvasWidth: CGFloat = 1200
#endif

public struct SwiftBook: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var appModel = SwiftBookModel()
    @State private var selectedIndex = 0

    let titles: [String]
    let documentsTable: [(String, AnyView)]
   
    public init(_ documentsTable: [(String, AnyView)]) {
        self.documentsTable = documentsTable
        self.titles = self.documentsTable.map { $0.0 }
    }
    
    public func renderSnapshot() {
        appModel.takeSnapshot = true
    }
    
    public func navigationMac() -> some View {
        VStack(alignment: .center) {
            List(0..<titles.count) { index in
                VStack {
                    SwiftBookNavButton(titles[index], selected: selectedIndex == index, action: {
                        self.selectedIndex = index
                    })
                   Divider()
                        .frame(width: navigationWidth, height: 0.5)
                        .background(Color.black)
                }
             }
             Spacer()
             Button(action: renderSnapshot) {
                 Text("Take Snapshot")
             }.padding()
             
        }
    }
    
    public func navigationIOS() -> some View {
        VStack(alignment: .center) {
            List(0..<titles.count) { index in
                SwiftBookNavButton(titles[index], selected: selectedIndex == index, action: {
                    self.selectedIndex = index
                })
             }
             Spacer()
             Button(action: renderSnapshot) {
                 Text("Take Snapshot")
             }.padding()
             
        }
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    if colorScheme == .light {
                        #if os(macOS)
                        navigationMac()
                            .background(Color.white)
                            .frame(maxWidth: navigationWidth, minHeight: geometry.size.height)
                        #else
                        navigationIOS()
                            .background(Color.white)
                            .frame(maxWidth: navigationWidth, minHeight: geometry.size.height)
                        #endif
                        
                    } else {
                        #if os(macOS)
                        navigationMac()
                            .frame(maxWidth: navigationWidth, minHeight: geometry.size.height)
                        #else
                        navigationIOS()
                            .frame(maxWidth: navigationWidth, minHeight: geometry.size.height)
                        #endif
                    }
                   VStack {
                    ScrollView(showsIndicators: false) {
                        Spacer(minLength: 100)
                        self.documentsTable[self.selectedIndex].1
                            .frame(minWidth: maxCanvasWidth - navigationWidth, maxWidth: .infinity, maxHeight: .infinity)
                        Spacer(minLength: 100)
                    }.background(colorScheme == .dark ? Color.darkBackground : Color.offWhite)
                    .id(selectedIndex)
                    
                   }
               }
            }.environmentObject(appModel)
            
        }.frame(minWidth: windowMinWidth, minHeight: windowMinHeight)
    }
}

#if os(macOS)

extension NSImage {
    func writePNG(toURL url: URL) {

        guard let data = tiffRepresentation,
              let rep = NSBitmapImageRep(data: data),
              let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {

            Swift.print("\(self) Error Function '\(#function)' Line: \(#line) No tiff rep found for image writing to \(url)")
            return
        }

        do {
            try imgData.write(to: url)
        } catch let error {
            Swift.print("\(self) Error Function '\(#function)' Line: \(#line) \(error.localizedDescription)")
        }
    }
}

final class ColorWell: NSObject, NSViewRepresentable {
    typealias NSViewType = NSColorWell
    
    @Binding var color: Color
    let colorWell = NSColorWell()
    
    public init(color: Binding<Color>) {
        self._color = color
        super.init()
        self.colorWell.addObserver(self, forKeyPath: "color", options: .new, context: nil)
    }
    
    deinit {
        colorWell.removeObserver(self, forKeyPath: "color")
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
    }
    
    func makeNSView(context: Context) -> NSColorWell {
        colorWell
    }
    
    func activate(active: Bool) {
        colorWell.activate(active)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "color" {
            color = Color(colorWell.color)
        }
    }
}

class NoInsetHostingView<V: View>: NSHostingView<V> {
    override var safeAreaInsets: NSEdgeInsets {
        .init()
    }
}

extension View {
    func renderAsImage() -> NSImage? {
        let view = NoInsetHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)
        view.setFrameOrigin(NSPoint(x: -view.fittingSize.width / 2, y: -view.fittingSize.height / 2))
        return view.bitmapImage()
    }
}

extension NSView {
    func bitmapImage() -> NSImage? {
        guard let rep = bitmapImageRepForCachingDisplay(in: bounds) else {
            return nil
        }
        cacheDisplay(in: bounds, to: rep)
        guard let cgImage = rep.cgImage else {
            return nil
        }
        return NSImage(cgImage: cgImage, size: bounds.size)
    }
}

#elseif os(iOS)

extension View {
    func renderAsImage() -> UIImage? {
        let hostingController = UIHostingController(rootView: self)
        let view = hostingController.view
        view?.sizeToFit()
        let targetSize = hostingController.view.intrinsicContentSize

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            if let view = view {
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
        }
    }
}

#endif

extension Color {
    public static let offWhite = Color(red: 0.95, green: 0.95, blue: 0.95)
    public static let offBlack = Color(red: 0.05, green: 0.05, blue: 0.05)
    public static let darkBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
    #if os(macOS)
    public static let underColor = Color(NSColor.underPageBackgroundColor)
    #elseif os(iOS)
    public static let underColor = Color(UIColor.systemBackground)
    #endif
}
