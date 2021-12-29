# SwiftBook

A Swift library for documenting, isolating, and testing SwiftUI components.

## Minimal Example
An example demonstrated with the slider ui element.


```swift
struct SliderDoc: View {
    @State private var value: Double = 0.0
    
    var body: some View {
        H1("Slider")
        P("A Slider element provided by Apple for SwiftUI.")
        SwiftBookComponent {
            Slider(value: $value)
        }
        
    }
}
```

## An example demonstrating the controls table provided with SwiftUI

```swift
struct CircleView: View {
    let color: Color
    let label: String
    let labelColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 300, height: 300, alignment: .center)
                .foregroundColor(color)
            Text(label)
                .foregroundColor(labelColor)
                .font(.headline)
        }
    }
}

struct CircleDoc: View {
    @State private var color: Color = .red
    @State private var label: String = "Red Circle"
    @State private var labelColor: Color = .primary

    var body: some View {
        H2("A red circle")
        H3("This is a description of a red circle.")
        SwiftBookComponent {
            CircleView(color: color, label: label, labelColor: labelColor)
        }
        SwiftBookControlTable {
            SwiftBookControlColor(color: $color, title: "color")
            SwiftBookControlColor(color: $labelColor, title: "labelColor")
            SwiftBookControlText(text: $label, label: "label")
        }
    }
}
```

## Full example app at https://gitlab.com/haydenpennington/shapes.git
