//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Kenan Baylan on 18.12.2022.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        getUserInfo()
    }
    
    
    
    func getUserInfo() {
        
        usernameLabel.text = UserSignleton.sharedUserInfo.username
        emailLabel.text = UserSignleton.sharedUserInfo.email
        
    }
    
    
    
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        } catch {
            print("error")
        }
    }
    
    
}
