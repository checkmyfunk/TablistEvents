//
//  ViewController.swift
//  TablistEvents
//
//  Created by Vitali Potchekin on 7/1/16.
//  Copyright © 2016 Vitali Potchekin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (FBSDKAccessToken.currentAccessToken() == nil){
            let loginButton : FBSDKLoginButton = FBSDKLoginButton()
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "email", "user_friends", "user_events"]
            
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
        }
            
        
        
        
//        if (FBSDKAccessToken.currentAccessToken() == nil){
//            print("Not logged in")
//        } else {
//            print("Logged in")
//        }
//        
//        let loginButton = FBSDKLoginButton()
//        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        loginButton.center = self.view.center
//        
//        loginButton.delegate = self
//        
//        self.view.addSubview(loginButton)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (FBSDKAccessToken.currentAccessToken() != nil){
            // User is already logged in, do work such as go to next view controller.
            self.performSegueWithIdentifier("showListOfEvents", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Facebook login
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print("Login complete")
            self.performSegueWithIdentifier("showListOfEvents", sender: self)
            self.returnUserData()
        } else {
            print(error.localizedDescription)
        }
    }
    
    
    //Facebook logout
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    //Get user information
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
            }
        })
    }
    
    //api call to get list of nearby events:
    //https://graph.facebook.com/search?type=place&center=44.4325,26.1039&distance=100

}

