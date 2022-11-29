//
//  SelfieLogListModel.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class SelfieLogListModel {
    var address: String!
    var createdDate: String!
    var facility: String!
    var id: String!
    var isDeleted: String!
    var labor: String!
    var latitude: String!
    var longitude: String!
    var punchInDate: String!
    var punchInId: String!
    var punchInTime: String!
    var punchOutDate: String!
    var punchhOutTime: String!
    var selfie: String!
    var siteId: String!
    var updatedDate: String!
    var employee: String!
    var shorting_date: String!
    var sortingIndex = 0
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        address = dictionary["address"] as? String
        createdDate = dictionary["created_date"] as? String
        facility = dictionary["facility"] as? String
        id = dictionary["id"] as? String
        isDeleted = dictionary["isDeleted"] as? String
        labor = dictionary["labor"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        punchInDate = dictionary["punch_in_date"] as? String
        punchInId = dictionary["punch_in_id"] as? String
        punchInTime = dictionary["punch_in_time"] as? String
        punchOutDate = dictionary["punch_out_date"] as? String
        punchhOutTime = dictionary["punchh_out_time"] as? String
        selfie = dictionary["selfie"] as? String
        siteId = dictionary["site_id"] as? String
        updatedDate = dictionary["updated_date"] as? String
        employee = dictionary["employee"] as? String
        shorting_date = dictionary["shorting_date"] as? String
    }
}
