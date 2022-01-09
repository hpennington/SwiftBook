//
//  SwiftBookNavButton.swift
//  
//
//  Created by Hayden Pennington on 12/26/21.
//

import SwiftUI

struct NavigationButton: View {
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
