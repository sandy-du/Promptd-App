//
//  DatabaseProtocol.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 1/5/2022.
//

import Foundation
import FirebaseAuth

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case favouritePrompts
    case myPrompts
    case postedStories
    case users
    case friends
    case friendRequests
    case allUsers
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onMyPromptsChange(change: DatabaseChange, myPrompts: [Prompt] )
    func onFavouritePromptsChange(change: DatabaseChange, favouritePrompts: [Prompt])
    func onPostedStoriesChange(change: DatabaseChange, postedStories: [Story])
    func onFriendsChange(change: DatabaseChange, friends: [User])
    func onFriendRequestsChange(change: DatabaseChange, friendRequests: [User])
    func onAllUsersChange(change: DatabaseChange, allUsers: [User])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addMyPrompt(text: String) -> Prompt
    func deleteMyPrompt(myPrompt: Prompt)
    
    func addFavouritePrompt(imageURL: String ,text: String) -> Prompt
    func deleteFavouritePrompt(favouritePrompt: Prompt)
    
    func createNewAccount(email: String, password: String, username: String)
    func signInWithAccount(email: String, password: String)
    
    func addStoryToUser(prompt: Prompt, text: String) -> Story
    func deleteStoryFromUser(story: Story)
    
    func addFriendToUser(friend: User) -> User
    func deleteFriendFromUser(user: User)
    
    func addUserToFriendRequest(friend: User) -> User
    func deleteUserFromFriendRequest(friend: User)
}
