//
//  SettingsTableViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 10/6/2022.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    let settings = ["About", "Sign Out"]
    weak var databaseController: DatabaseProtocol?
    
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
        return settings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let setting = settings[indexPath.row]
        content.text = setting
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settings[indexPath.row] == "Sign Out" {
            databaseController?.userSignOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let welcomeScreen = storyboard.instantiateViewController(withIdentifier: "welcomeScreen")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(welcomeScreen)
        }
        
        if settings[indexPath.row] == "About" {
            performSegue(withIdentifier: "toAboutPage", sender: nil)
        }
    }

}
