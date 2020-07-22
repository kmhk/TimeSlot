//
//  LoginVC.swift
//  TimeSlot
//
//  Created by com on 7/20/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPwd: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtUser.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtUser.delegate = self
        
        txtPwd.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        txtPwd.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Backend.shared().delegate = self
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Backend.shared().delegate = nil
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
        guard txtUser.text != "" && txtPwd.text != "" else { return }
        
        let showMsg: (String)->() = { msg in
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        ProgressHUD.fontStatus = .boldSystemFont(ofSize: 17.0)
        ProgressHUD.show("Loading ...")
        
        Backend.loginUser(email: txtUser.text!, pwd: txtPwd.text!) { (error) in
            ProgressHUD.dismiss()
            guard error == nil else {
                showMsg(error!.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: "segueNext", sender: nil)
        }
    }
    
    
    @objc func tapGestureHandler(_ sender: Any) {
        txtUser.resignFirstResponder()
        txtPwd.resignFirstResponder()
    }
    
}


// MARK: -
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapGestureHandler(self)
        
        if textField == txtUser {
            txtPwd.becomeFirstResponder()
            
        } else if textField == txtPwd {
            btnDoneTapped(self)
        }
        
        return true
    }
}


// MARK: -
extension LoginVC: BackendDelegate {
    func finishedLoadUser() {
        ProgressHUD.fontStatus = .boldSystemFont(ofSize: 17.0)
        ProgressHUD.show("Loading User Details ...")
    }
    
    func finishedLoadSchedule() {
        ProgressHUD.fontStatus = .boldSystemFont(ofSize: 17.0)
        ProgressHUD.show("Loading Schedules ...")
    }
    
    func finishedSubmission() {
        ProgressHUD.fontStatus = .boldSystemFont(ofSize: 17.0)
        ProgressHUD.show("Loading Contract Submissions ...")
    }
    
    func finishedContract() {
        ProgressHUD.fontStatus = .boldSystemFont(ofSize: 17.0)
        ProgressHUD.show("Loading Contracts ...")
    }
    
    func finishedUnavailable() {
        ProgressHUD.fontStatus = .boldSystemFont(ofSize: 17.0)
        ProgressHUD.show("Loading Completed")
    }
}
