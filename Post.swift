//
//  Post.swift
//  test_db_structure
//
//  Created by Ameenah Burhan on 4/2/17.
//  Copyright © 2017 Meena LLC. All rights reserved.
//

import Foundation

class Post{
    var postID: String
    var profilePic: String
    var username: String
    var postImage: String
    var timestamp: NSNumber
    
    init( postID: String, profilePic: String, username:String, postImage:String, timestamp:NSNumber){
        self.postID = postID
        self.profilePic = profilePic
        self.username = username
        self.postImage = postImage
        self.timestamp = timestamp
    }
    func returnPostAsDictionary()->NSDictionary{
        let postDictionary: NSDictionary = ["postID": postID,
                                            "profile_pic": profilePic,
                                            "username": username,
                                            "posted_pic": postImage,
                                            "timestamp": timestamp]
        return postDictionary
    }
}
