//
//  BreedListViewController.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 20/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import Foundation
import UIKit
import Combine
import CombineDataSources
import Nuke

enum Section {
    case main
}

class BreedListViewController: UIViewController, UICollectionViewDelegate {
    
    private var viewModel: BreedsListViewModel!
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 374, height: 300)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BreedCollectionCell.self, forCellWithReuseIdentifier: "cell")
        cv.collectionViewLayout = layout
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
        self.collectionView.delegate = self
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension BreedListViewController {
    fileprivate func setupDatasource() {
        viewModel.didChange
            .map{ $0 }
            .subscribe(collectionView.itemsSubscriber(cellIdentifier: "cell", cellType: BreedCollectionCell.self, cellConfig: { cell, indexPath, breed in
                cell.backgroundColor = #colorLiteral(red: 0.120877615, green: 0.1208335194, blue: 0.1312041219, alpha: 1)
                let cellViewModel = BreedCellViewModel(breed: breed, client: APIClient())
                cell.viewModel = cellViewModel
                cell.setup()
                cell.layer.cornerRadius = 25
            }))
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DogGalleryView", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "Gallery") as! DogGalleryViewController
        vc.breed = viewModel.dogList?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
