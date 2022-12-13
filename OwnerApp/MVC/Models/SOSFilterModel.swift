//
//  SOSFilterModel.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 13/12/21.
//

//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class SOSFilterModel {
    var createdDate: String!
    var facility: String!
    var id: String!
    var isDeleted: String!
    var labor: String!
    var latitude: String!
    var location: String!
    var longitude: String!
    var owner: String!
    var punchInId: String!
    var siteId: String!
    var type: String!
    var updatedDate: String!
    var sortingDate: String!
    var designation: String!
    var name: String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        createdDate = dictionary["created_date"] as? String
        facility = dictionary["facility"] as? String
        id = dictionary["id"] as? String
        isDeleted = dictionary["isDeleted"] as? String
        labor = dictionary["labor"] as? String
        latitude = dictionary["latitude"] as? String
        location = dictionary["location"] as? String
        longitude = dictionary["longitude"] as? String
        owner = dictionary["owner"] as? String
        punchInId = dictionary["punch_in_id"] as? String
        siteId = dictionary["site_id"] as? String
        type = dictionary["type"] as? String
        updatedDate = dictionary["updated_date"] as? String
        sortingDate = dictionary["shorting_date"] as? String
        designation = dictionary["designation"] as? String
        name = dictionary["name"] as? String
    }
}
