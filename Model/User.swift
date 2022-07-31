//
//  User.swift
//  InstagramFirestoreTutorial
//
//  Created by 이한목 on 2021/05/14.
//

import Foundation
import Firebase

struct User {
    let email :String
    let fullname : String
    let profileImageUrl : String
    let username : String
    let uid : String
    
    var isFollowed = false
    
    var stats : UserStats!
    
    var isCurrentUser : Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary : [String : Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        self.stats = UserStats(followers: 0, follwing: 0, posts: 0)
    }
}


struct UserStats {
    let followers : Int
    let follwing : Int
    let posts : Int
}


//let data : [String : Any] = ["email" : credentials.email,
//                             "fullname" : credentials.fullname,
//                             "profileImageUrl" : imageUrl,
//                             "uid" : uid,
//                             "username" : credentials.username]
