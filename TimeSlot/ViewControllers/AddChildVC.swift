//
//  AddChildVC.swift
//  TimeSlot
//
//  Created by com on 8/2/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import ProgressHUD

class AddChildVC: UIViewController {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnUploadAvatar: UIButton!
    @IBOutlet weak var lblName: UITextField!
    @IBOutlet weak var lblBirthday: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imgAvatar.roundView(radius: imgAvatar.frame.width / 2, borderWidth: 2, borderColor: UIColor.white.withAlphaComponent(0.8))
        btnUploadAvatar.roundView(radius: btnUploadAvatar.frame.width / 2, borderWidth: 1, borderColor: UIColor.white.withAlphaComponent(0.8))
        
        lblName.attributedPlaceholder = NSAttributedString(string: "Child Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lblName.delegate = self
        
        lblBirthday.attributedPlaceholder = NSAttributedString(string: "Birthday", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        lblBirthday.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let picker = UIDatePicker()
        picker.date = Date()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        lblBirthday.inputView = picker
        
        navigationItem.title = "Child"
        navigationController?.navigationBar.tintColor = .white
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(btnBackTapped(_:)))
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
        lblName.resignFirstResponder()
        lblBirthday.resignFirstResponder()
    }
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        let formater = DateFormatter()
        formater.dateFormat = "MMM dd, yyyy"
        lblBirthday.text = formater.string(from: sender.date)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        guard let name = lblName.text, let strBirth = lblBirthday.text else { return }
        
        let formater = DateFormatter()
        formater.dateFormat = "MMM dd, yyyy"
        let birth = formater.date(from: strBirth)
        
        ProgressHUD.show()
        
        Backend.addChild(name: name, birth: birth!) { (error) in
            ProgressHUD.dismiss()
            
            guard error == nil else {
                let alert = UIAlertController(title: nil, message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


// MARK: -
extension AddChildVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapGestureHandler(self)
        
        if textField == lblName {
            lblBirthday.becomeFirstResponder()
            
        } else if textField == lblBirthday {
            btnDone(self)
        }
        
        return true
    }
}

