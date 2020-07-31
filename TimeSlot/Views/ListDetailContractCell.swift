//
//  ListDetailContractCell.swift
//  TimeSlot
//
//  Created by com on 7/29/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class ListDetailContractCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDuration: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }

    func showInfo(_ data: Any) {
        if let item = data as? FDPrivateSubmission {
            guard let contract = Backend.findPrivateContract(item.contractId) else { return }
            
            let formater = DateFormatter()
            formater.dateFormat = "MMM d, yyyy HH:mm"
            lblDate.text = formater.string(from: item.start!)
            
            lblTitle.text = contract.title
            lblDescription.text = contract.descript
            lblPrice.text = "Price\t\t$\(contract.hourlyRate)/Hr"
            
            let duration = item.end!.timeIntervalSince(item.start!)
            let h = Int(duration/60/60)
            let m = Int(duration/60)%60
            lblDuration.text = String(format: "Duration\t\t%.2d:%.2d", h, m)
            
        } else if let item = data as? FDGroupSubmission {
            guard let contract = Backend.findGroupContract(item.contractId) else { return }
            
            let formater = DateFormatter()
            formater.dateFormat = "MMM d, yyyy HH:mm"
            lblDate.text = formater.string(from: item.start!)
            
            lblTitle.text = contract.title
            lblDescription.text = contract.descript
            lblPrice.text = "Price\t\t$\(contract.hourlyRate)/Hr"
            
            let duration = item.end!.timeIntervalSince(item.start!)
            let h = Int(duration/60/60)
            let m = Int(duration/60)%60
            lblDuration.text = String(format: "Duration\t\t%.2d:%.2d", h, m)
        }
    }
}
