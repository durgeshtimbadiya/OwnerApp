//
//  ImageModel.swift
//  EmployeeApp
//
//  Created by Bhupendra Shekhawat on 02/04/22.
//

import Foundation
import UIKit

class ImageModel{

    var isDeleted : Bool!
    var image_name : String!
    var image : UIImage!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isDeleted = dictionary["isDeleted"] as? Bool ?? false
        image_name = dictionary["image_name"] as? String
        image = dictionary["image"] as? UIImage
    }

}
