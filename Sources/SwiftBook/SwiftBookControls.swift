//
//  SwiftBookControls.swift
//  
//
//  Created by Hayden Pennington on 12/26/21.
//

import SwiftUI
import Combine

public struct SwiftBookControlTable<Content: View> : View {
    let component: () -> Content

    public init(@ViewBuilder component: @escaping () -> Content) {
        self.component = component
    }
  
    public var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    self.component()
                }
            }.frame(maxWidth: 400)
        }.fixedSize()
    }
}

public struct SwiftBookControlColor: View {
    @Binding public var color: Color
    let title: String
    
    #if os(macOS)
    @State var colorWell: ColorWell
    #endif
    
    public init(color: Binding<Color>, title: String) {
        self._color = color
        self.title = title
        #if os(macOS)
        self.colorWell = ColorWell(color: color)
        #endif
    }
    
    public var body: some View {
        VStack {
            
            #if os(iOS)
            if #available(iOS 14.0, *) {
                ColorPicker("", selection: $color)
                    .frame(width: 45, height: 40)
                    .padding()
            }
            #else
        
            Circle()
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(color)
                .padding()
                .onTapGesture {
                    #if os(macOS)
                    colorWell.activate(active: true)
                    #endif
                }
            #endif
            
            Spacer()
            Text(title)
                .font(.system(size: 14))
            
        }
    }
}

public struct SwiftBookControlToggle: View {
    @Binding public var active: Bool
    let title: String
    
    public init(active: Binding<Bool>, title: String) {
        self._active = active
        self.title = title
    }
    
    public var body: some View {
        VStack {
            Toggle(isOn: $active) {
                
            }.toggleStyle(SwitchToggleStyle())
            .padding()
            Spacer()
            Text(title)
                .font(.system(size: 14))
        }
 
    }
}

public struct SwiftBookControlText: View {
    @Binding var text: String
    let label: String
    
    public init(text: Binding<String>, label: String) {
        self._text = text
        self.label = label
    }
    
    public var body: some View {
        VStack {
            TextField(text, text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 400)
                .fixedSize()
            Spacer()
            Text(label)
        }
        
    }
}

public struct SwiftBookControlInt: View {
    @Binding var value: Int
    @State private var text: String
    let label: String
    
    public init(value: Binding<Int>, label: String) {
        self._value = value
        self.label = label
        self.text = String(value.wrappedValue)
    }
    
    public var body: some View {
        VStack {
            TextField(String(value), text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 400)
                .fixedSize()
                .onReceive(Just(text), perform: { newValue in
                    self.text = newValue.filter { $0.isNumber }
                    if let value = Int(self.text) {
                        self.value = value
                    }
                })
            Spacer()
            Text(label)
        }
        
    }
}

public struct SwiftBookControlDouble: View {
    @Binding var value: Double
    @State private var text: String
    let label: String
    
    public init(value: Binding<Double>, label: String) {
        self._value = value
        self.label = label
        self.text = String(value.wrappedValue)
    }
    
    public var body: some View {
        VStack {
            TextField(String(value), text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 400)
                .fixedSize()
                .onReceive(Just(text), perform: { newValue in
                    self.text = newValue.filter { $0.isNumber || $0 == "." }
                    if let value = Double(self.text) {
                        self.value = value
                    }
                })
            Spacer()
            Text(label)
        }
        
    }
}
