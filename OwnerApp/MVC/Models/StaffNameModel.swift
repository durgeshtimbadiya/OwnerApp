//
//  StaffNameModel.swift
//  EmployeeApp
//
//  Created by Jailove on 19/07/22.
//

import Foundation

class StaffNameModel{

    var staff_id : String!
    var name : String!
    var department : String!
    var staff_type : String!
    var isCheck: Bool!
    
    init(fromDictionary dictionary: [String:Any]){
        staff_id = dictionary["staff_id"] as? String
        name = dictionary["name"] as? String
        department = dictionary["department"] as? String
        staff_type = dictionary["staff_type"] as? String
        isCheck = dictionary["isCheck"] as? Bool ?? false
    
     }
}
