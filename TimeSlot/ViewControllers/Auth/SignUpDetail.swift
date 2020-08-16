//
//  SignUpDetail.swift
//  TimeSlot
//
//  Created by com on 8/3/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import ProgressHUD
import LocationPicker

class SignUpDetail: UIViewController {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var viewService: BorderdView!
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var lblDescription: UILabel!
    
    var location: Location? {
        didSet {
            txtLocation.text = location.flatMap({ $0.title }) ?? ""
        }
    }
    
    var user: FDUser?
    var pwd: String?
    var userType: UserType?
    
    let typeDescription = ["Available Mode lets you to select time you are available for business. You can make simple schedule for business.",
    "Unavailable Mode lets you to select time you are unavailable for business. You can make more flexible schedule for business."]

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
        
        txtLocation.delegate = self

        if userType == UserType.personal {
            viewService.isHidden = true
            segmentType.isHidden = true
            lblDescription.isHidden = true
            navigationItem.title = "Personal"
            
        } else {
            navigationItem.title = "Coach"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if #available(iOS 13.0, *), let navigationController = navigationController {
            let appearance = navigationController.navigationBar.standardAppearance
            appearance.backgroundColor = navigationController.navigationBar.barTintColor
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationItem.standardAppearance = appearance
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
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        lblDescription.text = typeDescription[segmentType.selectedSegmentIndex]
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
    
    @IBAction func btnAvatarTapped(_ sender: Any) {
        tapGestureHandler(self)
        
        let alert = UIAlertController(title: "", message: "Change your profile picture", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Choose from Photo Library", style: .default, handler: { (action) in
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Take from Camera", style: .default, handler: { (action) in
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
                man.longitude = (self.location?.coordinate.longitude ?? 0.0)
                man.latitude = (self.location?.coordinate.latitude ?? 0.0)
                man.service = self.btnService.title(for: .normal)!
                man.available_mode = (self.segmentType.selectedSegmentIndex == 0 ? true : false)
                
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtLocation {
            let locationPicker = LocationPickerViewController()
            locationPicker.location = location
            locationPicker.showCurrentLocationButton = true
            locationPicker.useCurrentLocationAsHint = true
            locationPicker.selectCurrentLocationInitially = true
            
            locationPicker.completion = { self.location = $0 }
            
            navigationController?.pushViewController(locationPicker, animated: true)
            
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tapGestureHandler(self)
        
        return true
    }
}


extension SignUpDetail: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        self.imgAvatar.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
