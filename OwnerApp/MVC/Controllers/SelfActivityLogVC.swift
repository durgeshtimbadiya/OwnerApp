//
//  SelfActivityLogVC.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

import CoreLocation
import UIKit

class SelfActivityLogVC: UIViewController, PrLocation {
    
    @IBOutlet var viewAttendanceLog: UIView!
    @IBOutlet var viewSelfieLog: UIView!
    @IBOutlet var viewSOSLog: UIView!
    @IBOutlet weak var lblSiteName: UILabel!

    var company_iDs = ""
    var site_iDs = ""
    var site_Name = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        lblSiteName.text = "\(site_Name):"
        viewAttendanceLog.dropShadowWithCornerRadius()
        viewSelfieLog.dropShadowWithCornerRadius()
        viewSOSLog.dropShadowWithCornerRadius()

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

    // MARK: - Attendance Log Action*****************

    @IBAction func btnAttendanceAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AtttendanceLogVC") as? AtttendanceLogVC {
            vc.company_iD = company_iDs
            vc.site_iD = site_iDs
            vc.site_Name = site_Name
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    // MARK: - Selfie Log Action*****************

    @IBAction func btnSelfieAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelfieLogVC") as? SelfieLogVC {
            vc.company_iD = company_iDs
            vc.site_iD = site_iDs
            vc.site_Name = site_Name
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }

    // MARK: - SOS Log Action*****************

    @IBAction func btnSOSAction(_: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SOSLogVC") as? SOSLogVC {
            vc.company_iD = company_iDs
            vc.site_iD = site_iDs
            vc.site_Name = site_Name
//            navigationController?.pushViewController(vc, animated: true)
            Functions.pushToViewController(self, toVC: vc)
        }
    }
}
