//
//  GoProMainViewController.swift
//  vemoryApp
//
//  Created by Gabriel Morales on 7/30/16.
//  Copyright © 2016 Gabemdev. All rights reserved.
//

import UIKit

class GoProMainViewController: UIViewController {
    // MARK: - Properties
    var imageArray = [Image]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Load data
        apiSetup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    func apiSetup() {
        self.activityIndicator.startAnimating()
        let api = VemoryAPI()
        api.retrieveImages { (images, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    self.imageArray = images!
                    self.sortImagesByParameter(.Likes)
                    self.reloadData()
                }
            })
        }
    }
    
    //MARK: - Actions
    /**
     Show detail pop up view for image.
     
     - parameter targetVC: View Controller that will present the detail pop up.
     - parameter image:    Image Alert object that will be used to populate detail view.
     */
    class func showImageModal(targetVC targetVC: UIViewController?, withImage image: ImageAlert) {
        let imageDetail = ImageDetailModalViewController.openImageModalViewController()
        imageDetail?.image = image
        targetVC?.presentingViewController?.providesPresentationContextTransitionStyle = true
        targetVC?.presentingViewController?.definesPresentationContext = true
        imageDetail!.modalPresentationStyle = .OverCurrentContext
        targetVC?.presentViewController(imageDetail!, animated: false, completion: nil)
    }
    
    /**
     Reload collection view when switching segment control.
     
     */
    @IBAction func onSegmentControlTapped(sender: UISegmentedControl) {
        
        var parameter: Image.Sort
        switch self.segmentedControl.selectedSegmentIndex {
        case 1:
            parameter = .Comments
        default:
            parameter = .Likes
        }
        self.activityIndicator.startAnimating()
        sortImagesByParameter(parameter)
    }
    
    /**
     Reload collection view
     */
    func reloadData() {
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
        })
    }
    
    func sortImagesByParameter(parameter: Image.Sort) {
        switch parameter {
        case .Likes:
            imageArray = imageArray.sort({$0.likes < $1.likes})
        case .Comments:
            imageArray = imageArray.sort({$0.comments < $1.comments})
            
        }
        reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension GoProMainViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let goProImage = imageArray[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(GoProCollectionViewCell), forIndexPath: indexPath) as! GoProCollectionViewCell
        
        var labelCount: Int
        switch self.segmentedControl.selectedSegmentIndex {
            //        case 0:
        //            labelCount = goProImage.likes
        case 1:
            labelCount = goProImage.comments
        default:
            labelCount = goProImage.likes
        }
        cell.configureWithImage(goProImage, labelCount:labelCount)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GoProMainViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let selectedImage = imageArray[indexPath.row]
        
        //Setup ImageAlert
        let alert = ImageAlert()
        alert.imageComments = "\(selectedImage.comments)"
        alert.imageLikes = "\(selectedImage.likes)"
        alert.alertImage = selectedImage.imageStandardResURL
        
        GoProMainViewController.showImageModal(targetVC: self, withImage: alert)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GoProMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Get screen width and divide by 2 to obtain equal width items.
        // Item will have same height and width.
        let size = CGRectGetWidth(UIScreen.mainScreen().bounds) / 2
        let itemSize = CGSizeMake(size, size)
        return itemSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}


