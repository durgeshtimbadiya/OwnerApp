//
//  GPSLocationVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

import CoreLocation
import UIKit

class GPSLocationVC: UIViewController, PrLocation {
    @IBOutlet var btnturnGPS: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        btnturnGPS.dropShadowWithCornerRadius()
    }

    override func viewWillAppear(_: Bool) {
        super.viewWillAppear(true)

        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            let statusbarView = UIView()
            statusbarView.backgroundColor = AppColor.Color_TopHeader
            view.addSubview(statusbarView)

            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true

        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = AppColor.Color_TopHeader
        }
    }

    @IBAction func btnTurnOnGPSAction(_: UIButton) {
        navigationController?.popViewController(animated: true, completion: {
            LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
            LocationManagerSingleton.shared.delegate = self
//            self.openSettingApp(message: "Please enable location and provide location permission")
        })
    }

    func GetLocation(currentLocation: CLLocationCoordinate2D) {
        print(currentLocation)
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        print("\(lat)")
        print("\(long)")
    }
}
