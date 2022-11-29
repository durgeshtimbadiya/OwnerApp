//
//	VehicleApprovalCount.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class VehicleApprovalCount{

	var approved : Int!
	var exit : Int!
	var pending : Int!
	var rejected : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		approved = dictionary["approved"] as? Int
		exit = dictionary["exit"] as? Int
		pending = dictionary["pending"] as? Int
		rejected = dictionary["rejected"] as? Int
	}

}