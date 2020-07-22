//
//  SignUpVC.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    @IBOutlet weak var txtPwdConfirm: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtEmail.delegate = self
        
        txtUser.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtUser.delegate = self
        
        txtPwd.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtPwd.delegate = self
        
        txtPwdConfirm.attributedPlaceholder = NSAttributedString(string: "Retype Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtPwdConfirm.delegate = self
        
        txtPhone.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtPhone.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        view.addGestureRecognizer(tapGesture)
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

    
    // MARK: button action
    
    @IBAction func btnDoneTapped(_ sender: Any) {
    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }
    
    
    @objc func tapGestureHandler(_ sender: Any) {
        txtEmail.resignFirstResponder()
        txtUser.resignFirstResponder()
        txtPwd.resignFirstResponder()
        txtPwdConfirm.resignFirstResponder()
        txtPhone.resignFirstResponder()
    }
}


// MARK: -
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapGestureHandler(self)
        
        if textField == txtEmail {
            txtUser.becomeFirstResponder()
            
        } else if textField == txtUser {
            txtPwd.becomeFirstResponder()
            
        } else if textField == txtPwd {
            txtPwdConfirm.becomeFirstResponder()
            
        } else if textField == txtPwdConfirm {
            txtPhone.becomeFirstResponder()
            
        } else if textField == txtPhone {
            btnDoneTapped(self)
        }
        
        return true
    }
}
