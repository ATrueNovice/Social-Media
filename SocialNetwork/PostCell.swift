//
//  PostCell.swift
//  SocialNetwork
//
//  Created by New on 6/18/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

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
    
    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        

    }


}
