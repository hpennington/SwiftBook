//
//  ArgumentRow.swift
//  
//
//  Created by Hayden Pennington on 1/9/22.
//

import SwiftUI

public enum ArgumentType: String {
    case bool = "Bool"
    case color = "Color"
    case string = "String"
    case int = "Int"
    case float = "Float"
    case double = "Double"
}

public struct ArgumentRow: View {
    @Environment(\.colorScheme) var colorScheme
    
    public let title: String
    public let description: String
    public let type: ArgumentType
    
    public init(title: String, description: String, type: ArgumentType) {
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
        .frame(width: 400, alignment: .leading)
        .padding()
        .background(colorScheme == .dark ? Color.offBlack : .white)
        .foregroundColor(Color.primary)
        .cornerRadius(10.0)
    }
}
