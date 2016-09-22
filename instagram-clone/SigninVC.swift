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
import SwiftKeychainWrapper

class SigninVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let _ = KeychainWrapper.stringForKey(KEY_UID) {
            self.performSegue(withIdentifier: "goToFeed", sender: self)
        }
    }
    
    @IBAction func emailButtonDidTouch (_ sender: AnyObject) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in
                if err == nil {
                    print("✅ SLAVIK: success with Firebase auth")
                    if let user = user {
                        let userData = ["provider" : user.providerID]
                        self.completeLogin(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, err) in
                        if err != nil {
                            print("🚨 SLAVIK: \(err.debugDescription)")
                        } else {
                            print("✅ SLAVIK: success with Facebook auth")
                            
                            if let user = user {
                                let userData = ["provider" : user.providerID]
                                self.completeLogin(id: user.uid, userData: userData)
                            }
                        }
                    })
                }
            })
        }
    }
    
    
    func completeLogin(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseUser(uid: id, userData: userData)
        let keychain = KeychainWrapper.defaultKeychainWrapper().setString(id, forKey: KEY_UID)
        print(keychain)
        performSegue(withIdentifier: "goToFeed", sender: self)
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
                
                if let user = user {
                    let userData = ["provider" : credential.provider]
                    self.completeLogin(id: user.uid, userData: userData)
                }
            })
        }
    }
}

