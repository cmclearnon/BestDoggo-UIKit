//
//  Parsing.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation
import Combine

/// Generic decode funtion for decoding JSON response data into
/// any codable type
func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, APIError> {
  let decoder = JSONDecoder()

  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
      .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
