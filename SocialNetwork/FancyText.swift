//
//  FancyText.swift
//  SocialNetwork
//
//  Created by New on 5/22/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

class FancyText: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }

    //Modifies the place holder text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }


}
