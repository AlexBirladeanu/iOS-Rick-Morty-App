//
//  TabBarViewController.swift
//  RickandMorty
//
//  Created by Alex Bîrlădeanu on 09.12.2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let charactersVC = CharactersViewController(interactor: DIContainer.shared.charactersInteractor)
        let episodesVC = EpisodesViewController(interactor: DIContainer.shared.episodesInteractor)
                
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: episodesVC)
        self.tabBar.tintColor = .systemGreen
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav1.navigationBar.tintColor = .systemGreen
        nav2.navigationBar.tintColor = .systemGreen
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "movieclapper"), tag: 2)
        
        setViewControllers([nav1, nav2], animated: true)
    }
}
