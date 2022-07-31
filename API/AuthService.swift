//
//  AuthService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이한목 on 2021/05/13.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email : String
    let password : String
    
    let fullname : String
    let username : String
    let profileImage : UIImage
}

// User
//let email :String
//let fullname : String
//let profileImageUrl : String
//let username : String
//let uid : String
//
//var isFollowed = false
//
//var stats : UserStats!

struct AuthService {
    static func logUserIn(withEmail email : String, password : String, completion : AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials : AuthCredentials, completion : @escaping(Error?) -> Void) {
        print(#function)
        // 이게 끝나면, imageUrl 에 접근 ! 
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                
                if let error = error {
                    print("DEBUG : Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data : [String : Any] = ["email" : credentials.email,
                                             "fullname" : credentials.fullname,
                                             "profileImageUrl" : imageUrl,
                                             "uid" : uid,
                                             "username" : credentials.username]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
//               Firestore.firestore().collection("users").document(uid).setData(data, completion : completion)
            }
        }
        
        print("DEBUG : Successfully uploaded to database! ") // first
    }
    
    static func resetPassword(withEmail email: String, completion: SendPasswordResetCallback?) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: completion)
    }
    
}
