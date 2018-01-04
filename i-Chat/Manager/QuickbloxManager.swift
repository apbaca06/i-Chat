//
//  QB.swift
//  i-Chat
//
//  Created by cindy on 2017/12/13.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Firebase

class QuickbloxManager {

    static func logInSync(withUserEmail email: String, password: String) {

        let layout = UICollectionViewFlowLayout()

        AppDelegate.shared.window?.rootViewController = HomeViewController(collectionViewLayout: layout)

        var error: Error?
        var uuser: QBUUser?

        SVProgressHUD.show(withStatus: NSLocalizedString("Connecting to server", comment: ""))

        QBRequest.logIn(withUserEmail: email, password: password, successBlock: { (response, user) in

            // MARK: User logged in with Quickblox
            uuser = user

            uuser?.email = email

            uuser?.password = password

            QBChat.instance.connect(with: uuser!, completion: { (error) in

                if error == nil {

//                    if let firebaseUser = Auth.auth().currentUser {
//
//                        DatabasePath.userRef.child(firebaseUser.uid).updateChildValues(["lastLoginTime": uuser?.lastRequestAt?.iso8601String])
//                    }
                    SVProgressHUD.dismiss()

//                    SVProgressHUD.show(withStatus: NSLocalizedString("Login Successfully", comment: ""))

//                    let layout = UICollectionViewFlowLayout()
//
//                    AppDelegate.shared.window?.rootViewController = HomeViewController(collectionViewLayout: layout)

                } else {

                    SVProgressHUD.dismiss()

                    DispatchQueue.main.async {
                        UIAlertController(error: error!).show()
                    }

                }

            })

        }) { (response) in

            SVProgressHUD.dismiss()

            // Todo: Error handling
            error = response.error?.error

            DispatchQueue.main.async {

                UIAlertController(error: error!).show()
            }

        }
    }

    static func signUpSync(name: String, email: String, password: String) {

        var error: Error?
        let uuser = QBUUser()

        uuser.email = email

        uuser.password = password

        uuser.fullName = name

        SVProgressHUD.show(withStatus: NSLocalizedString("Signing up...", comment: ""))

        QBRequest.signUp(uuser, successBlock: { (response, user) in
            if let firebaseUser = Auth.auth().currentUser {

                let navGenderViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferenceNav")

                AppDelegate.shared.window?.rootViewController = navGenderViewController

                DatabasePath.userRef.child(firebaseUser.uid).setValue(["name": name,
                                                           "email": email,
                                                           "qbID": user.id,
                                                           "createdTime": user.createdAt?.iso8601String,
                                                           "lastLoginTime": user.lastRequestAt?.iso8601String])
            }

        }) { (response) in

            SVProgressHUD.dismiss()

            error = response.error?.error

            let user = Auth.auth().currentUser

            user?.delete { error in
                if let error = error {
                    // An error happened.
                } else {
                    // Account deleted.
                }
            }

            DispatchQueue.main.async {

                UIAlertController(error: error!).show()

            }
        }

    }
}
