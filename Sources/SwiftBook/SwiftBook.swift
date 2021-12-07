//
//  SwiftBook
//  SwiftBook.swift
//
//  Created by Hayden Pennington on 11/27/21.
//

import SwiftUI

let windowMinWidth: CGFloat = 1100
let windowMinHeight: CGFloat = 700
let navigationWidth: CGFloat = 200
let maxCanvasWidth: CGFloat = 1000
let argsTableWidth: CGFloat = 400

@available(iOS 13, macOS 10.15, *)
extension Color {
    public static let offWhite = Color(red: 0.95, green: 0.95, blue: 0.95)
    public static let offBlack = Color(red: 0.05, green: 0.05, blue: 0.05)
    public static let darkBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBook<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedIndex = 0
    
    @Binding var takeSnapshot: Bool
    
    let content: Content
    let onNavChange: (_ document: String) -> ()
    let titles: [String]
    
    let padding: CGFloat = 15
    let cornerRadius: CGFloat = 10
    
    public init(takeSnapshot: Binding<Bool>, titles: [String], onNavChange: @escaping (_ document: String) -> (), @ViewBuilder content: () -> Content) {
        self._takeSnapshot = takeSnapshot
        self.titles = titles
        self.onNavChange = onNavChange
        self.content = content()
    }
    
    public func renderSnapshot() {
        takeSnapshot = true
    }
    
