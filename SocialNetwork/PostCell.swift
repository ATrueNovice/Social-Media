//
//  PostCell.swift
//  SocialNetwork
//
//  Created by New on 6/18/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {


    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!


    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
    }


    //configures data we will put in the cell. This is called in the cellForRowAt function.
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"


        //Image Download and Caching.
        if img != nil {
            self.postImg.image = img
        } else {
                let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
                //Max Pic Size
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in

                    if error != nil {
                        print("Note: Unable To Download Image")
                    } else {
                        print("Note: Image Downloaded.")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)

                            }
                        }
                    }

                })
            }
        }
        

    }
