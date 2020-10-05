//
//  DogGalleryViewController.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 21/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import UIKit
import Network

class DogGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NetworkHandlerObserver {
    
    private var viewModel: DogGalleryViewModel!
    var breed: String!
    var networkHandler = NetworkHandler.sharedInstance()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(DogGalleryCell.self, forCellWithReuseIdentifier: "cell")
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
    
    fileprivate let refreshButton: RefreshUIButton = {
        let button = RefreshUIButton()
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(refreshPressed(sender:)), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        statusDidChange(status: networkHandler.currentStatus)
        networkHandler.addObserver(observer: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = DogGalleryViewModel(breed: breed, client: APIClient())
        self.collectionView.delegate = self
        setupViews()
        setupDataSource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkHandler.removeObserver(observer: self)
    }
    
    @objc func refreshPressed(sender: UIButton!) {
        self.refreshButton.showLoading()
        self.viewModel.fetchImageURLs()
        self.refreshButton.hideLoading()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(connectionWarningMessageView)
        view.addSubview(refreshButton)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
        if status == .satisfied {
            self.viewModel.fetchImageURLs()
        }
        self.collectionView.isHidden = status == .satisfied ? false : true
        self.connectionWarningMessageView.isHidden = status == .satisfied ? true : false
    }
}

extension DogGalleryViewController {
    
    /// CombineDataSources library:
    /// Collection View subscribes to the view model and populates
    /// cells with data when it is set in the view model
    func setupDataSource() {
        viewModel.didChange
            .map{ $0 }
            .subscribe(collectionView.itemsSubscriber(cellIdentifier: "cell", cellType: DogGalleryCell.self, cellConfig: { cell, indexPath, imageURL in
                cell.backgroundColor = #colorLiteral(red: 0.120877615, green: 0.1208335194, blue: 0.1312041219, alpha: 1)
                cell.layer.cornerRadius = 25
                
                /// Validate that the imageURL string is not nil
                /// If so then use placeholderURL
                if let url = URL(string: imageURL!) {
                    cell.imageURL = url
                } else {
                    cell.imageURL = NetworkConstants.placeholderURL
                }
            }))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = 120
        return CGSize(width: collectionView.bounds.size.width / 2.2, height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20)
    }
}
