//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class VisitorLogGateModel{

	var addedBy : String!
	var approvalDate : String!
	var approvalGivenBy : String!
	var approvalType : String!
	var approvedBy : String!
	var askApproval : String!
	var companyName : String!
	var createdDate : String!
	var document : [VisitorDocument]!
	var entry : String!
	var entryBy : String!
	var entryBySecurity : String!
	var exit : Exit!
	var id : String!
	var isDeleted : String!
	var laborId : String!
	var otp : String!
	var owner : String!
	var registerMobileNo : String!
	var siteId : String!
	var status : String!
	var updatedDate : String!
	var vehicleNumber : String!
	var visitType : String!
	var visitorNo : String!
	var visitorRemark : String!
	var visitors : [Visitor]!
	var whomToMeet : String!
	var whomToMeetType : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		addedBy = dictionary["added_by"] as? String
		approvalDate = dictionary["approval_date"] as? String
		approvalGivenBy = dictionary["approval_given_by"] as? String
		approvalType = dictionary["approval_type"] as? String
		approvedBy = dictionary["approved_by"] as? String
		askApproval = dictionary["ask_approval"] as? String
		companyName = dictionary["company_name"] as? String
		createdDate = dictionary["created_date"] as? String
		document = [VisitorDocument]()
		if let documentArray = dictionary["document"] as? [[String:Any]]{
			for dic in documentArray{
				let value = VisitorDocument(fromDictionary: dic)
				document.append(value)
			}
		}
		entry = dictionary["entry"] as? String
		entryBy = dictionary["entry_by"] as? String
		entryBySecurity = dictionary["entry_by_security"] as? String
		if let exitData = dictionary["exit"] as? [String:Any]{
			exit = Exit(fromDictionary: exitData)
		}
		id = dictionary["id"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		laborId = dictionary["labor_id"] as? String
		otp = dictionary["otp"] as? String
		owner = dictionary["owner"] as? String
		registerMobileNo = dictionary["register_mobile_no"] as? String
		siteId = dictionary["site_id"] as? String
		status = dictionary["status"] as? String
		updatedDate = dictionary["updated_date"] as? String
		vehicleNumber = dictionary["vehicle_number"] as? String
		visitType = dictionary["visit_type"] as? String
		visitorNo = dictionary["visitor_no"] as? String
		visitorRemark = dictionary["visitor_remark"] as? String
		visitors = [Visitor]()
		if let visitorsArray = dictionary["visitors"] as? [[String:Any]]{
			for dic in visitorsArray{
				let value = Visitor(fromDictionary: dic)
				visitors.append(value)
			}
		}
		whomToMeet = dictionary["whom_to_meet"] as? String
		whomToMeetType = dictionary["whom_to_meet_type"] as? String
	}

}
