//
//  ImagePickerHandler.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.
//

import AVFoundation
import Foundation
import MobileCoreServices
import Photos
import UIKit

@objc protocol ImagePickerDelegate {
    func imagePicked(imagePicked: UIImage, strImageName: String)
    @objc optional func imagePathPicked(strURL: String)
}

class ImagePickerHandler: NSObject {
    static let shared = ImagePickerHandler()
    fileprivate var currentVC: UIViewController?

    // MARK: - Internal Properties

    var imagePickedBlock: ((UIImage) -> Void)?
    var videoPickedBlock: ((NSURL) -> Void)?
    var filePickedBlock: ((URL) -> Void)?
    var delegate: ImagePickerDelegate?
    var isEditingAllow = true
    var isForChat = false

    enum AttachmentType: String {
        case camera, video, photoLibrary
    }

    // MARK: - showAttachmentActionSheet

    // This function is used to show the attachment sheet for image, video, photo and file.
    func showPhotoCaptureOptions(vc: UIViewController) {
        currentVC = vc
        let actionCntl = UIAlertController(title: "Options", message: "", preferredStyle: .actionSheet)
        actionCntl.addAction(UIAlertAction(title: PHOTO_OPTION.CAMERA, style: .default, handler: { _ in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self.currentVC!)
        }))
        actionCntl.addAction(UIAlertAction(title: PHOTO_OPTION.LIBRARY, style: .default, handler: { _ in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self.currentVC!)
        }))
        actionCntl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverPresentationController = actionCntl.popoverPresentationController {
            popoverPresentationController.sourceView = vc.view
            popoverPresentationController.sourceRect = CGRect(x: vc.view.bounds.size.width / 2.0, y: vc.view.bounds.size.height / 2.0, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }

        vc.present(actionCntl, animated: true, completion: nil)
    }

    // MARK: - Authorisation Status

    // This is used to check the authorisation status whether user gives access to import the image, photo library, video.
    // if the user gives access, then we can import the data safely
    // if not show them alert to access from settings.
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController) {
        currentVC = vc
        if attachmentTypeEnum == AttachmentType.camera {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                if attachmentTypeEnum == AttachmentType.camera {
                    openCamera()
                }
            case .denied:
                print("permission denied")
                DispatchQueue.main.async {
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            case .notDetermined:
                print("Permission Not Determined")
                AVCaptureDevice.requestAccess(for: .video) { status in
                    if status {
                        // photo library access given
                        print("access given")
                        if attachmentTypeEnum == AttachmentType.camera {
                            self.openCamera()
                        }
                    } else {
                        print("restriced manually")
                        DispatchQueue.main.async {
                            self.addAlertForSettings(attachmentTypeEnum)
                        }
                    }
                }
            case .restricted:
                print("permission restricted")
                DispatchQueue.main.async {
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            default:
                break
            }
        }

        if attachmentTypeEnum == AttachmentType.photoLibrary {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                if attachmentTypeEnum == AttachmentType.photoLibrary {
                    photoLibrary()
                }
            case .denied:
                print("permission denied")
                DispatchQueue.main.async {
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            case .notDetermined:
                print("Permission Not Determined")
                PHPhotoLibrary.requestAuthorization { status in
                    if status == PHAuthorizationStatus.authorized {
                        // photo library access given
                        print("access given")
                        if attachmentTypeEnum == AttachmentType.photoLibrary {
                            self.photoLibrary()
                        }
                    } else {
                        print("restriced manually")
                        DispatchQueue.main.async {
                            self.addAlertForSettings(attachmentTypeEnum)
                        }
                    }
                }
            case .restricted:
                print("permission restricted")
                DispatchQueue.main.async {
                    self.addAlertForSettings(attachmentTypeEnum)
                }
            default:
                break
            }
        }
    }

    // MARK: - CAMERA PICKER

    // This function is used to open camera from the iphone and
    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .camera
                myPickerController.allowsEditing = false
                let screenSize = UIScreen.main.bounds.size
                let cameraAspectRatio = CGFloat(4.0 / 3.0)
                let cameraImageHeight = screenSize.width * cameraAspectRatio
                let scale = screenSize.height / cameraImageHeight
                myPickerController.cameraViewTransform = CGAffineTransform(translationX: 0, y: (screenSize.height - cameraImageHeight) / 2)
                myPickerController.cameraViewTransform = myPickerController.cameraViewTransform.scaledBy(x: scale, y: scale)

                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - PHOTO PICKER

    func photoLibrary() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = .photoLibrary
                myPickerController.allowsEditing = self.isEditingAllow
                self.currentVC?.present(myPickerController, animated: true, completion: nil)
            }
        }
    }

    // MARK: - SETTINGS ALERT

    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType) {
        var strAlertTitle = ""
        if attachmentTypeEnum == AttachmentType.camera {
            strAlertTitle = AlertMessages.ALERT_CAMERA_ACCESS_MESSAGE
        }
        if attachmentTypeEnum == AttachmentType.photoLibrary {
            strAlertTitle = AlertMessages.ALERT_PHOTO_LIBRARY_MESSAGE
        }
        App_AlertView.shared.SimpleMessage(Text: strAlertTitle)
//        App_AlertView.shared.AlertWithDoubleButton(Text: strAlertTitle , Button1Title: "Cancel".localized, Button1Action: {
//        }, Button1BGCOLOR: AppColor.Color_TopHeader, Button2Title: "Settings".localized, Button2Action: {
//            let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
//            if let url = settingsUrl {
//                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//            }
//        }, Button2BGCOLOR: AppColor.Color_Red)
    }
}

// MARK: - IMAGE PICKER DELEGATE

// This is responsible for image picker interface to access image, video and then responsibel for canceling the picker
extension ImagePickerHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        currentVC?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        currentVC?.dismiss(animated: true, completion: nil)

        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
    }
}
