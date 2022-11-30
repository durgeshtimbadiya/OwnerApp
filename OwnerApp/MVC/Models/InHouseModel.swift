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

class LiveVehiclesModel {

    var id : String!
    var vehicle_number : String!
    var vendor_mobile : String!
    var updated_date : String!
    var delete : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? String
        vehicle_number = dictionary["vehicle_number"] as? String
        vendor_mobile = dictionary["vendor_mobile"] as? String
        updated_date = dictionary["updated_date"] as? String
        delete = dictionary["delete"] as? String
    }

}


class LiveVisitorsModel {
    var id : String!
    var visitor_name : String!
    var register_mobile_no : String!
    var updated_date : String!
    var delete : String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? String
        visitor_name = dictionary["visitor_name"] as? String
        register_mobile_no = dictionary["register_mobile_no"] as? String
        updated_date = dictionary["updated_date"] as? String
        delete = dictionary["delete"] as? String
    }

}


