//
//  FriendProfileViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 10/6/2022.
//

import UIKit

class FriendProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DatabaseListener {
    
    var listenerType = ListenerType.friendPostedStories
    weak var databaseController: DatabaseProtocol?
    //var listenerType = ListenerType.postedStories
    let CELL_POSTED = "friendPostedCell"
    var allFriendPostedStories: [Story] = []
    var friendStories: [Story] = []
    var selectedStory: Story?
    var currentFriend: User?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allFriendPostedStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_POSTED, for: indexPath) as! FriendPostedCell
        let story = allFriendPostedStories[indexPath.row]
        cell.friendPromptLabel.text = story.prompt?.text
        cell.friendStoryText.text = story.text
        cell.friendDateText.text = formatDate(date: story.datePosted!)
        return cell
    }

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
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
        //
    }
    
    func onAllUsersChange(change: DatabaseChange, allUsers: [User]) {
        //
    }
    
    func onFriendPostedStoriesChange(change: DatabaseChange, friendPostedStories: [Story]) {
        allFriendPostedStories = friendPostedStories
        collectionView.reloadData()
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

class FriendPostedCell: UICollectionViewCell {
    @IBOutlet weak var friendPromptLabel: UILabel!
    @IBOutlet weak var friendStoryText: UILabel!
    @IBOutlet weak var friendDateText: UILabel!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        background.layer.cornerRadius = 12
    }
}
