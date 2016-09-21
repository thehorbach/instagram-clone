//
//  RoundButton.swift
//  instagram-clone
//
//  Created by Vyacheslav Horbach on 21/09/16.
//  Copyright © 2016 Vjaceslav Horbac. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        self.imageView?.contentMode = .scaleAspectFit
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.layer.frame.height / 2
    }
}
