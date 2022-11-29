//
//  AttendanceListModel.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AttendanceListModel{

    var address : String!
    var createdDate : String!
    var dataType : Int!
    var employee : String!
    var facility : String!
    var havePunched : Bool!
    var id : String!
    var isDeleted : String!
    var latitude : String!
    var locationPunchIn : String!
    var locationPunchOut : String!
    var longitude : String!
    var punchInDate : String!
    var punchInTime : String!
    var punchOutDate : String!
    var punchhOutTime : String!
    var punchOutTime : String!
    var qrData : String!
    var selfie : String!
    var shortingDate : String!
    var siteId : String!
    var totalWorked : String!
    var type : String!
    var updatedDate : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        address = dictionary["address"] as? String
        createdDate = dictionary["created_date"] as? String
        dataType = dictionary["data_type"] as? Int
        employee = dictionary["employee"] as? String
        facility = dictionary["facility"] as? String
        havePunched = dictionary["have_punched"] as? Bool
        id = dictionary["id"] as? String
        isDeleted = dictionary["isDeleted"] as? String
        latitude = dictionary["latitude"] as? String
        locationPunchIn = dictionary["location_punch_in"] as? String
        locationPunchOut = dictionary["location_punch_out"] as? String
        longitude = dictionary["longitude"] as? String
        punchInDate = dictionary["punch_in_date"] as? String
        punchInTime = dictionary["punch_in_time"] as? String
        punchOutDate = dictionary["punch_out_date"] as? String
        punchhOutTime = dictionary["punchh_out_time"] as? String
        punchOutTime = dictionary["punch_out_time"] as? String
        qrData = dictionary["qr_data"] as? String
        selfie = dictionary["selfie"] as? String
        shortingDate = dictionary["shorting_date"] as? String
        siteId = dictionary["site_id"] as? String
        totalWorked = dictionary["total_worked"] as? String
        type = dictionary["type"] as? String
        updatedDate = dictionary["updated_date"] as? String
    }

}
