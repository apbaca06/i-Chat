//
//  DatabasePath.swift
//  i-Chat
//
//  Created by cindy on 2017/12/20.
//  Copyright © 2017年 Jui-hsin.Chen. All rights reserved.
//

import Foundation
import Firebase

public struct DatabasePath {

    public static let databaseRoot = Database.database().reference()

    public static let userRef = databaseRoot.child("users")

    public static let userFriendRef = databaseRoot.child("user_friend")

    public static let chatroomRef = databaseRoot.child("chatroom")

    public static let messageRef = databaseRoot.child("message")

    public static let reportRef = databaseRoot.child("report")

    public static let userUnlikeRef = databaseRoot.child("user_unlike")

    public static let userSwipedLikeRef = databaseRoot.child("user_swipedLike")
}
