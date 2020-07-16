//
//  String+Capitalisation.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
