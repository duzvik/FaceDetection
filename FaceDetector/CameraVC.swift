//
//  ViewController.swift
//  FaceDetector
//
//  Created by Steve Sloven on 15.12.16.
//  Copyright © 2016 Duzvik. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {
    var photo: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageView.removeFromSuperview()

        //self.navigationController?.setNavigationBarHidden(true, animated: true)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard var photo = photo else {
            let alert = UIAlertController(title: "Alert", message: "Photo is empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        let cid:CIDetector = CIDetector(ofType:CIDetectorTypeFace, context:nil, options:[CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        //add CIDetectorImageOrientation option in case processing of rotated images https://developer.apple.com/reference/imageio/kcgimagepropertyorientation
        
        let results = cid.features(in: CIImage(image:photo)!/*, options: [CIDetectorImageOrientation: "4"] */)
 
        let widthRatio = UIScreen.main.bounds.size.width / photo.size.width
        let heightRatio = UIScreen.main.bounds.size.height / photo.size.height
        let scale = min(widthRatio, heightRatio)
        let imageWidth = scale * photo.size.width
        let imageHeight = scale * photo.size.height
        
        let imgV = UIImageView(frame: CGRect(x: 0, y: 20+navigationController!.navigationBar.frame.size.height, width: imageWidth, height: imageHeight))
        imgV.contentMode = .scaleAspectFit
        imgV.image = photo
        imgV.backgroundColor = UIColor.green
        self.view.addSubview(imgV)
        

  
        print("width ration: \(widthRatio) h ratio: \(heightRatio)  scale: \(scale) imageWidth: \(imageWidth) imageHeight: \(imageHeight)")

        print(imgV)
        print(imgV.bounds.size.height)
        //var transform = CGAffineTransform(scaleX: 1, y: -1)
        //transform = transform.translatedBy(x: 0, y: -imgV.bounds.size.height);
 
        
        //let contextLayer = CALayer()
       // contextLayer.frame = CGRect(x: 0, y: 0, width: photo.size.width, height: photo.size.height)
       // contextLayer.contents = photo.cgImage
        
 
        
        
        for r in results {
            let face:CIFaceFeature = r as! CIFaceFeature;
            let faceWidth = face.bounds.width

            let faceRect = UIView(frame: CGRect(x: face.bounds.origin.x*scale, y: imageHeight-(face.bounds.origin.y*scale + face.bounds.size.height*scale ), width: face.bounds.size.width*scale, height: face.bounds.size.height*scale ))
            faceRect.layer.borderWidth = 2
            faceRect.layer.borderColor = UIColor.green.cgColor
            
            imgV.addSubview(faceRect)
            
            
            let leftEyePoint = CGPoint(x: face.leftEyePosition.x*scale, y: imageHeight-(face.leftEyePosition.y*scale))
            let left = UIView(frame: CGRect(x: leftEyePoint.x, y: leftEyePoint.y, width: 5, height: 5))
            left.backgroundColor = UIColor.green
            imgV.addSubview(left)

            let rightEyePoint = CGPoint(x: face.rightEyePosition.x*scale, y: imageHeight-(face.rightEyePosition.y*scale))
            let right = UIView(frame: CGRect(x: rightEyePoint.x, y: rightEyePoint.y, width: 5, height: 5))
            right.backgroundColor = UIColor.orange
            imgV.addSubview(right)

            let mouthPoint = CGPoint(x: face.mouthPosition.x*scale, y: imageHeight-(face.mouthPosition.y*scale))
            let mouth = UIView(frame: CGRect(x: mouthPoint.x, y: mouthPoint.y, width: 5, height: 5))
            mouth.backgroundColor = UIColor.red
            imgV.addSubview(mouth)

            
/*            let keyPoint = face.leftEyePosition
            let leftEyeMaskLayer = CALayer()
            leftEyeMaskLayer.frame = CGRect(x: keyPoint.x - faceWidth * 0.15, y: keyPoint.y - faceWidth * 0.15, width: faceWidth * 0.3, height: faceWidth * 0.3)
            leftEyeMaskLayer.backgroundColor = UIColor.blue.withAlphaComponent(0.3).cgColor
            leftEyeMaskLayer.cornerRadius = faceWidth * 0.15
            contextLayer.addSublayer(leftEyeMaskLayer)
 */
            
            
           

            
            
            
          // let mouthPoint = face.mouthPosition.applying(transform)
          //  print("mouth Eye!")
          //  print(face.mouthPosition)
          //  print(mouthPoint)

           // let mouth = UIView(frame: CGRect(x: mouthPoint.x, y: mouthPoint.y, width: 5, height: 5))
            
           
            
            //http://stackoverflow.com/questions/12040458/ios-face-detection-transformation
            
            /*
            let test = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            test.center = imgV.center
            test.backgroundColor = UIColor.green
            imgV.addSubview(test)*/
            
            
            
            
/*             NSLog("Face found at (%f,%f) of dimensions %fx%f", face.bounds.origin.x, face.bounds.origin.y, face.bounds.width, face.bounds.height);
            let f = r.bounds.applying(transform)
            
            //let faceRectangle = UIView(frame: CGRect(x: f.origin.x, y: f.origin.x, width: f.width, height: f.height))
            let faceRectangle = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            faceRectangle.layer.borderWidth = 2
            faceRectangle.layer.borderColor = UIColor.red.cgColor
            faceRectangle.backgroundColor = UIColor.clear
            faceRectangle.center = CGPoint(x: f.origin.x, y: f.origin.x)
            self.view.addSubview(faceRectangle)
            */
            
          }
        print(UIScreen.main.bounds)
        
        
        // output image
        //UIGraphicsBeginImageContextWithOptions(contextLayer.frame.size, false, 0)
       // contextLayer.render(in: UIGraphicsGetCurrentContext()!)
       // let outputImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
       // UIGraphicsEndImageContext()

        
        //imgV.image = outputImage
 
        return
        /*

         let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)
        print(photo)
        guard let ciPhoto = CIImage(image: photo) else {
            let alert = UIAlertController(title: "Alert", message: "Failed to convert photo to ciImage", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let features = detector?.fea  features(in: ciPhoto, options: /*[CIDetectorImageOrientation: photo.imageOrientation]*/nil)
        
        guard let featuresArray = features else {
            let alert = UIAlertController(title: "Alert", message: "Cant detect any features", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return

        }
        for feature in featuresArray {
           print("Face bounds: ")
           print(feature.bounds)
        }*/
    }
    
}

