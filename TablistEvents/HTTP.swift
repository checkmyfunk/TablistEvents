//
//  HTTP.swift
//  TablistEvents
//
//  Created by Vitali Potchekin on 7/14/16.
//  Copyright © 2016 Vitali Potchekin. All rights reserved.
//

import Foundation

class HTTP {
    func test(_ request: NSMutableURLRequest, completionHandler: @escaping ((NSDictionary?) -> Void)) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            var JSON: NSDictionary? = nil
            
            if let data = data {
                do {
                    JSON = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                } catch {
                    JSON = nil
                }
            }
            
            DispatchQueue.main.async(execute: {
                completionHandler(JSON)
            })
            
        }) 
        task.resume()
    }
    
    func requestsForURL(_ url: String, withParameters params: [String: AnyObject?]) -> NSMutableURLRequest? {
        var s: String = url + "?"
        
        for (key, value) in params {
            
            if let str = value as? String {
                s = s + key + "=" + str + "&"
            } else if let d = value as? Double {
                s = s + key + "=" + String(d) + "&"
            } else if let i = value as? Int {
                s = s + key + "=" + String(i) + "&"
            } else if let arr = value as? [AnyObject] {
                let tempString = arr.map({"\($0)"}).joined(separator: ",")
                s = s + key + "=" + tempString + "&"
            }
        }
        print(s)
        
        let request = NSMutableURLRequest(url: URL(string: s)!)
        
        return request
    }
}


















