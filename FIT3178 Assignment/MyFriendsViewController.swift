//
//  MyFriendsViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 7/6/2022.
//

import UIKit

class MyFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatabaseListener {
    
    weak var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.friends
    var allFriends: [User] = []
    let CELL_FRIEND = "friendCell"
    var currentFriend: User?
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    @IBAction func goToAddFriends(_ sender: Any) {
        performSegue(withIdentifier: "addFriendsSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friendCell = tableView.dequeueReusableCell(withIdentifier: CELL_FRIEND, for: indexPath)
        var content = friendCell.defaultContentConfiguration()
        let friend = allFriends[indexPath.row]
        content.text = friend.username
        friendCell.contentConfiguration = content
        return friendCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentFriend = allFriends[indexPath.row]
        performSegue(withIdentifier: "toFriendProfileSegue", sender: nil)
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
        //
    }
    
    func onPostedStoriesChange(change: DatabaseChange, postedStories: [Story]) {
        //
    }
    
    func onFriendsChange(change: DatabaseChange, friends: [User]) {
        allFriends = friends
        tableView.reloadData()
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
    
    @IBAction func toFriendRequests(_ sender: Any) {
        performSegue(withIdentifier: "showFriendRequestsSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendProfileSegue" {
            let destination = segue.destination as! FriendProfileViewController
            databaseController?.setupFriendPostedStoriesListener(friend: currentFriend!)
            destination.currentFriend = currentFriend
        }
    }
    

}
