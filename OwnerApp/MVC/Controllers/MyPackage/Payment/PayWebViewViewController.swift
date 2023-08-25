//
//  PayWebViewViewController.swift
//  OwnerApp
//
//  Created by Durgesh on 18/07/23.
//

import UIKit
import WebKit
import ProgressHUD

class PayWebViewViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    var webURL: URL?
    var order_id = -1
    var htmlString: String?
    var siteName = ""
    
    @IBOutlet weak var webViewV: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = "Owner App"
        self.subTitleLabel.text = siteName
        webViewV.navigationDelegate = self
        if let url = webURL {
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Checking...")
            webViewV.load(URLRequest(url: url))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!//or use return self.navigationController for fetching app navigation bar colour
    }
}

extension PayWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // url_data
        if let urlString = webView.url?.absoluteString, !urlString.isEmpty {
            if urlString == "https://dev.sitepay.co.in/user/success" {
                let alertView = UIAlertController(title: "", message: "Congratulations, your package has been\nupgraded successfully !", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { action in
                    if let controller = self.navigationController?.children {
                        for cont in controller {
                            if cont is MenuVC {
                                self.navigationController?.popToViewController(cont, animated: true)
                                break
                            }
                        }
                    }
                }))
                alertView.addAction(UIAlertAction(title: "INVOICE", style: .default, handler: { action in
                    self.savePdf()
                }))
                self.present(alertView, animated: true)
            } else if urlString == "https://dev.sitepay.co.in/user/failed" {
                let alertView = UIAlertController(title: "", message: "Payment Failed", preferredStyle: .alert)
                alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alertView, animated: true)
            }
        }
//        webView.evaluateJavaScript("url_data", completionHandler: { (any, error) in
//            if let error = error {
//                print(error)
//            } else if let any = any {
//                print(any)
//            } else {
//                // what do??
//            }
//        })
        ProgressHUD.dismiss()
    }

     private func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
         ProgressHUD.dismiss()
    }
    
    func savePdf() {
        DispatchQueue.main.async {
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.colorBackground = .white
            ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
            ProgressHUD.show("Downloading Invoice...")
            let url = URL(string: "https://dev.sitepay.co.in/user/package_pdf/1689681516") //"\(pdfBaseURL)\(self.order_id)"
            DispatchQueue.main.async {
                if let pdfData = try? Data.init(contentsOf: url!) {
                    let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                    let pdfNameFromUrl = "OwnerApp-\(self.order_id)-Invoice.pdf"
                    let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            
                    do {
                        try pdfData.write(to: actualPath, options: .atomic)
                        self.showSavedPdf(url: "\(pdfBaseURL)\(self.order_id)", fileName: pdfNameFromUrl)
                        self.view.makeToast("PDF successfully saved!", duration: 1.0, position: .center)

                        print("pdf successfully saved!")
                    } catch {
                        print("Pdf could not be saved")
                    }
                }
            }
        }
    }
    
    func showSavedPdf(url:String, fileName:String) {
        if #available(iOS 10.0, *) {
            if let controller = self.navigationController?.children {
                for cont in controller {
                    if cont is MenuVC {
                        self.navigationController?.popToViewController(cont, animated: true)
                        break
                    }
                }
            }
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName)") {
                        // its your file! do what you want with it!
                        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: url.description))
                        dc.delegate = self
                        dc.presentPreview(animated: true)
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
            ProgressHUD.dismiss()
        }
    }

}
