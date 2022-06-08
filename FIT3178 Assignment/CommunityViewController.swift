//
//  CommunityViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 7/6/2022.
//

import UIKit

class CommunityViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let CELL_FRIENDPOSTED = "friendsPostedCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return total friends stories
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_FRIENDPOSTED, for: indexPath) as! FriendsPostedCell
        return cell
    }

    @IBAction func goToMyFriends(_ sender: Any) {
        performSegue(withIdentifier: "friendsListScreenSegue", sender: nil)
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

class FriendsPostedCell: UICollectionViewCell {
    
}
