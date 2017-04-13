//
//  FeedViewController.swift
//
//
//  Created by Ameenah Burhan on 4/2/17.
//
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    var databaseRef: FIRDatabaseReference!
    var feedArray = [Post]()
    let cellIdentifier = "cell"
    
    @IBOutlet weak var feedCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        self.feedCollectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.feedCollectionView.dataSource = self
        self.feedCollectionView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        feedCollectionView.reloadData()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return feedArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = feedCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! FeedCollectionViewCell
        //load profile picture
        cell.profileImage.sd_setImage(with: URL(string: feedArray[indexPath.row].profilePic), placeholderImage: UIImage(named: "dog2"))
        //load username
        cell.usernameLabel.text = feedArray[indexPath.row].username
        //load the post picture
        cell.postImageView.sd_setImage(with: URL(string: feedArray[indexPath.row].postImage), placeholderImage: UIImage(named: "dog2"))
        return cell
    }
    func loadData(){
        databaseRef = FIRDatabase.database().reference()
        //get users ID
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            //to get the users we are following
            let myFollowingRef = self.databaseRef.child("Following").child(uid)
            myFollowingRef.observe(.value, with: { (followingSnapshot) in
                //save users to dictionary
                let followingDictionary = followingSnapshot.value as! NSDictionary
                //get all users posts
                for(id,_) in followingDictionary{
                    let userPostRef = self.databaseRef.child("Post").child(id as! String)
                    userPostRef.observe(.childAdded, with: { (postSnapshot) in
                            let postId = postSnapshot.key
                            if let postData = postSnapshot.value as? NSDictionary{
                                guard let profileURL = postData["profile_pic"] as! String! else {return}
                                guard let username = postData["username"] as! String! else {return}
                                guard let postURL = postData["posted_pic"] as! String! else {return}
                                //append to feed array
                                self.feedArray.append(Post(postID: postId, profilePic: profileURL, username: username, postImage: postURL, timestamp: NSNumber(value: Int(NSDate().timeIntervalSince1970))))
                                //reload the collection view
                                self.feedCollectionView.reloadData()
                            }
                    })
                }
            })
        }
    }
    
}

