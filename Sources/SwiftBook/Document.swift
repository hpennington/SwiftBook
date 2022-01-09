//
//  SwiftBookDoc.swift
//  
//
//  Created by Hayden Pennington on 1/8/22.
//

import SwiftUI

public struct Document<Content: View>: View {
    let title: String
    let detail: String
    let content: Content
    
    public init(title: String, detail: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.detail = detail
        self.content = content()
    }
    
    public var body: some View {
        H1(title)
        P(detail)
        content
    }
}
