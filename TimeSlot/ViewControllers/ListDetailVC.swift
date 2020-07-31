//
//  ListDetailVC.swift
//  TimeSlot
//
//  Created by com on 7/29/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ListDetailVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contract: Any?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Time Slot"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(btnBackTapped(_:)))
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: -
extension ListDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailContractCell", for: indexPath) as! ListDetailContractCell
            cell.showInfo(contract!)
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailClientCell", for: indexPath) as! ListDetailClientCell
            cell.showInfo(contract!)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListDetailUserCell", for: indexPath) as! ListDetailUserCell
            cell.showInfo(contract!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else if indexPath.section == 1 {
            return 100
        } else {
            return 70
        }
    }
}
