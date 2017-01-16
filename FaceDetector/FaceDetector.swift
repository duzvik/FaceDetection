import UIKit

class FaceDetector {
    private var leftEyeView: UIView?
    private var faceRectView: UIView?
    private var rightEyeView: UIView?
    private var mouthView: UIView?
    
    
    private let RetinaToEyeScaleFactor: CGFloat = 0.5
    private let FaceBoundsToEyeScaleFactor: CGFloat = 4.0
    private let FaceBoundsToMouthScaleFactor: CGFloat = 3.0

    
    func detectFaceFrom(image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        
        
        // Get features from the image
        let newImage = CIImage(cgImage: image.cgImage!)
        let features = detector?.features(in: newImage) as! [CIFaceFeature]!
        
        UIGraphicsBeginImageContext(image.size)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        // Draws this in the upper left coordinate system
        image.draw(in: imageRect, blendMode: .normal, alpha: 1.0)
        
        let context = UIGraphicsGetCurrentContext()
        for faceFeature in features! {
            let faceRect = faceFeature.bounds
            
            context!.setStrokeColor(UIColor.green.cgColor)
            context!.setLineWidth(5)
            let faceBorderRect = CGRect(x: faceRect.origin.x, y: image.size.height - (faceRect.origin.y + faceRect.size.height ), width: faceRect.width, height: faceRect.height
            )
            context!.stroke(faceBorderRect)
            
            context!.saveGState()
            
            // CI and CG work in different coordinate systems, we should translate to
            // the correct one so we don't get mixed up when calculating the face position.
            context!.translateBy(x: 0.0, y: imageRect.size.height)
            context!.scaleBy(x: 1.0, y: -1.0)
            
            if faceFeature.hasLeftEyePosition {
                let leftEyePosition = faceFeature.leftEyePosition
                let eyeWidth = faceRect.size.width / FaceBoundsToEyeScaleFactor
                let eyeHeight = faceRect.size.height / FaceBoundsToEyeScaleFactor
                let eyeRect = CGRect(x: leftEyePosition.x - eyeWidth / 2.0,
                                     y: leftEyePosition.y - eyeHeight / 2.0,
                                     width: eyeWidth,
                                     height: eyeHeight)
                drawEyeBallForFrame(eyeRect)
            }
            
            if faceFeature.hasRightEyePosition {
                let leftEyePosition = faceFeature.rightEyePosition
                let eyeWidth = faceRect.size.width / FaceBoundsToEyeScaleFactor
                let eyeHeight = faceRect.size.height / FaceBoundsToEyeScaleFactor
                let eyeRect = CGRect(x: leftEyePosition.x - eyeWidth / 2.0,
                                     y: leftEyePosition.y - eyeHeight / 2.0,
                                     width: eyeWidth,
                                     height: eyeHeight)
                drawEyeBallForFrame(eyeRect)
            }
            
            if faceFeature.hasMouthPosition {
                let mouthPosition = faceFeature.mouthPosition
                let mouthWidth = faceRect.size.width / FaceBoundsToMouthScaleFactor
                drawMouthForFrame(CGRect(x: mouthPosition.x - mouthWidth / 2 , y: mouthPosition.y, width: mouthWidth, height: 10))
            }
            
            context!.restoreGState();
        }
        
        let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return overlayImage
    }
    
    func detectFaceFrom(image: UIImage?, applyToView: UIView?){
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
    
    private func drawEyeBallForFrame(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: rect)
        context?.setFillColor(UIColor.white.cgColor)
        context?.fillPath()
        
        var x: CGFloat
        var y: CGFloat
        var eyeSizeWidth: CGFloat
        var eyeSizeHeight: CGFloat
        eyeSizeWidth = rect.size.width * RetinaToEyeScaleFactor
        eyeSizeHeight = rect.size.height * RetinaToEyeScaleFactor
        
        x = CGFloat(arc4random_uniform(UInt32(rect.size.width - eyeSizeWidth)))
        y = CGFloat(arc4random_uniform(UInt32(rect.size.height - eyeSizeHeight)))
        x += rect.origin.x
        y += rect.origin.y
        
        let eyeSize = min(eyeSizeWidth, eyeSizeHeight)
        let eyeBallRect = CGRect(x: x, y: y, width: eyeSize, height: eyeSize)
        context?.addEllipse(in: eyeBallRect)
        context?.setFillColor(UIColor.black.cgColor)
        context?.fillPath()
    }
    
    private func drawMouthForFrame(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(rect)
        context?.setFillColor(UIColor.red.cgColor)
        context?.fillPath()
    }
    
    
}
