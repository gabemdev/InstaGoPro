//
//  VemoryAPI.swift
//  vemoryApp
//
//  Created by Gabriel Morales on 7/30/16.
//  Copyright © 2016 Gabemdev. All rights reserved.
//

import UIKit
import Alamofire

class VemoryAPI: NSObject {
    // Error code: The execution of the custom server code timed out.
    static let kErrorParsingJSONCode = 902
    static let kErrorParsingJSONMessage = "Unable to parse JSON"
    
    func retrieveImages(completion:(images:[Image]?, error:NSError?) ->Void) {
        let imageURLRequest = VemoryAPIRequestRouter.Images.URLRequest
        
        Alamofire.request(imageURLRequest)
            .responseJSON(completionHandler: {response in
                guard let JSON = response.result.value else {
                    completion(images: nil, error: response.result.error)
                    return
                }
                
                guard let imagesJSON = JSON["items"] as? [AnyObject] else {
                    completion(images: nil,error: NSError(
                        domain: VemoryAPI.kErrorParsingJSONMessage,
                        code: VemoryAPI.kErrorParsingJSONCode, userInfo: nil))
                    return
                }
                
                var imagesArray = [Image]()
                for imageJSON in imagesJSON {
                    let photo = Image()
                    
                    // Photo Website URL
                    photo.linkUrl = imageJSON["link"] as? String ?? ""
                    
                    // COmments Dictionary
                    if let comments_dict = imageJSON["comments"] as? [String:AnyObject] {
                        photo.comments = comments_dict["count"] as? Int ?? 0
                    }
                    
                    // Likes Dictionary
                    if let likes_dict = imageJSON["likes"] as? [String:AnyObject] {
                        photo.likes = likes_dict["count"] as? Int ?? 0
                    }
                    
                    // Image Dictionary
                    if let image_dict = imageJSON["images"] as? [String:AnyObject] {
                        // Thumbnail Dictionary
                        if let resolution_dict = image_dict["thumbnail"] as? [String:AnyObject] {
                            if let photoURL = resolution_dict["url"] as? String {
                                let url = NSURL(string: photoURL)
                                photo.imageURL = url
                            }
                        }
                        
                        // Standard Resolution Dictionary
                        if let standard_resolution_dict = image_dict["standard_resolution"] as? [String:AnyObject] {
                            if let photoURL = standard_resolution_dict["url"] as? String {
                                let url = NSURL(string: photoURL)
                                photo.imageStandardResURL = url
                            }
                        }
                    }
                    // Add photo object to image array.
                    imagesArray.append(photo)
                }
                completion(images: imagesArray, error: nil)
                }
        )
    }
}
