//
//  UIImageViewExtension.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import SDWebImage
import UIKit

extension UIImageView {
    func setImageSDWebImage(imgURL: String) {
        let url = imgURL.replacingOccurrences(of: " ", with: "%20")
        sd_imageIndicator?.startAnimatingIndicator()
        sd_setImage(with: URL(string: url), completed: nil)
    }

    func tintImageColor(color: UIColor) {
        if image != nil {
            image = image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            tintColor = color
        }
    }

    func setImageWith(urlString: String, placeholder: UIImage?, imageIndicator: SDWebImageActivityIndicator, completion: ((UIImage?, Error?) -> Void)?) {
        if let url = URL(string: urlString) {
            sd_imageIndicator = imageIndicator
            sd_setImage(with: url, placeholderImage: placeholder, options: .retryFailed, context: nil, progress: nil) { img, error, _, _ in
                if error != nil {
                    if placeholder == nil {
                        self.image = UIImage(named: "profile-Placeholder")
                    } else {
                        self.image = placeholder
                    }
                }
                if completion != nil {
                    completion!(img, error)
                }
            }
        } else {
            image = placeholder ?? UIImage(named: "profile-Placeholder")
        }
    }
}

extension UIImage {
    func fixToLocalization() -> UIImage? {
        return imageFlippedForRightToLeftLayoutDirection()
//        if Language.language.rawValue == AppLanguages.Arabic {
//            return self.imageFlippedForRightToLeftLayoutDirection()
//        }
//        else if Language.language.rawValue == AppLanguages.English {
//            return UIImage()
//        }
//        else{
//          return UIImage()
//        }
    }

    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color1.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: size.width, height: size.height))
        context?.clip(to: rect, mask: cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    func fixOrientation() -> UIImage {
        if imageOrientation == UIImage.Orientation.up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
    }

    func imageResize(floatWidth: CGFloat, floatHeight: CGFloat) -> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(CGSize(width: floatWidth, height: floatHeight), !hasAlpha, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: floatWidth, height: floatHeight)))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }

    func compressImage(uptoKb: Double, completion: @escaping (UIImage?, Data?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            if let imageData = self.jpegData(compressionQuality: 0.5) {
                var resizingImage = self
                var imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
                var imgFinalData = imageData
                while imageSizeKB > uptoKb {
                    if let resizedImage = resizingImage.resized(withPercentage: 0.2),
                       let imageData = resizedImage.jpegData(compressionQuality: 0.1)
                    {
                        resizingImage = resizedImage
                        imageSizeKB = Double(imageData.count) / 1000.0 // ! Or devide for 1024 if you need KB but not kB
                        imgFinalData = imageData
                        //  print("There were \(imageData.count) bytes")
                        let bcf = ByteCountFormatter()
                        bcf.allowedUnits = [.useMB, .useKB] // optional: restricts the units to MB only
                        bcf.countStyle = .file
                        let string = bcf.string(fromByteCount: Int64(imageData.count))
                        print("Final image size is: \(string)")
                    }
                }
                completion(self, imgFinalData)
                return
            }
            completion(nil, nil)
        }
    }

    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let img = UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
        return img
    }
}
