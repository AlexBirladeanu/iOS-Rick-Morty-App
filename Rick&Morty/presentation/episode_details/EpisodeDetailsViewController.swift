//
//  EpisodeDetailsViewController.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 10.12.2023.
//

import UIKit

class EpisodeDetailsViewController: UIViewController {

    private let episode: Episode
    private let interactor: EpisodeDetailsInteractor
    private var featuredCharacters = [Character]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private var collectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
        return collectionView
    }()
    
    init(episode: Episode, interactor: EpisodeDetailsInteractor) {
        self.episode = episode
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        fatalError("EpisodeDetailsVC called wrong init.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("EpisodeDetailsVC called wrong init.")
    }
}

extension EpisodeDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(episode.episode ?? "")"
        view.backgroundColor = .systemBackground
        fetchData()
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
}

extension EpisodeDetailsViewController {
    
    private func fetchData() {
        guard let urls = episode.characters else { return }
        Task {
            featuredCharacters = await interactor.getFeaturedCharacters(urls: urls)
        }
    }
}

extension EpisodeDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = featuredCharacters[indexPath.row]
        let detailsVC = DetailsViewController(character: character, interactor: DIContainer.shared.detailsInteractor)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension EpisodeDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredCharacters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else { fatalError("Failed to dequeue CharacterCell in VC.") }
        let character = featuredCharacters[indexPath.row]
        Task {
            let image = try! await interactor.downloadImage(urlString: character.image)
            cell.configure(image: image, text: character.name)
        }
        return cell
    }
}

extension EpisodeDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.width * 4 / 15
        return CGSize(width: size, height: size)
    }
}
