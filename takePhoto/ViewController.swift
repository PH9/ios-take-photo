//
//  ViewController.swift
//  takePhoto
//
//  Created by Wasith Theerapattrathamrong on 10/3/2559 BE.
//  Copyright © 2559 Wasith Theerapattrathamrong. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController {
    
    @IBOutlet var pidCameraOverlayView: UIView!
    @IBOutlet weak var cameraPreviewImage: UIImageView!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var topOverlayView: UIView!
    @IBOutlet weak var cameraPreviewZoneView: UIView!

    private var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupImagePicker() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.imagePicker.sourceType = .Camera
        } else {
            self.imagePicker.sourceType = .PhotoLibrary
        }
        
        self.imagePicker.showsCameraControls = false
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(self.imagePicker.sourceType)!
        
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        if self.cameraPreviewImage.isAnimating() {
            self.cameraPreviewImage.stopAnimating()
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .CurrentContext
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .FullScreen
        
//        let presentationController = imagePicker.presentationController
//        presentationController?.permittedArrowDirections = .Any
        
        if sourceType == .Camera {
            imagePicker.showsCameraControls = false
            NSBundle.mainBundle().loadNibNamed("PidCameraOverlay", owner: self, options: nil)
    
            self.pidCameraOverlayView!.frame = (imagePicker.cameraOverlayView?.frame)!
            
            imagePicker.cameraOverlayView = self.pidCameraOverlayView
            self.pidCameraOverlayView = nil
            
            // AdjustPreviewSize
            let screenSize = UIScreen.mainScreen().bounds.size
            let cameraAspectRatio: CGFloat = 4.0 / 3.0
            let cameraHeight = screenSize.width * cameraAspectRatio
            let scale: CGFloat = screenSize.height / cameraHeight
            let diffHeight = (screenSize.height - cameraHeight) / 2.0
            
            imagePicker.cameraViewTransform = CGAffineTransformMakeTranslation(0, diffHeight)
            imagePicker.cameraViewTransform = CGAffineTransformScale(imagePicker.cameraViewTransform, scale, scale)
        }
        
        self.imagePicker = imagePicker
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takePhotoButtonClicked(sender: AnyObject) {
        self.imagePicker.takePicture()
    }
    
    @IBAction func takePhotoMode(sender: AnyObject) {
        self.showImagePickerForSourceType(.Camera)
    }
    
    private func finishAndUpdate() {
        
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.cameraPreviewImage.image = pidCropImage(image!)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func pidCropImage(image: UIImage) -> UIImage {
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)

        let screenSize = UIScreen.mainScreen().bounds
        let imageSize = image.size
        let cameraAspectRatio: CGFloat = 4.0 / 3.0
        let imageHeight = screenSize.width * cameraAspectRatio
        let topOverlayFrame = self.topOverlayView.frame
        let cameraPreviewZoneFrame = self.cameraPreviewZoneView.frame

        let newX: CGFloat = 0
        let newY: CGFloat = (topOverlayFrame.height / screenSize.height) * imageHeight
        let newWidth: CGFloat = imageSize.width
        let newHeight: CGFloat = (cameraPreviewZoneFrame.height / screenSize.height) * imageSize.height
        
        let newRect = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)

        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, newRect)!

        let newImage = UIImage(
            CGImage: imageRef,
            scale: image.scale,
            orientation: image.imageOrientation
        )
        
        return newImage
    }
}