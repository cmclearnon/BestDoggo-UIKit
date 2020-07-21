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
    var baseURL = "https://complianz.io/wp-content/uploads/2019/03/placeholder-300x202.jpg"
    var subscribers = Set<AnyCancellable>()
    var viewModel: BreedCellViewModel! {
        didSet {
            nameLabel.text = viewModel.breed.capitalizingFirstLetter()
        }
    }
    
    var imageURL: String! {
        didSet {
            print("URL HAS BEEN SET")
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
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3450980392, alpha: 0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        nameLabel.text = ""
    }
    
    func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(cellImage)

        cellImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cellImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellImage.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -20).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
//        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor, constant: -10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
    }
    
    func setup() {
        print("Setup")
        viewModel.didChange.sink(receiveValue: { value in
            self.imageURL = value
            print("Setting URL")
        }).store(in: &subscribers)
    }
}
