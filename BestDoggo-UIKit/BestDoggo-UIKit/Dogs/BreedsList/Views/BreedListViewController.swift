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

class BreedListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: BreedsListViewModel!
    var sharedAPIClientInstance = APIClient()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(BreedCollectionCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        self.viewModel = BreedsListViewModel(client: sharedAPIClientInstance)
        view.addSubview(collectionView)
        setupViews()
        self.setupDatasource()
        self.collectionView.delegate = self
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension BreedListViewController {
    
    /// CombineDataSources library:
    /// Collection View subscribes to the view model and populates
    /// cells with data when it is set in the view model
    fileprivate func setupDatasource() {
        viewModel.fullListDidChange
            .map{ Array($0.keys) }
            .subscribe(collectionView.itemsSubscriber(cellIdentifier: "cell", cellType: BreedCollectionCell.self, cellConfig: { cell, indexPath, breed in
                cell.backgroundColor = #colorLiteral(red: 0.120877615, green: 0.1208335194, blue: 0.1312041219, alpha: 1)
                let cellViewModel = BreedCellViewModel(breed: breed, client: self.sharedAPIClientInstance)
                cell.viewModel = cellViewModel
                cell.setup(with: self.viewModel.dogsFullList?[breed])
                cell.layer.cornerRadius = 25
            }))
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DogGalleryView", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "Gallery") as! DogGalleryViewController
//        vc.breed = viewModel.dogList?[indexPath.row]
        vc.breed = Array(viewModel.dogsFullList!.keys)[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
