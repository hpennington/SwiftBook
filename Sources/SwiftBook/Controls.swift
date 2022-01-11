//
//  SwiftBookControls.swift
//  
//
//  Created by Hayden Pennington on 12/26/21.
//

import SwiftUI
import Combine

public enum ControlDimensions: CGFloat {
    case colorSwatchIOS = 45
    case colorSwatchMacOS = 30
    case tableMaxWidth = 400
    case fontSize = 14
    
}

public struct ControlsTable<Content: View> : View {
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
            }.frame(maxWidth: ControlDimensions.tableMaxWidth.rawValue)
        }.fixedSize()
    }
}

public struct ControlColor: View {
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
                    .frame(width: ControlDimensions.colorSwatchIOS.rawValue, height: ControlDimensions.colorSwatchIOS.rawValue)
                    .padding()
            }
            #else
        
            Circle()
                .frame(width: ControlDimensions.colorSwatchMacOS.rawValue, height: ControlDimensions.colorSwatchMacOS.rawValue, alignment: .center)
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
                .font(.system(size: ControlDimensions.fontSize.rawValue))
            
        }
    }
}

public struct ControlToggle: View {
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
                .font(.system(size: ControlDimensions.fontSize.rawValue))
        }
 
    }
}

public struct ControlText: View {
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
                .frame(maxWidth: ControlDimensions.tableMaxWidth.rawValue)
                .fixedSize()
            Spacer()
            Text(label)
        }
        
    }
}

public struct ControlInt: View {
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
                .frame(maxWidth: ControlDimensions.tableMaxWidth.rawValue)
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

public struct ControlDouble: View {
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
                .frame(maxWidth: ControlDimensions.tableMaxWidth.rawValue)
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
