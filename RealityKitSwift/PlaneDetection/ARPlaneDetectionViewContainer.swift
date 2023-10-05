import ARKit
import SwiftUI
import RealityKit

//  RealityKit tutorial: Plane Detection and Raycasting
//  https://www.youtube.com/watch?v=T1u1tyMlMLM

struct ARPlaneDetectionViewContainer: UIViewRepresentable {
    
    class Coordinator: NSObject, ARSessionDelegate {
        @IBOutlet var arView:ARView?
        
        override init() {
            print("init Coordinator class")
            self.arView = ARView(frame: .zero)
            super.init()
            
            self.arView?.session.delegate = self
            
            // 1. Fire off plane detection
            startPlaneDetection()

            // 2. 2D Point
            self.arView?.isUserInteractionEnabled = true
            self.arView?.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(handleTap(recognizer: ))))
            
        }
        
        deinit {
            print("deinit Coordinator class")
        }
        
        func startPlaneDetection() {
            print("startPlaneDetection")
            self.arView?.automaticallyConfigureSession = true
            
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            configuration.environmentTexturing = .automatic
            
            self.arView?.session.run(configuration)
        }
        
        @objc func handleTap(recognizer: UITapGestureRecognizer) {
            print("handleTap")
            
            // Touch location
            let tapLocation = recognizer.location(in: arView)
            
            // Raycast (2D -> 3D)
            let results = arView?.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let firstResult = results?.first {
                // 3D point (x,y,z)
                let worldPosition = simd_make_float3(firstResult.worldTransform.columns.3)
                
                // Create sphere
                let sphere = createSphere()
                
                // Place the sphere
                placeObject(object: sphere, at: worldPosition)
    
            }
        }
        
        func createSphere() -> ModelEntity {
            
            // Mesh
            let sphere = MeshResource.generateSphere(radius: 0.5)
            
            // Assign material
            let sphereMaterial = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
            
            // Model Entity
            let sphereEntity = ModelEntity(mesh: sphere, materials: [sphereMaterial])
            
            return sphereEntity
        }
    
        func placeObject(object: ModelEntity, at location: SIMD3<Float>) {
            
            // 1. Anchor
            let objectAnchor = AnchorEntity(world: location)
            
            // 2. Tie model to anchor
            objectAnchor.addChild(object)
            
            // 3. Add anchor to scene
            arView?.scene.addAnchor(objectAnchor)
        }
    }
    
    
    func makeUIView(context: Context) -> ARView {
        return context.coordinator.arView ?? ARView(frame: .zero)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    
}
