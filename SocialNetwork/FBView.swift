//
//  FBView.swift
//  SocialNetwork
//
//  Created by New on 5/22/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

class FBView: UIView {

    override func awakeFromNib() {
        super .awakeFromNib()

        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 5.0

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = self.frame.width / 2
    }
}
