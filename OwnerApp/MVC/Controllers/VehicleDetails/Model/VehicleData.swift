//
//	VehicleData.swift

import Foundation

struct VehicleData {

	var addedBy : String!
	var approvalDate : String!
	var approvalType : String!
	var approvedBy : String!
	var askApproval : String!
	var challanNumber : String!
	var commercialVehicleImage : String!
	var companyId : String!
	var companyMobile : String!
	var companyName : String!
	var createdDate : String!
    var document : [Document]!
	var driverContact : String!
	var entry : String!
	var entryBy : String!
	var entryBySecurity : String!
	var exit : [ExitEntry]!
	var exitAttechment : [ExitAttechment]!
	var id : String!
	var invoiceImg : String!
	var invoiceImgStatus : String!
	var inwardChallanImage : String!
	var isDeleted : String!
	var laborId : String!
	var materialType : String!
	var otp : String!
	var outwardChallanImage : String!
	var owner : String!
	var poImg : String!
	var poNumber : String!
	var quantity : String!
	var siteId : String!
	var status : String!
	var updatedDate : String!
	var vehicleNumber : String!
	var vendorMobile : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		addedBy = dictionary["added_by"] as? String
		approvalDate = dictionary["approval_date"] as? String
		approvalType = dictionary["approval_type"] as? String
		approvedBy = dictionary["approved_by"] as? String
		askApproval = dictionary["ask_approval"] as? String
		challanNumber = dictionary["challan_number"] as? String
		commercialVehicleImage = dictionary["commercial_vehicle_image"] as? String
		companyId = dictionary["company_id"] as? String
		companyMobile = dictionary["company_mobile"] as? String
		companyName = dictionary["company_name"] as? String
		createdDate = dictionary["created_date"] as? String
		document = [Document]()
		if let documentArray = dictionary["document"] as? [[String:Any]]{
			for dic in documentArray{
				let value = Document(fromDictionary: dic)
				document.append(value)
			}
		}
		driverContact = dictionary["driver_contact"] as? String
		entry = dictionary["entry"] as? String
		entryBy = dictionary["entry_by"] as? String
		entryBySecurity = dictionary["entry_by_security"] as? String
		exit = [ExitEntry]()
		if let exitArray = dictionary["exit"] as? [[String:Any]]{
			for dic in exitArray{
				let value = ExitEntry(fromDictionary: dic)
				exit.append(value)
			}
		}
		exitAttechment = [ExitAttechment]()
		if let exitAttechmentArray = dictionary["exit_attechment"] as? [[String:Any]]{
			for dic in exitAttechmentArray{
				let value = ExitAttechment(fromDictionary: dic)
				exitAttechment.append(value)
			}
		}
		id = dictionary["id"] as? String
		invoiceImg = dictionary["invoice_img"] as? String
		invoiceImgStatus = dictionary["invoice_img_status"] as? String
		inwardChallanImage = dictionary["inward_challan_image"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		laborId = dictionary["labor_id"] as? String
		materialType = dictionary["material_type"] as? String
		otp = dictionary["otp"] as? String
		outwardChallanImage = dictionary["outward_challan_image"] as? String
		owner = dictionary["owner"] as? String
		poImg = dictionary["po_img"] as? String
		poNumber = dictionary["po_number"] as? String
		quantity = dictionary["quantity"] as? String
		siteId = dictionary["site_id"] as? String
		status = dictionary["status"] as? String
		updatedDate = dictionary["updated_date"] as? String
		vehicleNumber = dictionary["vehicle_number"] as? String
		vendorMobile = dictionary["vendor_mobile"] as? String
	}

}

struct FieldData {

    var created_date = String()
    var employee_id = Int()
    var entry_id = Int()
    var field = String()
    var id = Int()
    var isDeleted = Int()
    var loged_in_type = Int()
    var msg = String()
    var update_type = Int()
    var updated_date = String()

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        
        if let createddate = dictionary["created_date"] as? String {
            created_date = createddate
        }
        if let employeeid = dictionary["employee_id"] as? Int {
            employee_id = employeeid
        }
        if let entryid = dictionary["entry_id"] as? Int {
            entry_id = entryid
        }
        if let fieldd = dictionary["field"] as? String {
            field = fieldd
        }
        if let idid = dictionary["id"] as? Int {
            id = idid
        }
        if let is_Deleted = dictionary["isDeleted"] as? Int {
            isDeleted = is_Deleted
        }
        if let logedintype = dictionary["loged_in_type"] as? Int {
            loged_in_type = logedintype
        }
        if let msgv = dictionary["msg"] as? String {
            msg = msgv
        }
        if let updatetype = dictionary["update_type"] as? Int {
            update_type = updatetype
        }
        if let updateddate = dictionary["updated_date"] as? String {
            updated_date = updateddate
        }
    }
}
