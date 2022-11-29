//
//  ImageViewController.swift
//  EmployeeApp
//
//  Created by Eppancy on 05/10/22.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
//    var image = UIImage(named: "nopreview")
    var imageURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.+
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        imageView.image = UIImage(named: "nopreview")
        imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "nopreview"), options: .refreshCached, completed: nil)
    }
    
    @IBAction func tapOnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
