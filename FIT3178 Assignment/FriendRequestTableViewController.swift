//
//  FriendRequestTableViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 8/6/2022.
//

import UIKit

class FriendRequestTableViewController: UITableViewController, DatabaseListener, FriendRequestTableViewCellDelegate {
    
    weak var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.friendRequests
    var allFriendRequests: [User] = []
    let CELL_FRIENDREQUEST = "friendRequestCell"
    
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
        return allFriendRequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure and return a hero cell
        let friendRequestCell = tableView.dequeueReusableCell(withIdentifier: CELL_FRIENDREQUEST, for: indexPath) as! FriendRequestTableViewCell
        // Set cell delegate
        friendRequestCell.cellDelegate = self
        friendRequestCell.acceptButton.tag = indexPath.row
        friendRequestCell.declineButton.tag = indexPath.row
        let user = allFriendRequests[indexPath.row]
        friendRequestCell.friendRequestLabel.text = user.username
        return friendRequestCell
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
        //
    }
    
    func onFriendRequestsChange(change: DatabaseChange, friendRequests: [User]) {
        allFriendRequests = friendRequests
        tableView.reloadData()
    }
    
    func onAllUsersChange(change: DatabaseChange, allUsers: [User]) {
        //
    }
    
    func onFriendPostedStoriesChange(change: DatabaseChange, friendPostedStories: [Story]) {
        //
    }
    
    func didPressAcceptButton(_ tag: Int) {
        let user = allFriendRequests[tag]
        let _ = databaseController?.addFriendToUser(friend: user)
        let _ = databaseController?.addUserToFriend(friend: user)
        let _ = databaseController?.deleteUserFromFriendRequest(friend: user)
        navigationController?.popViewController(animated: true)
    }
    
    func didPressDeclineButton(_ tag: Int) {
        let user = allFriendRequests[tag]
        let _ = databaseController?.deleteUserFromFriendRequest(friend: user)
        navigationController?.popViewController(animated: true)
    }
}

// Reference: https://stackoverflow.com/questions/39947076/uitableviewcell-buttons-with-action/39947434#39947434
protocol FriendRequestTableViewCellDelegate: AnyObject {
    func didPressAcceptButton(_ tag: Int)
    func didPressDeclineButton(_ tag: Int)
}

class FriendRequestTableViewCell: UITableViewCell {
    @IBOutlet weak var friendRequestLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    var cellDelegate: FriendRequestTableViewCellDelegate?
    
    
    @IBAction func acceptFriend(_ sender: UIButton) {
        cellDelegate?.didPressAcceptButton(sender.tag)
    }
    
    @IBAction func declineFriend(_ sender: UIButton) {
        cellDelegate?.didPressDeclineButton(sender.tag)
    }

}
