//
//  DataService.swift
//  instagram-clone
//
//  Created by Vyacheslav Horbach on 22/09/16.
//  Copyright © 2016 Vjaceslav Horbac. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DS_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //Storage references
    private var _STORAGE_POST_IMAGES = STORAGE_BASE.child("images")
    
    //DB references
    private var _REF_BASE = DS_BASE
    private var _REF_POST = DS_BASE.child("posts")
    private var _REF_USER = DS_BASE.child("users")
    
    var STORAGE_POST_IMAGES: FIRStorageReference {
        return _STORAGE_POST_IMAGES
    }
    
    var REF_BASE: FIRDatabaseReference {
        return  _REF_BASE
    }
    
    var REF_POST: FIRDatabaseReference {
        return _REF_POST
    }
    
    var REF_USER: FIRDatabaseReference {
        return _REF_USER
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.stringForKey(KEY_UID)
        let user = REF_USER.child(uid!)
        return user
    }
    
    func createFirebaseUser(uid: String, userData: Dictionary<String, String>) {
        REF_USER.child(uid).updateChildValues(userData)
    }
}
