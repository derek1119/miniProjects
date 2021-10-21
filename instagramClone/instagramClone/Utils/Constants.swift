//
//  Constants.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/20.
//

import Firebase

// MARK: - Root Reference

let DB_REF = Database.database().reference()
let STORAGE_REF = Storage.storage().reference()

// MARK: - Storage Reference

let STORAGE_PROFILE_IMAGES_REF = STORAGE_REF.child("profile_images")

// MARK: - Database Reference

let USER_REF = DB_REF.child("users")

let USER_FOLLOWER_REF = DB_REF.child("user-followers")
let USER_FOLLOWING_REF = DB_REF.child("user-following")

let POSTS_REF = DB_REF.child("posts")

let NOTIFICATIONS_REF = DB_REF.child("notifications")

// MARK: - Decoding Values

let FOLLOW_INT_VALUE = 2
