import UIKit

class PhotoVC: UIViewController {
    var photo: UIImage?
    private let RetinaToEyeScaleFactor: CGFloat = 0.5
    private let FaceBoundsToEyeScaleFactor: CGFloat = 4.0
    private let FaceBoundsToMouthScaleFactor: CGFloat = 3.0
    
    
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
        
        DispatchQueue.global(qos: .background).async{
            let randomNum:UInt32 = arc4random_uniform(170) // range is 0 to 169
            let z = String(format: "%03d", Int(randomNum))
            let url = "http://kingofwallpapers.com/face/face-\(z).jpg"
            self.photo = UIImage(data: try! Data(contentsOf: URL(string: url)!))
            
            DispatchQueue.main.async {
                self.imageView.image = self.photo
                self.imageView.contentMode = .scaleAspectFit
            }
            
            self.applyFilter(image: self.photo!)
        }
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func applyFilter(image: UIImage) {
        let faceDetector = FaceDetector()
        let overlayImage = faceDetector.detectFaceFrom(image: image)
        DispatchQueue.main.async {
            self.imageView.image = overlayImage
        }
    }
    
    
    func applyFilter2(image: UIImage){
        let faceDetector = FaceDetector()
        imageView.image = photo
        imageView.contentMode = .scaleAspectFit
        //get image frame after scale to fit screen
        var scaledImgRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        let imageRatio = image.size.width / image.size.height;
        let viewRatio = self.view.frame.size.width / self.view.frame.size.height;
        if(imageRatio < viewRatio){
            let scale = self.view.frame.size.height / image.size.height;
            let width = scale * image.size.width;
            let topLeftX = (self.view.frame.size.width - width) * 0.5;
            scaledImgRect = CGRect(x: topLeftX, y: 0, width: width, height: self.view.frame.size.height);
        } else {
            let scale = self.view.frame.size.width / image.size.width;
            let height = scale * image.size.height;
            let topLeftY = (self.view.frame.size.height - height) * 0.5;
            scaledImgRect =  CGRect(x: 0, y: topLeftY, width: self.view.frame.size.width, height: height);
        }
        
        let bgView = UIView(frame: scaledImgRect)
        view.addSubview(bgView)
        
        
        faceDetector.detectFaceFrom(image: photo, applyToView: bgView)
        return
    }
    
}
