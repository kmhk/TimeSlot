//
//  AddContractModel.swift
//  TimeSlot
//
//  Created by com on 8/3/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class AddContractModel: NSObject {
    func submitContract(_ contract: Any, finished: FDFinishedHandler!) {
        if let cont = contract as? FDPrivateContract {
            Backend.submitPrivateContract(contract: cont, finished: finished)
            
        } else if let cont = contract as? FDGroupContract {
            Backend.submitGroupContract(contract: cont, finished: finished)
        }
    }
}
