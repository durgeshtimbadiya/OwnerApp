//
//	Document.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class VisitorDocument{

	var remark : String!
	var type : String!
	var url : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		remark = dictionary["remark"] as? String
		type = dictionary["type"] as? String
		url = dictionary["url"] as? String
	}

}
