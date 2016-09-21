//
//  ViewController.swift
//  instagram-clone
//
//  Created by Vyacheslav Horbach on 21/09/16.
//  Copyright © 2016 Vjaceslav Horbac. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class SigninVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func facebookButtonDidTouch (_ sender: AnyObject) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email", "user_friends", "public_profile"], from: self) { (result, err) in
            
            guard err == nil else {
                print("🚨 SLAVIK: \(err.debugDescription)")
                return
            }
            
            guard result?.isCancelled == false else {
                print("🚨 SLAVIK: user canceled")
                return
            }
            
            print("✅ SLAVIK: success with Facebook auth")
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, err) in
                
                guard err == nil else {
                    print("🚨 SLAVIK: \(err.debugDescription)")
                    return
                }
                
                print("✅ SLAVIK: success with Firebase auth")
            })
        }
    }
}

