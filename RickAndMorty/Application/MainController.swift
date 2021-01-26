//
//  MainControllerViewController.swift
//  RickAndMorty
//
//  Created by сергей on 21.01.2021.
//

import UIKit

class MainController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
    }
    
    private func setupTabBarController() {
        UITabBar.appearance().tintColor = .systemPink
        viewControllers = [createCharactersNavigationController(), createEpisodesNavigationController()]
    }
    
    private func createCharactersNavigationController() -> UINavigationController {
        let charactersVC = CharactersViewController()
        charactersVC.title = "Characters"
        charactersVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        return UINavigationController(rootViewController: charactersVC)
    }
    
    private func createEpisodesNavigationController() -> UINavigationController {
        let episodesVC = EpisodesViewController()
        episodesVC.title = "Episodes"
        episodesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        return UINavigationController(rootViewController: episodesVC)
    }
    
}

