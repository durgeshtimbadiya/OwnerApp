//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AtGateModel{

	var address : String!
	var adhar : String!
	var approvalDate : String!
	var bloodGroup : String!
	var createdDate : String!
	var designation : String!
	var designationName : String!
	var deviceId : String!
	var dob : String!
	var facility : String!
	var facilityName : String!
	var facilityMaster : String!
	var haveAttendance : String!
	var id : String!
	var img : String!
	var isBlocked : String!
	var isDeleted : String!
	var locationPunchIn : String!
	var logedIn : String!
	var loginStatus : String!
	var mobile : String!
	var name : String!
	var notificationStatus : String!
	var otp : String!
	var owner : String!
	var password : String!
	var profileStatus : String!
	var punchedin : String!
	var siteId : String!
	var status : String!
	var swPassword : String!
	var totalWorked : String!
	var updatedDate : String!
	var verify : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		address = dictionary["address"] as? String
		adhar = dictionary["adhar"] as? String
		approvalDate = dictionary["approval_date"] as? String
		bloodGroup = dictionary["bloodGroup"] as? String
		createdDate = dictionary["created_date"] as? String
		designation = dictionary["designation"] as? String
		designationName = dictionary["designationName"] as? String
		deviceId = dictionary["device_id"] as? String
		dob = dictionary["dob"] as? String
		facility = dictionary["facility"] as? String
		facilityName = dictionary["facilityName"] as? String
		facilityMaster = dictionary["facility_master"] as? String
		haveAttendance = dictionary["have_attendance"] as? String
		id = dictionary["id"] as? String
		img = dictionary["img"] as? String
		isBlocked = dictionary["isBlocked"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		locationPunchIn = dictionary["location_punch_in"] as? String
		logedIn = dictionary["loged_in"] as? String
		loginStatus = dictionary["login_status"] as? String
		mobile = dictionary["mobile"] as? String
		name = dictionary["name"] as? String
		notificationStatus = dictionary["notification_status"] as? String
		otp = dictionary["otp"] as? String
		owner = dictionary["owner"] as? String
		password = dictionary["password"] as? String
		profileStatus = dictionary["profile_status"] as? String
		punchedin = dictionary["punchedin"] as? String
		siteId = dictionary["site_id"] as? String
		status = dictionary["status"] as? String
		swPassword = dictionary["sw_password"] as? String
		totalWorked = dictionary["total_worked"] as? String
		updatedDate = dictionary["updated_date"] as? String
		verify = dictionary["verify"] as? String
	}

}
