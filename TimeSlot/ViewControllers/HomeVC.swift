//
//  HomeVC.swift
//  TimeSlot
//
//  Created by com on 7/21/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import SDWebImage
import ProgressHUD
import LocationPicker

class HomeVC: UIViewController {

    @IBOutlet weak var imgViewAvatar: UIImageView!
    @IBOutlet weak var btnUploadAvatar: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = HomeViewModel()
    
    var location: Location? {
        didSet {
            lblLocation.text = location.flatMap({ $0.title }) ?? ""
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleView = navigationController?.navTitleWithImageAndText(titleText: "Profile")
        tabBarController?.navigationItem.titleView = titleView
        
        let barItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(btnLogoutTapped(_:)))
        barItem.tintColor = .white
        tabBarController?.navigationItem.rightBarButtonItem = barItem
        
        updateInfo()
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
    @objc func btnLogoutTapped(_ sender: Any) {
        print("log out")
        tabBarController?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func changedSegmentValue(_ sender: Any) {
        btnCreate.isHidden = (segmentType.selectedSegmentIndex == 0 && Backend.shared().user!.type == UserType.personal.rawValue)
        collectionView.reloadData()
    }
    
    
    @IBAction func btnAvatarTapped(_ sender: Any) {
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
    
    
    @objc func btnSignupContract(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ContractVC") as! ContractVC
        vc.contract = viewModel.myContracts[sender.tag]
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCreateTapped(_ sender: Any) {
        if let user = Backend.shared().user, user.type == UserType.coach.rawValue {
            if segmentType.selectedSegmentIndex == 0 {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddContractVC") as! AddContractVC
                self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddScheduleVC") as! AddScheduleVC
                self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
            }
            
        } else if let user = Backend.shared().user, user.type == UserType.personal.rawValue {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddChildVC") as! AddChildVC
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func btnRemoveChildTapped(_ sender: UIButton) {
        let index = sender.tag
        let child = viewModel.mySubs[index] as! FDChild
        
        ProgressHUD.show()
        viewModel.removeChildren(child: child) { (error) in
            ProgressHUD.dismiss()
            
            guard error == nil else {
                let alert = UIAlertController(title: nil, message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            self.collectionView.reloadData()
        }
    }
    
    @objc func lblNameTapGestureHandler(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = Backend.shared().user!.username
            textField.placeholder = "Enter your profile name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text =  alert.textFields![0].text {
                self.lblName.text = text
                self.uploadProfileName(text)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func lblLocationTapGestureHandler(_ sender: Any) {
        let locationPicker = LocationPickerViewController()
        locationPicker.location = location
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        
        locationPicker.completion = { self.location = $0; self.uploadLocation(self.location!) }
        
        tabBarController?.navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    
    // MARK: private method
    
    func uploadUserInfo(_ info: Any) {
        if let user = info as? FDBusiness {
            ProgressHUD.show()
            Backend.updateBusiness(user: user) { (error) in
                ProgressHUD.dismiss()
                if error != nil {
                    let alert = UIAlertController(title: nil, message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
        } else if let user = info as? FDPersonal {
            ProgressHUD.show()
            Backend.updatePersonal(user: user) { (error) in
                ProgressHUD.dismiss()
                if error != nil {
                    let alert = UIAlertController(title: nil, message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
    
    
    func uploadProfileName(_ name: String) {
        if Backend.shared().business != nil {
            Backend.shared().business!.username = name
            self.uploadUserInfo(Backend.shared().business!)
            
        } else if Backend.shared().personal != nil {
            Backend.shared().personal!.username = name
            self.uploadUserInfo(Backend.shared().personal!)
        }
    }
    
    
    func uploadLocation(_ loc: Location) {
        if Backend.shared().business != nil {
            Backend.shared().business!.location = loc.title ?? ""
            Backend.shared().business!.longitude = loc.coordinate.longitude
            Backend.shared().business!.latitude = loc.coordinate.latitude
            self.uploadUserInfo(Backend.shared().business!)
            
        } else if Backend.shared().personal != nil {
            Backend.shared().personal!.location = loc.title ?? ""
            self.uploadUserInfo(Backend.shared().personal!)
        }
    }
    
    
    func uploadProfileImage(image: UIImage) {
        ProgressHUD.show()
        
        Backend.uploadProfileImage(Backend.shared().user!.uid, image: image) { (error, url) in
            ProgressHUD.dismiss()
            
            if error != nil || url == nil {
                let alert = UIAlertController(title: nil, message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if Backend.shared().business != nil {
                Backend.shared().business!.photoUri = url!.absoluteString
                self.uploadUserInfo(Backend.shared().business!)
                
            } else if Backend.shared().personal != nil {
                Backend.shared().personal!.photoUri = url!.absoluteString
                self.uploadUserInfo(Backend.shared().personal!)
            }
        }
    }
    
    
    private func setupUI() {
        imgViewAvatar.layer.cornerRadius = imgViewAvatar.frame.width / 2
        imgViewAvatar.clipsToBounds = true
        imgViewAvatar.layer.borderWidth = 3
        imgViewAvatar.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        
        btnUploadAvatar.backgroundColor = UIColor.tsAccent
        btnUploadAvatar.layer.cornerRadius = btnUploadAvatar.frame.width / 2
        btnUploadAvatar.clipsToBounds = true
        btnUploadAvatar.layer.borderWidth = 1
        btnUploadAvatar.layer.borderColor = UIColor.white.cgColor
        
        btnEditProfile.layer.cornerRadius = btnUploadAvatar.frame.height / 2
        btnEditProfile.clipsToBounds = true
        btnEditProfile.layer.borderWidth = 1
        btnEditProfile.layer.borderColor = UIColor.white.cgColor
        
        lblName.isUserInteractionEnabled = true
        lblName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lblNameTapGestureHandler(_:))))
        
        lblLocation.isUserInteractionEnabled = true
        lblLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lblLocationTapGestureHandler(_:))))
        
        btnCreate.layer.cornerRadius = btnUploadAvatar.frame.height / 2
        btnCreate.clipsToBounds = true
        btnCreate.layer.borderWidth = 1
        btnCreate.layer.borderColor = UIColor.black.cgColor
        
        segmentType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tsMainBlue!], for: .selected)
        segmentType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
    }
    
    
    private func updateInfo() {
        guard let man = Backend.shared().user else { return }
        
        btnCreate.isHidden = (segmentType.selectedSegmentIndex == 0 && Backend.shared().user!.type == UserType.personal.rawValue)
        
        if man.type == UserType.coach.rawValue {
            segmentType.setTitle("UNAVAILABLE", forSegmentAt: 1)
            
            guard let user = Backend.shared().business else { return }
            if user.available_mode == true {segmentType.setTitle("AVAILABLE", forSegmentAt: 1)}
            lblName.text = user.username
            lblLocation.text = user.location
            lblEmail.text = user.email
            lblPhone.text = user.phoneNumber
            imgViewAvatar.sd_setImage(with: URL(string: user.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            
            viewModel.getContracts(id: Backend.shared().user!.uid)
            viewModel.getUnavailables(id: Backend.shared().user!.uid)
            
        } else {
            segmentType.setTitle("CHILDREN", forSegmentAt: 1)
            
            guard let user = Backend.shared().personal else { return }
            lblName.text = user.username
            lblLocation.text = user.location
            lblEmail.text = user.email
            lblPhone.text = user.phoneNumber
            imgViewAvatar.sd_setImage(with: URL(string: user.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            
            viewModel.getContractsOfCoach(id: Backend.shared().user!.uid)
            viewModel.getChildrens(id: Backend.shared().user!.uid)
        }
        
        collectionView.reloadData()
    }
}


// MARK: -
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentType.selectedSegmentIndex == 0 { // CONTRACTS
            return viewModel.myContracts.count
            
        } else {
            return viewModel.mySubs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentType.selectedSegmentIndex == 0 { // CONTRACTS
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContractCVCell", for: indexPath) as! ContractCVCell
            
            cell.setCellType(Backend.shared().user!.type == UserType.coach.rawValue)
            
            cell.btnSignUp.tag = indexPath.row
            cell.btnSignUp.addTarget(self, action: #selector(btnSignupContract(_:)), for: .touchUpInside)
            
            if let item = viewModel.myContracts[indexPath.row] as? FDPrivateContract {
                cell.lblTitle.text = item.title
                cell.lblNote.text = item.descript
                cell.lblPeoples.text = "1"
                cell.lblRate.text = String(format: "$ %.2f/HR", item.hourlyRate)
                
                if let coach = Backend.getBusiness(item.businessId) {
                    cell.imgViewAvatar.sd_setImage(with: URL(string: coach.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                    cell.lblOwner.text = coach.username
                }
                
            } else if let item = viewModel.myContracts[indexPath.row] as? FDGroupContract {
                cell.lblTitle.text = item.title
                cell.lblNote.text = item.descript
                cell.lblPeoples.text = "2 ~ \(item.maxPlayers)"
                cell.lblRate.text = String(format: "$ %.2f/HR", item.hourlyRate)
                
                if let coach = Backend.getBusiness(item.businessId) {
                    cell.imgViewAvatar.sd_setImage(with: URL(string: coach.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                    cell.lblOwner.text = coach.username
                }
            }
            
            return cell
            
        } else { // UNAVAILBLE or CHILDREN
            if Backend.shared().user!.type == UserType.coach.rawValue { // UNAVAILBLE
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnavailableCVCell", for: indexPath) as! UnavailableCVCell
                
                let item = viewModel.mySubs[indexPath.row]
                cell.showData(item)
                
                return cell
                
            } else { // CHILDREN
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildrenCVCell", for: indexPath) as! ChildrenCVCell
                
                let item = viewModel.mySubs[indexPath.row]
                cell.btnRemove.tag = indexPath.row
                cell.btnRemove.addTarget(self, action: #selector(btnRemoveChildTapped(_:)), for: .touchUpInside)
                cell.showInfo(item as! FDChild)
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if segmentType.selectedSegmentIndex == 0 { // CONTRACTS
            return CGSize(width: collectionView.frame.width - 20, height: 150)
        } else {
            return CGSize(width: collectionView.frame.width - 20, height: 95)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
}


// MARK: -
extension HomeVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        self.imgViewAvatar.image = image
        
        picker.dismiss(animated: true, completion: nil)
        self.uploadProfileImage(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
