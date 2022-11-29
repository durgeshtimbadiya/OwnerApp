//
//  UIImage.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import Foundation
import UIKit

extension UIImage {
    func setTintColor(color: UIColor) -> UIImage {
        if #available(iOS 13.0, *) {
            return self.withTintColor(color)
        } else {
            var image = withRenderingMode(.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            color.set()
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}
