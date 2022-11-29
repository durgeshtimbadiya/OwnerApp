//
//  APIClient.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Alamofire
import Foundation
import ProgressHUD

typealias Parameter = [String: Any]
typealias APIResultBlock = (APIClientResult) -> Void
typealias APIRawResultBlock = (APIClientRawResult) -> Void

typealias ResponseBody = Any

private let ResponseParseErrorMessage = "Sorry! we couldn't parse the server response."

struct APIResponse {
    var statusCode = 0
    var body: ResponseBody?
    var message: String = ""

    init() {}

    init(_ json: ResponseBody) {
        if let jSon = json as? [String: Any] {
            guard let code = jSon["code"] as? Int else { return }
            let msg = jSon["message"] as? String ?? ""
            statusCode = code
            body = jSon
            message = msg
        } else if let jSon = json as? [[String: Any]] {
            guard let code = jSon[0]["code"] as? Int else { return }
            guard let msg = jSon[0]["message"] as? String else { return }
            statusCode = code
            body = jSon[0]
            message = msg
        } else if let jSon = json as? String {
            body = jSon
        } else {
            statusCode = 200
            body = json
        }
    }
}

struct APIRawResponse {
    var statusCode: Int = 0
    var tokenStr: String?
    var message: String = ""

    init() {}

    init(_ json: ResponseBody) {
        //        guard let code = json["status"] as? Int else { return }
        //        guard let msg = json["message"] as? String else { return }
        //        guard let token = json["cftoken"] as? String else { return }
        //
        //        statusCode = code
        //        tokenStr = token
        //        message = msg

        if let jSon = json as? [String: Any] {
            guard let code = jSon["code"] as? Int else { return }
            guard let msg = jSon["message"] as? String else { return }

            statusCode = code
            message = msg
        }
    }
}

enum APIClientResult {
    case fail(String)
    case success(APIResponse)
}

enum APIClientRawResult {
    case fail(String)
    case success(APIRawResponse)
}

enum APIClientUploadDownloadResult {
    case fail(Error)
    case success(Any)
    case progress(Float)
}

protocol EndPointProtocol {
    var path: String { get set }
    var method: HTTPMethod { get set }
    var parameter: Parameter? { get set }
    var resultCompletion: APIResultBlock? { get set }
    var resultRawCompletion: APIRawResultBlock? { get set }
}

class MultipartFormDataModel {
    var name = String()
    var imgData = Data()
}

enum AccceptedResultType {
    case raw, statusValidated
}

struct EndPoint: EndPointProtocol {
    var path: String
    var method: HTTPMethod
    var parameter: Parameter?
    var resultCompletion: APIResultBlock?
    var resultRawCompletion: APIRawResultBlock?
    var authorizedToken: String?
    var showLoader: Bool = true
    var multipartFormData: [MultipartFormDataModel]?
    var headers: HTTPHeaders?
    var encoding: ParameterEncoding = URLEncoding.default
    var isRawData = false
    var isValidateByStatusCode = true

    init(path: String, method: HTTPMethod = .get, parameter: Parameter? = nil, authToken: String? = nil, showLoader: Bool = true, encoding: ParameterEncoding = URLEncoding.default, multipartFormData: [MultipartFormDataModel]? = nil, completion: @escaping APIResultBlock) {
        self.path = path
        self.method = method
        self.parameter = parameter
        authorizedToken = authToken
        resultCompletion = completion
        self.showLoader = showLoader
        self.multipartFormData = multipartFormData
        self.encoding = encoding
    }

    init(path: String, method: HTTPMethod = .get, parameter: Parameter? = nil, authToken: String? = nil, showLoader _: Bool = true, multipartFormData: [MultipartFormDataModel]? = nil, headers: HTTPHeaders? = nil, completion: @escaping APIRawResultBlock) {
        self.path = path
        self.method = method
        self.parameter = parameter
        authorizedToken = authToken
        resultRawCompletion = completion
//        self.showLoader = showLoader
        self.multipartFormData = multipartFormData
        self.headers = headers
    }
}

class APIClient: NSObject {
    static let shared = APIClient()

    let session = Alamofire.SessionManager.default

