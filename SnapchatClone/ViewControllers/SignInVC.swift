//  ViewController.swift
//  SnapchatClone


import UIKit
import Firebase
import FirebaseFirestore

class SignInVC: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        if passwordTextField.text != "" && emailTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { result, error in
                if error != nil {
                    self.makeAlert(title: "Error", message:error?.localizedDescription ?? "Error.")
                }
                
                self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            }
            
            
        } else {
            makeAlert(title: "Error!", message: "Password/Email is not empty ")
            
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if passwordTextField.text != "" && emailTextField.text != "" && usernameTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                auth, error in
                //error is null
                if error != nil {
                    self.makeAlert(title:"Error!", message: error?.localizedDescription ?? "Error")
                } else {
                    
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["email":self.emailTextField.text! , "username":self.usernameTextField.text! ] as [String: Any]
                    
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        //error is
                    }
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            self.makeAlert(title: "Error!", message: "Username/Password/Email is not empty ")
        }
    }
    
    func makeAlert(title:String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}

