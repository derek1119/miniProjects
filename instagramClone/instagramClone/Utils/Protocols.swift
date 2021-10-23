//
//  Protocols.swift
//  instagramClone
//
//  Created by Sh Hong on 2021/10/20.
//

protocol UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: UserProfileHeader)
    func setUserStats(for header: UserProfileHeader)
    func handleFollowersTapped(for header: UserProfileHeader)
    func handleFollowingTapped(for header: UserProfileHeader)
}

protocol FollowCellDelegate {
    func handleFollowTapped(for cell: FollowCell)
}

protocol FeedCellDelegate {
    func handleUserNameTapped(for cell: FeedCell)
    func handleOptionsTapped(for cell: FeedCell)
    func handleLikeTapped(for cell: FeedCell)
    func handleCommentTapped(for cell: FeedCell)
    func handleMessageTapped(for cell: FeedCell)
    func handleSavePostTapped(for cell: FeedCell)
}
