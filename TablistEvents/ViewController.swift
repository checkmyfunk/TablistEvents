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
        
        
        if (FBSDKAccessToken.current() == nil){
            let loginButton : FBSDKLoginButton = FBSDKLoginButton()
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "email", "user_friends", "user_events"]
            
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if (FBSDKAccessToken.current() != nil){
            // User is already logged in, do work such as go to next view controller.
            self.performSegue(withIdentifier: "showListOfEvents", sender: self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Facebook login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error == nil {
            print("Login complete")
            self.performSegue(withIdentifier: "showListOfEvents", sender: self)
            self.returnUserData()
        } else {
            print(error.localizedDescription)
        }
    }
    
    
    //Facebook logout
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User logged out")
    }
    
    //Get user information
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            } else {
                print("fetched user: \(result)")
                let userName : NSString = result.value(forKey: "name") as! NSString
                print("User Name is: \(userName)")
            }
        })
    }

}

