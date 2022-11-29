//
//	Exit.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Exit{

	var approvalStatus : String!
	var approveType : String!
	var approvedBy : String!
	var approvedDate : String!
	var askApproval : String!
	var challan : String!
	var challanStatus : String!
	var createdDate : String!
	var entryId : String!
	var exitApprovedBy : String!
	var exitBy : String!
	var exitBySecurity : String!
	var exitByType : String!
	var exitStatus : String!
	var id : String!
	var isDeleted : String!
	var materialImgStatus : String!
	var materialRejectRemark : String!
	var materialStatus : String!
	var outpass : String!
	var owner : String!
	var purposeOfOutPass : String!
	var rejectedMaterialImg : String!
	var securityExitBy : String!
	var siteId : String!
	var updatedDate : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		approvalStatus = dictionary["approval_status"] as? String
		approveType = dictionary["approve_type"] as? String
		approvedBy = dictionary["approved_by"] as? String
		approvedDate = dictionary["approved_date"] as? String
		askApproval = dictionary["ask_approval"] as? String
		challan = dictionary["challan"] as? String
		challanStatus = dictionary["challan_status"] as? String
		createdDate = dictionary["created_date"] as? String
		entryId = dictionary["entry_id"] as? String
		exitApprovedBy = dictionary["exit_approved_by"] as? String
		exitBy = dictionary["exit_by"] as? String
		exitBySecurity = dictionary["exit_by_security"] as? String
		exitByType = dictionary["exit_by_type"] as? String
		exitStatus = dictionary["exit_status"] as? String
		id = dictionary["id"] as? String
		isDeleted = dictionary["isDeleted"] as? String
		materialImgStatus = dictionary["material_img_status"] as? String
		materialRejectRemark = dictionary["material_reject_remark"] as? String
		materialStatus = dictionary["material_status"] as? String
		outpass = dictionary["outpass"] as? String
		owner = dictionary["owner"] as? String
		purposeOfOutPass = dictionary["purpose_of_out_pass"] as? String
		rejectedMaterialImg = dictionary["rejected_material_img"] as? String
		securityExitBy = dictionary["security_exit_by"] as? String
		siteId = dictionary["site_id"] as? String
		updatedDate = dictionary["updated_date"] as? String
	}

}