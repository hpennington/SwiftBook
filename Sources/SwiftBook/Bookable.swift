//
//  Bookable.swift
//  
//
//  Created by Hayden Pennington on 1/8/22.
//

import SwiftUI

public struct Bookable<Content: View>: View {
    let title: String?
    let detail: String?
    let component: Content
    
    public init(title: String?, detail: String?, component: () -> Content) {
        self.title = title
        self.detail = detail
        self.component = component()
    }
    
    public var body: some View {
        H2(title)
        P(detail)
        SwiftBookComponent {
            component
        }
    }
}
