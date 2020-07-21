//
//  Responses.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation

struct DogBreedListResp: Decodable, Hashable {
    let status: String
    let message: [String: [String]]
}

struct DogImageResp<T: Decodable>: Decodable {
    let status: String
    let message: T
}
