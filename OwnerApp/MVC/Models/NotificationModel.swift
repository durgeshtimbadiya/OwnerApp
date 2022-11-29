//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class NotificationModel{

    var addedBy : String!
    var additionalData : String!
    var appType : String!
    var createdDate : String!
    var entryId : String!
    var id : String!
    var isDeleted : String!
    var notification : String!
    var notificationType : String!
    var owner : String!
    var seen : String!
    var siteId : String!
    var type : String!
    var updatedDate : String!
    var userId : String!
    var userType : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        addedBy = dictionary["added_by"] as? String
        additionalData = dictionary["additional_data"] as? String
        appType = dictionary["app_type"] as? String
        createdDate = dictionary["created_date"] as? String
        entryId = dictionary["entry_id"] as? String
        id = dictionary["id"] as? String
        isDeleted = dictionary["isDeleted"] as? String
        notification = dictionary["notification"] as? String
        notificationType = dictionary["notification_type"] as? String
        owner = dictionary["owner"] as? String
        seen = dictionary["seen"] as? String
        siteId = dictionary["site_id"] as? String
        type = dictionary["type"] as? String
        updatedDate = dictionary["updated_date"] as? String
        userId = dictionary["user_id"] as? String
        userType = dictionary["user_type"] as? String
    }

}
