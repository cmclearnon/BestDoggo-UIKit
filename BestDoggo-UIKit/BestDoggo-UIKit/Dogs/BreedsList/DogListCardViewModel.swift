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
    @Published var urlString: String = ""
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
        urlTask = client.getSingleDogImageURL(for: breed)
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
                        self.urlString = ""
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] url in
                    guard let self = self else { return }
                    self.urlString = url
                    self.isLoading = false
            })
    }
}
