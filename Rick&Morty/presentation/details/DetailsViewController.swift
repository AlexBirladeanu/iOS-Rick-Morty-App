//
//  DetailsViewController.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {
    
    private let character: Character
    private let interactor: DetailsInteractor
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private let speciesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    init(character: Character, interactor: DetailsInteractor) {
        self.character = character
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        fatalError("Use `init(coder:interactor:)` to instantiate a `DetailsViewController` instance.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:interactor:)` to instantiate a `DetailsViewController` instance.")
    }
}

extension DetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        scrollView.delegate = self
        fetchDetails()
        scrollView.addSubview(imageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(speciesLabel)
        scrollView.addSubview(typeLabel)
        view.addSubview(scrollView)
        setupDetailsStackViews()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(
            width: view.bounds.width,
            height: view.bounds.height
        )
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        speciesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speciesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            speciesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            speciesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 4),
            typeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupDetailsStackViews() {
        let statusCardView = makeStackView(description: "Status", value: character.status)
        let genderCardView = makeStackView(description: "Gender", value: character.gender)
        let originCardView = makeStackView(description: "Origin", value: character.origin.name)
        let locationCardView = makeStackView(description: "Last seen at", value: character.location.name)
        let mainStackView = UIStackView(arrangedSubviews: [
            DividerView(), statusCardView, DividerView(), genderCardView, DividerView(), originCardView, DividerView(),  locationCardView, DividerView()
        ])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusCardView.arrangedSubviews.first!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genderCardView.arrangedSubviews.first!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            originCardView.arrangedSubviews.first!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationCardView.arrangedSubviews.first!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    private func makeStackView(description: String, value: String) -> UIStackView {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 20)
        descriptionLabel.text = description
        
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.font = UIFont.systemFont(ofSize: 18)
        valueLabel.textColor = .systemGray
        valueLabel.text = value
        
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, valueLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension DetailsViewController{
    
    private func fetchDetails() {
        nameLabel.text = character.name
        speciesLabel.text = character.species
        typeLabel.text = character.type
        Task {
            imageView.image = try await interactor.downloadImage(urlString: character.image)
        }
    }
}
