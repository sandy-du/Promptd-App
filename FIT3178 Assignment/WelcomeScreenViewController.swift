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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func loginScreenSegue(_ sender: Any) {
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    @IBAction func signupScreenSegue(_ sender: Any) {
        performSegue(withIdentifier: "signupSegue", sender: nil)
    }
    
}
