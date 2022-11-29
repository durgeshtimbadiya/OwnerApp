//
//	Visitor.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class VisitorModel{

	var createdDate : String!
	var entryId : String!
	var id : String!
	var isDeleted : String!
	var mobile : String!
	var updatedDate : String!
	var visitorName : String!
	var visitorType : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createdDate = dictionary["created_date"] as? String
		entryId = dictionary["entry_id"] as? String
		id = dictionary["id"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		mobile = dictionary["mobile"] as? String
		updatedDate = dictionary["updated_date"] as? String
		visitorName = dictionary["visitor_name"] as? String
		visitorType = dictionary["visitor_type"] as? String
	}

}
