//
//  EditProViewController.swift
//  wip_meenagram
//
//

import UIKit
import Firebase
import SDWebImage

class EditProViewController: UIViewController {
        
        @IBOutlet weak var profileImageView: UIImageView!
        @IBOutlet weak var usernameText: UITextField!
        @IBOutlet weak var displayNameText: UITextField!
        @IBOutlet weak var bioText: UITextField!
        
        
        var databaseRef: FIRDatabaseReference!
        var storageRef: FIRStorageReference!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            databaseRef = FIRDatabase.database().reference()
            storageRef = FIRStorage.storage().reference()
            
            loadProfileData()
            
        }

        func loadProfileData(){
            
            //if the user is logged in get the profile data
            
            if let userID = FIRAuth.auth()?.currentUser?.uid{
                databaseRef.child("profile").child(userID).observe(.value, with: { (snapshot) in
                    
                    //create a dictionary of users profile data
                    let values = snapshot.value as? NSDictionary
                    
                    //if there is a url image stored in photo
                    if let profileImageURL = values?["photo"] as? String{
                        //using sd_setImage load photo
                        self.profileImageView.sd_setImage(with: URL(string: profileImageURL))
                    }
                
                    self.usernameText.text = values?["username"] as? String
                    
                    
                    self.displayNameText.text = values?["display"] as? String
                    
        
                    self.bioText.text = values?["bio"] as? String
                })
                
            }
        }

}


