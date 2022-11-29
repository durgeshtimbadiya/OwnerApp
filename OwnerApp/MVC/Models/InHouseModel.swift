//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class InHouseModel{

	var approvalDate : String!
	var createdDate : String!
	var exitId : String!
	var exitName : String!
	var exitStatus : String!
	var id : String!
	var isDeleted : String!
	var name : String!
	var siteId : String!
	var staffId : String!
	var staffName : String!
	var staffType : String!
	var updatedDate : AnyObject!
	var userId : String!
	var vehicle : String!
	var vehicleNo : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		approvalDate = dictionary["approval_date"] as? String
		createdDate = dictionary["created_date"] as? String
		exitId = dictionary["exit_id"] as? String
		exitName = dictionary["exit_name"] as? String
		exitStatus = dictionary["exit_status"] as? String
		id = dictionary["id"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		name = dictionary["name"] as? String
		siteId = dictionary["site_id"] as? String
		staffId = dictionary["staff_id"] as? String
		staffName = dictionary["staff_name"] as? String
		staffType = dictionary["staff_type"] as? String
		updatedDate = dictionary["updated_date"] as? AnyObject
		userId = dictionary["user_id"] as? String
		vehicle = dictionary["vehicle"] as? String
		vehicleNo = dictionary["vehicle_no"] as? String
	}

}
