//
//  HTTP.swift
//  TablistEvents
//
//  Created by Vitali Potchekin on 7/14/16.
//  Copyright © 2016 Vitali Potchekin. All rights reserved.
//

import Foundation

class HTTP {
    func test(request: NSMutableURLRequest, completionHandler: (NSDictionary? -> Void)) {
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            var JSON: NSDictionary? = nil
            
            if let data = data {
                do {
                    JSON = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary
                } catch {
                    JSON = nil
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(JSON)
            })
            
        }
        task.resume()
    }
    
    func requestsForURL(url: String, withParameters params: [String: AnyObject?]) -> NSMutableURLRequest? {
        var s: String = url + "?"
        
        for (key, value) in params {
            
            if let str = value as? String {
                s = s + key + "=" + str
            } else if let b = value as? Bool {
                s = s + key + "=" + (b ? "1" : "0")
            } else if let arr = value as? [AnyObject] {
                //s = s + key + "=" + arr.split()
            }
        }
        
        return nil
    }
}
