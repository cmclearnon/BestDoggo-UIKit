//
//  Models.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 17/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation

struct Breed: Codable {
    let name: String?
    let imageURL: URL?
}

struct DogGallery: Codable {
    let name: String?
    let imageURLList: [URL?]?
}
