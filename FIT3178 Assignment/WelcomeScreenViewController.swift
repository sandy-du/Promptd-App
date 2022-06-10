//
//  WelcomeScreenViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 18/5/2022.
//

import UIKit

class WelcomeScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginScreenSegue(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    @IBAction func signupScreenSegue(_ sender: Any) {
        performSegue(withIdentifier: "signupSegue", sender: nil)
    }
    
}
