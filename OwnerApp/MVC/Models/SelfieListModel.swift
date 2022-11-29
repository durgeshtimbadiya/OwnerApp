

//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class SelfieListModel {
    var address: String!
    var createdDate: String!
    var facility: String!
    var id: String!
    var isDeleted: String!
    var labor: String!
    var latitude: String!
    var longitude: String!
    var punchInId: String!
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
        punchInId = dictionary["punch_in_id"] as? String
        selfie = dictionary["selfie"] as? String
        siteId = dictionary["site_id"] as? String
        updatedDate = dictionary["updated_date"] as? String
        employee = dictionary["employee"] as? String
        shorting_date = dictionary["shorting_date"] as? String
    }
}
