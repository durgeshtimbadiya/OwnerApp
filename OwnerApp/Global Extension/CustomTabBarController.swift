//
//  CustomTabBarController.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_: Bool) {
        for item in tabBar.items! {}
    }

    override func tabBar(_: UITabBar, didSelect item: UITabBarItem) {
        print("VieController :", item.title)
    }
}
