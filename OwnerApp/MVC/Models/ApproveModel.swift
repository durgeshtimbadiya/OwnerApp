//
//	RootClass.swift

import Foundation

//class ApproveModel {
//    var approvalDate: String!
//    var approvalType: String!
//    var approvedBy: String!
//    var askApproval: String!
//    var challanNumber: String!
//    var commercialVehicleImage: String!
//    var companyName: String!
//    var createdDate: String!
//    var docs: [DocModel]!
//    var driverContact: String!
//    var entry: String!
//    var entryBy: String!
//    var exitAskApproval: String!
//    var exitStatus: String!
//    var id: String!
//    var invoiceImg: String!
//    var invoiceImgStatus: String!
//    var inwardChallanImage: String!
//    var isDeleted: String!
//    var laborId: String!
//    var materialType: String!
//    var otp: String!
//    var outwardChallanImage: String!
//    var owner: String!
//    var poImg: String!
//    var poNumber: String!
//    var quantity: String!
//    var seen: String!
//    var siteId: String!
//    var status: String!
//    var updatedDate: String!
//    var vehicleNumber: String!
//    var vendorMobile: String!
//
//    /**
//     * Instantiate the instance using the passed dictionary values to set the properties values
//     */
//    init(fromDictionary dictionary: [String: Any]) {
//        approvalDate = dictionary["approval_date"] as? String
//        approvalType = dictionary["approval_type"] as? String
//        approvedBy = dictionary["approved_by"] as? String
//        askApproval = dictionary["ask_approval"] as? String
//        challanNumber = dictionary["challan_number"] as? String
//        commercialVehicleImage = dictionary["commercial_vehicle_image"] as? String
//        companyName = dictionary["company_name"] as? String
//        createdDate = dictionary["created_date"] as? String
//        docs = [DocModel]()
//        if let docsArray = dictionary["docs"] as? [[String: Any]] {
//            for dic in docsArray {
//                let value = DocModel(fromDictionary: dic)
//                docs.append(value)
//            }
//        }
//        driverContact = dictionary["driver_contact"] as? String
//        entry = dictionary["entry"] as? String
//        entryBy = dictionary["entry_by"] as? String
//        exitAskApproval = dictionary["exit_ask_approval"] as? String
//        exitStatus = dictionary["exit_status"] as? String
//        id = dictionary["id"] as? String
//        invoiceImg = dictionary["invoice_img"] as? String
//        invoiceImgStatus = dictionary["invoice_img_status"] as? String
//        inwardChallanImage = dictionary["inward_challan_image"] as? String
//        isDeleted = dictionary["isDeleted"] as? String
//        laborId = dictionary["labor_id"] as? String
//        materialType = dictionary["material_type"] as? String
//        otp = dictionary["otp"] as? String
//        outwardChallanImage = dictionary["outward_challan_image"] as? String
//        owner = dictionary["owner"] as? String
//        poImg = dictionary["po_img"] as? String
//        poNumber = dictionary["po_number"] as? String
//        quantity = dictionary["quantity"] as? String
//        seen = dictionary["seen"] as? String
//        siteId = dictionary["site_id"] as? String
//        status = dictionary["status"] as? String
//        updatedDate = dictionary["updated_date"] as? String
//        vehicleNumber = dictionary["vehicle_number"] as? String
//        vendorMobile = dictionary["vendor_mobile"] as? String
//    }
//}

struct ApproveModel{
    
