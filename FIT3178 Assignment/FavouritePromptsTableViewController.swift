//
//  FavouritePromptsTableViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 10/5/2022.
//

import UIKit

class FavouritePromptsTableViewController: UITableViewController, DatabaseListener {
    
    weak var databaseController: DatabaseProtocol?
    var allFavouritePrompts: [Prompt] = []
    var listenerType = ListenerType.favouritePrompts
    let CELL_FAVPROMPT = "favouritePromptCell"
    var currentPrompt: Prompt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFavouritePrompts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure and return a favouritePrompt cell
        let favPromptCell = tableView.dequeueReusableCell(withIdentifier: CELL_FAVPROMPT, for: indexPath)
        var content = favPromptCell.defaultContentConfiguration()
        let favPrompt = allFavouritePrompts[indexPath.row]
        content.text = favPrompt.text
        favPromptCell.contentConfiguration = content
        return favPromptCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPrompt = allFavouritePrompts[indexPath.row]
        performSegue(withIdentifier: "showFavouritedWritingScreenSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favPrompt = allFavouritePrompts[indexPath.row]
            databaseController?.deleteFavouritePrompt(favouritePrompt: favPrompt)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func onMyPromptsChange(change: DatabaseChange, myPrompts: [Prompt]) {
        //
    }
    
    func onFavouritePromptsChange(change: DatabaseChange, favouritePrompts: [Prompt]) {
        allFavouritePrompts = favouritePrompts
        tableView.reloadData()
    }

    func onPostedStoriesChange(change: DatabaseChange, postedStories: [Story]) {
        //
    }
    
    func onFriendsChange(change: DatabaseChange, friends: [User]) {
        //
    }
    
    
    func onAllUsersChange(change: DatabaseChange, allUsers: [User]) {
        //
    }
    
    func onFriendRequestsChange(change: DatabaseChange, friendRequests: [User]) {
        //
    }
    
    func onFriendPostedStoriesChange(change: DatabaseChange, friendPostedStories: [Story]) {
        //
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavouritedWritingScreenSegue" {
            let destination = segue.destination as! WritingScreenViewController
            destination.currentPrompt = currentPrompt
            destination.currentScreen = "FavouritePrompts"
        }
    }

}
