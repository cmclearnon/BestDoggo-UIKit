//
//  RoundedButton.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 21/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        super.layoutSubviews()
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layer.cornerRadius = frame.height/2
    }

}
