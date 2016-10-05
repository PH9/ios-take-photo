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

            self.cameraPreviewImage.image = pidCropImage(image!.fixOrientation())
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    private func pidCropImage(image: UIImage) -> UIImage {
        let imageSize = image.size
        let screenSize = UIScreen.mainScreen().bounds
        var expectedHeight: CGFloat = 1468
        var expectedWidth: CGFloat = 2448
        var startX: CGFloat = 952
        var startY: CGFloat = 1442

        expectedHeight = (cameraPreviewZoneView.bounds.height / screenSize.height) * imageSize.height
        expectedWidth = expectedHeight * 1.6
        startX = (imageSize.width - expectedWidth) / 2
        startY = (imageSize.height - expectedHeight) / 2

        let cropRect = CGRect(x: startX, y: startY, width: expectedWidth, height: expectedHeight)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect)!

        let orientation = image.imageOrientation
        let newImage = UIImage(CGImage: imageRef, scale: 1, orientation: orientation)

        return newImage
    }
}