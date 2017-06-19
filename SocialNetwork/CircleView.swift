//
//  CircleView.swift
//  SocialNetwork
//
//  Created by New on 6/18/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

class CircleView: UIImageView {


    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
    }



}
