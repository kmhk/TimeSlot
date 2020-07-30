//
//  SearchVC.swift
//  TimeSlot
//
//  Created by com on 7/21/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = SearchViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleView = navigationController?.navTitleWithImageAndText(titleText: "My List")
        tabBarController?.navigationItem.titleView = titleView
        
        guard let man = Backend.shared().user else { return }
        
        if man.type == UserType.coach.rawValue {
            viewModel.getFollowingUsers(id: man.uid)
            
        } else {
            viewModel.getCoaches()
        }
        
        collectionView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func btnAddTapped(_ sender: UIButton) {
        guard let man = Backend.shared().user else { return }
        let item = viewModel.users[sender.tag]
        
        if man.type == UserType.coach.rawValue {
            viewModel.addFollowerTo(coachID: man.uid, personID: (item as! FDPersonal).uid) { (error) in
                if let error = error { print("\(error.localizedDescription)") }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        } else {
            viewModel.requestFollowerTo(coachID: (item as! FDBusiness).uid, personID: man.uid) { (error) in
                if let error = error { print("\(error.localizedDescription)") }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    @objc func btnWaitingTapped(_ sender: UIButton) {
        guard let man = Backend.shared().user else { return }
        let item = viewModel.users[sender.tag]
        
        if man.type == UserType.coach.rawValue {
            print("no need to implement coach's waiting")
            
        } else {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to cancel this follow request?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
                self.viewModel.cancelRequestFollowFrom(coachID: (item as! FDBusiness).uid, personID: man.uid) { (error) in
                    if let error = error { print("\(error.localizedDescription)") }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @objc func btnCloseTapped(_ sender: UIButton) {
        guard let man = Backend.shared().user else { return }
        let item = viewModel.users[sender.tag]
        
        if man.type == UserType.coach.rawValue {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to cancel this follow request?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
                self.viewModel.cancelRequestFollowFrom(coachID: man.uid, personID: (item as! FDPersonal).uid) { (error) in
                    if let error = error { print("\(error.localizedDescription)") }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: nil, message: "Are you sure you want to cancel this follow request?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
                self.viewModel.cancelRequestFollowFrom(coachID: (item as! FDBusiness).uid, personID: man.uid) { (error) in
                    if let error = error { print("\(error.localizedDescription)") }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: -
extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCVCell", for: indexPath) as! UserCVCell
        
        cell.showInfo(viewModel.users[indexPath.row])
        
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self, action: #selector(btnAddTapped(_:)), for: .touchUpInside)
        
        cell.btnWaiting.tag = indexPath.row
        cell.btnWaiting.addTarget(self, action: #selector(btnWaitingTapped(_:)), for: .touchUpInside)
        
        cell.btnClose.tag = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(btnCloseTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 20, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
}
