//
//  Post.swift
//  test_db_structure
//
//  Created by Ameenah Burhan on 4/2/17.
//  Copyright © 2017 Meena LLC. All rights reserved.
//

import Foundation

class Post{
    var profilePic: String
    var username: String
    var postImage: String
    
    init(profilePic: String, username:String, postImage:String){
        self.profilePic = profilePic
        self.username = username
        self.postImage = postImage
    }
    func returnPostAsDictionary()->NSDictionary{
        let postDictionary: NSDictionary = ["profile_pic": profilePic,
                                            "username": username,
                                            "posted_pic": postImage]
        return postDictionary
    }
}
