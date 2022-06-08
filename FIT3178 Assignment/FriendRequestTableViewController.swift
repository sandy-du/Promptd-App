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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    func didPressAcceptButton(_ tag: Int) {
        let user = allFriendRequests[tag]
        let _ = databaseController?.addFriendToUser(friend: user)
        navigationController?.popViewController(animated: true)
    }
    
    func didPressDeclineButton(_ tag: Int) {
        let user = allFriendRequests[tag]
        let _ = databaseController?.deleteUserFromFriendRequest(friend: user)
        navigationController?.popViewController(animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
