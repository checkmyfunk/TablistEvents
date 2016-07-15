//
//  EventsListViewController.swift
//  TablistEvents
//
//  Created by Vitali Potchekin on 7/9/16.
//  Copyright © 2016 Vitali Potchekin. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class Venue {
    var id: String?
}

class Event {

}

class EventsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var data = NSMutableData()
    var allVenues: [Venue] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.eventsTableView.dataSource = self
        self.eventsTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let accessToken: String = FBSDKAccessToken.currentAccessToken().tokenString
        let latitude  = "40.730610"
        let longitude = "-73.935242"
        let distance  = "1000"
        let url = "https://graph.facebook.com/v2.5/search?type=place&q=&center=" + latitude + "," + longitude + "&distance=" + distance + "&limit=1000&fields=id&access_token=" + accessToken

        //self.loadData()
        
        self.test(NSMutableURLRequest(URL: NSURL(string: url)!)) { (json) in
            
            self.allVenues = []
            //TODO: do something
            
            if let data = json!["data"] as? [[String: AnyObject]] {
                for dataEntry in data {
                    if let id = dataEntry["id"] as? String {
                        let tempVenue = Venue()
                        tempVenue.id = id
                        self.allVenues.append(tempVenue)
                    }
                }
            }
            self.eventsTableView.reloadData()
        }
    }
    
    @IBAction func reload(sender: AnyObject) {
        
    }
    
    @IBAction func clear(sender: AnyObject) {
        self.allVenues = []
        self.eventsTableView.reloadData()
    }
    
    
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

//    func loadData() {
//        let accessToken: String = FBSDKAccessToken.currentAccessToken().tokenString
//        let latitude  = "40.730610"
//        let longitude = "-73.935242"
//        let distance  = "1000"
//        let url = "https://graph.facebook.com/v2.5/search?type=place&q=&center=" + latitude + "," + longitude + "&distance=" + distance + "&limit=1000&fields=id&access_token=" + accessToken
//       
//        guard let requestURL = NSURL(string: url) else {
//            return
//        }
//        
//        let urlRequest = NSMutableURLRequest(URL: requestURL)
//        let session = NSURLSession.sharedSession()
//        
//        let task = session.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
//            
//            self.allVenues = []
//            
//            if let httpResponse = response as? NSHTTPURLResponse {
//                let statusCode = httpResponse.statusCode
//            
//                if (statusCode == 200) {
//                    print("Everyone is fine, file downloaded successfully.")
//                
//                    do {
//                        let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//                    
//                        if let data = jsonResult["data"] as? [[String: AnyObject]] {
//                            for dataEntry in data {
//                                if let id = dataEntry["id"] as? String {
//                                    let tempVenue = Venue()
//                                    tempVenue.id = id
//                                    self.allVenues.append(tempVenue)
//                                }
//                            }
//                        }
//                    } catch {
//                        print("Error with Json: \(error)")
//                    }
//                }
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                self.eventsTableView.reloadData()
//            })
//        }
//        task.resume()
//    }

    
    //TableView methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allVenues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.eventsTableView.dequeueReusableCellWithIdentifier("eventCell") as! EventCell
        cell.stationNameLabel.text = self.allVenues[indexPath.row].id
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
