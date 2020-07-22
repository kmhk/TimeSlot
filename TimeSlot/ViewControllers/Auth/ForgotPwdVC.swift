//
//  ForgotPwdVC.swift
//  TimeSlot
//
//  Created by com on 7/21/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ForgotPwdVC: UIViewController {
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txtUser.attributedPlaceholder = NSAttributedString(string: "example@test.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnOK.layer.borderWidth = 1.0
        btnOK.layer.cornerRadius = 1.0
        btnOK.layer.borderColor = UIColor.lightGray.cgColor
        
        btnCancel.layer.borderWidth = 1.0
        btnCancel.layer.cornerRadius = 1.0
        btnCancel.layer.borderColor = UIColor.tsAccentLight?.cgColor
        btnCancel.setTitleColor(UIColor.tsAccentLight, for: .normal)
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

    // MARK:
    @IBAction func btnCancelTapped(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }
}
