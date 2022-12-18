//  UploadVC.swift
//  SnapchatClone


import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageUpload))
        uploadImageView.addGestureRecognizer(recognizer)
    }
    
    
    @objc func imageUpload(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        uploadImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    
    @IBAction func uploadClicked(_ sender: Any) {
        //Storage Processing
        let storage = Storage.storage()
        let storageReference = storage.reference() //?
        let mediaFolder = storageReference.child("media")
        
        if let data = uploadImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data,metadata: nil) { metaData, error in
                
                if error != nil {
                    self.makeAlert(title: "Error!!!", message: error?.localizedDescription ?? "Error!")
                } else {
                    
                    imageReference.downloadURL { url, error in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            //Firestore Processing
                            let fireStore = Firestore.firestore()
                            
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSignleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error Localize")
                                } else {
                                    
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        
                                        for document in snapshot!.documents {
                                            
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictionary = ["imageUrlArray" : imageUrlArray] as? [String:Any]
                                                
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additionalDictionary!, merge: true) { error in
                                                    
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.uploadImageView.image = UIImage(systemName:"plus.square.fill.on.square.fill")
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        
                                    } else {
                                        
                                        let snapDictionary = ["imageUrlArray" : [imageUrl!], "snapOwner" : UserSignleton.sharedUserInfo.username , "date" : FieldValue.serverTimestamp()   ] as [String : Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            
                                            if error != nil {
                                                self.makeAlert(title: "Error", message:error?.localizedDescription ?? "Error")
                                            } else {
                                                
                                                self.tabBarController?.selectedIndex = 0
                                                self.uploadImageView.image = UIImage(systemName:"plus.square.fill.on.square.fill")
                                                
                                            }
                                        }
                                    }
                                }
                       
                            }
                            
                        }
                    }
                }
            }
        }
        
       
    }
    
    func makeAlert(title:String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}