    public var body: some View {
        VStack {
            HStack {
               VStack(alignment: .center) {
                   List(0..<titles.count) { index in
                       Text(titles[index])
                           .padding(padding)
                           .frame(width: navigationWidth - (padding * 2), alignment: .leading)
                           .foregroundColor(selectedIndex == index ? .blue : .primary)
                           .background(colorScheme == .dark ? Color(NSColor.underPageBackgroundColor) : Color.offWhite)
                           .cornerRadius(cornerRadius)
                           .onTapGesture {
                                self.onNavChange(self.titles[index])
                                self.selectedIndex = index
                           }
                    }
                    Spacer()
                    Button(action: renderSnapshot) {
                        Text("Take Snapshot")
                    }.padding()
               }
               .frame(maxWidth: navigationWidth)
               VStack {
                ScrollView(showsIndicators: false) {
                    Spacer(minLength: 100)
                    self.content
                        .frame(minWidth: maxCanvasWidth - navigationWidth, maxWidth: .infinity, maxHeight: .infinity)
                    Spacer(minLength: 100)
                }.background(colorScheme == .dark ? Color.darkBackground : Color.offWhite)
                .id(selectedIndex)
                
               }
           }.frame(minWidth: windowMinWidth, minHeight: windowMinHeight)
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookArgsTable<C: View> : View {
    let component: C

    public init(_ component: () -> (C)) {
        self.component = component()
    }
  
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Arguments")
                .padding()
                .font(.headline)
            component
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookSnapshot<C: View>: View {
    let frame: CGSize
    let component: C
    @Binding var takeSnapshot: Bool
    
    public init(frame: CGSize, component: C, takeSnapshot: Binding<Bool>) {
        self.component = component
        self._takeSnapshot = takeSnapshot
        self.frame = frame
        
        if let snapshot = self.component.renderAsImage(frame: NSSize(width: frame.width, height: frame.height)) {
            let url = FileManager().homeDirectoryForCurrentUser.appendingPathComponent(NSUUID().uuidString + ".png")
            print(url)
            snapshot.writePNG(toURL: url)
        }
    }
    
    public var body: some View {
        HStack {
            EmptyView()

        }
        .onAppear(perform: {
            self.takeSnapshot = false
        })
    }
}

@available(macOS 10.15, *)
public extension NSImage {
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

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookComponent<C: View> : View {
    let frame: CGSize
    let component: C
    
    @Binding var takeSnapshot: Bool
  
    public init(takeSnapshot: Binding<Bool>, frame: CGSize, _ component: () -> (C)) {
        self._takeSnapshot = takeSnapshot
        self.frame = frame
        self.component = component()
    }
  
    public var body: some View {
        HStack(alignment: .center) {
            component
                .frame(maxWidth: maxCanvasWidth, alignment: .center)
                .padding()
            if takeSnapshot {
                SwiftBookSnapshot(frame: frame, component: self.component, takeSnapshot: $takeSnapshot)
            }
        }
        
    }
}

@available(iOS 13, macOS 10.15, *)
@objc final class ColorWell: NSObject, NSViewRepresentable {
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

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookControlColor: View {
    @Binding public var color: Color
    let title: String
    
    @State var colorWell: ColorWell

    public init(color: Binding<Color>, title: String) {
        self._color = color
        self.title = title
        self.colorWell = ColorWell(color: color)
    }
    
    public var body: some View {
        VStack {
            Circle()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(color)
                .padding()
                .onTapGesture {
                    colorWell.activate(active: true)
                }
            Spacer()
            Text(title)
                .font(.system(size: 14))
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookControlToggle: View {
    @Binding public var active: Bool
    let title: String
    
    public init(active: Binding<Bool>, title: String) {
        self._active = active
        self.title = title
    }
    
    public var body: some View {
        VStack {
            Toggle(isOn: $active) {
                
            }.toggleStyle(SwitchToggleStyle())
            .padding()
            Spacer()
            Text(title)
                .font(.system(size: 14))
        }
 
    }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookControlText: View {
    @Binding var text: String
    let label: String
    
    public init(text: Binding<String>, label: String) {
        self._text = text
        self.label = label
    }
    
    public var body: some View {
        VStack {
            TextField(text, text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 400)
                .fixedSize()
            Spacer()
            Text(label)
        }
        
    }
}

public enum SwiftBookArgType: String {
    case bool = "Bool"
    case color = "Color"
    case string = "String"
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookArgRow: View {
    @Environment(\.colorScheme) var colorScheme
    
    public let title: String
    public let description: String
    public let type: SwiftBookArgType
    
    public init(title: String, description: String, type: SwiftBookArgType) {
        self.title = title
        self.description = description
        self.type = type
    }
    
    public var body: some View {
        HStack {
            Text(title)
            Text(":")
            Text(type.rawValue)
            Spacer()
            Text(description)
            Spacer()
        }
        .frame(width: 400, alignment: .leading)
        .padding()
        .background(colorScheme == .dark ? Color.offBlack : .white)
        .foregroundColor(Color.primary)
        .cornerRadius(10.0)
    }
}

#if os(macOS)
@available(macOS 10.15, *)
class NoInsetHostingView<V>: NSHostingView<V> where V: View {
    override var safeAreaInsets: NSEdgeInsets {
        return .init()
    }
}

@available(macOS 10.15, *)
extension View {
    func renderAsImage(frame: NSSize) -> NSImage? {
        let view = NoInsetHostingView(rootView: self)
        view.setFrameSize(frame)
        return view.bitmapImage()
    }
}

@available(macOS 10.15, *)
public extension NSView {
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
#endif

public enum HeaderSize: CGFloat {
    case h1 = 50
    case h2 = 40
    case h3 = 32
    case h4 = 24
    case h5 = 18
    case h6 = 12
}

@available(iOS 13, macOS 10.15, *)
public struct H1: View {
    let text: String?
    
    public init(_ text: String?) {
        self.text = text
    }
    
    public var body: some View {
        if let text = text {
            Text(text)
                .frame(maxWidth: maxCanvasWidth, alignment: .leading)
                .font(.system(size: HeaderSize.h1.rawValue))
                .padding()
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct H2: View {
    let text: String?
    
    public init(_ text: String?) {
        self.text = text
    }
    
    public var body: some View {
        if let text = text {
            Text(text)
                .frame(maxWidth: maxCanvasWidth, alignment: .leading)
                .font(.system(size: HeaderSize.h2.rawValue))
                .padding()
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct H3: View {
    let text: String?
    
    public init(_ text: String?) {
        self.text = text
    }
    
    public var body: some View {
        if let text = text {
            Text(text)
                .frame(maxWidth: maxCanvasWidth, alignment: .leading)
                .font(.system(size: HeaderSize.h3.rawValue))
                .padding()
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct H4: View {
    let text: String?
    
    public init(_ text: String?) {
        self.text = text
    }
    
    public var body: some View {
        if let text = text {
            Text(text)
                .frame(maxWidth: maxCanvasWidth, alignment: .leading)
                .font(.system(size: HeaderSize.h4.rawValue))
                .padding()
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct H5: View {
    let text: String?
    
    public init(_ text: String?) {
        self.text = text
    }
    
    public var body: some View {
        if let text = text {
            Text(text)
                .frame(maxWidth: maxCanvasWidth, alignment: .leading)
                .font(.system(size: HeaderSize.h5.rawValue))
                .padding()
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct H6: View {
    let text: String?
    
    public init(_ text: String?) {
        self.text = text
    }
    
    public var body: some View {
        if let text = text {
            Text(text)
                .frame(maxWidth: maxCanvasWidth, alignment: .leading)
                .font(.system(size: HeaderSize.h6.rawValue))
                .padding()
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct P: View {
    let text: String?
    
    public init(_ text: String?) {
        self.text = text
    }
    
    public var body: some View {
        if let text = text {
            Text(text)
                .frame(maxWidth: maxCanvasWidth, maxHeight: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 18))
                .padding()
                
        }
    }
}
