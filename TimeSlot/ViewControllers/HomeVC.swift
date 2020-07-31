//
//  HomeVC.swift
//  TimeSlot
//
//  Created by com on 7/21/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import SDWebImage

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
    }
    
    
    @IBAction func changedSegmentValue(_ sender: Any) {
        btnCreate.isHidden = (segmentType.selectedSegmentIndex == 0)
        collectionView.reloadData()
    }
    
    
    @objc func btnSignupContract(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ContractVC") as! ContractVC
        vc.contract = viewModel.myContracts[sender.tag]
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: private method
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
        
        btnCreate.layer.cornerRadius = btnUploadAvatar.frame.height / 2
        btnCreate.clipsToBounds = true
        btnCreate.layer.borderWidth = 1
        btnCreate.layer.borderColor = UIColor.black.cgColor
        
        segmentType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.tsMainBlue!], for: .selected)
        segmentType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
    }
    
    
    private func updateInfo() {
        guard let man = Backend.shared().user else { return }
        
        if man.type == UserType.coach.rawValue {
            segmentType.setTitle("UNAVAILABLE", forSegmentAt: 1)
            
            guard let user = Backend.shared().business else { return }
            lblName.text = user.username
            lblLocation.text = user.location
            lblEmail.text = user.email
            lblPhone.text = user.phoneNumber
            imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: user.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            
            viewModel.getContracts(id: Backend.shared().user!.uid)
            viewModel.getUnavailables(id: Backend.shared().user!.uid)
            
        } else {
            segmentType.setTitle("CHILDREN", forSegmentAt: 1)
            
            btnCreate.isHidden = (segmentType.selectedSegmentIndex == 0)
            
            guard let user = Backend.shared().personal else { return }
            lblName.text = user.username
            lblLocation.text = user.location
            lblEmail.text = user.email
            lblPhone.text = user.phoneNumber
            imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: user.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            
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
                    cell.imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: coach.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                    cell.lblOwner.text = coach.username
                }
                
            } else if let item = viewModel.myContracts[indexPath.row] as? FDGroupContract {
                cell.lblTitle.text = item.title
                cell.lblNote.text = item.descript
                cell.lblPeoples.text = "2 ~ \(item.maxPlayers)"
                cell.lblRate.text = String(format: "$ %.2f/HR", item.hourlyRate)
                
                if let coach = Backend.getBusiness(item.businessId) {
                    cell.imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: coach.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                    cell.lblOwner.text = coach.username
                }
            }
            
            return cell
            
        } else { // UNAVAILBLE or CHILDREN
            if Backend.shared().user!.type == UserType.coach.rawValue { // UNAVAILBLE
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UnavailableCVCell", for: indexPath) as! UnavailableCVCell
                
                let item = viewModel.mySubs[indexPath.row]
                cell.showData(item as! FDUnavailable)
                
                return cell
                
            } else { // CHILDREN
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildrenCVCell", for: indexPath) as! ChildrenCVCell
                
                let item = viewModel.mySubs[indexPath.row]
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
