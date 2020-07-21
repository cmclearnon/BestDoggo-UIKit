//
//  BreedListCollectionViewCellViewModel.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 20/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation
import Combine

class BreedCellViewModel {
    @Published var urlString: String? {
        didSet {
            didChange.send(urlString ?? "")
        }
    }
    @Published var isLoading: Bool = false
    var didChange = PassthroughSubject<String?, Never>()

    var breed: String
    private let client: APIClient
    private var subscribers = Set<AnyCancellable>()
    
    init(breed: String, client: APIClient, scheduler: DispatchQueue = DispatchQueue(label: "BreedCellViewModelThread")) {
        self.client = client
        self.breed = breed
        fetchURLList()
    }
    
    func fetchURLList() {
        isLoading = true
        client.getSingleDogImageURL(for: breed)
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
            }).store(in: &subscribers)
    }
    
    deinit {
        for subscriber in subscribers {
            subscriber.cancel()
        }
    }
}
