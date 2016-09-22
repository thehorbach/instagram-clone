//
//  DataService.swift
//  instagram-clone
//
//  Created by Vyacheslav Horbach on 22/09/16.
//  Copyright © 2016 Vjaceslav Horbac. All rights reserved.
//

import Foundation
import Firebase

let DS_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DS_BASE
    private var _REF_POST = DS_BASE.child("posts")
    private var _REF_USER = DS_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return  _REF_BASE
    }
    
    var REF_POST: FIRDatabaseReference {
        return _REF_POST
    }
    
    var REF_USER: FIRDatabaseReference {
        return _REF_USER
    }
    
    func createFirebaseUser(uid: String, userData: Dictionary<String, String>) {
        REF_USER.child(uid).updateChildValues(userData)
    }
}
