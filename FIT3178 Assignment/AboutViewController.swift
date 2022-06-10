//
//  AboutViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 10/6/2022.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutText.isEditable = false
        aboutText.text = "\n\nThird-party libraries used includes Firebase (Firestore, Authentication), SwiftSoup \n References to external resources such as Stackoverflow and Youtube videos is acknowledged throughout the source code. \n\nNotable websites used: www.hackingwithswift.com,\n https://developer.apple.com/,\n https://makeschool.org/mediabook/oa/tracks/build-ios-apps/build-a-photo-sharing-app \n\nWritten prompts sourced from https://www.randomwordgenerator.org/random-sentence-generator \n\nImages sourced from unsplash.com"
    }
}
