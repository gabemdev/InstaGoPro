//
//  GoProCollectionViewCell.swift
//  vemoryApp
//
//  Created by Gabriel Morales on 7/30/16.
//  Copyright © 2016 Gabemdev. All rights reserved.
//

import UIKit
import AlamofireImage

class GoProCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    private var currentImage: Image?
    var image: Image? {
        set(newImage) {
            currentImage = newImage
        }
        get {
            return currentImage
        }
    }
    
    func configureWithImage(image: Image, labelCount: Int) {
        self.image = image
        countLabel.text = "\(labelCount)"
        
        if let imageURLString = image.imageURL {
            imageView.af_setImageWithURL(imageURLString)
        } else {
            imageView.af_setImageWithURL(NSURL(string: "https://placeholdit.imgix.net/~text?txtsize=33&txt=No%20Image%20Available&w=320&h=320")!)
        }
    }
    
}
