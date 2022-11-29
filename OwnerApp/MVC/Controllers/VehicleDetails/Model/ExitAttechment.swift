//
//	ExitAttechment.swift

import Foundation

struct ExitAttechment{

	var attechment : String!
	var createdDate : String!
	var entryId : String!
	var id : String!
	var idType : String!
	var isDeleted : String!
	var type : String!
	var updatedDate : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		attechment = dictionary["attechment"] as? String
		createdDate = dictionary["created_date"] as? String
		entryId = dictionary["entry_id"] as? String
		id = dictionary["id"] as? String
		idType = dictionary["id_type"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		type = dictionary["type"] as? String
		updatedDate = dictionary["updated_date"] as? String
	}

}