    func request(with endpoint: EndPoint) {
        if endpoint.showLoader {
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Checking...")
//            RappleActivityIndicatorView.startAnimatingWithLabel("Checking...")
//        ProjectUtilities.loadingShow()
        }

        var headers = APIClient.httpsHeaders(with: endpoint.authorizedToken)

        if endpoint.isRawData {
            headers["Content-Type"] = "application/json"
        }

//        if appDelegate.isLogin{
//            if endpoint.path.contains(Webservice.ECBaseUrl){
//                print("ecommerce:api caleld")
//                headers["Authorization"] = "Bearer \(USERDEFAULTS.value(forKey: EcommerceAccessToken) ?? "")"
//            }else {
//                headers["Authorization"] = "Bearer \(appDelegate.userLoginAccessDetails?.token ?? "")"
//            }
//        }
//
//        if endpoint.path.contains(Webservice.baseUrl){
//            headers["Accept-Language"] = Language.language.rawValue
//        }

        var newParams = endpoint.parameter

//        if endpoint.path.contains(Webservice.baseUrl){
//            if endpoint.method != .get{
//                if newParams != nil{
//                    newParams!["device_type"] = "i"
//                    newParams!["device_id"] = DeviceId
//                    newParams!["device_token"] = appDelegate.strFcmToken
//                    newParams!["device_version"] = systemVersion
//                }
//            }}

        var newEncoding = endpoint.encoding
        // newEncoding = JSONEncoding.default

//        print("******* API Log ******")
//        print("URL : ", endpoint.path)
//        print("Method : ", endpoint.method)
//        print("Params : ", newParams ?? [:])
//        print("Headers : \(headers)")

        session.request(endpoint.path, method: endpoint.method,
                        parameters: newParams,
                        encoding: newEncoding,
                        headers: headers)
            .responseJSON { response in

//                ProjectUtilities.loadingHide()
//                RappleActivityIndicatorView.stopAnimation()

                switch response.result {
                case let .failure(error):
                    endpoint.resultCompletion?(.fail(error.localizedDescription))

//                    if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
//                        print("Response failure : \(responseString)")
//                    }

                case let .success(value):
                    if let json = value as? ResponseBody {
                        let response = APIResponse(json)

                        if endpoint.isValidateByStatusCode {
                            if response.statusCode == 200 {
//                                print("Response  : \(response.body ?? "")")
//                                print("******* API Log ******")
                                endpoint.resultCompletion?(.success(response))
                            } else {
                                if let dictJson = json as? [String: AnyObject] {
                                    let response = APIResponse(json)
                                    if response.statusCode == 401 {
                                        USERDEFAULTS.set(nil, forKey: UserDefaults.Keys.UserLoginAccessDetails)
//                                        appDelegate.setRootViewController()
                                    }
//                                    print("Response  : \(response)")
//                                    print("******* API Log ******")
                                    endpoint.resultCompletion?(.fail(dictJson["message"] as? String ?? ""))
                                } else {
//                                    print("Response Failure  : \(response.message)")
//                                    print("******* API Log ******")
                                    endpoint.resultCompletion?(.fail(response.message))
                                }
                            }
                        } else {
//                            print("Response  : \(response.body ?? "")")
//                            print("******* API Log ******")
                            endpoint.resultCompletion?(.success(response))
                        }
                    } else {
                        endpoint.resultCompletion?(.fail(ResponseParseErrorMessage))

//                        if let data = response.data, let responseString = String(data: data, encoding: .utf8) {
//                            print("Response Failure  : \(responseString)")
//                            print("******* API Log ******")
//                        }
                    }
                }
                ProgressHUD.dismiss()
            }
    }

    func downloadRequest(with _: EndPoint) {}

