//
//  FirebaseManager.swift
//  i-Chat
//
//  Created by cindy on 2017/12/14.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD
import KeychainSwift
import Crashlytics

public enum FirebaseError: Error {

    case notObject

    case missingValueForKey(String)

    case invalidValueForKey(String)

}

class FirebaseManager {

    static func logIn(withEmail email: String, withPassword password: String) {

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            if error == nil {

                let keychain = KeychainSwift()

                keychain.set(email, forKey: "userEmail")

                keychain.set(password, forKey: "userPassword")

                keychain.set((user?.uid)!, forKey: "uid")

                // MARK: Logged into Firebase successfully

                SVProgressHUD.show(withStatus: NSLocalizedString("Logging in...", comment: ""))

                // MARK: Logged into Quickblox
                QuickbloxManager.logInSync(

                    withUserEmail: email,

                    password: password
                )
            }
        }
    }

    static func signUp(name: String, withEmail email: String, withPassword password: String) {

        Auth.auth().createUser(withEmail: email, password: password) { (firebaseUser, error) in

            // MARK: Failed to sign up for Firebase
            if error != nil {

                DispatchQueue.main.async {
                    UIAlertController(error: error!).show()
                    let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInViewController")

                    AppDelegate.shared.window?.rootViewController = loginViewController
                }

            }

            // MARK: Signed up for Firebase successfully
            if error == nil {

                let keychain = KeychainSwift()

                keychain.set(email, forKey: "userEmail")

                keychain.set(password, forKey: "userPassword")

                guard
                    let user = firebaseUser
                else { return }

                keychain.set(user.uid, forKey: "uid")

                // MARK: Signed up for Quickblox
                QuickbloxManager.signUpSync(name: name, email: email, password: password)

            }
        }
    }

    static func userUnlike(uid: String, recieverUid: String) {
        DatabasePath.userUnlikeRef.child(uid).updateChildValues([recieverUid: 0])
    }

    static func userLike(uid: String, recieverUid: String) {
        DatabasePath.userRef.child(uid).child("likeList").updateChildValues([recieverUid: 0])
    }

    static func userSwipedLike(uid: String, recieverUid: String) {
        DatabasePath.userSwipedLikeRef.child(recieverUid).updateChildValues([uid: 0])
    }

    static func findIfWasSwiped(uid: String, recieverUid: String, completionHandler: @escaping (Bool) -> Void) {
        DatabasePath.userRef.child(recieverUid).child("likeList").queryOrderedByKey().queryEqual(toValue: uid).observeSingleEvent(of: .value) { (datasnapshot) in
            print("***if is matched", datasnapshot)

            let exist = datasnapshot.exists()

            switch exist {
            case true :
                DatabasePath.userFriendRef.child(uid).child(recieverUid).updateChildValues(["block": false, "chatroomID": "\(uid)_\(recieverUid)"])

                DatabasePath.userFriendRef.child(recieverUid).child(uid).updateChildValues(["block": false, "chatroomID": "\(uid)_\(recieverUid)"])
                completionHandler(true)

            case false:

                completionHandler(false)
            }
        }
    }

    static func getFriendList(eventType type: DataEventType, completionHandler: @escaping ([(User, String, Bool)]) -> Void) {

        let keychain = KeychainSwift()

        typealias UserChatIDBlock = (User, String, Bool)

        guard let uid = keychain.get("uid")
        else { return }

        DatabasePath.userFriendRef.child(uid).observe(type) { (datasnapshot) in

            guard let friendList = datasnapshot.value as? [String: Any]
            else { return }

            var friendsWithChatBlock: [UserChatIDBlock] = []

            for friend in friendList {
                let friendID = friend.key

                guard let dict = friend.value as? [String: Any],
                     let ifBlock = dict["block"] as? Bool,
                     let chatroomID = dict["chatroomID"] as? String
                else { return }

                DatabasePath.userRef.child(friendID).observeSingleEvent(of: .value, with: { (datasnapshot) in

                    do {

                    let userDic = [ datasnapshot.key: datasnapshot.value]

                    let userFriend = try User(userDic)

                    friendsWithChatBlock.append((userFriend, chatroomID, ifBlock))
                    completionHandler(friendsWithChatBlock)

                    } catch {
                        print(error, "**")
                    }

                })

            }

        }

    }

}
