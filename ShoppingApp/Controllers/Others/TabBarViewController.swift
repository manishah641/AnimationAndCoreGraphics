//
//  TabBarViewController.swift
//  ShoppingApp
//
//  Created by syed on 09/10/2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = ShoppingCartViewController()
        let vc4 = VisionViewController()
        
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Shpping Cart"
        vc4.title = "Vision"
        
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        let nav4 = UINavigationController(rootViewController: vc4)
       
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
    
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Shopping Cart", image: UIImage(systemName: "cart"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "vision", image: UIImage(systemName: "gearshape.2"), tag: 3)
        
        
        
        setViewControllers([nav1,nav2,nav3,nav4], animated: true)
        
        
    }
    



}
