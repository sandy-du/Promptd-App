//
//  WritingScreenViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 18/5/2022.
//

import UIKit

class WritingScreenViewController: UIViewController {
    
    //weak var databaseController: DatabaseProtocol?
    @IBOutlet weak var storyTextField: UITextView!
    var currentPrompt: FavouritePrompt?
    weak var coreDataController: CoreDataProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //databaseController = appDelegate?.databaseController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        coreDataController = appDelegate?.coreDataController
        
    }
    
    @IBAction func saveStoryToUser(_ sender: Any) {
        //let _ = databaseController?.addStoryToUser(prompt: currentPrompt!, text: storyTextField.text)
        let _ = coreDataController?.addDraft(prompt: currentPrompt!, text: storyTextField.text)
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
