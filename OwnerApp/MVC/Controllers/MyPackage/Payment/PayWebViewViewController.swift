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
    var isGoldSelected = false
    
    private var isInvoiceShow = false
    
    @IBOutlet weak var webViewV: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleLabel.text = AppName
        self.subTitleLabel.text = siteName
        webViewV.navigationDelegate = self
        
        if let htmlContent = htmlString {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ProgressHUD.animationType = .circleStrokeSpin
                ProgressHUD.colorBackground = .white
                ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
                ProgressHUD.show("Loading...")
//            }
            webViewV.loadHTMLString(htmlContent, baseURL: nil)
        } else if let url = webURL {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                ProgressHUD.animationType = .circleStrokeSpin
                ProgressHUD.colorBackground = .white
                ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
                ProgressHUD.show("Checking...")
            }
            webViewV.load(URLRequest(url: url))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            let statusbarView = UIView()
            statusbarView.backgroundColor = AppColor.Color_TopHeader
            view.addSubview(statusbarView)

            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = AppColor.Color_TopHeader
        }
    }
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        if isInvoiceShow, let controller = self.navigationController?.children {
            for cont in controller {
                if cont is MenuVC {
                    self.navigationController?.popToViewController(cont, animated: true)
                    return
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController!//or use return self.navigationController for fetching app navigation bar colour
    }
}

extension PayWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // url_data
        if let urlString = webView.url?.absoluteString, !urlString.isEmpty {
            if urlString == "https://sitepay.co.in/user/success" {
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
                    UserDefaults.standard.setValue(self.isGoldSelected ? "2" : "1", forKey: "currentSitePackage")
                    self.isInvoiceShow = true
                    self.savePdf()
                }))
                self.present(alertView, animated: true)
            } else if urlString == "https://sitepay.co.in/user/failed" {
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
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorBackground = .white
        ProgressHUD.colorAnimation = AppColor.Color_SkyBlueTitle
        ProgressHUD.show("Downloading Invoice...")
        if let url = URL(string: "\(pdfBaseURL)\(self.order_id)") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let pdfData = data {
                    DispatchQueue.main.async {
                        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                        let pdfNameFromUrl = "OwnerApp-\(self.order_id)-Invoice.pdf"
                        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                
                        do {
                            try pdfData.write(to: actualPath, options: .atomic)
                            self.showSavedPdf(url: "\(pdfBaseURL)\(self.order_id)", fileName: pdfNameFromUrl, webUrl: url)
                            self.view.makeToast("PDF successfully saved!", duration: 1.0, position: .center)
                            print("pdf successfully saved!")
                        } catch {
                            ProgressHUD.dismiss()
                            print("Pdf could not be saved")
                        }
                    }
                } else {
                    ProgressHUD.dismiss()
                }
            }.resume()
        } else {
            ProgressHUD.dismiss()
        }
    }
    
    func showSavedPdf(url:String, fileName:String, webUrl: URL) {
//        if #available(iOS 10.0, *) {
//            if let controller = self.navigationController?.children {
//                for cont in controller {
//                    if cont is MenuVC {
//                        self.navigationController?.popToViewController(cont, animated: true)
//                        break
//                    }
//                }
//            }
        isInvoiceShow = true
            webViewV.load(URLRequest(url: webUrl))

//            do {
//                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
//                for url in contents {
//                    if url.description.contains("\(fileName)") {
//                        // its your file! do what you want with it!
//                        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: url.description))
//                        dc.delegate = self
//                        dc.presentPreview(animated: true)
//                    }
//                }
//            } catch {
//                print("could not locate pdf file !!!!!!!")
//            }
            ProgressHUD.dismiss()
//        }
    }

}

