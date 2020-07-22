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
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = HomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        segmentType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .selected)
        segmentType.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        
        collectionView.dataSource = self
        collectionView.delegate = self
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
    
    // MARK: private method
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
            
            viewModel.getMyContracts()
            
        } else {
            segmentType.setTitle("CHILDREN", forSegmentAt: 1)
            
            guard let user = Backend.shared().personal else { return }
            lblName.text = user.username
            lblLocation.text = user.location
            lblEmail.text = user.email
            lblPhone.text = user.phoneNumber
            imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: user.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            
            viewModel.getContractsOfMyCoach()
        }
        
        collectionView.reloadData()
    }
}


// MARK: -
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.myContracts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentType.selectedSegmentIndex == 0 { // CONTRACTS
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContractCVCell", for: indexPath) as! ContractCVCell
            
            cell.setCellType(Backend.shared().user!.type == UserType.coach.rawValue)
            
            if let item = viewModel.myContracts[indexPath.row] as? FDPrivateContract {
                cell.lblTitle.text = item.title
                cell.lblNote.text = item.descript
                cell.lblPeoples.text = "1"
                cell.lblRate.text = String(format: "$ %.2f/HR", item.hourlyRate)
                
                if let coach = viewModel.getBusiness(item.businessId) {
                    cell.imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: coach.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                    cell.lblOwner.text = coach.username
                }
                
            } else if let item = viewModel.myContracts[indexPath.row] as? FDGroupContract {
                cell.lblTitle.text = item.title
                cell.lblNote.text = item.descript
                cell.lblPeoples.text = "2 ~ \(item.maxPlayers)"
                cell.lblRate.text = String(format: "$ %.2f/HR", item.hourlyRate)
                
                if let coach = viewModel.getBusiness(item.businessId) {
                    cell.imgViewAvatar.sd_setImage(with: URL(fileURLWithPath: coach.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                    cell.lblOwner.text = coach.username
                }
            }
            
            return cell
            
        } else { // UNAVAILBLE or CHILDREN
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
}
