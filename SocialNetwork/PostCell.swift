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

    override func awakeFromNib() {
        super.awakeFromNib()


    }


}
