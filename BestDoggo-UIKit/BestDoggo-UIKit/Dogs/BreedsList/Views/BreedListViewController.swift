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
import Network

class BreedListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NetworkHandlerObserver {
    
    private var viewModel: BreedsListViewModel!
    var sharedAPIClientInstance = APIClient()
    var networkHandler = NetworkHandler.sharedInstance()
    
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
    
    fileprivate let connectionWarningMessageView: UILabel = {
       let lb = UILabel()
        lb.text = "Unable to load images. Please check your internet connection and try again."
        lb.sizeToFit()
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    fileprivate let refreshButton: UIButton = {
        let button = RoundedButton()
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(refreshPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func refreshPressed(sender: UIButton!) {
        self.viewModel.fetchDogBreeds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusDidChange(status: networkHandler.currentStatus)
        networkHandler.addObserver(observer: self)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkHandler.removeObserver(observer: self)
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(connectionWarningMessageView)
        view.addSubview(refreshButton)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        connectionWarningMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        connectionWarningMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        connectionWarningMessageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectionWarningMessageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func statusDidChange(status: NWPath.Status) {
        self.collectionView.isHidden = status == .satisfied ? false : true
        self.connectionWarningMessageView.isHidden = status == .satisfied ? true : false
        self.refreshButton.isHidden = status == .satisfied ? true : false
    }
}

extension BreedListViewController {
    
    /// CombineDataSources library:
    /// Collection View subscribes to the view model and populates
    /// cells with data when it is set in the view model
    fileprivate func setupDatasource() {
        viewModel.fullListDidChange
            .map{ $0 }
            .subscribe(collectionView.itemsSubscriber(cellIdentifier: "cell", cellType: BreedCollectionCell.self, cellConfig: { cell, indexPath, breed in
                cell.backgroundColor = #colorLiteral(red: 0.120877615, green: 0.1208335194, blue: 0.1312041219, alpha: 1)
                cell.nameString = breed.name?.capitalizingFirstLetter()
                cell.imageURL = breed.imageURL
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
        vc.breed = viewModel.dogsFullList?[indexPath.row].name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
