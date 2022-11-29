//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class AdminDeletedModel{

	var addedDate : String!
	var department : String!
	var deviceId : String!
	var email : String!
	var id : String!
	var isBlocked : String!
	var isDeleted : String!
	var logedIn : String!
	var loginStatus : String!
	var mobile : String!
	var name : String!
	var otp : String!
	var owner : String!
	var password : String!
	var profilePic : String!
	var profileStatus : String!
	var siteId : String!
	var swPassword : String!
	var updatedDate : String!
	var vehicle : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		addedDate = dictionary["added_date"] as? String
		department = dictionary["department"] as? String
		deviceId = dictionary["device_id"] as? String
		email = dictionary["email"] as? String
		id = dictionary["id"] as? String
		isBlocked = dictionary["isBlocked"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		logedIn = dictionary["loged_in"] as? String
		loginStatus = dictionary["login_status"] as? String
		mobile = dictionary["mobile"] as? String
		name = dictionary["name"] as? String
		otp = dictionary["otp"] as? String
		owner = dictionary["owner"] as? String
		password = dictionary["password"] as? String
		profilePic = dictionary["profile_pic"] as? String
		profileStatus = dictionary["profile_status"] as? String
		siteId = dictionary["site_id"] as? String
		swPassword = dictionary["sw_password"] as? String
		updatedDate = dictionary["updated_date"] as? String
		vehicle = dictionary["vehicle"] as? String
	}

}
