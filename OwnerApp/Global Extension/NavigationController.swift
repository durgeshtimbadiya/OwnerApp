//
//  NavigationController.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

class NavigationController: InteractiveNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
        isNavigationBarHidden = true
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = false
        }
        navigationBar.barTintColor = .appDefaultColor
        navigationBar.backgroundColor = .appDefaultColor

//        navigationBar.titleTextAttributes = [NSAttributedString.Key.font : (AppFont.roboto.with(weight: .bold, size: 17))!, NSAttributedString.Key.foregroundColor : UIColor.white]
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

public extension UINavigationController {
    func pushViewController(viewController: UIViewController,
                            animated: Bool,
                            completion: (() -> Void)?)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }

    func popViewController(animated: Bool,
                           completion: (() -> Void)?)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}
