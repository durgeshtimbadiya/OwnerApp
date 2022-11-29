//
//  TableViewExtension.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

// Adding refresh control with closure support
private var closureKey: Void?
extension UITableView {
    func addRefreshControl(completionBlock: @escaping () -> Void) -> UIRefreshControl {
        _refreshClosure = completionBlock
        let refresh = UIRefreshControl()
        refresh.tintColor = AppColor.Color_TopHeader
        refresh.addTarget(nil, action: #selector(pullToRefreshedEvent), for: .valueChanged)
        addSubview(refresh)
        return refresh
    }

    private var _refreshClosure: () -> Void {
        get {
            return objc_getAssociatedObject(self, &closureKey) as! () -> Void
        }
        set {
            objc_setAssociatedObject(self, &closureKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc private func pullToRefreshedEvent() {
        _refreshClosure()
    }

    func setEmptyMessage(_ message: String, CustomLabel: UILabel? = nil) {
        if let lbl = CustomLabel {
            backgroundView = lbl
            separatorStyle = .none
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = .black
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "Montserrat-Regular", size: 17)
            messageLabel.sizeToFit()
            messageLabel.textColor = AppColor.Color_TopHeader
            backgroundView = messageLabel
            separatorStyle = .none
        }
    }

    func restore() {
        backgroundView = nil
        separatorStyle = .none
    }
}

extension UICollectionView {
    func setEmptyMessage(_ message: String, textcolor: UIColor = AppColor.Color_TopHeader) {
        let messageLabel = UILabel(frame: CGRect(x: 20, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = textcolor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Montserrat-Regular", size: 17)
        messageLabel.sizeToFit()

        backgroundView = messageLabel
        layoutIfNeeded()
    }

    func restore() {
        backgroundView = nil
        layoutIfNeeded()
    }
}
