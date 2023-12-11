//
//  CharacterCell.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 11.12.2023.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    
    static let identifier = "CharacterCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(image: UIImage, text: String) {
        self.imageView.image = image
        self.label.text = text
        self.setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.spacing = 4
        self.addSubview(stackView)
        stackView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
        self.label.text = nil
    }
}
