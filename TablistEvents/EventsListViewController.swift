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
    //fill out the Event class fields
}

class EventsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var eventsTableView: UITableView!
    
    var data = NSMutableData()
    var allVenues: [Venue] = []
    var venueIDs: [String] = []
    var allEvents: [Event] = []
    //facebook sets the limit of returned events to be no more than for 50 places
    let venueIDLimit = 49

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.eventsTableView.dataSource = self
        self.eventsTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
        
    }
    
    @IBAction func reload(_ sender: AnyObject) {
        self.loadData()
    }
    
    @IBAction func clear(_ sender: AnyObject) {
        self.allVenues = []
        self.eventsTableView.reloadData()
    }
    
    func loadData(){
        //venues URL parameters
        let accessToken: String = FBSDKAccessToken.current().tokenString
        let latitude  = "40.730610"
        let longitude = "-73.935242"
        let center = latitude + "," + longitude
        let distance  = "1000"
        
        //events URL parameters
        let currentTimestampString = "\(Date().timeIntervalSince1970)"
        let currentTimestamp = currentTimestampString.components(separatedBy: ".")
        let fields = "id,name,cover.fields(id,source),picture.type(large),location,events.fields(id,name,cover.fields(id,source),picture.type(large),description,start_time,attending_count,declined_count,maybe_count,noreply_count).since(" + currentTimestamp[0] + ")"
        
        for venue in allVenues {
            guard let v = venue.id else {
                return
            }
            venueIDs.append(v)
        }
        
        //venues URL components
        let URLParams : [String : AnyObject?] = ["type" : "place" as Optional<AnyObject>, "q" : "" as Optional<AnyObject>, "center" : center as Optional<AnyObject>, "distance" : distance as Optional<AnyObject>, "limit" : "1000" as Optional<AnyObject>, "fields" : "id" as Optional<AnyObject>, "access_token" : accessToken as Optional<AnyObject>]
        
        //eventsURLComponents
        let eventsURLParams : [String : AnyObject?] = ["ids" : venueIDs as Optional<AnyObject>, "fields" : fields as Optional<AnyObject>, "access_token" : accessToken as Optional<AnyObject>]
        
        let http = HTTP()
        let requestForPlaces = http.requestsForURL("https://graph.facebook.com/v2.5/search", withParameters: URLParams)
    
        guard let request = requestForPlaces else {
            return
        }
        
        http.test(request) { (json) in
            
            self.allVenues = []
            
            //need to refactor this - to many nested "if" statements
            if let json = json, let data = json["data"] as? [[String: AnyObject]] {
                for dataEntry in data {
                    if let id = dataEntry["id"] as? String {
                        if self.allVenues.count <= self.venueIDLimit {
                            let tempVenue = Venue(id: id)
                            self.allVenues.append(tempVenue)
                        }
                    }
                }
            }
            
            //remove this method
            self.eventsTableView.reloadData()
            
            
            //check if allVenues is not empty and make a new call for Events with Venue ID's as parameter
            //call httpRequestforURL with new url,
            if (!self.allVenues.isEmpty) {
                let requestForEvents = http.requestsForURL("https://graph.facebook.com/v2.5/", withParameters: eventsURLParams)
                
                guard let requestEvents = requestForEvents else {
                    return
                }
                
                http.test(requestEvents) { (json) in
                    self.allEvents = []
                    if let json = json, let data = json["data"] as? [[String: AnyObject]] {
                        for dataEntry in data {
                            if let id = dataEntry["id"] as? String {
                                //replace this parse with events parsing instead of venue parcing
                                let tempVenue = Venue(id: id)
                                self.allVenues.append(tempVenue)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allVenues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventCell
        cell.stationNameLabel.text = self.allVenues[(indexPath as NSIndexPath).row].id
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
