//
//  FancyButton.swift
//  instagram-clone
//
//  Created by Vyacheslav Horbach on 21/09/16.
//  Copyright © 2016 Vjaceslav Horbac. All rights reserved.
//

import UIKit

class FancyButton: RoundButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        
        self.layer.cornerRadius = 2.0
    }
}
