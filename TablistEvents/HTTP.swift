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
                s = s + key + "=" + str + "&"
            } else if let d = value as? Double {
                s = s + key + "=" + String(d) + "&"
            } else if let i = value as? Int {
                s = s + key + "=" + String(i) + "&"
            } else if let arr = value as? [AnyObject] {
                let tempString = arr.map({"\($0)"}).joinWithSeparator(",")
                s = s + key + "=" + tempString + "&"
            }
        }
        print(s)
        
        let request = NSMutableURLRequest(URL: NSURL(string: s)!)
        
        return request
    }
}


















