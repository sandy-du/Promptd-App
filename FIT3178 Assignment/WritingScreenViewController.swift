//
//  WritingScreenViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 18/5/2022.
//

import UIKit

class WritingScreenViewController: UIViewController {
    
    weak var databaseController: DatabaseProtocol?
    @IBOutlet weak var storyTextField: UITextView!
    var currentPrompt: Prompt?
    var currentStoryText: String?
    weak var coreDataController: CoreDataProtocol?
    @IBOutlet weak var promptWriteView: UIView!
    @IBOutlet weak var promptTextLabel: UILabel!
    @IBOutlet weak var promptImageView: UIImageView!
    var currentDraft: StoryDraft?
    var currentScreen: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        coreDataController = appDelegate?.coreDataController
        
        promptWriteView.layer.cornerRadius = 10
        promptWriteView.clipsToBounds = true
        promptTextLabel.text = currentPrompt?.text
        
        if currentPrompt?.imageURL != nil {
            getImage()
            promptImageView.contentMode = .scaleAspectFill
            promptImageView.clipsToBounds = true
        } else {
            promptImageView.removeFromSuperview()
            promptTextLabel.font = promptTextLabel.font.withSize(20)
        }
    
        storyTextField.text = currentStoryText ?? ""
        
    }
    
    @IBAction func saveStoryToUser(_ sender: Any) {
        //let _ = databaseController?.addStoryToUser(prompt: currentPrompt!, text: storyTextField.text)
        let _ = coreDataController?.addDraft(prompt: currentPrompt!, text: storyTextField.text)
        navigationController?.popViewController(animated: true)
        
    }
    func getImage() {
        if let imageURL = currentPrompt?.imageURL {
            let requestURL = URL(string: imageURL)
            if let requestURL = requestURL {
                Task {
                    do {
                        let (data, response ) = try await URLSession.shared.data(from: requestURL)
                        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                            throw ImageError.invalidServerResponse
                        }
                        
                        if let image = UIImage(data: data) {
                            promptImageView.image = image
                        } else {
                            print("Not a valid image!")
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func postDraft(_ sender: Any) {
        let _ = databaseController?.addStoryToUser(prompt: currentPrompt!, text: storyTextField.text)
        if (currentScreen == "Draft") {
            coreDataController?.deleteDraft(draft: currentDraft!)
        } else if (currentScreen == "MyPrompts") {
            databaseController?.deleteMyPrompt(myPrompt: currentPrompt!)
        } else if (currentScreen == "FavouritePrompts") {
            databaseController?.deleteFavouritePrompt(favouritePrompt: currentPrompt!)
        }
        navigationController?.popViewController(animated: true)
    }
}
