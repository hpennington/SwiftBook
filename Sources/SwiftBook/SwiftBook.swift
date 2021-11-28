import SwiftUI

@available(iOS 13, macOS 10.15, *)
public struct SwiftBook: View {
    let docs: [Any]
    let titles: [String]
    @State var components: [AnyView]
    
    public init?(docs: [Any]) {
        self.docs = docs
        self.titles = docs.compactMap({doc in
            (doc as! SwiftBookDoc).title
        })
        
        if self.titles.count > 0 {
            self.components = (docs[0] as! SwiftBookDoc).stories
        } else {
            self.components = []
        }
        
    }
    
    public var body: some View {
        if self.docs.count > 0 {
            
            HStack {
                VStack {
                    VStack{
                        List(0..<titles.count) { index in
                            Text(titles[index])
                                .onTapGesture {
                                    components = (docs[index] as! SwiftBookDoc).stories
                                }
                        }
                    }
                }
                .background(Color.red)
                .frame(maxWidth: 200)
                ScrollView {
                    VStack {
                        ForEach(0..<components.count, id: \.self) { index in
                            components[index]
                        }
                    }.frame(minWidth: 1000, maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color(red: 0.1, green: 0.1, blue: 0.1))
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public protocol SwiftBookDoc {
    var title: String { get }
    var stories: [AnyView] { get }
}
