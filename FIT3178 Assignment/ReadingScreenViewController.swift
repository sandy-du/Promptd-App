//
//  ReadingScreenViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 10/6/2022.
//

import UIKit

class ReadingScreenViewController: UIViewController {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var promptImageView: UIImageView!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var promptView: UIView!
    var currentPrompt: Prompt?
    var currentStoryText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        promptView.layer.cornerRadius = 10
        promptView.clipsToBounds = true
        promptLabel.text = currentPrompt?.text
        
        if currentPrompt?.imageURL != nil {
            getImage()
            promptImageView.contentMode = .scaleAspectFill
            promptImageView.clipsToBounds = true
        } else {
            promptImageView.removeFromSuperview()
            promptLabel.font = promptLabel.font.withSize(20)
        }
        
        storyTextView.text = currentStoryText
        storyTextView.isEditable = false
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
}
