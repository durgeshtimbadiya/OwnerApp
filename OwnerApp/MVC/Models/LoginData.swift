//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class LoginData: NSObject, NSCoding {
    var addedDate: String!
    var address: String!
    var bloodGroup: String!
    var department: String!
    var designation: String!
    var deviceId: String!
    var dob: String!
    var email: String!
    var id: String!
    var img: String!
    var logedIn: String!
    var loginStatus: String!
    var mobile: String!
    var name: String!
    var owner: String!
    var parking: String!
    var profilePic: String!
    var profileStatus: String!
    var siteId: String!
    var vehicle: String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String: Any]) {
        addedDate = dictionary["added_date"] as? String
        address = dictionary["address"] as? String
        bloodGroup = dictionary["blood_group"] as? String
        department = dictionary["department"] as? String
        designation = dictionary["designation"] as? String
        deviceId = dictionary["device_id"] as? String
        dob = dictionary["dob"] as? String
        email = dictionary["email"] as? String
        id = dictionary["id"] as? String
        img = dictionary["img"] as? String
        logedIn = dictionary["loged_in"] as? String
        loginStatus = dictionary["login_status"] as? String
        mobile = dictionary["mobile"] as? String
        name = dictionary["name"] as? String
        owner = dictionary["owner"] as? String
        parking = dictionary["parking"] as? String
        profilePic = dictionary["profile_pic"] as? String
        profileStatus = dictionary["profile_status"] as? String
        siteId = dictionary["site_id"] as? String
        vehicle = dictionary["vehicle"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        if addedDate != nil {
            dictionary["added_date"] = addedDate
        }
        if address != nil {
            dictionary["address"] = address
        }
        if bloodGroup != nil {
            dictionary["blood_group"] = bloodGroup
        }
        if department != nil {
            dictionary["department"] = department
        }
        if designation != nil {
            dictionary["designation"] = designation
        }
        if deviceId != nil {
            dictionary["device_id"] = deviceId
        }
        if dob != nil {
            dictionary["dob"] = dob
        }
        if email != nil {
            dictionary["email"] = email
        }
        if id != nil {
            dictionary["id"] = id
        }
        if img != nil {
            dictionary["img"] = img
        }
        if logedIn != nil {
            dictionary["loged_in"] = logedIn
        }
        if loginStatus != nil {
            dictionary["login_status"] = loginStatus
        }
        if mobile != nil {
            dictionary["mobile"] = mobile
        }
        if name != nil {
            dictionary["name"] = name
        }
        if owner != nil {
            dictionary["owner"] = owner
        }
        if parking != nil {
            dictionary["parking"] = parking
        }
        if profilePic != nil {
            dictionary["profile_pic"] = profilePic
        }
        if profileStatus != nil {
            dictionary["profile_status"] = profileStatus
        }
        if siteId != nil {
            dictionary["site_id"] = siteId
        }
        if vehicle != nil {
            dictionary["vehicle"] = vehicle
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder) {
        addedDate = aDecoder.decodeObject(forKey: "added_date") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        bloodGroup = aDecoder.decodeObject(forKey: "blood_group") as? String
        department = aDecoder.decodeObject(forKey: "department") as? String
        designation = aDecoder.decodeObject(forKey: "designation") as? String
        deviceId = aDecoder.decodeObject(forKey: "device_id") as? String
        dob = aDecoder.decodeObject(forKey: "dob") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        img = aDecoder.decodeObject(forKey: "img") as? String
        logedIn = aDecoder.decodeObject(forKey: "loged_in") as? String
        loginStatus = aDecoder.decodeObject(forKey: "login_status") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        owner = aDecoder.decodeObject(forKey: "owner") as? String
        parking = aDecoder.decodeObject(forKey: "parking") as? String
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        profileStatus = aDecoder.decodeObject(forKey: "profile_status") as? String
        siteId = aDecoder.decodeObject(forKey: "site_id") as? String
        vehicle = aDecoder.decodeObject(forKey: "vehicle") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder) {
        if addedDate != nil {
            aCoder.encode(addedDate, forKey: "added_date")
        }
        if address != nil {
            aCoder.encode(address, forKey: "address")
        }
        if bloodGroup != nil {
            aCoder.encode(bloodGroup, forKey: "blood_group")
        }
        if department != nil {
            aCoder.encode(department, forKey: "department")
        }
        if designation != nil {
            aCoder.encode(designation, forKey: "designation")
        }
        if deviceId != nil {
            aCoder.encode(deviceId, forKey: "device_id")
        }
        if dob != nil {
            aCoder.encode(dob, forKey: "dob")
        }
        if email != nil {
            aCoder.encode(email, forKey: "email")
        }
        if id != nil {
            aCoder.encode(id, forKey: "id")
        }
        if img != nil {
            aCoder.encode(img, forKey: "img")
        }
        if logedIn != nil {
            aCoder.encode(logedIn, forKey: "loged_in")
        }
        if loginStatus != nil {
            aCoder.encode(loginStatus, forKey: "login_status")
        }
        if mobile != nil {
            aCoder.encode(mobile, forKey: "mobile")
        }
        if name != nil {
            aCoder.encode(name, forKey: "name")
        }
        if owner != nil {
            aCoder.encode(owner, forKey: "owner")
        }
        if parking != nil {
            aCoder.encode(parking, forKey: "parking")
        }
        if profilePic != nil {
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if profileStatus != nil {
            aCoder.encode(profileStatus, forKey: "profile_status")
        }
        if siteId != nil {
            aCoder.encode(siteId, forKey: "site_id")
        }
        if vehicle != nil {
            aCoder.encode(vehicle, forKey: "vehicle")
        }
    }
}
