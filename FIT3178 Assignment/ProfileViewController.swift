//
//  ProfileViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 7/6/2022.
//  Collection View reference: https://www.youtube.com/watch?v=PhuzQRtAGmg
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, DatabaseListener {
    
    weak var databaseController: DatabaseProtocol?
    var listenerType = ListenerType.postedStories
    let CELL_POSTED = "postedCell"
    var allPostedStories: [Story] = []
    var selectedStory: Story?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPostedStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_POSTED, for: indexPath) as! PostedCell
        let story = allPostedStories[indexPath.row]
        cell.promptLabel.text = story.prompt?.text
        cell.storyTextLabel.text = story.text
        cell.dateLabel.text = formatDate(date: story.datePosted!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedStory = allPostedStories[indexPath.row]
        performSegue(withIdentifier: "showStoryReadingScreen", sender: nil)
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
        allPostedStories = postedStories
        collectionView.reloadData()
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
    
    @IBAction func toSettings(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsSegue", sender: nil)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStoryReadingScreen" {
            let destination = segue.destination as! ReadingScreenViewController
            let currentPrompt = Prompt()
            currentPrompt.text = selectedStory?.prompt?.text
            currentPrompt.imageURL = selectedStory?.prompt?.imageURL
            destination.currentPrompt = currentPrompt
            destination.currentStoryText = selectedStory?.text
        }
    }
    

}


class PostedCell: UICollectionViewCell {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var storyTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        background.layer.cornerRadius = 12
    }
}
