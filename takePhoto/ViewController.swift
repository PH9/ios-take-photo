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
    
    @IBOutlet weak var cameraPreviewImage: UIImageView!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    private var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupImagePicker()
    }
    
    private func setupImagePicker() {

    }
    
    @IBAction func takePhotoButtonClicked(sender: AnyObject) {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.imagePicker.sourceType = .Camera
        } else {
            self.imagePicker.sourceType = .PhotoLibrary
        }
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(self.imagePicker.sourceType)!
        
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
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