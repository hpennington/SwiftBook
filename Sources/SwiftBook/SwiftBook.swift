import SwiftUI

let windowMinWidth: CGFloat = 1100
let windowMinHeight: CGFloat = 700
let navigationWidth: CGFloat = 200
let maxCanvasWidth: CGFloat = 1000
let argsTableWidth: CGFloat = 400

@available(iOS 13, macOS 10.15, *)
extension Color {
    static var offWhite: Color {
        Color(red: 0.95, green: 0.95, blue: 0.95)
    }
    
    static var offBlack: Color {
        Color(red: 0.05, green: 0.05, blue: 0.05)
    }
    
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.1)
    }
}

@available(iOS 13, macOS 10.15, *)
public protocol SwiftBookDoc {
    var title: String { get }
    var description: String { get }
    var argsTable: [SwiftBookArgRow] { get }
    var controls: [[AnyView]] { get }
    var stories: [AnyView] { get }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBook: View {
    @Environment(\.colorScheme) var colorScheme
    
    let docs: [SwiftBookDoc]
    let titles: [String]

    @State var stories: [AnyView] = []
    @State var selectedIndex = 0
    
    public init(docs: [SwiftBookDoc]) {
        self.docs = docs
        self.titles = docs.map { $0.title }
    }
    
    let padding: CGFloat = 15
    let cornerRadius: CGFloat = 10

    public var body: some View {
        if self.docs.count > selectedIndex {
            let doc = self.docs[selectedIndex]
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
                                selectedIndex = index
                                let doc = docs[index]
                                stories = doc.stories
                            }
                    }
                    
                }
                
                .frame(maxWidth: navigationWidth)
                VStack {
                    SwiftBookCanvas(title: doc.title, description: doc.description, stories: $stories, controls: doc.controls, argsTable: doc.argsTable, selectedIndex: selectedIndex)
                        .background(colorScheme == .dark ? Color.darkBackground : Color.offWhite)
                }
            }
            .frame(minWidth: windowMinWidth, minHeight: windowMinHeight)
            .onAppear(perform: {
                self.stories = doc.stories
            })
            
        }
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
        }
        
    }
}

@available(iOS 13, macOS 10.15, *)
public struct SwiftBookControlColor: View {
    @Binding public var color: Color
    
    public init(color: Binding<Color>) {
        self._color = color
    }
    
    public var body: some View {
        HStack {
            Circle()
                .frame(width: 40, height: 40, alignment: .center)
                .foregroundColor(color)
                .padding()
                .onTapGesture {
                    color = .green
                }
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
        Toggle(isOn: $active) {
            Text(title)
        }
        .toggleStyle(SwitchToggleStyle())

    }
}

public enum SwiftBookArgType: String {
    case bool = "Bool"
    case color = "Color"
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
    case h1 = 40
    case h2 = 32
    case h3 = 24
    case h4 = 16
    case h5 = 12
    case h6 = 8
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
