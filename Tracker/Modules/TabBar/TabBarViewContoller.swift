//
//  TabBarViewContoller.swift
//  Tracker
//
//  Created by Тихтей  Павел on 10.04.2023.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trackersViewController = TrackersViewController()
        let statisticViewController = StatisticViewController()
        
        trackersViewController.tabBarItem = UITabBarItem(title: "Трекеры",
                                                         image: UIImage(named: "tabBarTrackers"),
                                                         selectedImage: nil)
        statisticViewController.tabBarItem = UITabBarItem(title: "Статистика",
                                                          image: UIImage(named: "tabBarStatistic"),
                                                          selectedImage: nil)
        self.setViewControllers([trackersViewController, statisticViewController], animated: false)
        tabBar.tintColor = UIColor(red: 0.216, green: 0.447, blue: 0.906, alpha: 1)
        tabBar.layer.borderWidth = 0.2
        tabBar.layer.backgroundColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
