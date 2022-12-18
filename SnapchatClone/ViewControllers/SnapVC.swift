//
//  SnapVC.swift
//  SnapchatClone
//
//  Created by Kenan Baylan on 18.12.2022.
//

import UIKit

class SnapVC: UIViewController {

    @IBOutlet var snapTimeLabel: UILabel!
    
    var selectedSnap : Snap?
    var selectedTime :  Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let time = selectedTime {
            snapTimeLabel.text = "Time Left \(time)"
        }
        
    }
    

}
