import Flutter
import UIKit
import ARKit
import Vision
import Alamofire

public class SwiftFaceFinderPlugin: NSObject, FlutterPlugin {

    /*
    let flutterTextureRegistry : FlutterTextureRegistry
    
    init(flutterTextureRegistry : FlutterTextureRegistry) {
        self.flutterTextureRegistry = flutterTextureRegistry
     
    }*/
    
    @IBOutlet private var sceneView: ARSCNView?
    
    private var scanTimer: Timer?
    
    private var post_url : String?;
    
    private var scannedFaceViews = [UIView]()
    
    //get the orientation of the image that correspond's to the current device orientation
    private var imageOrientation: CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portrait: return .right
        case .landscapeRight: return .down
        case .portraitUpsideDown: return .left
        case .unknown: fallthrough
        case .faceUp: fallthrough
        case .faceDown: fallthrough
        case .landscapeLeft: return .up
        }
    }
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "face_finder", binaryMessenger: registrar.messenger())
    let instance = SwiftFaceFinderPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    print(call.method);
    if(call.method == "getPlatformVersion")
    {
        result("iOS2 " + UIDevice.current.systemVersion)
    }
    else if(call.method == "getCameraViewer")
    {
        let args = call.arguments as! NSDictionary;
        let position : Array<CGFloat> = args["position"] as! Array<CGFloat>
        post_url = args["url"] as! String;
        
        if #available(iOS 11.0, *) {
            
            var width = position[2];
            if(width <= 0)
            {
                width = UIApplication.shared.keyWindow?.rootViewController?.view.frame.width as! CGFloat
            }
            
            var height = position[3];
            if(height <= 0)
            {
                height = UIApplication.shared.keyWindow?.rootViewController?.view.frame.height as! CGFloat
            }
            
            sceneView = ARSCNView(frame: CGRect(x: position[0], y: position[1], width: width, height: height));
            
            let configuration = ARFaceTrackingConfiguration()
            sceneView!.session.run(configuration)
            
            UIApplication.shared.keyWindow?.addSubview(sceneView!);
            
            scanTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(scanForFaces), userInfo: nil, repeats: true);
        } else {
            // Fallback on earlier versions
        }
        
        result(1);
        
        //FlutterPluginRegistrar regi
    }
  }
    
    @objc
    @available(iOS 11.0, *)
    private func scanForFaces() {
        
        //remove the test views and empty the array that was keeping a reference to them
        _ = scannedFaceViews.map { $0.removeFromSuperview() }
        scannedFaceViews.removeAll()
        
        //get the captured image of the ARSession's current frame
        guard let capturedImage = sceneView!.session.currentFrame?.capturedImage else { return }
        
        let image = CIImage.init(cvPixelBuffer: capturedImage)
        
        
        
        
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
            
            DispatchQueue.main.async {
                //Loop through the resulting faces and add a red UIView on top of them.
                if let faces = request.results as? [VNFaceObservation] {
                    for face in faces {
                        let faceView = UIView(frame: self.faceFrame(from: face.boundingBox))
                        faceView.layer.borderColor = UIColor.black.cgColor;
                        faceView.layer.borderWidth = 3.0
                        
                        //faceView.backgroundColor = .red
                        
                        self.sceneView!.addSubview(faceView)
                        
                        self.scannedFaceViews.append(faceView)
                        
                        self.takePhoto(bounds: face.boundingBox);
                    }
                    
                    if(faces.count > 0)
                    {
                        //self.takePhoto();
                    }
                }
            }
        }
        
        DispatchQueue.global().async {
            try? VNImageRequestHandler(ciImage: image, orientation: self.imageOrientation).perform([detectFaceRequest])
        }
    }
    
    @available(iOS 11.0, *)
    private func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        //translate camera frame to frame inside the ARSKView
        let origin = CGPoint(x: boundingBox.minX * sceneView!.bounds.width, y: (1 - boundingBox.maxY) * sceneView!.bounds.height)
        let size = CGSize(width: boundingBox.width * sceneView!.bounds.width, height: boundingBox.height * sceneView!.bounds.height)
        
        return CGRect(origin: origin, size: size)
    }
    
    private func takePhoto(bounds: CGRect) {
        
        print("Taking photo");
        
        let headers : HTTPHeaders = [
            "Content-Type" : "image/jpeg"
        ]
        
        var imageUI = sceneView!.snapshot();
        
        //let imageCropped: CGImage = imageUI.cgImage!.cropping(to: bounds)!
        
        //imageUI = UIImage(cgImage: imageCropped);
        
        let resizedImage = imageUI.resized(toWidth: 500);
        
        let imageData = UIImageJPEGRepresentation(resizedImage!, 90);
        if(imageData != nil)
        {
            Alamofire.upload(imageData!, to: self.post_url!,  headers:headers).responseJSON { response in
                debugPrint(response)
            }
            
        }
    }
    
}
