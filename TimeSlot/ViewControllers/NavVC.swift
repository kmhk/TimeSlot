//
//  NavVC.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class NavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UINavigationBar.appearance().barTintColor = UIColor.tsMainDark
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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


// MARK: -
extension UINavigationController {
    func navTitleWithImageAndText(titleText: String) -> UIView {
        let titleView = UIView()
        
        let label = UILabel()
        label.text = titleText
        //label.sizeToFit()
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 36)
        label.textColor = .white
        label.center = titleView.center
        label.textAlignment = .center
        
        let image = UIImageView()
        image.image = UIImage(named: "imgLogo")
        
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect - 5
        let imageY = label.frame.origin.y
        
        let imageW = label.frame.size.height * imageAspect
        let imageH = label.frame.size.height
        
        image.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH)
        image.contentMode = .scaleAspectFit
        
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        titleView.sizeToFit()
        
        return titleView
    }
}
