//
//  WebServices.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Alamofire
import Foundation

enum Webservice {
    enum Server {
        case live
        case EC
        var baseUrlString: String {
            switch self {
            case .live:
                return "https://dev.sitepay.co.in/api/"//"https://dev.androappstech.com/wendor/api/" //
            case .EC:
                return ""
            }
        } 
    }

    static var server: Server {
        return Server.live
    }

    // base url for current server
    static var baseUrl: String {
        // salary cap base url is using for every api except Payement and Socket APIs
        return Webservice.server.baseUrlString //
    }

    // MARK: - Login Flow

    enum Authentication {
        private static let Token = "c7d3965d49d4a59b0da80e90646aee77548458b3377ba3c0fb43d5ff91d54ea28833080e3de6ebd4fde36e2fb7175cddaf5d8d018ac1467c3d15db21c11b6909"

        // ******************************Login Api ***********************************//

        private static let Login = Webservice.baseUrl + "User/login"
        private static let LoginWithOTP = Webservice.baseUrl + "User/verify_otp_admin"
        private static let ForgotPassword = Webservice.baseUrl + "User/forget_password"
        private static let ForgotMatchPassword = Webservice.baseUrl + "User/match_forget_otp"
        private static let newPassword = Webservice.baseUrl + "User/new_password"
        private static let PasswordUpdate = Webservice.baseUrl + "Admin/password_update"
        private static let Site = Webservice.baseUrl + "Admin/mysites"
        private static let NotificationUpdate = Webservice.baseUrl + "Notification/fcm_device_update"
        private static let SiteDelete = Webservice.baseUrl + "Employee/delete_site"
        private static let GetProfileData = Webservice.baseUrl + "Admin/get_profile"
        private static let RemoveProfilePhoto = Webservice.baseUrl + "Admin/profile_update"
        private static let NotificationList = Webservice.baseUrl + "Admin/get_notification"
        private static let Attendance = Webservice.baseUrl + "Admin/attendance"
        private static let AttendanceList = Webservice.baseUrl + "Admin/attendance_list"
        private static let AttendanceFilter = Webservice.baseUrl + "Admin/filter_monthly"
        private static let SOS = Webservice.baseUrl + "Admin/addSos"
        private static let SelfieList = Webservice.baseUrl + "Admin/selfie_list"
        private static let SOSLogList = Webservice.baseUrl + "Admin/sosList"
        private static let SOSFilter = Webservice.baseUrl + "Admin/filter_monthly"

        //MARK:- Vehicle Approval Log
        private static let vehicleLog = Webservice.baseUrl + "Admin/all_logs"
        private static let approveLog = Webservice.baseUrl + "Admin/request_list"
        private static let vehicleDetail = Webservice.baseUrl + "Admin/entry_detail"
        private static let exitApproval = Webservice.baseUrl + "Admin/exit"
        private static let exitVisitoApproval = Webservice.baseUrl + "Admin/visitor_exit"
        private static let UploadImage = Webservice.baseUrl + "Admin/addDocumentVehicle"
        private static let AcceptORReject = Webservice.baseUrl + "Admin/request_decision"
        private static let SearchAprroveVehicle = Webservice.baseUrl + "Admin/entry_search"
        private static let MenuApi = Webservice.baseUrl + "Admin/approaval_api"
        private static let NotificationReset = Webservice.baseUrl + "Admin/approval_notification_seen"
        private static let ReportManagementCount = Webservice.baseUrl + "Employee/report_count"
        
        
        //MARK:- Gate Mangement Vehicle/Visitor Approval Log
        private static let visitorLog = Webservice.baseUrl + "Admin/all_logs_visitor"
        private static let visitorAporovalLog = Webservice.baseUrl + "Admin/visitor_request_list"
        private static let visitorSearchAprrove = Webservice.baseUrl + "Admin/visitor_entry_search"
        private static let visitorDetailLog = Webservice.baseUrl + "Admin/entry_visitor_detail"
        private static let updateVehicleEntry = Webservice.baseUrl + "Admin/update_vehicle_entry"
        private static let updateVisitorEntry = Webservice.baseUrl + "Admin/update_visitor_entry"
        private static let visitorAprroveAndReject = Webservice.baseUrl + "Admin/visitor_request_decision"
        
        
        //MARK:- Report Managment Log
        private static let reportSeen = Webservice.baseUrl + "Employee/report_seen"
        private static let StaffList = Webservice.baseUrl + "Admin/staff"
        private static let uploadReportList = Webservice.baseUrl + "Admin/upload_report_list"
        private static let LiveStrengthList = Webservice.baseUrl + "Admin/live_strength"
        private static let LogoutApp = Webservice.baseUrl + "Admin/logout"


