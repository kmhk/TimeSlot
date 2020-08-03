//
//  SignUpDetail.swift
//  TimeSlot
//
//  Created by com on 8/3/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import ProgressHUD

class SignUpDetail: UIViewController {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var viewService: BorderdView!
    @IBOutlet weak var btnService: UIButton!
    
    var user: FDUser?
    var pwd: String?
    var userType: UserType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgAvatar.roundView(radius: imgAvatar.frame.width / 2, borderWidth: 2, borderColor: UIColor.white.withAlphaComponent(0.8))
        btnUpload.roundView(radius: btnUpload.frame.width / 2, borderWidth: 1, borderColor: UIColor.white.withAlphaComponent(0.8))
        
        txtLocation.attributedPlaceholder = NSAttributedString(string: "Location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtLocation.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        view.addGestureRecognizer(tapGesture)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .white

        if userType == UserType.personal {
            viewService.isHidden = true
            navigationItem.title = "Personal"
            
        } else {
            navigationItem.title = "Coach"
        }
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
    
    @objc func tapGestureHandler(_ sender: Any) {
        txtLocation.resignFirstResponder()
    }

    @IBAction func btnServiceTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: "Choose your service", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "soccer", style: .default, handler: { (action) in
            self.btnService.setTitle("soccer", for: .normal)
        }))
        actionSheet.addAction(UIAlertAction(title: "hockey", style: .default, handler: { (action) in
            self.btnService.setTitle("hockey", for: .normal)
        }))
        actionSheet.addAction(UIAlertAction(title: "basketball", style: .default, handler: { (action) in
            self.btnService.setTitle("basketball", for: .normal)
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        guard let location = txtLocation.text, location.count > 0 else { return }
        if let userType = self.userType, userType == .coach, btnService.title(for: .normal) == "Service" { return }
        
        let errorhandler: ((Error)->()) = { error in
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        user!.type = userType!.rawValue
        
        ProgressHUD.show()
        Backend.submitUser(user: user!, pwd: pwd!) { (error) in
            guard error == nil else { errorhandler(error!); return }
            
            if self.userType! == .coach {
                let man = FDBusiness([:])
                man.type = self.userType!.rawValue
                man.uid = self.user!.uid
                man.username = self.user!.username
                man.email = self.user!.email
                man.phoneNumber = self.user!.phoneNumber
                man.location = location
                man.service = self.btnService.title(for: .normal)!
                
                Backend.submitBusiness(user: man) { (error) in
                    ProgressHUD.dismiss()
                    guard error == nil else { errorhandler(error!); return }
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            } else {
                let man = FDPersonal([:])
                man.type = self.userType!.rawValue
                man.uid = self.user!.uid
                man.username = self.user!.username
                man.email = self.user!.email
                man.phoneNumber = self.user!.phoneNumber
                man.location = location
                
                Backend.submitPersonal(user: man) { (error) in
                    ProgressHUD.dismiss()
                    guard error == nil else { errorhandler(error!); return }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
}

// MARK: -
extension SignUpDetail: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapGestureHandler(self)
        
        return true
    }
}

