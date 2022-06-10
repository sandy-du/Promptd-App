//
//  MyPromptsTableViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 4/5/2022.
//

import UIKit

class MyPromptsTableViewController: UITableViewController, DatabaseListener {
    

    weak var databaseController: DatabaseProtocol?
    var allMyPrompts: [Prompt] = []
    var listenerType = ListenerType.myPrompts
    let CELL_MYPROMPT = "myPromptCell"
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
        return allMyPrompts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure and return a myPrompts cell
        let myPromptCell = tableView.dequeueReusableCell(withIdentifier: CELL_MYPROMPT, for: indexPath)
        var content = myPromptCell.defaultContentConfiguration()
        let myPrompt = allMyPrompts[indexPath.row]
        content.text = myPrompt.text
        myPromptCell.contentConfiguration = content
        return myPromptCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPrompt = allMyPrompts[indexPath.row]
        performSegue(withIdentifier: "showMyPromptWritingScreenSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let myPrompt = allMyPrompts[indexPath.row]
            databaseController?.deleteMyPrompt(myPrompt: myPrompt)
        }
    }
    
    @IBAction func addMyPrompts(_ sender: Any) {
        performSegue(withIdentifier: "addMyPromptSegue", sender: nil)
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
        allMyPrompts = myPrompts
        tableView.reloadData()
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
        if segue.identifier == "showMyPromptWritingScreenSegue" {
            let destination = segue.destination as! WritingScreenViewController
            destination.currentPrompt = currentPrompt
            destination.currentScreen = "MyPrompts"
        }
    }
    

}
