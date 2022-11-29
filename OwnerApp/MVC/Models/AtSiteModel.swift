//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AtSiteModel{

	var addedDate : String!
	var address : String!
	var bloodGroup : String!
	var departName : String!
	var department : String!
	var designation : String!
	var designationName : String!
	var deviceId : String!
	var dob : String!
	var email : String!
	var facilityName : String!
	var id : String!
	var img : String!
	var isBlocked : String!
	var isDeleted : String!
	var locationPunchIn : String!
	var logedIn : String!
	var loginStatus : String!
	var mobile : String!
	var name : String!
	var otp : String!
	var owner : String!
	var parking : String!
	var password : String!
	var profilePic : String!
	var profileStatus : String!
	var punchedin : String!
	var siteId : String!
	var swPassword : String!
	var updatedDate : String!
	var vehicle : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		addedDate = dictionary["added_date"] as? String
		address = dictionary["address"] as? String
		bloodGroup = dictionary["blood_group"] as? String
		departName = dictionary["departName"] as? String
		department = dictionary["department"] as? String
		designation = dictionary["designation"] as? String
		designationName = dictionary["designationName"] as? String
		deviceId = dictionary["device_id"] as? String
		dob = dictionary["dob"] as? String
		email = dictionary["email"] as? String
		facilityName = dictionary["facilityName"] as? String
		id = dictionary["id"] as? String
		img = dictionary["img"] as? String
		isBlocked = dictionary["isBlocked"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		locationPunchIn = dictionary["location_punch_in"] as? String
		logedIn = dictionary["loged_in"] as? String
		loginStatus = dictionary["login_status"] as? String
		mobile = dictionary["mobile"] as? String
		name = dictionary["name"] as? String
		otp = dictionary["otp"] as? String
		owner = dictionary["owner"] as? String
		parking = dictionary["parking"] as? String
		password = dictionary["password"] as? String
		profilePic = dictionary["profile_pic"] as? String
		profileStatus = dictionary["profile_status"] as? String
		punchedin = dictionary["punchedin"] as? String
		siteId = dictionary["site_id"] as? String
		swPassword = dictionary["sw_password"] as? String
		updatedDate = dictionary["updated_date"] as? String
		vehicle = dictionary["vehicle"] as? String
	}

}
