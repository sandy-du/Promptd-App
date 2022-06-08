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
        
        //allUsers = [createUser(username: "sam"), createUser(username: "max"), createUser(username: "seb"), createUser(username: "connor"), createUser(username: "conan")]
        
        // Comment out to not have all users show up intially
        //filteredUsers = allUsers
        
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
    
    func createUser(username: String) -> User {
        let user = User()
        user.username = username
        return user
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
                return (user.username?.lowercased().contains(searchText) ?? false)
            })
        } else {
            // Comment out to not have all users show up intially
            //filteredUsers = allUsers
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
    
    func didPressButton(_ tag: Int){
        // Function to pass the addFriendButton the friend added
        let friendSelected = allUsers[tag]
        //let _ = databaseController?.addFriendToUser(friend: friendSelected)
        let _ = databaseController?.addUserToFriendRequest(friend: friendSelected)
        navigationController?.popViewController(animated: true)
    }
    
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
