//
//  VemoryAPIRequestRouter.swift
//  vemoryApp
//
//  Created by Gabriel Morales on 7/30/16.
//  Copyright © 2016 Gabemdev. All rights reserved.
//

import UIKit
import Alamofire

public enum VemoryAPIRequestRouter: URLRequestConvertible {
    
    // Set base URL String and default time out.
    static let baseURLString = "https://www.instagram.com/gopro"
    static let defaultTimeout = 15 //seconds
    
    // Images case, add more depending on additional routes.
    case Images
    
    public var URLRequest: NSMutableURLRequest {
        let baseURL = VemoryAPIRequestRouter.baseURLString
        
        let result: (baseURLString: String, path: String, method: Alamofire.Method, parameters: [String: AnyObject]?) = {
            // Handle cases defined above. 
            switch self {
            case .Images:
                return (baseURL, "/media", .GET, nil)
            }
        }()
        
        let URL = NSURL(string: result.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        URLRequest.HTTPMethod = result.method.rawValue
        URLRequest.timeoutInterval = NSTimeInterval(VemoryAPIRequestRouter.defaultTimeout * 1000)
        
        let encoding = Alamofire.ParameterEncoding.URL
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
}
