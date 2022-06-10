//
//  AddMyPromptViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 4/5/2022.
//

import UIKit

class AddMyPromptViewController: UIViewController {
    @IBOutlet weak var promptText: UITextView!
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    @IBAction func saveMyPrompt(_ sender: Any) {
        let _ = databaseController?.addMyPrompt(text: promptText.text)
        navigationController?.popViewController(animated: true)
    }
}
