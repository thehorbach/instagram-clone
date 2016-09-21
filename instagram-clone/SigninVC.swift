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
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func emailButtonDidTouch (_ sender: AnyObject) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
                if err == nil {
                    print("✅ SLAVIK: success with Firebase auth")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, err) in
                        if err != nil {
                            print("🚨 SLAVIK: \(err.debugDescription)")
                        } else {
                            print("✅ SLAVIK: success with Facebook auth")
                        }
                    })
                }
            })
        }
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

