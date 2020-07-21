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
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(DogGalleryCell.self, forCellWithReuseIdentifier: "cell")
        cv.collectionViewLayout = layout
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewModel = DogGalleryViewModel(breed: breed, client: APIClient())
        setupViews()
        setupDataSource()
        self.collectionView.delegate = self
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DogGalleryViewController {
    func setupDataSource() {
        viewModel.didChange
            .map{ $0 }
            .subscribe(collectionView.itemsSubscriber(cellIdentifier: "cell", cellType: DogGalleryCell.self, cellConfig: { cell, indexPath, imageURL in
                cell.backgroundColor = #colorLiteral(red: 0.120877615, green: 0.1208335194, blue: 0.1312041219, alpha: 1)
                cell.layer.cornerRadius = 25
                
                if let url = imageURL {
                    cell.imageURL = url
                } else {
                    cell.imageURL = "https://complianz.io/wp-content/uploads/2019/03/placeholder-300x202.jpg"
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
