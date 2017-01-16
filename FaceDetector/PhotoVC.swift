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

    var imageView: UIImageView {
        get {
            return self.view as! UIImageView
        }
    }
    
    override func loadView() {
        self.view = UIImageView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let randomNum:UInt32 = arc4random_uniform(170) // range is 0 to 169
        let z = String(format: "%03d", Int(randomNum))
        let url = "http://kingofwallpapers.com/face/face-\(z).jpg"
        self.photo = UIImage(data: try! Data(contentsOf: URL(string: url)!))
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let photo = photo else {
            let alert = UIAlertController(title: "Alert", message: "Photo is empty", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        let faceDetector = FaceDetector()
        imageView.image = photo
        imageView.contentMode = .scaleAspectFit
        //get image frame after scale to fit screen
        var scaledImgRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        let imageRatio = photo.size.width / photo.size.height;
        let viewRatio = self.view.frame.size.width / self.view.frame.size.height;
        if(imageRatio < viewRatio){
            let scale = self.view.frame.size.height / photo.size.height;
            let width = scale * photo.size.width;
            let topLeftX = (self.view.frame.size.width - width) * 0.5;
            scaledImgRect = CGRect(x: topLeftX, y: 0, width: width, height: self.view.frame.size.height);
        } else {
            let scale = self.view.frame.size.width / photo.size.width;
            let height = scale * photo.size.height;
            let topLeftY = (self.view.frame.size.height - height) * 0.5;
            scaledImgRect =  CGRect(x: 0, y: topLeftY, width: self.view.frame.size.width, height: height);
        }
        
        let bgView = UIView(frame: scaledImgRect)
        view.addSubview(bgView)
        
        
        faceDetector.detectFace(image: photo, applyToView: bgView)
        return
    }
 
}
