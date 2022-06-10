//
//  AddFriendsViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 7/6/2022.
//

import UIKit

class AddFriendsViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener, TableViewCellDelegate {

    

    weak var databaseController: DatabaseProtocol?
    // All the users in the DB
    var allUsers: [User] = []
    // Filtered users from the search
    var filteredUsers: [User] = []
    let CELL_USER = "userCell"
    var listenerType = ListenerType.allUsers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        // Set up search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Username"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        // This view controller decides how the search controller is presented
        definesPresentationContext = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure and return a hero cell
        let userCell = tableView.dequeueReusableCell(withIdentifier: CELL_USER, for: indexPath) as! AddFriendTableViewCell
        // Set cell delegate
        userCell.cellDelegate = self
        userCell.addFriendButton.tag = indexPath.row
        let user = filteredUsers[indexPath.row]
        userCell.friendUserLabel.text = user.username
        return userCell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            filteredUsers = allUsers.filter({ (user: User) -> Bool in
                return (user.username?.lowercased().contains(searchText) ?? false && (user.uid != databaseController?.getCurrentUser().uid))
            })
        }
        tableView.reloadData()
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
    
    func onAllUsersChange(change: DatabaseChange, allUsers: [User]) {
        self.allUsers = allUsers
        tableView.reloadData()
    }
    
    func onFriendRequestsChange(change: DatabaseChange, friendRequests: [User]) {
        //
    }
    func onFriendPostedStoriesChange(change: DatabaseChange, friendPostedStories: [Story]) {
        //
    }
    
    func didPressButton(_ tag: Int){
        // Function to pass the addFriendButton the friend added
        let friendSelected = filteredUsers[tag]
        //let _ = databaseController?.addFriendToUser(friend: friendSelected)
        print("Friend selected to send request to: \(friendSelected.username)")
        let _ = databaseController?.addUserToFriendRequest(friend: friendSelected)
        navigationController?.popViewController(animated: true)
    }
    
}

// Reference: https://stackoverflow.com/questions/39947076/uitableviewcell-buttons-with-action/39947434#39947434
protocol TableViewCellDelegate: AnyObject {
    func didPressButton(_ tag: Int)
}

class AddFriendTableViewCell: UITableViewCell {
    
    var cellDelegate: TableViewCellDelegate?
    @IBOutlet weak var friendUserLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBAction func addFriend(_ sender: UIButton){
        // Add friend to friend list of user
        cellDelegate?.didPressButton(sender.tag)
    }
    
}
