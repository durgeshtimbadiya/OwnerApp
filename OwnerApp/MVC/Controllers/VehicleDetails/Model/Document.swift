//
//	Document.swift

import Foundation

struct Document{

	var type : String!
	var url : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		type = dictionary["type"] as? String
		url = dictionary["url"] as? String
	}

}
