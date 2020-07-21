//
//  APIClient.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation
import Combine

protocol APICallable {
    func listAllBreeds() -> AnyPublisher<DogBreedListResp, APIError>
    func getSingleDogImageURL(for breed: String) -> AnyPublisher<DogImageResp<String>, APIError>
    func getRandomImageURLs(for breed: String, amount: Int) -> AnyPublisher<DogImageResp<[String]>, APIError>
}

class APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension APIClient: APICallable {
    func listAllBreeds() -> AnyPublisher<DogBreedListResp, APIError> {
        return fetch(with: getAllBreedsURL())
    }
    
    func getSingleDogImageURL(for breed: String) -> AnyPublisher<DogImageResp<String>, APIError> {
        return fetch(with: getSingleRandomImageURL(of: breed))
    }
    
    func getRandomImageURLs(for breed: String, amount: Int) -> AnyPublisher<DogImageResp<[String]>, APIError> {
        return fetch(with: getRandomImagesURL(of: breed, amount: amount))
    }
    
    private func fetch<T: Decodable>(with endpoint: URL?) -> AnyPublisher<T, APIError> {
        
        /// Try to safely cast the passed in URL
        /// If fails: Return a network error as a Fail type, then erase its type to AnyPublisher
        guard let url = endpoint else {
            let error = APIError.network(description: "Bad URL formatting")
            return Fail(error: error).eraseToAnyPublisher()
        }

        /// URLSession.dataTaskPublisher for fetching Dog API data
        /// Returns either tuple (Data, URLResponse) or URLError
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            /// Cast error as APIError
            .mapError { error -> APIError in
                return .network(description: "Network error: Please check internet connection")
            }.flatMap(maxPublishers: .max(1)) { result in
                decode(result.data)
            }

            /// Use eraseToAnyPublisher to erase the return type to AnyPublisher
            /// to prevent leak of implementation details
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

/// Construction of different Dog API endpoint URLs
private extension APIClient {
    private struct Domains {
        static let baseURL = "https://dog.ceo"
    }

    private struct Routes {
        static let listAllBreeds = "/api/breeds/list/all"
        static let selectedBreed = "/api/breed/"
        static let randomImages = "/images/random"
    }

    func getAllBreedsURL() -> URL? {
        let urlString = Domains.baseURL + Routes.listAllBreeds
        let fullURL = URL(string: urlString)
        return fullURL
    }
    
    func getSingleRandomImageURL(of breed: String) -> URL? {
        let urlString = Domains.baseURL
                        + Routes.selectedBreed
                        + breed
                        + Routes.randomImages
        let fullURL = URL(string: urlString)
        return fullURL
    }

    func getRandomImagesURL(of breed: String, amount: Int) -> URL? {
        let urlString = Domains.baseURL
                        + Routes.selectedBreed
                        + breed
                        + Routes.randomImages
                        + "/\(amount)"
        let fullURL = URL(string: urlString)
        return fullURL
    }
}
