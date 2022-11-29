//
//  InteractiveNavigationController.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

class InteractiveNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    // MARK: - UIGestureRecognizerDelegate Methods

    // --------------------------
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
//        if let _ = viewControllers.last as? DraftingCompletedVC {
//            return false
//        }
//
//        if(viewControllers.count > 1) {
//            return true
//        }

        return false
    }
}
