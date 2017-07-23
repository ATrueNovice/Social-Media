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
    @IBOutlet weak var likeImg: UIImageView!



    var post: Post!

    var likesRef: FIRDatabaseReference!


    override func awakeFromNib() {
        super.awakeFromNib()

        //This is a gesture recognizer written programatically. This allows users to tap the heart to show that they liked it. It is done like this because any repetition in MainStoryboard Tap Gestures break with repetition.

        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true

    }


    //configures data we will put in the cell. This is called in the cellForRowAt function.
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesRef = Dataservice.ds.REF_USER_CURRENT.child("likes").child(post.postkey)
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



        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }

        func likeTapped(sender: UITapGestureRecognizer) {
            //Sends likes to Firebase and then ObserveSingle Event listens for any changes.

            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in

                //Since we are working with JSON it is NSNUll not "nill"
                if let _  = snapshot.value as? NSNull {

                    //Since no one has liked the post, we use the default name of the image. NOTE there are two different images. Empty and full heart. This image changes depending on if the item is liked or not.

                    self.likeImg.image = UIImage(named: "filled-heart")
                    self.post.adjustLikes(addLike: true)
                    self.likesRef.setValue(true) //Adds another value to the user DB in firebase, linking the like to the user.
                } else {
                    self.likeImg.image = UIImage(named: "empty-heart")
                    self.post.adjustLikes(addLike: false)
                    self.likesRef.removeValue()
                }
            })


        }

    }
