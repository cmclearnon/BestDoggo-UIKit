//
//  DogGalleryViewModel.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation
import Combine

class DogGalleryViewModel: ObservableObject {
    @Published var imageURLList: [[String]] = []
    @Published var breed: String
    @Published var isLoading: Bool = false
    
    private let client: APIClient
    
    private var urlTask: AnyCancellable?
    
    init(breed: String, client: APIClient) {
        self.client = client
        self.breed = breed
        fetchImageURLs()
    }
    
    func fetchImageURLs() {
        isLoading = true
        urlTask = client.getRandomImageURLs(for: breed, amount: 10)
            .mapError({ (error) -> APIError in
                return .network(description: "Error fetching image URL")
            })
            .map(\.message)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        self.imageURLList = []
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] urls in
                    guard let self = self else { return }
                    self.imageURLList = urls.clump(by: 2)
                    self.isLoading = false
            })
    }
}
