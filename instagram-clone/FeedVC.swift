//
//  FeedVC.swift
//  instagram-clone
//
//  Created by Vyacheslav Horbach on 22/09/16.
//  Copyright © 2016 Vjaceslav Horbac. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POST.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            
            guard let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] else {
                print("ERROR: Parsing Firebase data as FIRDataSnapshot")
                return
            }
            
            for snap in snapshots {

                guard let postDict = snap.value as? Dictionary<String, AnyObject> else {
                    print("ERROR: Parsing Firebase data as Dictionary<String, AnyObject>")
                    return
                }
                
                let post = Post.init(postKey: snap.key, postData: postDict)
                self.posts.append(post)
            }
            
            self.tableView.reloadData()
        })
    }

    
    @IBAction func signoutButtonDidTouch (_ sender: AnyObject) {
        let keychainResults = KeychainWrapper.removeObjectForKey(KEY_UID)
        print(keychainResults)
        try!  FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }

}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        return cell
    }
}
