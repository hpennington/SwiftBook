//
//  SwiftBook
//  SwiftBook.swift
//
//  Created by Hayden Pennington on 11/27/21.
//

import SwiftUI
import Combine

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

@available(iOS 13, macOS 10.15, *)
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

@available(iOS 13, macOS 10.15, *)
private final class SwiftBookModel: ObservableObject {
    @Published var takeSnapshot: Bool = false
}

@available(iOS 13, macOS 10.15, *)
private struct SwiftBookNavButton: View {
    @Environment(\.colorScheme) var colorScheme
    private let title: String
    private let selected: Bool
    private let action: () -> Void
    private let cornerRadius: CGFloat = 10
    private let padding: CGFloat = 5
    
    init(_ title: String, selected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.selected = selected
        self.action = action
    }
    #if os(macOS)
    var body: some View {
        Button(title, action: {
            self.action()
        })
            .buttonStyle(PlainButtonStyle())
            .frame(width: navigationWidth - (padding * 2), alignment: .leading)
            .cornerRadius(cornerRadius)
            .padding(padding)
            .foregroundColor(self.selected ? .blue : .primary)
    }
    #else
    var body: some View {
        Button(title, action: {
            self.action()
        })
            .buttonStyle(PlainButtonStyle())
            .frame(width: navigationWidth - (padding * 2), alignment: .leading)
            .cornerRadius(cornerRadius)
            .padding(padding)
            .foregroundColor(self.selected ? .blue : .primary)
    }
    #endif
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBook: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var appModel = SwiftBookModel()
    @State private var selectedIndex = 0

    let titles: [String]
    let documentsTable: [(String, AnyView)]
   
    public init(documentsTable: [(String, AnyView)]) {
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

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookArgsTable<Content: View> : View {
    let component: () -> Content

    public init(@ViewBuilder component: @escaping () -> Content) {
        self.component = component
    }
  
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Arguments")
                .padding()
                .font(.headline)
            component()
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookSnapshot<C: View>: View {
    let component: C
    @EnvironmentObject private var appModel: SwiftBookModel
    
    public init(component: C) {
        self.component = component
        
        #if os(macOS)
        if let snapshot = self.component.padding().renderAsImage() {
            let url = FileManager().homeDirectoryForCurrentUser.appendingPathComponent(NSUUID().uuidString + ".png")
            print(url)
            snapshot.writePNG(toURL: url)
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

#if os(macOS)

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

#endif

@available(iOS 13, macOS 10.15, *)
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

#if os(macOS)
@available(macOS 10.15, *)
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
#endif

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookControlTable<Content: View> : View {
    let component: () -> Content

    public init(@ViewBuilder component: @escaping () -> Content) {
        self.component = component
    }
  
    public var body: some View {
        HStack {
            self.component()
        }.fixedSize()
    }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookControlColor: View {
    @Binding public var color: Color
    let title: String
    
    #if os(macOS)
    @State var colorWell: ColorWell
    #endif
    
    public init(color: Binding<Color>, title: String) {
        self._color = color
        self.title = title
        #if os(macOS)
        self.colorWell = ColorWell(color: color)
        #endif
    }
    
    public var body: some View {
        VStack {
            
                #if os(iOS)
                if #available(iOS 14.0, *) {
                    ColorPicker("", selection: $color)
                        .frame(width: 45, height: 40)
                        .padding()
                } else {
                    // TODO Implement UIKit Color Picker for iOS 13
                }
                #else
            
                Circle()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundColor(color)
                    .padding()
                    .onTapGesture {
                        #if os(macOS)
                        colorWell.activate(active: true)
                        #endif
                    }
                #endif
            
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

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookControlInt: View {
    @Binding var value: Int
    @State private var text: String
    let label: String
    
    public init(value: Binding<Int>, label: String) {
        self._value = value
        self.label = label
        self.text = String(value.wrappedValue)
    }
    
    public var body: some View {
        VStack {
            TextField(String(value), text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 400)
                .fixedSize()
                .onReceive(Just(text), perform: { newValue in
                    self.text = newValue.filter { $0.isNumber }
                    if let value = Int(self.text) {
                        self.value = value
                    }
                })
            Spacer()
            Text(label)
        }
        
    }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookControlDouble: View {
    @Binding var value: Double
    @State private var text: String
    let label: String
    
    public init(value: Binding<Double>, label: String) {
        self._value = value
        self.label = label
        self.text = String(value.wrappedValue)
    }
    
    public var body: some View {
        VStack {
            TextField(String(value), text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 400)
                .fixedSize()
                .onReceive(Just(text), perform: { newValue in
                    self.text = newValue.filter { $0.isNumber || $0 == "." }
                    if let value = Double(self.text) {
                        self.value = value
                    }
                })
            Spacer()
            Text(label)
        }
        
    }
}

public enum SwiftBookArgType: String {
    case bool = "Bool"
    case color = "Color"
    case string = "String"
    case int = "Int"
    case float = "Float"
    case double = "Double"
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
        .init()
    }
}

@available(macOS 10.15, *)
extension View {
    func renderAsImage() -> NSImage? {
        let view = NoInsetHostingView(rootView: self)
        view.setFrameSize(view.fittingSize)
        view.setFrameOrigin(NSPoint(x: -view.fittingSize.width / 2, y: -view.fittingSize.height / 2))
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

#elseif os(iOS)

@available(iOS 13, *)
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

public enum HeaderSize: CGFloat {
    #if os(macOS)
    case h1 = 50
    case h2 = 40
    case h3 = 32
    case h4 = 24
    case h5 = 18
    case h6 = 12
    #elseif os(iOS)
    case h1 = 72
    case h2 = 50
    case h3 = 40
    case h4 = 32
    case h5 = 24
    case h6 = 18
    #endif
}

#if os(macOS)
let ParagraphSize = 18
#elseif os(iOS)
let ParagraphSize = 24
#endif

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
                .font(.system(size: CGFloat(ParagraphSize)))
                .padding()
                
        }
    }
}
