//
//  ListVC.swift
//  TimeSlot
//
//  Created by com on 7/21/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ListViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let titleView = navigationController?.navTitleWithImageAndText(titleText: "Contract List")
        tabBarController?.navigationItem.titleView = titleView
        
        guard let man = Backend.shared().user else { return }
        
        if man.type == UserType.coach.rawValue {
            viewModel.getContractsOfCoach(id: man.uid)
            
        } else {
            viewModel.getContracts(id: man.uid)
        }
        
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: -
extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contracts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let startDate = Date().startOfWeek else { return "" }
        
        let endDate = startDate.addingTimeInterval(60*60*24*6)
        
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy MMMM dd, E"
        
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MMMM dd, E"
        
        let str = formatter1.string(from: startDate) + " ~ " + formatter2.string(from: endDate)
        return str
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTVCell", for: indexPath) as! ListTVCell
        
        let item = viewModel.contracts[indexPath.row]
        cell.showInfo(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
