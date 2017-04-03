//
//  LoginViewController.swift
//  
//
//  Created by Ameenah Burhan on 4/2/17.
//
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var databaseRef: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference()
        
        if FIRAuth.auth()?.currentUser != nil{
            goToHome()
        }
    }
    func login(){
        guard let email = emailText.text else{return}
        guard let pass = passwordText.text else{return}
        
        FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
            if error != nil{
                self.signup(email: email, password: pass)
            }else{
                self.createNewUserProfile(email: email)
                self.goToHome()
            }
        })
    }
    func signup(email:String, password:String){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil{
                print(error!)
                return
            }else{
            //create a user profile
                self.createNewUserProfile(email: email)
                self.goToHome()
            }
        })
    }
    func createNewUserProfile(email: String){
        if let currentUser = FIRAuth.auth()?.currentUser?.uid{
            let newUserProfile = databaseRef.child("User").child(currentUser)
            newUserProfile.updateChildValues(["email": email,
                                              "profile_photo": "https://firebasestorage.googleapis.com/v0/b/database-setup.appspot.com/o/donut.jpg?alt=media&token=d2d28761-22e9-4321-9c42-9ba9cb098c41",
                                              "username":email])
            
        }
    }
    func goToHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homePVC = storyboard.instantiateViewController(withIdentifier: "feed")
        self.present(homePVC, animated: true, completion: nil)
        
    }
    @IBAction func Login(_ sender: Any) {
        login()
    }
}
