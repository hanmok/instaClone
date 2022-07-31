//
//  UserCellViewModel.swift
//  InstagramFirestoreTutorial
//
//  Created by 이한목 on 2021/05/14.
//

import Foundation

struct UserCellViewModel {
    
    private let user : User
    
    var profileImageUrl : URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username : String {
        return user.username
    }
    
    var fullname : String {
        return user.fullname
    }
    
    init(user : User) {
        self.user = user
    }
    
}
