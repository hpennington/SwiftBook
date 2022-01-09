//
//  SwiftBookArgsTable.swift
//  
//
//  Created by Hayden Pennington on 12/26/21.
//

import SwiftUI

public struct ArgumentsTable<Content: View> : View {
    let component: () -> Content

    public init(@ViewBuilder component: @escaping () -> Content) {
        self.component = component
    }
  
    public var body: some View {
        VStack(alignment: .leading) {
            Text("Arguments")
                .padding()
                .font(.headline)
            component()
        }
    }
}

