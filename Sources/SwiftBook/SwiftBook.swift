import SwiftUI

@available(iOS 13, macOS 10.15, *)
public struct SwiftBook: View {
    @Environment(\.colorScheme) var colorScheme
    
    let docs: [Any]
    let titles: [String]
    let controls: [[AnyView]]

    @State var components: [AnyView] = []
    @State var selectedIndex = 0
    
    public init(docs: [Any], controls: [[AnyView]]) {
        self.docs = docs
        self.titles = docs.compactMap({doc in
            (doc as! SwiftBookDoc).title
        })
        
        self.controls = controls
    }
    
    public var body: some View {
        if self.docs.count > 0 {
            HStack {
                VStack {
                    List(0..<titles.count) { index in
                        Text(titles[index])
                            .onTapGesture {
                                selectedIndex = index
                                components = (docs[index] as! SwiftBookDoc).stories
                            }
                            .padding(2)
                            .foregroundColor(selectedIndex == index ? .blue : .white)
                    }
                }
                .frame(maxWidth: 200)
                ScrollView {
                    VStack {
                        ForEach(0..<components.count, id: \.self) { index in
                            components[index]
                            if controls[selectedIndex].count > index {
                                controls[selectedIndex][index]
                            }
                        }
                    }.frame(minWidth: 800, maxWidth: .infinity, maxHeight: .infinity)

                }
            }
            .frame(minWidth: 1100, minHeight: 700)
            .background(colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 0.95, green: 0.95, blue: 0.95))
            .onAppear(perform: {
                self.components = (docs[0] as! SwiftBookDoc).stories
            })
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public protocol SwiftBookDoc {
    var title: String { get }
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
