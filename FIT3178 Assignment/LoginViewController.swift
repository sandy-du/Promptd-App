//
//  LoginViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 18/5/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set up database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    @IBAction func login(_ sender: Any) {
        
        guard let email = emailTextField.text, isValidEmail(email: email) else {
            displayMessage(title: "Invalid Email", message: "Please type in a valid email")
            return
        }
        guard let password = passwordTextField.text, isValidPassword(password: password) else {
            displayMessage(title: "Invalid Password", message: "Please type in a password longer than 8 characters")
            return
        }
        
        databaseController?.signInWithAccount(email: email, password: password)
        performSegue(withIdentifier: "loginToNotifsSegue", sender: nil)
    }
    
    // Reference: https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift by Maxim Shoustin
    func isValidEmail(email: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._]+@[A-Za-z0-9]+.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool{
        let minPasswordLength = 8
        return password.count >= minPasswordLength
    }
    
    func displayMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add some behaviour to the alert e.g. Dismiss button
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        // Present alert to the user
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func toSignUp(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpScreen", sender: nil)
    }
}
