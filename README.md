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

struct ContentView: View {
    var body: some View {
        SwiftBook([
            ("Slider", AnyView(SliderDoc())),
        ])
    }
}


```


## Full example app at https://gitlab.com/haydenpennington/shapes.git
