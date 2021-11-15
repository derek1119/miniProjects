//
//  Protocols.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/20.
//

import UIKit

protocol UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: UserProfileHeader)
    func setUserStats(for header: UserProfileHeader)
    func handleFollowersTapped(for header: UserProfileHeader)
    func handleFollowingTapped(for header: UserProfileHeader)
}

protocol FollowCellDelegate {
    func handleFollowTapped(for cell: FollowLikeCell)
}

protocol FeedCellDelegate {
    func handleUserNameTapped(for cell: FeedCell)
    func handleOptionsTapped(for cell: FeedCell)
    // 더블 탭으로 좋아요를 표시한 것인지 혹은 좋아요 버튼을 눌러서 표시한 액션인지 분기처리하기 위함
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool)
    func handleCommentTapped(for cell: FeedCell)
    func handleMessageTapped(for cell: FeedCell)
    func handleSavePostTapped(for cell: FeedCell)
    func handleConfigureLikeButton(for cell: FeedCell)
    func handleShowLikes(for cell: FeedCell)
}

protocol NotificationCellDelegate {
    func handleFollowTapped(for cell: NotificationCell)
    func handlePostTapped(for cell: NotificationCell)
}

protocol Printable {
    var description: String { get }
}

protocol CommentInputAccessoryViewDelegate {
    func didSummit(forComment comment: String)
}

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
