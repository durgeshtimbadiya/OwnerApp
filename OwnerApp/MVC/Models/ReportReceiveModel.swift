//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ReportReceiveModel{

	var createdDate : String!
	var file : String!
	var fileType : String!
	var id : String!
	var isDeleted : String!
	var name : String!
	var receiver : String!
	var receiverType : String!
	var remark : String!
	var seen : String!
	var sender : String!
	var senderType : String!
	var siteId : String!
	var updatedDate : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdDate = dictionary["created_date"] as? String
		file = dictionary["file"] as? String
		fileType = dictionary["file_type"] as? String
		id = dictionary["id"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		name = dictionary["name"] as? String
		receiver = dictionary["receiver"] as? String
		receiverType = dictionary["receiver_type"] as? String
		remark = dictionary["remark"] as? String
		seen = dictionary["seen"] as? String
		sender = dictionary["sender"] as? String
		senderType = dictionary["sender_type"] as? String
		siteId = dictionary["site_id"] as? String
		updatedDate = dictionary["updated_date"] as? String
	}

}
