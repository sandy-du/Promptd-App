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
    var currentImage: UIImage?
    var currentStoryText: String?
    weak var coreDataController: CoreDataProtocol?
    @IBOutlet weak var promptWriteView: UIView!
    @IBOutlet weak var promptTextLabel: UILabel!
    @IBOutlet weak var promptImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //databaseController = appDelegate?.databaseController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        coreDataController = appDelegate?.coreDataController
        
        promptWriteView.layer.cornerRadius = 10
        promptWriteView.clipsToBounds = true
        promptTextLabel.text = currentPrompt?.text
        promptImageView.image = currentImage
        promptImageView.contentMode = .scaleAspectFill
        promptImageView.clipsToBounds = true
        
        // TESTING PURPOSE TO SEE IF THE TEXTVIEW TEXT CAN BE CHANGED BASED ON SEGUE
        storyTextField.text = currentStoryText ?? ""
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
