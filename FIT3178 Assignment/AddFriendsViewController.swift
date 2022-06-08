//
//  AddFriendsViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 7/6/2022.
//

import UIKit

class AddFriendsViewController: UITableViewController, UISearchResultsUpdating {

    // All the users in the DB
    var allUsers: [User] = []
    // Filtered users from the search
    var filteredUsers: [User] = []
    let CELL_USER = "userCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allUsers = [createUser(username: "sam"), createUser(username: "max"), createUser(username: "seb"), createUser(username: "connor"), createUser(username: "conan")]
        
        // Comment out to not have all users show up intially
        //filteredUsers = allUsers
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class AddFriendTableViewCell: UITableViewCell {
    @IBOutlet weak var friendUserLabel: UILabel!
    @IBAction func addFriend(_ sender: Any){
        // Add friend to friend list of user
    }
    
}
