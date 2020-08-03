//
//  AddChildViewModel.swift
//  TimeSlot
//
//  Created by com on 8/2/20.
//  Copyright © 2020 com. All rights reserved.
//

import UIKit

class AddChildViewModel: NSObject {
    
    func addChild(name: String, birth: Date, finished: FDFinishedHandler!) {
        Backend.addChild(name: name, birth: birth, finished: finished)
    }

}
