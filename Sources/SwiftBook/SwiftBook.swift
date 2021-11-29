import SwiftUI

@available(iOS 13, macOS 10.15, *)
public struct SwiftBook: View {
    @Environment(\.colorScheme) var colorScheme
    
    let docs: [Any]
    let titles: [String]

    @State var components: [AnyView] = []
    @State var selectedIndex = 0
    
    public init(docs: [Any]) {
        self.docs = docs
        self.titles = docs.compactMap({doc in
            (doc as! SwiftBookDoc).title
        })
    }
    
    public var body: some View {
        if self.docs.count > 0 {
            HStack {
                VStack(alignment: .center) {
                    List(0..<titles.count) { index in
                        Text(titles[index])
                            .padding(15)
                            .frame(width: 170, alignment: .leading)
                            .foregroundColor(selectedIndex == index ? .blue : .primary)
                            .background(colorScheme == .dark ? Color(NSColor.underPageBackgroundColor) : Color(red: 0.95, green: 0.95, blue: 0.95))
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedIndex = index
                                components = (docs[index] as! SwiftBookDoc).stories
                            }
                    }
                    
                }
                
                .frame(maxWidth: 200)
                VStack {
                    SwiftBookCanvas(title: (self.docs[selectedIndex] as! SwiftBookDoc).title, description: (self.docs[selectedIndex] as! SwiftBookDoc).description, components: $components, controls: (self.docs[selectedIndex] as! SwiftBookDoc).controls, argsTable: (self.docs[selectedIndex] as! SwiftBookDoc).argsTable, selectedIndex: selectedIndex)
                        .background(colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 0.95, green: 0.95, blue: 0.95))
                }
            }
            .frame(minWidth: 1100, minHeight: 700)
            .onAppear(perform: {
                self.components = (docs[0] as! SwiftBookDoc).stories
            })
        }
    }
}

@available(iOS 13, macOS 10.15, *)
private struct SwiftBookCanvas: View {
    let title: String
    let description: String
    @Binding var components: [AnyView]
    let controls: [[AnyView]]
    let argsTable: [SwiftBookArgRow]
    var selectedIndex: Int
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 100)
            VStack {
                Text(title)
                    .frame(maxWidth: 1000, alignment: .leading)
                    .font(.system(size: 44))
                    .padding()
                Text(description)
                    .frame(maxWidth: 1000, alignment: .leading)
                    .font(.system(size: 18))
                    .padding()
                ForEach(0..<components.count, id: \.self) { index in
                    SwiftBookCanvasInner(components: $components, controls: controls, argsTable: argsTable, index: index)
                }
            }.frame(minWidth: 800, maxWidth: .infinity, maxHeight: .infinity)
            Spacer(minLength: 100)
        }
    }
}

@available(iOS 13, macOS 10.15, *)
private struct SwiftBookCanvasInner: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var components: [AnyView]
    let controls: [[AnyView]]
    let argsTable: [SwiftBookArgRow]
    let index: Int
    
    var body: some View {
        if index < components.count {
            components[index]
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
                        .frame(width: 400, alignment: .leading)
                        .padding()
                        .background(colorScheme == .dark ? Color(red: 0.05, green: 0.05, blue: 0.05) : .white)
                        .foregroundColor(Color.primary)
                        .cornerRadius(10.0)
                }
            }
        }
        
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
            Text(description)
        }
    }
}

public enum SwiftBookArgType: String {
    case bool = "Bool"
    case color = "Color"
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
                .frame(maxWidth: 1000, alignment: .leading)
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
                .frame(maxWidth: 1000, alignment: .leading)
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
                .frame(maxWidth: 1000, alignment: .leading)
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
                .frame(maxWidth: 1000, alignment: .leading)
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
                .frame(maxWidth: 1000, alignment: .leading)
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
                .frame(maxWidth: 1000, alignment: .leading)
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
                .frame(maxWidth: 1000, maxHeight: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 18))
                .padding()
                
        }
    }
}
