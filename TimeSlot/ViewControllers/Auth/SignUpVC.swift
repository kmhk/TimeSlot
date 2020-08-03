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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNext" {
            let vc = segue.destination as! SignUpRoleVC
            vc.user = sender as? FDUser
            vc.pwd = txtPwd.text
        }
    }

    
    // MARK: button action
    
    @IBAction func btnDoneTapped(_ sender: Any) {
        guard let email = txtEmail.text, let name = txtUser.text, let pwd = txtPwd.text, let pwdConfirm = txtPwdConfirm.text, let phone = txtPhone.text else { return }
        guard email.count > 0, name.count > 0, pwd.count > 0, phone.count > 0, pwd == pwdConfirm else { return }
        
        let user = FDUser([:])
        user.email = email
        user.username = name
        user.phoneNumber = phone
        
        self.performSegue(withIdentifier: "segueNext", sender: user)
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
