//
//  MyPackageModel.swift
//  OwnerApp
//
//  Created by Durgesh on 17/07/23.
//

import Foundation

struct MyPackageModel {
    var upcoming_package = Int()
    var platinum_package = "0.00"
    var gold_package = "0.00"
    var current_package = CurrentPackageModel()
    
    init() { }
    init(_ response: [String: Any]) {
        
        upcoming_package = response["upcoming_package"] as? Int ?? 0
        platinum_package = response["platinum_package"] as? String ?? "0.00"
        gold_package = response["gold_package"] as? String ?? "0.00"
        
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
    var start_date = ""
    var end_date = ""
    var payable_amount = Double()
    var valid_for = 30
    var mode = "Net Banking"
    var package_name = ""
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
    var platinum_package = "0.00"
    var gold_package = "0.00"
    
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
        start_date = response["start_date"] as? String ?? ""
        end_date = response["end_date"] as? String ?? ""
        if let endDate = response["end_date"] as? String {
            end_date = convertDateFormater(endDate)
        }
        if let startDate = response["start_date"] as? String {
            start_date = convertDateFormater(startDate)
        }
        payable_amount = response["payable_amount"] as? Double ?? 0.0
        valid_for = response["valid_for"] as? Int ?? 30
        mode = response["mode"] as? String ?? "Net Banking"
        created_at = response["created_at"] as? String ?? ""
        
        if let idid = response["id"] as? Double {
            amount = idid
        } else if let idid1 = response["id"] as? String {
            amount = Double(idid1) ?? 0.0
        }
        
        if let idid = response["cgst"] as? Double {
            cgst = idid
        } else if let idid1 = response["cgst"] as? String {
            cgst = Double(idid1) ?? 0.0
        }
        
        if let idid = response["sgst"] as? Double {
            sgst = idid
        } else if let idid1 = response["sgst"] as? String {
            sgst = Double(idid1) ?? 0.0
        }

        if let idid = response["id"] as? Int {
            id = idid
        } else if let idid1 = response["id"] as? String {
            id = Int(idid1) ?? 0
        }
        
        if let idid = response["payment_id"] as? Int {
            payment_id = idid
        } else if let idid1 = response["payment_id"] as? String {
            payment_id = Int(idid1) ?? 0
        }
        
        if let idid = response["reference_id"] as? Int {
            reference_id = idid
        } else if let idid1 = response["reference_id"] as? String {
            reference_id = Int(idid1) ?? 0
        }
        
        if let idid = response["status"] as? Int {
            status = idid
        } else if let idid1 = response["status"] as? String {
            status = Int(idid1) ?? 0
        }
        
        if let idid = response["user_id"] as? Int {
            user_id = idid
        } else if let idid1 = response["user_id"] as? String {
            user_id = Int(idid1) ?? 0
        }        
        type = response["type"] as? String ?? ""
    }
    
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd MMM yyyy"
        if date1 != nil {
            return dateFormatter.string(from: date1!)
        }
        return date
    }
}
