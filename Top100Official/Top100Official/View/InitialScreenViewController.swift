//
//  InitialScreenViewController.swift
//  Top100Official
//
//  Created by Consultant on 5/20/22.
//

import UIKit

class InitialScreenViewController: UIViewController {
    
    lazy var tabMenuControl: UITabBarController = {
        let tabmenu = UITabBarController()
        tabmenu.tabBar.tintColor = UIColor.colorFromHex("FFFFFF")
        return tabmenu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabMenuUI()
    }
    
    
    private func setupTabMenuUI() {
        createTabBarController()
    }
    
    private func createTabBarController(){
        
        let firstVc = AlbumTableViewController(viewModel: AlbumScreenTableViewModel())
        firstVc.title = "Top 100 Albums This Week!!!"
        firstVc.tabBarItem = UITabBarItem.init(title: "Top 100", image: UIImage(systemName: "bell"), tag: 0)
        
        
        let secondVc =  FavoriteAlbumViewController()
        secondVc.title = "Favorite Albums"
        secondVc.tabBarItem = UITabBarItem.init(title: "Favorite", image: UIImage(systemName: "star"), tag: 0)
        
        let controllerArray = [firstVc, secondVc]
        self.tabMenuControl.viewControllers = controllerArray.map{UINavigationController.init(rootViewController: $0)}
        
        let attrNavbar = [
          NSAttributedString.Key.font: UIFont(name: "Noteworthy", size: 17)!
        ]

        UINavigationBar.appearance().titleTextAttributes = attrNavbar
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Noteworthy", size: 10)!], for: .normal)
        
        self.view.addSubview(self.tabMenuControl.view)
    }
}


