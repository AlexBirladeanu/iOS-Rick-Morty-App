//
//  ViewController.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import UIKit

class CharactersViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.sizeToFit()
        searchBar.placeholder = "Search characters"
        searchBar.backgroundColor = .systemBackground
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.startAnimating()
        return indicator
    }()
    
    private let interactor: CharactersInteractor!
    private var characters: [Character] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var unchangedCharacters = [Character]()
    private var nextUrl: String?
    
    init(interactor: CharactersInteractor) {
        self.interactor = interactor
        self.characters = []
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        fatalError("Use `init(coder:interactor:)` to instantiate a `CharactersViewController` instance.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:interactor:)` to instantiate a `CharactersViewController` instance.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters"
        self.view.backgroundColor = .systemBackground
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupSubviews()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        fetchCharacters()
    }
}

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = characters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = character.name
        content.secondaryText = character.species
        
        Task {
            content.image = try await interactor.downloadImage(urlString: character.image)
            content.imageProperties.maximumSize = CGSizeMake(200, 200)
            content.imageProperties.cornerRadius = 10
            DispatchQueue.main.async {
                cell.contentConfiguration = content
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        navigateToCharacterDetails(character: characters[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (nextUrl != nil && indexPath.row == unchangedCharacters.count - 1) {
            showIndicator()
            fetchNextCharacters()
        }
    }
}

extension CharactersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            characters = unchangedCharacters
        } else {
            characters = unchangedCharacters.filter({ character in
                character.name.lowercased().contains(searchText.lowercased())
            })
        }
        tableView.reloadData()
    }
}

extension CharactersViewController {
    
    private func navigateToCharacterDetails(character: Character) {
        let detailsVC = DetailsViewController(character: character, interactor: DIContainer.shared.detailsInteractor)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension CharactersViewController {
    
    private func setupSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
    
    private func showIndicator() {
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                indicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                indicator.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    private func hideIndicator() {
        indicator.removeFromSuperview()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension CharactersViewController {
    
    private func fetchCharacters() {
        Task {
            do {
                let response =  try await interactor.getFirstCharacters()
                characters = response.results
                unchangedCharacters = response.results
                nextUrl = response.info.next
            } catch {
                print("Error fetching characters: \(error)")
            }
        }
    }
    
    private func fetchNextCharacters() {
        guard let url = nextUrl else { return }
        Task {
            let nextResponse = try await interactor.getNextCharacters(urlString: url)
            nextUrl = nextResponse.info.next
            unchangedCharacters.append(contentsOf: nextResponse.results)
            characters = unchangedCharacters
            hideIndicator()
        }
    }
}

