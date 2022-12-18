//
//  SettingsVC.swift
//  SnapchatClone
//
//  Created by Kenan Baylan on 18.12.2022.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func logOutClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        } catch {
            print("error")
        }
    }
    

}
