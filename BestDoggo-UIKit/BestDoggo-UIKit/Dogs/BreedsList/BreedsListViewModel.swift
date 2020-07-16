//
//  BreedsListViewModel.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation
import Combine

class BreedsListViewModel: ObservableObject, Identifiable {
    @Published var dogList: [String] = []
    
    private let client: APIClient
    
    /// A collection of network requests
    /// Keeping these references allows for network requests to remain alive
    private var disposables = Set<AnyCancellable>()
    
    init(client: APIClient, scheduler: DispatchQueue = DispatchQueue(label: "BreedsListViewModel")) {
        self.client = client
        fetchDogBreeds()
    }
    
    func fetchDogBreeds() {
        client.listAllBreeds()
            .mapError({ (error) -> APIError in
                return .network(description: "Error fetching breed list")
            })
            .map(\.message.keys)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        self.dogList = []
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] dogs in
                    guard let self = self else { return }
                    self.dogList = Array(dogs)
            }).store(in: &disposables)
    }
}
