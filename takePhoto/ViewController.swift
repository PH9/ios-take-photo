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
        imagePicker.modalPresentationStyle = (sourceType == .Camera) ? .FullScreen : .Popover
        
        let presentationController = imagePicker.popoverPresentationController
        presentationController?.permittedArrowDirections = .Any
        
        if sourceType == .Camera {
            imagePicker.showsCameraControls = false
            NSBundle.mainBundle().loadNibNamed("PidCameraOverlay", owner: self, options: nil)
            self.pidCameraOverlayView!.frame = (imagePicker.cameraOverlayView?.frame)!
            imagePicker.cameraOverlayView = self.pidCameraOverlayView
            self.pidCameraOverlayView = nil
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
            self.cameraPreviewImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}