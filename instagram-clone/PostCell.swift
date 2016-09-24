//
//  PostCell.swift
//  instagram-clone
//
//  Created by Vyacheslav Horbach on 22/09/16.
//  Copyright © 2016 Vjaceslav Horbac. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureUI(postData: Post, img: UIImage? = nil) {
        self.post = postData
        self.captionTextView.text = postData.caption
        self.likesLabel.text = "\(post.likes)"
        
        if img != nil {
            self.postImageView.image = img
        } else {
            
            let imageUrl = post.imageUrl
            let ref = FIRStorage.storage().reference(forURL: imageUrl)
            ref.data(withMaxSize: 10 * 1024 * 1024, completion: { (data, err) in
                
                guard err == nil else {
                    print(err.debugDescription)
                    return
                }
                
                guard let imageData = data else {
                    print("problem with getting data")
                    return
                }
                
                guard let image = UIImage(data: imageData) else {
                    print("error converting data to Image")
                    return
                }
                
                self.postImageView.image = image
                FeedVC.imageCache.setObject(image, forKey: imageUrl as NSString)
            })
        }
    }
}
