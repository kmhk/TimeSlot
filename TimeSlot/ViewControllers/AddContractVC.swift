//
//  AddContractVC.swift
//  TimeSlot
//
//  Created by com on 8/2/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import ProgressHUD

class AddContractVC: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var segmentType: UISegmentedControl!
    @IBOutlet weak var containerGroup: UIView!
    @IBOutlet weak var txtCount: UITextField!
    @IBOutlet weak var txtRate: UITextField!
    @IBOutlet weak var containerRate: UIView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "TimeSlot"
        navigationController?.navigationBar.tintColor = .white
        
        txtDescription.roundView(radius: 8, borderWidth: 1, borderColor: UIColor.gray.withAlphaComponent(0.3))
        btnCreate.squareGradientView()
        
        containerGroup.isHidden = true
        
        var frame = containerRate.frame
        frame.origin.y = containerGroup.frame.minY
        containerRate.frame = frame
        
        txtTitle.delegate = self
        txtCount.delegate = self
        txtRate.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func valueChangedSegment(_ sender: Any) {
        if segmentType.selectedSegmentIndex == 0 {
            containerGroup.isHidden = true
            
            var frame = containerRate.frame
            frame.origin.y = containerGroup.frame.minY
            containerRate.frame = frame
        } else {
            containerGroup.isHidden = false
            
            var frame = containerRate.frame
            frame.origin.y = containerGroup.frame.minY + 93
            containerRate.frame = frame
        }
    }
    
    @IBAction func btnCreateTapped(_ sender: Any) {
        var contract: Any?
        
        if segmentType.selectedSegmentIndex == 0 {
            if let title = txtTitle.text, let descript = txtDescription.text, let rate = txtRate.text {
                contract = FDPrivateContract([:])
                (contract as! FDPrivateContract).businessId = Backend.shared().business!.uid
                (contract as! FDPrivateContract).title = title
                (contract as! FDPrivateContract).descript = descript
                (contract as! FDPrivateContract).hourlyRate = Double(rate)!
                (contract as! FDPrivateContract).length = 60 * 60
            }
            
        } else {
            if let title = txtTitle.text, let descript = txtDescription.text, let count = txtCount.text, let rate = txtRate.text {
                contract = FDGroupContract([:])
                (contract as! FDGroupContract).businessId = Backend.shared().business!.uid
                (contract as! FDGroupContract).title = title
                (contract as! FDGroupContract).descript = descript
                (contract as! FDGroupContract).hourlyRate = Double(rate)!
                (contract as! FDGroupContract).length = 60 * 60
                (contract as! FDGroupContract).maxPlayers = Int(count)!
            }
        }
        
        ProgressHUD.show()
        AddContractModel().submitContract(contract!) { (error) in
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
extension AddContractVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var frame = view.bounds
        frame.size.height = frame.height - 270
        scrollView.frame = frame
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: containerRate.frame.maxY + 20)
    }
}
