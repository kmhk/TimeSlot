//
//  AddScheduleVC.swift
//  TimeSlot
//
//  Created by com on 8/3/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import ProgressHUD

class AddScheduleVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtNote: UITextView!
    
    @IBOutlet weak var viewStartDate: UIView!
    @IBOutlet weak var txtStartDate: UITextField!
    
    @IBOutlet weak var viewEndDate: UIView!
    @IBOutlet weak var txtEndDate: UITextField!
    
    @IBOutlet weak var switchAllDay: UISwitch!
    
    @IBOutlet weak var viewTime: UIView!
    
    @IBOutlet weak var viewStartTime: UIView!
    @IBOutlet weak var txtStartTime: UITextField!
    
    @IBOutlet weak var viewEndTime: UIView!
    @IBOutlet weak var txtEndTime: UITextField!
    
    @IBOutlet weak var viewDay: UIView!
    
    @IBOutlet weak var switchRepeat: UISwitch!
    
    
    @IBOutlet weak var viewDays: UIView!
    
    @IBOutlet weak var switchMon: UISwitch!
    @IBOutlet weak var switchTue: UISwitch!
    @IBOutlet weak var switchWed: UISwitch!
    @IBOutlet weak var switchThr: UISwitch!
    @IBOutlet weak var switchFri: UISwitch!
    @IBOutlet weak var switchSat: UISwitch!
    @IBOutlet weak var switchSun: UISwitch!
    
    @IBOutlet weak var btnCreate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "TimeSlot"
        navigationController?.navigationBar.tintColor = .white
        
        txtTitle.delegate = self
        
        txtNote.roundView(radius: 8, borderWidth: 1, borderColor: UIColor.gray.withAlphaComponent(0.3))
        
        viewStartDate.roundView(radius: 8, borderWidth: 1, borderColor: UIColor.gray.withAlphaComponent(0.3))
        viewEndDate.roundView(radius: 8, borderWidth: 1, borderColor: UIColor.gray.withAlphaComponent(0.3))
        viewStartTime.roundView(radius: 8, borderWidth: 1, borderColor: UIColor.gray.withAlphaComponent(0.3))
        viewEndTime.roundView(radius: 8, borderWidth: 1, borderColor: UIColor.gray.withAlphaComponent(0.3))
        
        switchRepeat.addTarget(self, action: #selector(valueChangedSwitchRepeat(_:)), for: .valueChanged)
        switchAllDay.addTarget(self, action: #selector(valueChangedSwitchDay(_:)), for: .valueChanged)
        
        btnCreate.squareGradientView()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: viewDay.frame.maxY + 20)
        
        var picker = UIDatePicker()
        picker.date = Date()
        picker.datePickerMode = .date
        picker.tag = 0x100
        picker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        txtStartDate.inputView = picker
        txtStartDate.delegate = self
        
        picker = UIDatePicker()
        picker.date = Date()
        picker.datePickerMode = .date
        picker.tag = 0x101
        picker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        txtEndDate.inputView = picker
        txtEndDate.delegate = self
        
        picker = UIDatePicker()
        picker.date = Date()
        picker.datePickerMode = .time
        picker.tag = 0x102
        picker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        txtStartTime.inputView = picker
        txtStartTime.delegate = self
        
        picker = UIDatePicker()
        picker.date = Date()
        picker.datePickerMode = .time
        picker.tag = 0x103
        picker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        txtEndTime.inputView = picker
        txtEndTime.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnCreateTapped(_ sender: Any) {
        guard let title = txtTitle.text, let note = txtNote.text, let startDate = txtStartDate.text, let endDate = txtEndDate.text else { return }
        guard switchAllDay.isOn == false, let startTime = txtStartTime.text, let endTime = txtEndTime.text else { return }
        
        let formater = DateFormatter()
        
        let submission = FDUnavailable([:])
        
        submission.businessId = Backend.shared().business!.uid
        submission.title = title
        submission.note = note
        
        formater.dateFormat = "MMM dd, yyyy"
        submission.start = formater.date(from: startDate)
        submission.end = formater.date(from: endDate)
        
        submission.allDay = switchAllDay.isOn
        if switchAllDay.isOn == false {
            formater.dateFormat = "HH:mm"
            submission.startTime = formater.date(from: startTime)
            
            let endTime = formater.date(from: endTime)
            submission.duration = Int(endTime!.timeIntervalSince(submission.startTime!))
            
        } else {
            submission.startTime = Date()
            submission.duration = 24 * 60 * 60
        }
        
        submission.repeatly = switchRepeat.isOn
        submission.monday = switchMon.isOn
        submission.tuesday = switchTue.isOn
        submission.wednesday = switchWed.isOn
        submission.thursday = switchThr.isOn
        submission.friday = switchFri.isOn
        submission.saturday = switchSat.isOn
        submission.sunday = switchSun.isOn
        
        ProgressHUD.show()
        Backend.submitUnavailable(submission) { (error) in
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
    
    @objc func valueChangedSwitchRepeat(_ sender: UISwitch) {
        if sender.isOn == true {
            viewDays.isHidden = false
            
            var frame = btnCreate.frame
            frame.origin.y = viewDays.frame.maxY + 20
            btnCreate.frame = frame
            
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: viewDay.frame.maxY + 20)
            
        } else {
            viewDays.isHidden = true
            
            var frame = btnCreate.frame
            frame.origin.y = viewDays.frame.minY
            btnCreate.frame = frame
            
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: viewDay.frame.maxY + 20)
        }
    }
    
    @objc func valueChangedSwitchDay(_ sender: UISwitch) {
        if sender.isOn == true {
            viewTime.isHidden = true
            
            var frame = viewDay.frame
            frame.origin.y = viewTime.frame.minY
            viewDay.frame = frame
            
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: viewDay.frame.maxY + 20)
            
        } else {
            viewTime.isHidden = false
            
            var frame = viewDay.frame
            frame.origin.y = viewTime.frame.maxY + 20
            viewDay.frame = frame
            
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: viewDay.frame.maxY + 20)
        }
    }
    
    @objc func timePickerValueChanged(_ sender: UIDatePicker) {
        let tag = sender.tag
        let date = sender.date
        let formater = DateFormatter()
        
        if tag == 0x100 {
            formater.dateFormat = "MMM dd, yyyy"
            txtStartDate.text = formater.string(from: date)
        } else if tag == 0x101 {
            formater.dateFormat = "MMM dd, yyyy"
            txtEndDate.text = formater.string(from: date)
        } else if tag == 0x102 {
            formater.dateFormat = "HH:mm"
            txtStartTime.text = formater.string(from: date)
        } else {
            formater.dateFormat = "HH:mm"
            txtEndTime.text = formater.string(from: date)
        }
        
    }

}


// MARK: -
extension AddScheduleVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var frame = view.bounds
        frame.size.height = frame.height - 270
        scrollView.frame = frame
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: viewDay.frame.maxY + 20)
    }

}

