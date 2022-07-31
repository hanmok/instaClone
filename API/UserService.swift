//
//  UserService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이한목 on 2021/05/14.
//
//let COLLECTION_USERS = Firestore.firestore().collection("users")




import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {

    static func fetchUser(withUid uid : String, completion : @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchUsers(completion : @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }

            let users = snapshot.documents.map({ User(dictionary: $0.data())})
            completion(users)
        }
    }
    
    
//        let COLLECTION_USERS = Firestore.firestore().collection("users")
    
//        Auth :            Manages authentication for Firebase apps.
//        auth() :          Gets the auth object for the default Firebase app.
//        currentUser :     Synchronously gets the cached current user, or null if there is none.
//        uid :             the provider's user ID for the user.
    
//     data : Retrieves all fields in the document as an `NSDictionary`. Returns `nil` if the document doesn't exist.
    
    /*
    dictionary : [
     "fullname" : ,
     "profileImageUrl" : ,
     "username" : ,
     "uid" : ,
     "email" :
     ]
    */
    
    
    
    static func follow(uid : String, completion : @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
            // currentUid 의 following 에 uid 추가,
            // uid 의 follower 에 currentUid 추가.
        }
    }
    

    static func unfollow(uid : String, completion : @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).delete(completion: completion)
        }
    }
    
    static func checkIfUserIsFollowed(uid : String, completion : @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).getDocument { (snapshot, error) in
            guard let isFollowed = snapshot?.exists else { return } // no any attribute here, so checking 'exist' is enough.
            completion(isFollowed)
        }
    }
    
    // Firestore.firestore().collection("following").document(currentUid).collection("user-following").document(uid)
    
    static func fetchUserStats(uid : String, completion : @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { (snapshot, _) in
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { (snapshot, _) in
                    let posts = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, follwing: following, posts: posts))
                }
            }
        }
    }
}

//        let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
//        Firestore.firestore().collection("following").document(currentUid).collection("user-following").document(uid)
