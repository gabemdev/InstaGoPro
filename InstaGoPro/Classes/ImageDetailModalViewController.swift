//
//  ImageDetailModalViewController.swift
//  vemoryApp
//
//  Created by Gabriel Morales on 7/31/16.
//  Copyright © 2016 Gabemdev. All rights reserved.
//

import UIKit
import AlamofireImage

class ImageDetailModalViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    
    private var currentImage: ImageAlert?
    
    var image: ImageAlert? {
        set(newImage) {
            currentImage = newImage
        }
        get {
            return currentImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set custom presentation and transition style.
        self.modalPresentationStyle = .OverFullScreen
        self.modalTransitionStyle = .CrossDissolve
        setupImageAlert()
    }
    
    /**
     Pop up modal class method so we can use anywhere in the app.
     
     */
    class func openImageModalViewController() -> ImageDetailModalViewController? {
        let storyboard = UIStoryboard(name: "PopUp", bundle: NSBundle.mainBundle())
        return storyboard.instantiateViewControllerWithIdentifier("ImageDetailModalViewController") as? ImageDetailModalViewController
    }
    
    //MARK: Private Methods
    func setupImageAlert() {
        guard let selected: ImageAlert = image else {
            print("Error")
            return
        }
        
        // Populate detail view
        commentsLabel.text = selected.imageComments
        likesLabel.text = selected.imageLikes
        if let imageURL = selected.alertImage {
            alertImageView.af_setImageWithURL(imageURL)
        }
    }
    
}

private extension ImageDetailModalViewController {
    
    // Dismiss detail view
    @IBAction func onCloseModalButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}