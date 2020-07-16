//
//  APIError.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation

enum APIError: Error {
    case parsing(description: String)
    case network(description: String)
}
