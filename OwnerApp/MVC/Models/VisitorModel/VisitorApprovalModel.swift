//
//	RootClass.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class VisitorApprovalModel{

	var approvalDate : String!
	var approvalType : String!
	var approvedBy : String!
	var askApproval : String!
	var companyName : String!
	var createdDate : String!
	var docs : [String]!
	var entry : String!
	var entryBy : String!
	var exitApprovedDate : String!
	var exitAskApproval : String!
	var exitBy : String!
	var exitByType : String!
	var exitCreatedDate : String!
	var exitStatus : String!
	var exitUpdatedDate : String!
	var id : String!
	var isDeleted : String!
	var laborId : String!
	var otp : String!
	var owner : String!
	var registerMobileNo : String!
	var securityExitBy : String!
	var siteId : String!
	var status : String!
	var timeSpent : Int!
	var uniqueId : String!
	var updatedDate : String!
	var vehicleNumber : String!
	var visitType : String!
	var visitorName : String!
	var visitorNo : String!
	var visitorRemark : String!
	var visitors : [VisitorModel]!
	var whomToMeet : String!
	var whomToMeetType : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		approvalDate = dictionary["approval_date"] as? String
		approvalType = dictionary["approval_type"] as? String
		approvedBy = dictionary["approved_by"] as? String
		askApproval = dictionary["ask_approval"] as? String
		companyName = dictionary["company_name"] as? String
		createdDate = dictionary["created_date"] as? String
		docs = dictionary["docs"] as? [String]
		entry = dictionary["entry"] as? String
		entryBy = dictionary["entry_by"] as? String
		exitApprovedDate = dictionary["exit_approved_date"] as? String
		exitAskApproval = dictionary["exit_ask_approval"] as? String
		exitBy = dictionary["exit_by"] as? String
		exitByType = dictionary["exit_by_type"] as? String
		exitCreatedDate = dictionary["exit_created_date"] as? String
		exitStatus = dictionary["exit_status"] as? String
		exitUpdatedDate = dictionary["exit_updated_date"] as? String
		id = dictionary["id"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		laborId = dictionary["labor_id"] as? String
		otp = dictionary["otp"] as? String
		owner = dictionary["owner"] as? String
		registerMobileNo = dictionary["register_mobile_no"] as? String
		securityExitBy = dictionary["security_exit_by"] as? String
		siteId = dictionary["site_id"] as? String
		status = dictionary["status"] as? String
		timeSpent = dictionary["time_spent"] as? Int
		uniqueId = dictionary["unique_id"] as? String
		updatedDate = dictionary["updated_date"] as? String
		vehicleNumber = dictionary["vehicle_number"] as? String
		visitType = dictionary["visit_type"] as? String
		visitorName = dictionary["visitor_name"] as? String
		visitorNo = dictionary["visitor_no"] as? String
		visitorRemark = dictionary["visitor_remark"] as? String
		visitors = [VisitorModel]()
		if let visitorsArray = dictionary["visitors"] as? [[String:Any]]{
			for dic in visitorsArray{
				let value = VisitorModel(fromDictionary: dic)
				visitors.append(value)
			}
		}
		whomToMeet = dictionary["whom_to_meet"] as? String
		whomToMeetType = dictionary["whom_to_meet_type"] as? String
	}

}
