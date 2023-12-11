//
//  EpisodesViewController.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.startAnimating()
        return indicator
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.sizeToFit()
        searchBar.placeholder = "Search episodes"
        searchBar.backgroundColor = .systemBackground
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var interactor: EpisodesInteractor
    private var nextUrl: String?
    private var selectedEpisode: (indexPath: IndexPath, characters: [Character])?
    private var episodes = [Episode]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var unchangedEpisodes = [Episode]()
    
    init(interactor: EpisodesInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        fatalError("Use `init(coder:interactor:)` to instantiate a `EpisodesViewController` instance.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use `init(coder:interactor:)` to instantiate a `EpisodesViewController` instance.")
    }
}

extension EpisodesViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Episodes"
        view.backgroundColor = .systemBackground
        fetchFirstEpisodes()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    override func viewDidLayoutSubviews() {
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
}

extension EpisodesViewController {
    
    private func fetchFirstEpisodes() {
        Task {
            do {
                let response = try await interactor.getFirstEpisodes()
                nextUrl = response.info.next
                episodes = response.results
                unchangedEpisodes = episodes
            } catch {
                print("Error fetching episodes: \(error)")
            }
        }
    }
    
    private func fetchNextEpisodes() {
        guard let next = nextUrl else { return }
        Task {
            do {
                let response = try await interactor.getNextEpisodes(url: next)
                nextUrl = response.info.next
                unchangedEpisodes.append(contentsOf: response.results)
                episodes = unchangedEpisodes
                hideIndicator()
            } catch {
                print("Error fetching episodes: \(error)")
            }
        }
    }
}

extension EpisodesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let episode = episodes[indexPath.row]
        content.text = episode.episode
        content.textProperties.color = .systemGray
        content.secondaryText = episode.name
        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 16)
        content.image = UIImage(systemName: "chevron.right")
        content.imageProperties.tintColor = .systemGray
        cell.contentConfiguration = content
        return cell
    }
}

extension EpisodesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        let episodeDetailsVC = EpisodeDetailsViewController(episode: episode, interactor: DIContainer.shared.episodeDetailsInteractor)
        navigationController?.pushViewController(episodeDetailsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (nextUrl != nil && indexPath.row == unchangedEpisodes.count - 1) {
            showIndicator()
            fetchNextEpisodes()
        }
    }
}

extension EpisodesViewController {
    
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

extension EpisodesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            episodes = unchangedEpisodes
        } else {
            episodes = unchangedEpisodes.filter({ episode in
                (episode.episode ?? "").lowercased().contains(searchText.lowercased())
            })
        }
    }
}
