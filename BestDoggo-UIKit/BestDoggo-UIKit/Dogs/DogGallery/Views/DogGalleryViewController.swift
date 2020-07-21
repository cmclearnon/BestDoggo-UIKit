//
//  DogGalleryViewController.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 21/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import UIKit

class DogGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: DogGalleryViewModel!
    var breed: String!
    
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
    
    fileprivate let refreshButton: UIButton = {
        let button = RoundedButton()
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(refreshPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = DogGalleryViewModel(breed: breed, client: APIClient())
        self.collectionView.delegate = self
        setupViews()
        setupDataSource()
    }
    
    @objc func refreshPressed(sender: UIButton!) {
        self.viewModel.fetchImageURLs()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(refreshButton)
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: refreshButton.topAnchor, constant: -10).isActive = true
        
        refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
                if let url = imageURL {
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
