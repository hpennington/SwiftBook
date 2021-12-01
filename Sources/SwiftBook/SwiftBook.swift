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
    static let offWhite = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let offBlack = Color(red: 0.05, green: 0.05, blue: 0.05)
    static let darkBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
}

/// SwiftBookDoc
///
/// SwiftBook has the concepts of "docs" that contain the "stories".
/// Create a doc file and conform to SwiftBookDoc.
/// Fill the stories property with Views containing your components.
@available(iOS 13, macOS 10.15, *)
public protocol SwiftBookDoc: View {
    var argsTable: [SwiftBookArgRow] { get }
    var controls: [[AnyView]] { get }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBook<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    let content: Content
    let titles: [String]
    
    let padding: CGFloat = 15
    let cornerRadius: CGFloat = 10
    
    public init(titles: [String], @ViewBuilder content: () -> Content) {
        self.titles = titles
        self.content = content()
    }
    
    public var body: some View {
        VStack {
            HStack {
               VStack(alignment: .center) {
                   List(0..<titles.count) { index in
                       Text(titles[index])
                           .padding(padding)
                           .frame(width: navigationWidth - (padding * 2), alignment: .leading)
//                           .foregroundColor(selectedIndex == index ? .blue : .primary)
                           .background(colorScheme == .dark ? Color(NSColor.underPageBackgroundColor) : Color.offWhite)
                           .cornerRadius(cornerRadius)
//                           .onTapGesture {
//                               selectedIndex = index
//                               let doc = docs[index]
//                               stories = doc.stories
//                           }
                   }

               }

               .frame(maxWidth: navigationWidth)
               VStack {
                ScrollView(showsIndicators: false) {
                    Spacer(minLength: 100)
                    self.content
                        .frame(minWidth: maxCanvasWidth - navigationWidth, maxWidth: .infinity, maxHeight: .infinity)
                    Spacer(minLength: 100)
                }
                
//                   SwiftBookCanvas(title: doc.title, description: doc.description, stories: $stories, controls: doc.controls, argsTable: doc.argsTable, selectedIndex: selectedIndex)
                       .background(colorScheme == .dark ? Color.darkBackground : Color.offWhite)
               }
           }
//            self.content
//                .frame(width: 1000, height: 800)
        }
    }
}
//public struct SwiftBook<Content> where Content : View {
//    @Environment(\.colorScheme) var colorScheme
//
//    let content: Content
//    let titles: [String]
//
//    @State var stories: [AnyView] = []
//    @State var selectedIndex = 0
//
//    public init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//        self.titles = []
////        self.titles = docs.map { $0.title }
//    }
//
//    let padding: CGFloat = 15
//    let cornerRadius: CGFloat = 10
//
//    public var body: some View {
//        VStack {
//            content
//        }
//
////        if self.docs.count > selectedIndex {
////            let doc = self.docs[selectedIndex]
////            doc
////            HStack {
////                VStack(alignment: .center) {
////                    List(0..<titles.count) { index in
////                        Text(titles[index])
////                            .padding(padding)
////                            .frame(width: navigationWidth - (padding * 2), alignment: .leading)
////                            .foregroundColor(selectedIndex == index ? .blue : .primary)
////                            .background(colorScheme == .dark ? Color(NSColor.underPageBackgroundColor) : Color.offWhite)
////                            .cornerRadius(cornerRadius)
////                            .onTapGesture {
////                                selectedIndex = index
////                                let doc = docs[index]
////                                stories = doc.stories
////                            }
////                    }
////
////                }
////
////                .frame(maxWidth: navigationWidth)
////                VStack {
////                    SwiftBookCanvas(title: doc.title, description: doc.description, stories: $stories, controls: doc.controls, argsTable: doc.argsTable, selectedIndex: selectedIndex)
////                        .background(colorScheme == .dark ? Color.darkBackground : Color.offWhite)
////                }
////            }
////            .frame(minWidth: windowMinWidth, minHeight: windowMinHeight)
////            .onAppear(perform: {
////                self.stories = doc
////            })
//
////        }
//    }
//}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookComponent<C: View> : View {
  let component: C
  
  public init(_ component: () -> (C)) {
    self.component = component()
  }
  
  public var body: some View {
    component
        .frame(maxWidth: maxCanvasWidth, alignment: .center)
        .padding()
  }
}

@available(iOS 13, macOS 10.15, *)
private struct SwiftBookCanvas: View {
    let title: String
    let description: String
    @Binding var stories: [AnyView]
    let controls: [[AnyView]]
    let argsTable: [SwiftBookArgRow]
    var selectedIndex: Int
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer(minLength: 100)
            VStack {
                Text(title)
                    .frame(maxWidth: maxCanvasWidth, alignment: .leading)
                    .font(.system(size: 44))
                    .padding()
                Text(description)
                    .frame(maxWidth: maxCanvasWidth, alignment: .leading)
                    .font(.system(size: 18))
                    .padding()
                ForEach(0..<stories.count, id: \.self) { index in
                    SwiftBookCanvasInner(stories: $stories, controls: controls, argsTable: argsTable, index: index)
                }
            }
            .frame(minWidth: maxCanvasWidth - navigationWidth, maxWidth: .infinity, maxHeight: .infinity)
            Spacer(minLength: 100)
        }
        .id(selectedIndex)
    }
}

@available(iOS 13, macOS 10.15, *)
private struct SwiftBookCanvasInner: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var stories: [AnyView]
    let controls: [[AnyView]]
    let argsTable: [SwiftBookArgRow]
    let index: Int
    
    var body: some View {
        if index < stories.count {
            stories[index]
            HStack {
                if controls.count > index {
             
                    ForEach(0..<controls[index].count, id: \.self) { controlIndex in

                        controls[index][controlIndex]
                        
                    }
             
                }
            }
            
            VStack(alignment: .leading) {
                Text("Arguments")
                    .padding()
                    .font(.headline)
                ForEach(0..<argsTable.count, id: \.self) { argsIndex in
                    argsTable[argsIndex]
                        .frame(width: argsTableWidth, alignment: .leading)
                        .padding()
                        .background(colorScheme == .dark ? Color.offBlack : .white)
                        .foregroundColor(Color.primary)
                        .cornerRadius(10.0)
                }
            }
            Spacer(minLength: 100)
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
    }
}

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
