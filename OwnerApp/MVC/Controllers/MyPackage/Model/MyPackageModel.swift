//
//  MyPackageModel.swift
//  OwnerApp
//
//  Created by Durgesh on 17/07/23.
//

import Foundation

struct MyPackageModel {
    var upcoming_package = Int()
    var platinum_package = "5000.00"
    var gold_package = "3000.00"
    var current_package = CurrentPackageModel()
    
    init() { }
    init(_ response: [String: Any]) {
        
        upcoming_package = response["upcoming_package"] as? Int ?? 0
        platinum_package = response["platinum_package"] as? String ?? "5000.00"
        gold_package = response["gold_package"] as? String ?? "3000.00"
        
        if let currentPackage = response["current_package"] as? [String: Any] {
            current_package = CurrentPackageModel(currentPackage)
        } else if let upComPackage = response["upcoming_package"] as? [String: Any] {
            current_package = CurrentPackageModel(upComPackage)
        }
        current_package.platinum_package = platinum_package
        current_package.gold_package = gold_package
    }
}

struct CurrentPackageModel {
    var plan = "2" // 1=platinum , 2=gold
    var date_diff = 28
    var start_date = "08 Aug 2022"
    var end_date = "07 Sep 2022"
    var payable_amount = Double()
    var valid_for = 30
    var mode = "Net Banking"
    var package_name = "GOLD"
    var created_at = String()
    var amount = Double()
    var cgst = Double()
    var sgst = Double()
    var id = Int()
    var payment_id = Int()
    var reference_id = Int()
    var status = Int()
    var user_id = Int()
    var type = String()
    var platinum_package = "5000.00"
    var gold_package = "3000.00"
    
    init() { }
    init(_ response: [String: Any]) {
        plan = response["plan"] as? String ?? ""
        package_name = response["package_name"] as? String ?? ""
        if package_name.isEmpty {
            if plan == "1" {
                package_name = "platinum"
            } else if plan == "2" {
                package_name = "gold"
            }
        }
        date_diff = response["date_diff"] as? Int ?? 28
        start_date = response["start_date"] as? String ?? "08 Aug 2022"
        end_date = response["end_date"] as? String ?? "07 Sep 2022"
        payable_amount = response["payable_amount"] as? Double ?? 0.0
        valid_for = response["valid_for"] as? Int ?? 30
        mode = response["mode"] as? String ?? "Net Banking"
        created_at = response["created_at"] as? String ?? ""
        
        amount = response["amount"] as? Double ?? 0.0
        cgst = response["cgst"] as? Double ?? 0.0
        sgst = response["sgst"] as? Double ?? 0.0
        id = response["id"] as? Int ?? 0
        payment_id = response["payment_id"] as? Int ?? 0
        reference_id = response["reference_id"] as? Int ?? 0
        status = response["status"] as? Int ?? 0
        user_id = response["user_id"] as? Int ?? 0
        type = response["type"] as? String ?? ""
    }
}