    func uploadRequest(with endpoint: EndPoint) {
        if endpoint.showLoader {
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Checking...")
            //  ProjectUtilities.loadingShow()
        }

        var headers = APIClient.httpsHeaders(with: endpoint.authorizedToken)
//        if appDelegate.isLogin{
//            headers["Authorization"] = "Bearer \(appDelegate.userLoginAccessDetails?.token ?? "")"
//        }

        print(endpoint.path, "->", endpoint.parameter ?? "")

        var newParams = endpoint.parameter

        if endpoint.path.contains(Webservice.baseUrl), !endpoint.path.contains("photo_prescription/upload/images/") {
            if endpoint.method != .get {
//                 if newParams != nil{
//                     newParams!["device_type"] = "i"
//                     newParams!["device_id"] = DeviceId
//                     newParams!["device_token"] = appDelegate.strFcmToken
//                     newParams!["device_version"] = systemVersion
//                 }
            }
        }

        Alamofire.upload(multipartFormData: { multipartFormData in

            for item in endpoint.multipartFormData! {
                multipartFormData.append(item.imgData, withName: item.name, fileName: ProjectUtilities.findUniqueSavePathImage()!, mimeType: "file")
            }
            if newParams != nil {
                for (key, value) in newParams! {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }

        }, to: endpoint.path, headers: headers) { result in

            switch result {
            case let .success(upload, _, _):

                upload.uploadProgress(closure: { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in

//                    ProjectUtilities.loadingHide()
                    
                    switch response.result {
                    case let .failure(error):
                        endpoint.resultCompletion?(.fail(error.localizedDescription))

                    case let .success(value):
                        if let json = value as? ResponseBody {
                            let response = APIResponse(json)

                            if response.statusCode == 200 {
                                print(response.body ?? "")
                                endpoint.resultCompletion?(.success(response))
                            } else {
                                endpoint.resultCompletion?(.fail(response.message))
                            }
                        } else {
                            endpoint.resultCompletion?(.fail(ResponseParseErrorMessage))
                        }
                    }
                }
            case let .failure(error):
                endpoint.resultCompletion?(.fail(error.localizedDescription))
//                ProjectUtilities.loadingHide()
            }
            ProgressHUD.dismiss()
        }
    }

    func multipartRequest(with endpoint: EndPoint) {
        if endpoint.showLoader {
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Checking...")
            // ProjectUtilities.loadingShow()
        }
        var headers = APIClient.httpsHeaders(with: endpoint.authorizedToken)

        if endpoint.isRawData {
            headers["Content-Type"] = "application/json"
        }
        let newParams = endpoint.parameter

        var newEncoding = endpoint.encoding
        newEncoding = JSONEncoding.default

//        print("******* API Log ******")
//        print("URL : ", endpoint.path)
//        print("Method : ", endpoint.method)
//        print("Params : ", newParams ?? [:])
//        print("Headers : \(headers)")

        Alamofire.upload(multipartFormData: { multipartFormData in

            for item in endpoint.multipartFormData! {
                var mimeType = ""
                let dataMimeType = Swime.mimeType(data: item.imgData)
//                      mimeType = dataMimeType?.mime ?? ""
                mimeType = "video/mp4"
//                if (dataMimeType?.mime.contains("audio"))! == true {
//                    mimeType = "audio/mp3"
//                } else {
//                    mimeType = dataMimeType?.mime ?? ""
//                }
                multipartFormData.append(item.imgData, withName: item.name, fileName: ProjectUtilities.findUniqueSavePath(data: item.imgData)!, mimeType: mimeType)
//                print("******* Multipart Log ******")
//                print("Name : ", item.name)
//                print("mimeType : ", mimeType)
//                print("fileName : ", ProjectUtilities.findUniqueSavePath(data: item.imgData)!)
//                print("****************************")
            }
            if newParams != nil {
                for (key, value) in newParams! {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            }

        }, to: endpoint.path, headers: headers) { result in

            switch result {
            case let .success(upload, _, _):

                upload.uploadProgress(closure: { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in

//                    ProjectUtilities.loadingHide()

                    switch response.result {
                    case let .failure(error):
                        endpoint.resultCompletion?(.fail(error.localizedDescription))

                    case let .success(value):
                        if let json = value as? ResponseBody {
                            let response = APIResponse(json)

                            if response.statusCode == 200 {
                                print(response.body ?? "")
                                endpoint.resultCompletion?(.success(response))
                            } else {
                                endpoint.resultCompletion?(.fail(response.message))
                            }
                        } else {
                            endpoint.resultCompletion?(.fail(ResponseParseErrorMessage))
                        }
                    }
                }
            case let .failure(error):
                endpoint.resultCompletion?(.fail(error.localizedDescription))
//                ProjectUtilities.loadingHide()
            }
            ProgressHUD.dismiss()
        }
    }

    func requestRawData(with endpoint: EndPoint) {
        if endpoint.showLoader {
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Checking...")
            //  ProjectUtilities.loadingShow()
        }

        var headers: HTTPHeaders = [:]

        if let rh = endpoint.headers {
            headers = rh
        }

        print(endpoint.path, "->", endpoint.parameter ?? "")

        session.request(endpoint.path, method: endpoint.method,
                        parameters: endpoint.parameter, encoding: JSONEncoding.default,
                        headers: headers)
            .responseJSON { response in

//                ProjectUtilities.loadingHide()

                switch response.result {
                case let .failure(error):
                    endpoint.resultCompletion?(.fail(error.localizedDescription))

                case let .success(value):
                    if let json = value as? ResponseBody {
                        let response = APIRawResponse(json)

                        if response.statusCode == 200 {
                            print(response.tokenStr ?? "")
                            endpoint.resultRawCompletion?(.success(response))
                        } else {
                            print(json)
                            endpoint.resultRawCompletion?(.fail(response.message))
                        }
                    } else {
                        endpoint.resultRawCompletion?(.fail(ResponseParseErrorMessage))
                    }
                }
                ProgressHUD.dismiss()
            }
    }

    // class methods
    class func httpsHeaders(with token: String?) -> HTTPHeaders {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        if let token = token {
            defaultHeaders["token"] = "\(token)"
        }
        return defaultHeaders
    }
}
