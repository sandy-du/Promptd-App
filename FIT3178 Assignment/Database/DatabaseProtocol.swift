//
//  DatabaseProtocol.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 1/5/2022.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case favouritePrompts
    case myPrompts
    case stories
    case users
    case all
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onMyPromptsChange(change: DatabaseChange, myPrompts: [MyPrompt] )
    func onFavouritePromptsChange(change: DatabaseChange, favouritePrompts: [FavouritePrompt])
}

protocol DatabaseProtocol: AnyObject {
    func cleanup()
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addMyPrompt(text: String) -> MyPrompt
    func deleteMyPrompt(myPrompt: MyPrompt)
    
    func addFavouritePrompt(imageURL: String ,text: String) -> FavouritePrompt
    func deleteFavouritePromp(favouritePrompt: FavouritePrompt)
    
    func createNewAccount(email: String, password: String)
    func signInWithAccount(email: String, password: String)
}
