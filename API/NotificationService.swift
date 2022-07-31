//
//  NotificationService.swift
//  InstagramFirestoreTutorial
//
//  Created by 이한목 on 2021/05/28.
//

import Firebase

struct NotificationService {
    
    static func uploadNotification(toUid uid : String, fromUser : User, type : NotificationType, post : Post? = nil) {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return } // current ==== fromUser
        guard uid != currentUid else { return }
        
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document() // made to set data (know notificationID)
        
        var data : [String : Any] = ["timestamp" : Timestamp(date: Date()),
                                     "uid" : fromUser.uid,
                                     "type" : type.rawValue,
                                     "id" : docRef.documentID,
                                     "userProfileImageUrl" : fromUser.profileImageUrl,
                                     "username" : fromUser.username]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
    }
    
    static func fetchNotifications(completion : @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").
        
        let query = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").order(by : "timestamp", descending: true)
        
        query.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let notifications = documents.map({ Notification(dictionary: $0.data()) })
            completion(notifications)
        }
    }
}
