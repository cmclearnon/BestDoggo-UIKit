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
    @Published var dogList: [String]? {
        didSet {
            didChange.send(dogList ?? [])
        }
    }

    let didChange = PassthroughSubject<[String], Never>()
    
    /// A collection of network requests
    /// Keeping these references allows for network requests to remain alive
    private var disposables = Set<AnyCancellable>()
    
    private let client: APIClient
    
    init(client: APIClient, scheduler: DispatchQueue = DispatchQueue(label: "BreedListViewModelThread")) {
        self.client = client
        self.fetchDogBreeds()
    }
    
    func fetchDogBreeds() {
        client.listAllBreeds()
            .mapError({ (error) -> APIError in
                return .network(description: "Error fetching breed list from API")
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
