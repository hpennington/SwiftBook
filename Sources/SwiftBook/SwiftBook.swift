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
            return nil
        }
        
    }
    
    public var body: some View {
        ScrollView {
            HStack {
                VStack{
                    ForEach(0..<titles.count) { index in
                        Text(titles[index])
                            .onTapGesture {
                                components = (docs[1] as! SwiftBookDoc).stories
                            }
                    }
                }
                VStack {
                    ForEach(0..<components.count, id: \.self) { index in
                        components[index]
                    }
                }
            }
        }
    }
}

@available(iOS 13, macOS 10.15, *)
public protocol SwiftBookDoc {
    var title: String { get }
    var stories: [AnyView] { get }
}
