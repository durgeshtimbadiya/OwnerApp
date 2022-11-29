//
//  SOSVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

import CoreLocation
import UIKit

class SOSVC: UIViewController, PrLocation {
    @IBOutlet var vieMedical: UIView!
    @IBOutlet var viewFire: UIView!
    @IBOutlet var viewEmergency: UIView!
    @IBOutlet var viewTheft: UIView!
    @IBOutlet var viewSOS: UIView!
    @IBOutlet weak var lblSiteName: UILabel!

    var sos_Type = ""
    var company_iD = ""
    var site_iD = ""
    var site_Name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSiteName.text = "\(site_Name):"
        vieMedical.round(corners: .allCorners, cornerRadius: 10)
        viewFire.round(corners: .allCorners, cornerRadius: 10)
        viewEmergency.round(corners: .allCorners, cornerRadius: 10)
        viewTheft.round(corners: .allCorners, cornerRadius: 10)

        viewSOS.layer.cornerRadius = viewSOS.layer.bounds.height / 2

        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        LocationManagerSingleton.shared.delegate = self
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

    override func viewDidAppear(_: Bool) {
        super.viewDidAppear(true)
        LocationManagerSingleton.shared.StartStopUpdatingLocation(start: true)
        LocationManagerSingleton.shared.delegate = self
    }

    func GetLocation(currentLocation: CLLocationCoordinate2D) {
        let lat = currentLocation.latitude
        let long = currentLocation.longitude
        print("\(lat)")
        print("\(long)")
    }

    @IBAction func btnBackAction(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - SOS Api Api Functionality-------------------------------

    func SOSFuncApi(type: String, user_id: String, site_id: String, latitude: String, longitude: String, location: String, facility_id: String) {
        if ProjectUtilities.checkInternateAvailable(viewController: self) {
            let params = ["type": type,
                          "user_id": user_id,
                          "site_id": site_id,
                          "latitude": latitude,
                          "longitude": longitude,
                          "facility_id": facility_id,
                          "location": location] as [String: Any]

            Webservice.Authentication.SOSApi(parameter: params) { result in
                switch result {
                case let .success(response):
                    if let body = response.body as? [String: Any] {
                        if body["message"] as? String ?? "" == "Success" {
                            self.view.makeToast("SOS Submitted Successfully", duration: 0.8, position: .center)

                        } else {
                            appDelegate.ShowAlertController(message: body["message"] as? String ?? "", viewController: self)
                        }
                    }
                case let .fail(errorMsg):
                    appDelegate.ShowAlertController(message: errorMsg, viewController: self)
                    print(errorMsg)
                }
            }
        }
    }

    func AlertConfirmation(message: String, typeValue: String) {
        let alertcontroller = UIAlertController(title: "Confirmation", message: "Is there any \(message) emergency", preferredStyle: .alert)
        let yes = UIAlertAction(title: "YES", style: .default) { _ in
            self.SOSFuncApi(type: typeValue, user_id: appDelegate.userLoginAccessDetails?.id ?? "", site_id: self.site_iD, latitude: appDelegate.Lat, longitude: appDelegate.Long, location: appDelegate.Location, facility_id: self.company_iD)
        }
        let cancel = UIAlertAction(title: "NO", style: .cancel, handler: nil)

        alertcontroller.addAction(yes)
        alertcontroller.addAction(cancel)
        present(alertcontroller, animated: true)
    }

    // MARK: - SOS Action******************************

    @IBAction func btnMedicalAction(_: Any) {
        AlertConfirmation(message: "medical", typeValue: "1")
    }

    @IBAction func btnFIreAction(_: Any) {
        AlertConfirmation(message: "fire", typeValue: "2")
    }

    @IBAction func btnEmergencyAction(_: Any) {
        AlertConfirmation(message: "lift", typeValue: "3")
    }

    @IBAction func btnTheftAction(_: Any) {
        AlertConfirmation(message: "theft", typeValue: "4")
    }
}
