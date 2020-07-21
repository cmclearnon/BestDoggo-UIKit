//
//  DogGalleryCell.swift
//  BestDoggo-UIKit
//
//  Created by Chris McLearnon on 21/07/2020.
//  Copyright © 2020 chrismclearnon. All rights reserved.
//

import UIKit
import Nuke

class DogGalleryCell: UICollectionViewCell {
    
    /// Once imageURL is assigned a value load image into the cell
    var imageURL: String! {
        didSet {
            Nuke.loadImage(with: URL(string: imageURL)!, into: cellImage)
        }
    }
    
    let cellImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
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
        cellImage.image = nil
    }
    
    func addSubviews() {
        contentView.addSubview(cellImage)

        cellImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cellImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cellImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
