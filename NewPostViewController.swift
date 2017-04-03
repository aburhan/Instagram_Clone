//
//  NewPostViewController.swift
//  test_db_structure
//
//  Created by Ameenah Burhan on 4/2/17.
//  Copyright © 2017 Meena LLC. All rights reserved.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let picker = UIImagePickerController()
    let testData = TestLoadData()
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!

    @IBOutlet weak var postImageView: UIImageView!
    //@IBOutlet weak var captionTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storageRef = FIRStorage.storage().reference()
        databaseRef = FIRDatabase.database().reference()
        testData.addDummyPosts()
    }
    func getPhotoFromLibrary(){
        picker.delegate = self
        picker.allowsEditing = false
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(picker, animated: true, completion: nil)
    }
    @IBAction func getPhotoFromLibrary(_ sender: Any) {
        getPhotoFromLibrary()
    }
    @IBAction func sharePhoto(_ sender: Any) {
        //get the userid
        let userID = FIRAuth.auth()?.currentUser?.uid
        //get timestamp
        let postID = NSUUID().uuidString
        //load the image into storage
        let postItem = storageRef.child("post").child(userID!).child(postID)
        //get image from imageview
        guard let postImage = postImageView.image else{return}
        //guard let postCaption = captionTextView.text else{return}
        //convert image to PNG

        if let imageToUpload = UIImagePNGRepresentation(postImage){
            postItem.put(imageToUpload, metadata: nil) { (metadata, error)           in
                if error != nil{
                    print(error!)
                    return
                }
                //get image URL from storage
            postItem.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let imageURL = url?.absoluteString{
                        let userRef = self.databaseRef.child("User").child(userID!)
                        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        let userDictionary = snapshot.value as! NSDictionary
                            //create instance of a post
                            print("creating new post")
                            let newpost = Post(profilePic: userDictionary.value(forKey: "profile_photo") as! String, username: userDictionary.value(forKey: "username") as! String, postImage: imageURL)
                            print(newpost.username, newpost.profilePic, newpost.postImage)
                         //store post in the dictionary
                         let postRef = self.databaseRef.child("Post").child(userID!).child(postID)
                          postRef.updateChildValues(newpost.returnPostAsDictionary() as! [AnyHashable : Any])
                        self.dismiss(animated: true, completion: nil )
                        })
                    }
                })
            }
        }
    }
    @IBAction func cancelShare(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        postImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    //when user cancels the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
