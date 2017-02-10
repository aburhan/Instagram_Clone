//
//  EditProViewController.swift
//  wip_meenagram
//
//

import UIKit
import Firebase
import SDWebImage

class EditProViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        //add your own outlets here and connect them to your storyboard!
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
//set up button action
    @IBAction func getPhotoFromLibrary(_ sender: Any) {
        //create instance of Image picker controller
        let picker = UIImagePickerController()
        //set delegate
        picker.delegate = self
        //set details
            //is the picture going to be editable(zoom)?
        picker.allowsEditing = false
            //what is the source type
        picker.sourceType = .photoLibrary
            //set the media type
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //show photoLibrary
        present(picker, animated: true, completion: nil)
    }
    //what happens when the user selects a photo?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
        //create holder variable for chosen image
        var chosenImage = UIImage()
        //save image into variable
        print(info)
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //update image view
        profileImageView.image = chosenImage
        //dismiss
        dismiss(animated: true, completion: nil)
    }
    //what happens when the user hits cancel?
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
                        self.profileImageView.sd_setImage(with: URL(string: profileImageURL), placeholderImage: UIImage(named: "empty-profile-1.png"))
                    }
                
                    self.usernameText.text = values?["username"] as? String
                    
                    
                    self.displayNameText.text = values?["display"] as? String
                    
        
                    self.bioText.text = values?["bio"] as? String
                })
                
            }//end of if
        }//end of loadProfileData

    
    
}


