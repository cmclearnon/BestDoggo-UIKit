//
//  ViewController.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 16/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import UIKit
import Combine
import CombineDataSources

enum Section {
    case main
}

class BreedsListViewController: UIViewController {
    private var viewModel: BreedsListViewModel!
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        self.viewModel = BreedsListViewModel(client: APIClient())
        view.addSubview(collectionView)
        setupViews()
        self.setupDatasource()
//
//        let _ = self.viewModel.currentVMData
//            .receive(on: RunLoop.main)
//            .sink { [weak self] (breeds) in
//                guard let `self` = self else {
//                    return
//                }
//                self.createSnapshot(breeds)
//        }
//        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: )
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .blue
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension BreedsListViewController {
    fileprivate func setupDatasource() {
//
//        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: { [weak self] (UICollectionView, indexPath, breed) -> UICollectionViewCell? in
//
//            guard let `self` = self else {
//                return UICollectionViewCell()
//            }
//
//            if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewCell {
//                return cell
//            }
//
//            return UICollectionViewCell()
//        })
        viewModel.didChange
            .map{ $0 }
            .subscribe(collectionView.itemsSubscriber(cellIdentifier: "cell", cellType: UICollectionViewCell.self, cellConfig: { cell, indexPath, breed in
                    cell.backgroundColor = .yellow
//                cell.viewModel = BreedCellViewModel(breed: breed, client: APIClient())
//                print("Breed: \(breed)")
            }))
        self.collectionView.reloadData()
    }
    
    fileprivate func createSnapshot(_ breeds: [String]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(breeds)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}


