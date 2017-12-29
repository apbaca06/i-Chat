//
//  UserProvider.swift
//  i-Chat
//
//  Created by cindy on 2017/12/29.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import Foundation
import Nuke
import KeychainSwift
import Firebase
import MapKit

protocol UserProviderDelegate: class {

    func userProvider(_ provider: UserProvider, didFetch users: [User])
    func userProvider(_ provider: UserProvider, didFetch user: User?)

}

class UserProvider {

    var users: [User] = []

    var minAgePreference: Int?

    var maxAgePreference: Int?

    weak var delegate: UserProviderDelegate?

    let keychain = KeychainSwift()

    func fetchCurrentUser() {
//
//        guard let uid = keychain.get("uid")
//            else { return }
//
//        DatabasePath.userRef.child(uid).observeSingleEvent(of: .value) { [unowned self] (datashot) in
//            do {
//                let user = try User(datashot)
//
//                self.keychain.set("\(user.minAge)", forKey: "minAge")
//                self.keychain.set("\(user.maxAge)", forKey: "maxAge")
//                self.keychain.set("\(user.preference)", forKey: "preference")
//
//                self.delegate?.userProvider(self, didFetch: user)
//                } catch {
//
//            }
//        }
    }

    func loadSwipeImage() {

        guard let uid = keychain.get("uid")
            else { return }

        DatabasePath.userRef.child(uid).observeSingleEvent(of: .value) { [unowned self] (datashot) in
            do {

                    let userDic = [ datashot.key: datashot.value]

                    let user = try User(userDic)

                    self.keychain.set("\(user.minAge)", forKey: "minAge")
                    self.keychain.set("\(user.maxAge)", forKey: "maxAge")
                    self.keychain.set("\(user.preference.rawValue)", forKey: "preference")
                    self.keychain.set("\(user.maxDistance)", forKey: "maxDistance")
                    self.keychain.set("\(user.latitude)", forKey: "latitude")
                    self.keychain.set("\(user.longitude)", forKey: "longitude")

                    self.delegate?.userProvider(self, didFetch: user)

                guard let minAge = Int(self.keychain.get("minAge")!),
                    let maxAge = Int(self.keychain.get("maxAge")!),
                    let preference = self.keychain.get("preference"),
                    let maxDistance = Int(self.keychain.get("maxDistance")!),
                    let latitude = Double(self.keychain.get("latitude")!),
                    let longitude = Double(self.keychain.get("longitude")!)
                    else { return }

                DatabasePath.userRef.queryOrdered(byChild: "gender").queryEqual(toValue: preference).observe(.value) { (dataSnapshot) in
                    do {

                        guard let datas = dataSnapshot.value as? [String: Any]

                            else { return }

                        for data in datas {

                            let userDic = [data.key: data.value]

                            let user = try User(userDic)

                            //        DatabasePath.userRef
                            //            .queryOrdered(byChild: "maxDistance")
                            //            .queryStarting(atValue: 0)
                            //            .queryEnding(atValue: 80)
                            //            .observe(.value) { (datasnapshot) in
                            //                print("*****", datasnapshot)
                            //        }

                            let location1 = CLLocation(latitude: latitude, longitude: longitude)
                            let location2 = CLLocation(latitude: user.latitude, longitude: user.longitude)

                            let distanceBtwn = Int((location1.distance(from: location2))/1000)
                            print("***", "distance = \(distanceBtwn) km")

                            if user.email != Auth.auth().currentUser?.email && user.age >= minAge && user.age <= maxAge && distanceBtwn <= maxDistance {
                                self.users.append(user)
                                self.delegate?.userProvider(self, didFetch: self.users)
                            }
                        }

                    } catch {
                        print(error, "**")
                    }
                }
            } catch {
                print(error, "**")
            }
        }
    }
}
