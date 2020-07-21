//
//  BreedListCollectionViewCell.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 20/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import UIKit
import Combine
import Nuke

class BreedCollectionCell: UICollectionViewCell {
    var subscribers = Set<AnyCancellable>()
    var viewModel: BreedCellViewModel! {
        didSet {
            nameLabel.text = viewModel.breed.capitalizingFirstLetter()
        }
    }
    
    /// Once imageURL is assigned a value load image into the cell
    var imageURL: String! {
        didSet {
            Nuke.loadImage(with: URL(string: imageURL)!, into: self.cellImage)
        }
    }
    
    let cellImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        cellImage.image = nil
    }
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(cellImage)

        cellImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cellImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellImage.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -20).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    func setup(with value: String?) {
        /// Validate that the imageURL string is not nil
        /// If so then use placeholderURL
//        viewModel.didChange.sink(receiveValue: { value in
//            if let url = value {
//                self.imageURL = url
//            } else {
//                self.imageURL = NetworkConstants.placeholderURL
//            }
//        }).store(in: &subscribers)
        if let url = value {
            self.imageURL = url
        } else {
            self.imageURL = NetworkConstants.placeholderURL
        }
    }
}
