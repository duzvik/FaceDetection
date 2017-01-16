import UIKit

class FaceDetector {
    private var leftEyeView: UIView?
    private var faceRectView: UIView?
    private var rightEyeView: UIView?
    private var mouthView: UIView?
    
    func detectFace(image: UIImage?, applyToView: UIView?){
        guard let image = image else {
            return
        }
        
        //add CIDetectorImageOrientation option in case processing of rotated images https://developer.apple.com/reference/imageio/kcgimagepropertyorientation
        let cid:CIDetector = CIDetector(ofType:CIDetectorTypeFace, context:nil, options:[CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        
        let t1 = Int64(Date().timeIntervalSince1970 * 1000)
        var cidFeatures = cid.features(in: CIImage(image:image)!  /*, options: [CIDetectorImageOrientation: "4"] */)
        let t2 = Int64(Date().timeIntervalSince1970 * 1000)
        print("-->Face Recognishion: \(t2-t1) msec results: \(cidFeatures.count) ")
        
        if cidFeatures.count > 1 {
            cidFeatures = [cidFeatures.first!]  //track only one face ;)
        }
        
        let widthRatio = UIScreen.main.bounds.size.width / image.size.width
        let heightRatio = UIScreen.main.bounds.size.height / image.size.height
        let scale = min(widthRatio, heightRatio)
        //let imageWidth = scale * image.size.width
        let imageHeight = scale * image.size.height
        
        self.faceRectView?.removeFromSuperview()
        self.leftEyeView?.removeFromSuperview()
        self.rightEyeView?.removeFromSuperview()
        self.mouthView?.removeFromSuperview()
        
        for r in cidFeatures {
            let face:CIFaceFeature = r as! CIFaceFeature;
            //let faceWidth = face.bounds.width
            
            let faceRect = UIView(frame: CGRect(x: face.bounds.origin.x*scale, y: imageHeight-(face.bounds.origin.y*scale + face.bounds.size.height*scale ), width: face.bounds.size.width*scale, height: face.bounds.size.height*scale ))
            faceRect.layer.borderWidth = 2
            faceRect.layer.borderColor = UIColor.green.cgColor
            
            let leftEyePoint = CGPoint(x: face.leftEyePosition.x*scale, y: imageHeight-(face.leftEyePosition.y*scale))
            let left = UIView(frame: CGRect(x: leftEyePoint.x, y: leftEyePoint.y, width: 5, height: 5))
            left.backgroundColor = UIColor.green
            
            let rightEyePoint = CGPoint(x: face.rightEyePosition.x*scale, y: imageHeight-(face.rightEyePosition.y*scale))
            let right = UIView(frame: CGRect(x: rightEyePoint.x, y: rightEyePoint.y, width: 5, height: 5))
            right.backgroundColor = UIColor.orange
            
            
            let mouthPoint = CGPoint(x: face.mouthPosition.x*scale, y: imageHeight-(face.mouthPosition.y*scale))
            let mouth = UIView(frame: CGRect(x: mouthPoint.x, y: mouthPoint.y, width: 5, height: 5))
            mouth.backgroundColor = UIColor.red
            
            faceRectView = faceRect
            applyToView?.addSubview(self.faceRectView!)
            leftEyeView = left
            applyToView?.addSubview(self.leftEyeView!)
            rightEyeView = right
            applyToView?.addSubview(self.rightEyeView!)
            mouthView = mouth
            applyToView?.addSubview(self.mouthView!)
            
        }
        
        
    }
    
}
