//
//  ViewController.swift
//  takePhoto
//
//  Created by Wasith Theerapattrathamrong on 10/3/2559 BE.
//  Copyright © 2559 Wasith Theerapattrathamrong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var cameraPreviewImage: UIImageView!
    
    var capturedImages: NSMutableArray = NSMutableArray()
    var imagePickerController: UIImagePickerController!
    let sourceType = UIImagePickerControllerSourceType.Camera
    var isCameraAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(self.sourceType)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpCameraPreview()
    }
    
    private func setUpCameraPreview() {
        guard self.isCameraAvailable else {
            return
        }
        
        if self.cameraPreviewImage.isAnimating() {
            self.cameraPreviewImage.stopAnimating()
        }

        self.imagePickerController = UIImagePickerController()
        self.imagePickerController.modalPresentationStyle = .CurrentContext
        self.imagePickerController.sourceType = self.sourceType
        self.imagePickerController.delegate = self
        self.imagePickerController.modalPresentationStyle = .FullScreen
        
        self.imagePickerController.showsCameraControls = false;
        
        self.presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        guard self.isCameraAvailable else {
            return
        }
        
        if self.isCameraAvailable {
            self.imagePickerController.takePicture()
        }
    }
}

extension ViewController {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.capturedImages.addObject(image)
            self.finishTakePhotoUpdateUI()
        }
    }
    
    private func finishTakePhotoUpdateUI() {

    }
}