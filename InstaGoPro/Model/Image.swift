//
//  Images.swift
//  vemoryApp
//
//  Created by Gabriel Morales on 7/30/16.
//  Copyright © 2016 Gabemdev. All rights reserved.
//

import UIKit

class Image: NSObject {
    var comments: Int = 0
    var likes: Int = 0
    var linkUrl: String?
    var imageURL: NSURL?
    var imageStandardResURL: NSURL?
    var sortType = Sort.Likes
    
    enum Sort {
        case Likes
        case Comments
    }
}
