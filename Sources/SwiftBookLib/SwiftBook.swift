import SwiftUI

@available(iOS 13, macOS 10.15, *)
public struct SwiftBook: View {
    let components: [AnyView]
    
    public init(components: [AnyView]) {
        self.components = components
    }
    
    public var body: some View {
        ScrollView {
            ForEach(0..<components.count) { index in
                components[index]
            }
        }
    }
}
