import SwiftUI

struct ContentView : View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Experience") {
                    ARViewContainer().edgesIgnoringSafeArea(.all)
                }
                NavigationLink("Plane Detection and Raycasting") {
                    ARPlaneDetectionViewContainer().edgesIgnoringSafeArea(.all)
                }
            }
            .navigationTitle("RealityKit")
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
