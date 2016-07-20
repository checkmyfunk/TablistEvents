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
    
    init() {
    
    }
    
    init(id: String) {
        self.id = id
    }
    
    var id: String?
}

class Event {

}

class EventsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var data = NSMutableData()
    var allVenues: [Venue] = []
    var venueIDs: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.eventsTableView.dataSource = self
        self.eventsTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadData()
        
    }
    
    @IBAction func reload(sender: AnyObject) {
        self.loadData()
    }
    
    @IBAction func clear(sender: AnyObject) {
        self.allVenues = []
        self.eventsTableView.reloadData()
    }
    
    func loadData(){
        
        let accessToken: String = FBSDKAccessToken.currentAccessToken().tokenString
        let latitude  = "40.730610"
        let longitude = "-73.935242"
        let center = latitude + "," + longitude
        let distance  = "1000"
    
        
        //places URL parameters
        let URLParams : [String : AnyObject?] = ["type" : "place",
                                                 "q" : "",
                                                 "center" : center,
                                                 "distance" : distance,
                                                 "limit" : "1000",
                                                 "fields" : "id",
                                                 "access_token" : accessToken]
        
        
        let http = HTTP()
        let requestForPlaces = http.requestsForURL("https://graph.facebook.com/v2.5/search", withParameters: URLParams)
    
        guard let request = requestForPlaces else {
            return
        }
        
        http.test(request) { (json) in
            
            self.allVenues = []
            //TODO: do something
            
            if let json = json, let data = json["data"] as? [[String: AnyObject]] {
                for dataEntry in data {
                    if let id = dataEntry["id"] as? String {
                        let tempVenue = Venue(id: id)
                        self.allVenues.append(tempVenue)
                    }
                }
            }
            
            //remove this method
            self.eventsTableView.reloadData()
            
            
            //check if allVenues is not empty and make a new call for Events with Venue ID's as parameter
            //call httpRequestforURL with new url,
            
        }
        
        //events URL parameters
        
        let currentTimestamp = "\(NSDate().timeIntervalSince1970 * 1000)"
        print (currentTimestamp)
        
        let fields = "id,name,cover.fields(id,source),picture.type(large),location,events.fields(id,name,cover.fields(id,source),picture.type(large),description,start_time,attending_count,declined_count,maybe_count,noreply_count).since(" + currentTimestamp + ")"
        
        for venue in allVenues {
            guard let v = venue.id else {
                return
            }
            
            venueIDs.append(v)
        }
        
        
        let eventsURLParams : [String : AnyObject?] = ["ids" : venueIDs,
                                                       "fields" : fields ,
                                                       "access_token" : accessToken]
        
        let requestForEvents = http.requestsForURL("https://graph.facebook.com/v2.5/", withParameters: eventsURLParams)
        
        guard let request1 = requestForEvents else {
            return
        }
        
        http.test(request1) { (json) in
            
            //TODO: do something
            
            
        }
        
    }
    
    
    
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
