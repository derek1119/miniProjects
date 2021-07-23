//
//  Constants.swift
//  API _ Tutorial
//
//  Created by Sh Hong on 2021/07/20.
//

import Foundation

enum SEGUE_ID {
    static let  USER_LIST_VC = "goToUserListVC"
    static let PHOTO_COLLECTION_VC = "goToPhotoCollectionVC"
}

enum API {
    static let BASE_URL : String = "https://api.unsplash.com/"
    
    static let CLIENT_ID : String = "qmjoNkPFeLhC64G_zB87PsvPHXTAZ_Ma9oz6yTbMIeY"
}

enum NOTIFICATION {
    enum API {
        static let AUTH_FAIL = "authentication_fail"
    }
}
