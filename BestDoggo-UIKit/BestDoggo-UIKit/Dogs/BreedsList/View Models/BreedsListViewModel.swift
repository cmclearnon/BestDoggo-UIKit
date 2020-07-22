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
    
    @Published var dogsFullList: [Breed]? {
        didSet {
            fullListDidChange.send(dogsFullList ?? [])
        }
    }

    let didChange = PassthroughSubject<[String], Never>()
    let fullListDidChange = PassthroughSubject<[Breed], Never>()
    
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
                    self.fetchSingleImageURLs()
            }).store(in: &disposables)
    }
    
    func fetchSingleImageURLs() {
        fetch(completionHandler: { (newList, err)  in
            guard let fullList = newList else {
                self.dogsFullList = []
                return
            }
            self.dogsFullList = fullList
        })
    }
    
    /// Asynchronous loop for fetching single image URL for each breed
    /// Creates full [Breed] list for breeds and their image URLs
    func fetch(completionHandler: @escaping ([Breed]?, Error?) -> Void) {
        var list: [Breed] = []
        
        /// Worker group synchronising for calling completionHandler after all loops have finished
        let group = DispatchGroup()
        for dog in self.dogList! {
            group.enter()
            self.client.getSingleDogImageURL(for: dog)
                .mapError({ (error) -> APIError in
                    return .network(description: "Error fetching dog image URL from API")
                })
                .map(\.message)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] value in
                    guard self != nil else { return }
                    switch value {
                    case .failure:
                        let newBreed = Breed(name: dog, imageURL: URL(string: NetworkConstants.placeholderURL))
                        list.append(newBreed)
                        group.leave()
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] url in
                    guard self != nil else { return }
                    if let fullURL = URL(string: url) {
                        let newBreed = Breed(name: dog, imageURL: fullURL)
                        list.append(newBreed)
                    } else {
                        let newBreed = Breed(name: dog, imageURL: URL(string: NetworkConstants.placeholderURL))
                        list.append(newBreed)
                    }
                    group.leave()
                }).store(in: &disposables)
        }
        /// Notify main thread that group workers are finished to call completionHandler
        group.notify(queue: .main) {
            completionHandler(list, nil)
        }
    }
}
