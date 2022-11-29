//
//  UILableExtension.swift
//  EmployeeApp
//
//  Created by Jailove Mewara on 19/11/21.

import UIKit

extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font ?? "Montserrat-Regular"], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height / charSize))
        return linesRoundedUp
    }

    func setLineSpacing(lineSpacing: CGFloat = 1.0, lineHeightMultiple: CGFloat = 0.0) {
        guard let labelText = text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString: NSMutableAttributedString
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

        attributedText = attributedString
    }

    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = vissibleTextLength
        let mutableString: String = text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: (text?.count)! - lengthForVisibleString), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: (trimmedString?.count ?? 0) - readMoreLength, length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: font])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = lineBreakMode
        let labelWidth: CGFloat = frame.size.width
        let labelHeight: CGFloat = frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: text!, attributes: attributes as? [NSAttributedString.Key: Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index = 0
            var prev = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < text!.count && (text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key: Any], context: nil).size.height <= labelHeight
            return prev
        }
        return text!.count
    }
}