    var approvalDate : String!
    var approvalType : String!
    var approvedBy : String!
    var askApproval : String!
    var challanNumber : String!
    var commercialVehicleImage : String!
    var companyName : String!
    var createdDate : String!
    var docs : [DocModel]!
    var driverContact : String!
    var entry : String!
    var entryBy : String!
    var exitApprovedDate : String!
    var exitAskApproval : String!
    var exitBy : String!
    var exitByType : String!
    var exitCreatedDate : String!
    var exitStatus : String!
    var exitUpdatedDate : String!
    var id : String!
    var invoiceImg : String!
    var invoiceImgStatus : String!
    var inwardChallanImage : String!
    var isDeleted : String!
    var laborId : String!
    var materialType : String!
    var otp : String!
    var outwardChallanImage : String!
    var owner : String!
    var poImg : String!
    var poNumber : String!
    var quantity : String!
    var securityExitBy : String!
    var siteId : String!
    var status : String!
    var uniqueId : String!
    var updatedDate : String!
    var vehicleNumber : String!
    var vendorMobile : String!
    var timeSpent: String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        approvalDate = dictionary["approval_date"] as? String
        approvalType = dictionary["approval_type"] as? String
        approvedBy = dictionary["approved_by"] as? String
        askApproval = dictionary["ask_approval"] as? String
        challanNumber = dictionary["challan_number"] as? String
        commercialVehicleImage = dictionary["commercial_vehicle_image"] as? String
        companyName = dictionary["company_name"] as? String
        createdDate = dictionary["created_date"] as? String
        docs = [DocModel]()
        if let docsArray = dictionary["docs"] as? [[String:Any]]{
            for dic in docsArray{
                let value = DocModel(fromDictionary: dic)
                docs.append(value)
            }
        }
        driverContact = dictionary["driver_contact"] as? String
        entry = dictionary["entry"] as? String
        entryBy = dictionary["entry_by"] as? String
        exitApprovedDate = dictionary["exit_approved_date"] as? String
        exitAskApproval = dictionary["exit_ask_approval"] as? String
        exitBy = dictionary["exit_by"] as? String
        exitByType = dictionary["exit_by_type"] as? String
        exitCreatedDate = dictionary["exit_created_date"] as? String
        exitStatus = dictionary["exit_status"] as? String
        exitUpdatedDate = dictionary["exit_updated_date"] as? String
        id = dictionary["id"] as? String
        invoiceImg = dictionary["invoice_img"] as? String
        invoiceImgStatus = dictionary["invoice_img_status"] as? String
        inwardChallanImage = dictionary["inward_challan_image"] as? String
        isDeleted = dictionary["isDeleted"] as? String
        laborId = dictionary["labor_id"] as? String
        materialType = dictionary["material_type"] as? String
        otp = dictionary["otp"] as? String
        outwardChallanImage = dictionary["outward_challan_image"] as? String
        owner = dictionary["owner"] as? String
        poImg = dictionary["po_img"] as? String
        poNumber = dictionary["po_number"] as? String
        quantity = dictionary["quantity"] as? String
        securityExitBy = dictionary["security_exit_by"] as? String
        siteId = dictionary["site_id"] as? String
        status = dictionary["status"] as? String
        uniqueId = dictionary["unique_id"] as? String
        updatedDate = dictionary["updated_date"] as? String
        vehicleNumber = dictionary["vehicle_number"] as? String
        vendorMobile = dictionary["vendor_mobile"] as? String
        timeSpent = "Exit Pending"
        if let timespnt = dictionary["time_spent"] as? Double, timespnt > 0 {
            timeSpent = ApproveModel.formatTimeFor(seconds: timespnt)
        }
    }

    /*
     *  Fotmat time using seconds
     */
    static func formatTimeFor(seconds: Double) -> String {
        let result = getHoursMinutesSecondsFrom(seconds: seconds)
        var hoursString = "\(result.hours)"
        if hoursString.utf8.count == 1 {
            hoursString = "0\(result.hours)"
        }
        
        var minutesString = "\(result.minutes)"
        if minutesString.utf8.count == 1 {
            minutesString = "0\(result.minutes)"
        }
        
        var secondsString = "\(result.seconds)"
        if secondsString.utf8.count == 1 {
            secondsString = "0\(result.seconds)"
        }
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    // MARK: Convert seconds to current time for playing audio
    static func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
}
