//
//  MyPromptsTableViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 4/5/2022.
//

import UIKit

class MyPromptsTableViewController: UITableViewController, DatabaseListener {
    

    weak var databaseController: DatabaseProtocol?
    var allMyPrompts: [MyPrompt] = []
    var listenerType = ListenerType.myPrompts
    let CELL_MYPROMPT = "myPromptCell"
    
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
        let myPrompt = allMyPrompts[indexPath.row]
        performSegue(withIdentifier: "showMyPromptsWritingScreen", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func onMyPromptsChange(change: DatabaseChange, myPrompts: [MyPrompt]) {
        allMyPrompts = myPrompts
        
    }
    
    func onFavouritePromptsChange(change: DatabaseChange, favouritePrompts: [FavouritePrompt]) {
        //
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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