import UIKit
import AVFoundation


class CameraVC: UIViewController {
    var _faceRect: UIView?
    var _left: UIView?
    var _right: UIView?
    var _mouth: UIView?
    var _tmp: CGFloat?
    
    var faceDetector = FaceDetector()
    
    lazy var session : CaptureSessionController = {
        let session = CaptureSessionController()
        session.delegate = self
        return session
    }()
    
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
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.startCaptureSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopCaptureSession()
    }
}

extension CameraVC: CaptureSessionControllerDelegate {
    func captureSessionController(_ captureSessionController: CaptureSessionController, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    func captureSessionController(_ captureSessionController: CaptureSessionController, didStopRunningCaptureSession captureSession: AVCaptureSession) {
        print("session stopped")
    }
    
    func captureSessionController(_ captureSessionController: CaptureSessionController, didStartRunningCaptureSession captureSession: AVCaptureSession) {
        print("session started")
    }
     
    func captureSessionController(_ captureSessionController: CaptureSessionController, didUpdateWithSampleBuffer sampleBuffer: CMSampleBuffer) {
        DispatchQueue.main.async {
            let sampleImg = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer)
            self.imageView.image = sampleImg
        }
        
        if let img = self.imageView.image {
            faceDetector.detectFaceFrom(image: img, applyToView: self.imageView)
        }
       
     }
    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
    {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);
        
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer!);
        let height = CVPixelBufferGetHeight(imageBuffer!);
        
        // Create a device-dependent RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Create a bitmap graphics context with the sample buffer data
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage = context?.makeImage();
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
        
        // Create an image object from the Quartz image
        let image = UIImage.init(cgImage: quartzImage!);
        
        return (image);
    }
    
}
