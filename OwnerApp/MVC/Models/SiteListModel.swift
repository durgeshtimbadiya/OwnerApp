//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class SiteListModel{

    var addedDate : String!
    var address : String!
    var approve : String!
    var bloodGroup : String!
    var department : String!
    var descriptionField : String!
    var designation : String!
    var deviceId : String!
    var dob : String!
    var email : String!
    var employeeBlocked : String!
    var employeeId : String!
    var id : String!
    var img : String!
    var isBlocked : String!
    var isDeleted : String!
    var latitude : String!
    var logedIn : String!
    var loginStatus : String!
    var longitude : String!
    var mobile : String!
    var name : String!
    var otp : String!
    var owner : String!
    var ownerBlocked : String!
    var userBlocked : String!
    var parking : String!
    var password : String!
    var pdfQr : String!
    var photo : String!
    var profilePic : String!
    var profileStatus : String!
    var qrCode : String!
    var siteBlocked : String!
    var siteId : String!
    var status : String!
    var swPassword : String!
    var type : String!
    var updatedDate : String!
    var uploadReport : Int!
    var vehicle : String!
    var vehicleApproval : Int!
    var vehicleApprovalCount : VehicleApprovalCount!
    var visitorApproval : Int!
    var visitorApprovalCount : VehicleApprovalCount!
    var package : String!
    var upcoming_package : String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        addedDate = dictionary["added_date"] as? String
        address = dictionary["address"] as? String
        approve = dictionary["approve"] as? String
        bloodGroup = dictionary["blood_group"] as? String
        department = dictionary["department"] as? String
        descriptionField = dictionary["description"] as? String
        designation = dictionary["designation"] as? String
        deviceId = dictionary["device_id"] as? String
        dob = dictionary["dob"] as? String
        email = dictionary["email"] as? String
        employeeBlocked = dictionary["employeeBlocked"] as? String
        employeeId = dictionary["owner"] as? String
        id = dictionary["id"] as? String
        img = dictionary["img"] as? String
        isBlocked = dictionary["isBlocked"] as? String
        isDeleted = dictionary["isDeleted"] as? String
        latitude = dictionary["latitude"] as? String
        logedIn = dictionary["loged_in"] as? String
        loginStatus = dictionary["login_status"] as? String
        longitude = dictionary["longitude"] as? String
        mobile = dictionary["mobile"] as? String
        name = dictionary["name"] as? String
        otp = dictionary["otp"] as? String
        owner = dictionary["owner"] as? String
        ownerBlocked = dictionary["ownerBlocked"] as? String
        userBlocked = dictionary["userBlocked"] as? String
        
        parking = dictionary["parking"] as? String
        password = dictionary["password"] as? String
        pdfQr = dictionary["pdf_qr"] as? String
        photo = dictionary["photo"] as? String
        profilePic = dictionary["profile_pic"] as? String
        profileStatus = dictionary["profile_status"] as? String
        qrCode = dictionary["qr_code"] as? String
        siteBlocked = dictionary["siteBlocked"] as? String
        siteId = dictionary["site_id"] as? String
        status = dictionary["status"] as? String
        swPassword = dictionary["sw_password"] as? String
        type = dictionary["type"] as? String
        updatedDate = dictionary["updated_date"] as? String
        uploadReport = dictionary["upload_report"] as? Int
        vehicle = dictionary["vehicle"] as? String
        vehicleApproval = dictionary["vehicle_approval"] as? Int
        if let vehicleApprovalCountData = dictionary["vehicle_approval_count"] as? [String:Any]{
            vehicleApprovalCount = VehicleApprovalCount(fromDictionary: vehicleApprovalCountData)
        }
        visitorApproval = dictionary["visitor_approval"] as? Int
        if let visitorApprovalCountData = dictionary["visitor_approval_count"] as? [String:Any]{
            visitorApprovalCount = VehicleApprovalCount(fromDictionary: visitorApprovalCountData)
        }
        
        package = dictionary["package"] as? String //upcoming_package
        upcoming_package = dictionary["upcoming_package"] as? String
    }

}
