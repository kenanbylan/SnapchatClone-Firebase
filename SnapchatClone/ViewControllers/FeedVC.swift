import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableViewControllers: UITableView!
    
    let fireStoreDb = Firestore.firestore()
    var snapArray = [Snap]()
    var choosenSnap : Snap?
    var timeLeft : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewControllers.delegate = self
        tableViewControllers.dataSource = self
        
        getSnapsFromFirebase()
        getUserInfo()
    }
    
    
    
    func getSnapsFromFirebase(){
        
        fireStoreDb.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID

                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour  {
                                        
                                        if difference >= 24 {
                                            self.fireStoreDb.collection("Snaps").document(documentId).delete()
                                        }
                                        //time left --> Snapvc
                                        self.timeLeft = 24 - difference
                                        
                                    }
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue())
                                    self.snapArray.append(snap)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    self.tableViewControllers.reloadData()
                    
                }
            }
        }
    }
    
    func getUserInfo(){
        
        fireStoreDb.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshots, error in
        
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }
            
            if snapshots?.isEmpty == false && snapshots != nil {
                self.snapArray.removeAll(keepingCapacity: false)
                for document in snapshots!.documents {
                    if let username = document.get("username") as? String {
                        
                        UserSignleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                        UserSignleton.sharedUserInfo.username = username
                        
                    }
                }
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.usernameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[2]))
        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = self.choosenSnap
            destinationVC.selectedTime = self.timeLeft
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        choosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
        
        
    }
    
    
    
    
    func makeAlert(title:String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    
    

}
