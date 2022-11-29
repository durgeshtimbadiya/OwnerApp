//
//	Doc.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class DocModel {
    var fileUrl: String!
    var type: String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        fileUrl = dictionary["file_url"] as? String
        type = dictionary["type"] as? String
    }
}
