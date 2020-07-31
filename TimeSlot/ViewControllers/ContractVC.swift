//
//  ContractVC.swift
//  TimeSlot
//
//  Created by com on 7/29/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit
import ProgressHUD
import JZCalendarWeekView

class ContractVC: UIViewController {

    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgClientAvatar: UIImageView!
    @IBOutlet weak var lblClientName: UILabel!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var imgUserAvatar: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    var tableView: UITableView?
    
    let calendarView = CalendarCollectionView()
    
    let viewModel = ContractViewModel()
    
    var contract: Any?
    
    var contractDate: Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "Time Slot"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(btnBackTapped(_:)))
        
        // set info
        viewContainer.addSubview(calendarView)
        
        viewTitle.squareGradientView()
        btnSignUp.squareGradientView()
        
        imgClientAvatar.roundView(radius: imgClientAvatar.frame.width / 2)
        imgUserAvatar.roundView(radius: imgUserAvatar.frame.width / 2)
        
        if let item = contract as? FDPrivateContract {
            lblTitle.text = item.title
            lblDescription.text = item.descript
            lblMembers.text = "1"
            lblRate.text = String(format: "$ %.2f/HR", item.hourlyRate)
            
            if let coach = Backend.getBusiness(item.businessId) {
                imgClientAvatar.sd_setImage(with: URL(fileURLWithPath: coach.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                lblClientName.text = coach.username
            }
            
        } else if let item = contract as? FDGroupContract {
            lblTitle.text = item.title
            lblDescription.text = item.descript
            lblMembers.text = "2 ~ \(item.maxPlayers)"
            lblRate.text = String(format: "$ %.2f/HR", item.hourlyRate)
            
            if let coach = Backend.getBusiness(item.businessId) {
                imgClientAvatar.sd_setImage(with: URL(fileURLWithPath: coach.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                lblClientName.text = coach.username
            }
        }
        
        if let me = Backend.shared().personal {
            imgUserAvatar.sd_setImage(with: URL(fileURLWithPath: me.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            lblUserName.text = me.username
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        calendarView.frame = viewContainer.bounds
        
        guard let man = Backend.shared().user else { return }
        
        if man.type == UserType.coach.rawValue {
            viewModel.getEventsOfCoach(id: man.uid)
            
        } else {
            viewModel.getEvents(id: man.uid)
        }
        
        setupCalendarView()
    }
    
    
    private func setupCalendarView() {
        calendarView.baseDelegate = self
        
        calendarView.setupCalendar(numOfDays: 3,
                                   setDate: Date(),
                                   allEvents: viewModel.events,
                                   scrollType: .sectionScroll,
                                   scrollableRange: (nil, nil))

        // LongPress delegate, datasorce and type setup
        calendarView.longPressDelegate = self
        calendarView.longPressDataSource = self
        calendarView.longPressTypes = [.addNew, .move]

        // Optional
        calendarView.addNewDurationMins = 120
        calendarView.moveTimeMinInterval = 15
    }
    
    
    func showTimePicker(date: Date) {
        contractDate = date
        
        let container = UIView(frame: view.bounds)
        container.tag = 0x2000
        container.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.addSubview(container)
        
        let picker = UIDatePicker(frame: CGRect(x: 0, y: view.frame.height - 300, width: view.frame.width, height: 300))
        picker.datePickerMode = .time
        picker.setValue(UIColor.white, forKey: "textColor")
        picker.backgroundColor = UIColor.lightGray
        picker.date = date
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        container.addSubview(picker)
        
        let mnu = UIView(frame: CGRect(x: 0, y: picker.frame.minY - 40, width: picker.frame.width, height: 40))
        mnu.backgroundColor = UIColor.gray
        container.addSubview(mnu)
        
        let btn = UIButton(frame: CGRect(x: mnu.frame.width - 80, y: 2, width: 80, height: 36))
        btn.setTitle("DONE", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(btnDoneTapped(_:)), for: .touchUpInside)
        btn.squareGradientView()
        mnu.addSubview(btn)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnDetailListTapped(_ sender: Any) {
        guard let me = Backend.shared().personal, me.childIds.count > 0 else { return }
        
        let container = UIView(frame: view.bounds)
        container.backgroundColor = .clear
        container.tag = 0x1000
        view.addSubview(container)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapToHideTableView(_:)))
        gesture.delegate = self
        container.addGestureRecognizer(gesture)
        
        let rt = (sender as! UIButton).superview!.frame
        tableView = UITableView(frame: CGRect(x: rt.minX, y: rt.minY, width: rt.width - 22, height: CGFloat(me.childIds.count + 1) * 30), style: .plain)
        tableView!.separatorColor = UIColor.white
        tableView!.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 10)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.shadowView()
        container.addSubview(tableView!)
    }
    
    
    @IBAction func btnAddContract(_ sender: Any) {
        guard let date = contractDate else {
            let alert = UIAlertController(title: nil, message: "You should input valid values", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
//        let format = DateFormatter()
//        format.dateFormat = "yyyy, MMM dd, HH:mm:ss"
//        let str = format.string(from: date)
//        print("\(str)")
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to create new schedule?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            var submission: Any?
            if let item = self.contract as? FDPrivateContract {
                submission = FDPrivateSubmission([:])
                (submission as! FDPrivateSubmission).businessId = item.businessId
                (submission as! FDPrivateSubmission).contractId = item.id
                (submission as! FDPrivateSubmission).start = date
                (submission as! FDPrivateSubmission).end = date.addingTimeInterval(TimeInterval(item.length/1000))
                (submission as! FDPrivateSubmission).userId = Backend.shared().personal!.uid
                (submission as! FDPrivateSubmission).confirmed = false
                
            } else if let item = self.contract as? FDGroupContract {
                submission = FDGroupSubmission([:])
                (submission as! FDGroupSubmission).businessId = item.businessId
                (submission as! FDGroupSubmission).contractId = item.id
                (submission as! FDGroupSubmission).start = date
                (submission as! FDGroupSubmission).end = date.addingTimeInterval(TimeInterval(item.length/1000))
                (submission as! FDGroupSubmission).users.append(Backend.shared().personal!.uid)
                (submission as! FDGroupSubmission).confirmedMap[Backend.shared().personal!.uid] = false
            }
            
            ProgressHUD.show()
            self.viewModel.submitSubmission(submission!) { (error) in
                ProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func onTapToHideTableView(_ sender: Any) {
        if let sub = view.viewWithTag(0x1000) {
            sub.removeFromSuperview()
        }
    }
    
    
    @objc func btnDoneTapped(_ sender: Any) {
        if let sub = view.viewWithTag(0x2000) {
            sub.removeFromSuperview()
        }
        
//        let format = DateFormatter()
//        format.dateFormat = "yyyy, MMM dd, HH:mm:ss"
//        let str = format.string(from: contractDate!)
//        print("\(str)")
        
        var len = 0
        if let item = contract as? FDPrivateContract {
            len = item.length
            
        } else if let item = contract as? FDGroupContract {
            len = item.length
        }
        
        let event = AllDayEvent(id: "",
                                title: lblTitle.text!,
                                startDate: contractDate!,
                                endDate: contractDate!.addingTimeInterval(TimeInterval(len/1000)),
                                location: "unknown",
                                isAllDay: false)
        
        viewModel.addNewEvent(Backend.shared().personal!.uid, newEvent: event)
        calendarView.forceReload(reloadEvents: viewModel.events)
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: sender.date)
        
        var curComp = calendar.dateComponents([.hour, .minute, .year, .month, .day], from: contractDate!)
        curComp.hour = comp.hour
        curComp.minute = comp.minute
        
        contractDate = calendar.date(from: curComp)
    }
}


// MARK: -
extension ContractVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let pt = touch.location(in: self.view)
        if tableView?.frame.contains(pt) == false {
            return true
        }
        
        return false
    }
}


// MARK: -
extension ContractVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let me = Backend.shared().personal else { return 0 }
        
        return me.childIds.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CotnractVCChildTVCell")
        
        if indexPath.row == 0 {
            cell.imageView!.sd_setImage(with: URL(fileURLWithPath: Backend.shared().personal!.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            cell.imageView!.roundView(radius: cell.imageView!.frame.width / 2)
            cell.textLabel?.text = Backend.shared().personal!.username
            
            return cell
        }
        
        let childID = Backend.shared().personal!.childIds[indexPath.row - 1]
        guard let child = Backend.getChild(childID) else { return cell }
        
        cell.imageView!.sd_setImage(with: URL(fileURLWithPath: child.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
        cell.imageView!.roundView(radius: cell.imageView!.frame.width / 2)
        cell.textLabel?.text = child.username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            imgUserAvatar.sd_setImage(with: URL(fileURLWithPath: Backend.shared().personal!.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
            lblUserName.text = Backend.shared().personal!.username
            
        } else {
            let childID = Backend.shared().personal!.childIds[indexPath.row - 1]
            if let child = Backend.getChild(childID) {
                imgUserAvatar.sd_setImage(with: URL(fileURLWithPath: child.photoUri), placeholderImage: UIImage(named: "imgAvatar"))
                lblUserName.text = child.username
            }
        }
        
        onTapToHideTableView(self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}


// MARK: -
extension ContractVC: JZBaseViewDelegate {
    func initDateDidChange(_ weekView: JZBaseWeekView, initDate: Date) {
        
    }
    
}


// MARK: -
extension ContractVC: JZLongPressViewDelegate, JZLongPressViewDataSource {
    func weekView(_ weekView: JZLongPressWeekView, viewForAddNewLongPressAt startDate: Date) -> UIView {
        showTimePicker(date: startDate)
        return UIView()
    }
    
}
