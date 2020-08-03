//
//  SignUpRoleVC.swift
//  TimeSlot
//
//  Created by com on 8/3/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class SignUpRoleVC: UIViewController {
    
    var user: FDUser?
    var pwd: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNext" {
            let vc = segue.destination as! SignUpDetail
            vc.user = user
            vc.pwd = pwd
            vc.userType = ((sender as! String) == "personal" ? UserType.personal : UserType.coach)
        }
    }

    @IBAction func btnPersonalTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueNext", sender: "personal")
    }
    
    @IBAction func btnBusinessTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "segueNext", sender: "business")
    }
}