        static func LoginApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: Login, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func LoginViaOTP(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: LoginWithOTP, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
       
        static func ForgotPasswordApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: ForgotPassword, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func ForgotMatchPasswordApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: ForgotMatchPassword, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func newPasswordApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: newPassword, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func PasswordUpdateApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: PasswordUpdate, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func SiteList(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: Site, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func LogoutApp(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: LogoutApp, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func NotificationUpdateApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: NotificationUpdate, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func SiteDeleteApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: SiteDelete, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func GetProfileDataApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: GetProfileData, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func NotificationListApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: NotificationList, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func RemoveProfilePhotoApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: RemoveProfilePhoto, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func AttendanceApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: Attendance, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func AttendanceListApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: AttendanceList, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func AttendanceFilterApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: AttendanceFilter, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func SOSApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: SOS, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func SelfieListApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: SelfieList, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func SOSLogListApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: SOSLogList, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func SOSFilterApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: SOSFilter, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func vehicleLogApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: vehicleLog, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func approveLogApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: approveLog, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func rejectLogApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: approveLog, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }


        static func vehicleDetailApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: vehicleDetail, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func exitApprovalApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: exitApproval, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func updateVehiclelApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: updateVehicleEntry, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func exitVisitorApprovalApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: exitVisitoApproval, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func UploadImage(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: UploadImage, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }

        static func AcceptORRejectApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: AcceptORReject, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func SearchAprroveVehicleApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: SearchAprroveVehicle, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func MenuApis(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: MenuApi, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func notificationResetApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: NotificationReset, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
       
        static func reportManagmentApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: ReportManagementCount, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        //MARK:- Visitor Log
        static func visitorLogApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: visitorLog, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func visitorAporovalLogApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: visitorAporovalLog, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func visitorSearchAprrovalApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: visitorSearchAprrove, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func visitorDetailLogApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: visitorDetailLog, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        //MARK:- Report Managment Log
        
        static func reportSeenApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: reportSeen, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func StaffListApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: StaffList, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func uploadReportList(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: uploadReportList, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func liveStrengthListApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: LiveStrengthList, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
        
        static func visitorAprroveAndRejectApi(parameter: Parameter, completion: @escaping APIResultBlock) {
            let endpoint = EndPoint(path: visitorAprroveAndReject, method: .post, parameter: parameter, authToken: Token, completion: completion)
            APIClient.shared.request(with: endpoint)
        }
                
    }

    enum Cancel {
        static func cancelPreviousAPICall(completion: @escaping () -> Void) {
            let sessionManager = Alamofire.SessionManager.default
            sessionManager.session.getTasksWithCompletionHandler {
                dataTasks, uploadTasks, downloadTasks in dataTasks.forEach {
                    $0.cancel()
                }
                uploadTasks.forEach {
                    $0.cancel()
                }
                downloadTasks.forEach {
                    $0.cancel()
                }
                completion()
            }
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

// MARK: - Video UpLoading in Background Mode

class Networking {
    static let sharedInstance = Networking()
    public var sessionManager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    private init() {
        sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.youApp.identifier.backgroundtransfer"))
    }
}
