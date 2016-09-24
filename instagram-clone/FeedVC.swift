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
    @IBOutlet weak var selectedImageImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
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

    @IBAction func selectImageButtonDidTouch (_sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signoutButtonDidTouch (_ sender: AnyObject) {
        let keychainResults = KeychainWrapper.removeObjectForKey(KEY_UID)
        print(keychainResults)
        try!  FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonDidTouch (_ sender: AnyObject) {
        
        guard let caption = captionTextField.text, caption.characters.count > 0 else {
            print("the caption field is empty")
            return
        }
        
        guard let image = selectedImageImageView.image, imageSelected == true else {
            print("user did not select any image")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(image, 0.2) {
            
            let imageUniqueID = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.STORAGE_POST_IMAGES.child(imageUniqueID).put(imageData, metadata: metadata, completion: { (metadata, err) in
                
                guard err == nil else {
                    print(err.debugDescription)
                    return
                }
                
                self.imageSelected = false
                let downloadURL = metadata?.downloadURL()?.absoluteString
                
            })
        }
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
        
        let post = self.posts[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        guard let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) else {
            cell.configureUI(postData: post)
            return cell
        }
        
        cell.configureUI(postData: post, img: image)

        return cell
    }
}

extension FeedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            print("Invalid image selected")
            return
        }
        
        self.selectedImageImageView.image = image
        imageSelected = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

