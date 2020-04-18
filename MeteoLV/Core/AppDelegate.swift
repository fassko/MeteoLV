//
//  AppDelegate.swift
//  MeteoLV
//
//  Created by Kristaps Grinbergs on 18/02/2018.
//  Copyright © 2018 fassko. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var mapCoordinator: MapViewCooordinator?
  var favoritesCoordinator: FavoritesViewCoordinator?
  var listCoordinator: ListCoordinator?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let mapNavigationController = UINavigationController()
    mapCoordinator = MapViewCooordinator(navigationController: mapNavigationController)
    mapCoordinator?.start()
    let mapTabBarItem = UITabBarItem(title: "Map".localized, image: UIImage(named: "map"), tag: 0)
    mapTabBarItem.accessibilityLabel = "Map"
    mapNavigationController.tabBarItem = mapTabBarItem
    
    let favoritesNavigationController = UINavigationController()
    favoritesCoordinator = FavoritesViewCoordinator(navigationController: favoritesNavigationController)
    favoritesCoordinator?.start()
    let favoritesTabBarItem = UITabBarItem(title: "Favorites".localized, image: UIImage(named: "favorites"), tag: 0)
    favoritesTabBarItem.accessibilityLabel = "Favorites"
    favoritesNavigationController.tabBarItem = favoritesTabBarItem
    
    let listNavigationController = UINavigationController()
    listCoordinator = ListCoordinator(navigationController: listNavigationController)
    listCoordinator?.start()
    let listTabBarItem = UITabBarItem(title: "List".localized, image: UIImage(named: "list"), tag: 0)
    listTabBarItem.accessibilityLabel = "List"
    listNavigationController.tabBarItem = listTabBarItem
    
    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [mapNavigationController,
                                        favoritesNavigationController,
                                        listNavigationController]
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()
    
    return true
  }
}
