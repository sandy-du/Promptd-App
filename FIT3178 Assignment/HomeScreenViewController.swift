//
//  HomeScreenViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 21/4/2022.
//

import UIKit
import SwiftSoup

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var promptView: UIView!
    @IBOutlet weak var favouriteButton: UIButton!
    var counter: Int = 0
    let REQUEST_STRING = "https://api.unsplash.com/photos/random/?client_id=Rik_ZjL2_JqDOC9osc5GIvCRg0OYOpwEUCUgHh2ZS64&orientation=landscape"
    var imagePromptURL: String?
    var promptFavourited = false
    weak var databaseController: DatabaseProtocol?
    var currentFavouritePrompt: FavouritePrompt?
    var currentPrompt: FavouritePrompt?
    var currentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        promptView.layer.cornerRadius = 10
        
        promptLabel.textColor = .gray
        // Setting up favourite button
        let starImage = UIImage(systemName: "star")
        favouriteButton.setImage(starImage, for: .normal)

        Task {
            await requestRandomImageURL()
            getImage()
        }
        getRandomPrompt()
        
        // Set the new prompt as the current prompt
        currentPrompt = FavouritePrompt()
        
    }
    
    @IBAction func writeStory(_ sender: Any) {
        performSegue(withIdentifier: "writingScreenSegue", sender: nil)
    }
    

    @IBAction func nextPrompt(_ sender: Any) {
        // Reset favourited button
        promptFavourited = false
        let starImage = UIImage(systemName: "star")
        favouriteButton.setImage(starImage, for: .normal)
        
        Task {
            await requestRandomImageURL()
            getImage()
        }
        getRandomPrompt()
        
    }
    
    func requestRandomImageURL() async {
        // Create URL for the API request
        guard let requestURL = URL(string: REQUEST_STRING) else {
            print("INVALID URL!")
            return
        }
        
        let urlRequest = URLRequest(url: requestURL)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            let decoder = JSONDecoder()
            let visualPromptData = try decoder.decode(VisualPromptData.self, from: data)
            if let imageURL = visualPromptData.imageURL {
                await MainActor.run {
                    imagePromptURL = imageURL
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func getImage() {
        if let imageURL = imagePromptURL {
            let requestURL = URL(string: imageURL)
            if let requestURL = requestURL {
                Task {
                    do {
                        let (data, response ) = try await URLSession.shared.data(from: requestURL)
                        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                            throw ImageError.invalidServerResponse
                        }
                        
                        if let image = UIImage(data: data) {
                            imageView.image = image
                            currentImage = image
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
    
    func getRandomPrompt() {
        guard let writtenPromptURL = URL(string: "https://www.randomwordgenerator.org/random-sentence-generator") else {
            print("INVALID URL!")
            return
        }
        
        guard let html = try? String(contentsOf: writtenPromptURL) else {
            print("No HTML FOUND!")
            return
        }
        
        guard let document = try? SwiftSoup.parse(html) else {
            print("No document parsed!")
            return
        }
        
        do {
            
            if let sentence = try? document.select(".result").first()?.text() {
                promptLabel.text = sentence
            }
        }
    }

    @IBAction func favourited(_ sender: Any) {
        let starImageFilled = UIImage(systemName: "star.fill")
        let starImage = UIImage(systemName: "star")
        if promptFavourited == false {
            favouriteButton.setImage(starImageFilled, for: .normal)
            promptFavourited = true
            // Add prompt to database
            currentFavouritePrompt = databaseController?.addFavouritePrompt(imageURL: imagePromptURL ?? "", text: promptLabel.text ?? "")
            
        } else if promptFavourited == true {
            favouriteButton.setImage(starImage, for: .normal)
            promptFavourited = false
            // Remove prompt from database
            let _ = databaseController?.deleteFavouritePrompt(favouritePrompt: currentFavouritePrompt!)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "writingScreenSegue" {
            let destination = segue.destination as! WritingScreenViewController
            currentPrompt?.text = promptLabel.text
            currentPrompt?.imageURL = imagePromptURL
            destination.currentPrompt = currentPrompt
            destination.currentImage = currentImage
        }
    }
    
   

}

enum ImageError: Error {
    case invalidServerResponse
}
