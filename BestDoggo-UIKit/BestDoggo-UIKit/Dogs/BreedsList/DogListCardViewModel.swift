//
//  DogListCardViewModel.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation
import Combine

class DogListCardViewModel: ObservableObject {
    @Published var urlList: [String] = []
    @Published var isLoading: Bool = false
    
    private let client: APIClient
    
    var breed: String
    
    var urlTask: AnyCancellable?
    
    init(breed: String, client: APIClient, scheduler: DispatchQueue = DispatchQueue(label: "DogListCardViewModel")) {
        self.client = client
        self.breed = breed
        fetchURLList()
    }
    
    func fetchURLList() {
        isLoading = true
        urlTask = client.getRandomImageURLs(for: breed, amount: 1)
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
                        self.urlList = []
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] urls in
                    guard let self = self else { return }
                    self.urlList = urls
                    self.isLoading = false
            })
    }
}
