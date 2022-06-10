//
//  SignupViewController.swift
//  FIT3178 Assignment
//
//  Created by Sandy Du on 18/5/2022.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    weak var databaseController: DatabaseProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up database controller
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signup(_ sender: Any) {
        
        guard let email = emailTextField.text, isValidEmail(email: email) else {
            displayMessage(title: "Invalid Email", message: "Please type in a valid email")
            return
        }
        guard let password = passwordTextField.text, isValidPassword(password: password) else {
            displayMessage(title: "Invalid Password", message: "Please type in a password longer than 8 characters")
            return
        }
        
        guard let username = usernameTextField.text else {
            displayMessage(title: "Enter Username", message: "Please enter a username")
            return
        }
        
        databaseController?.createNewAccount(email: email, password: password, username: username)
        performSegue(withIdentifier: "signupToNotifsSegue", sender: nil)
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreen = storyboard.instantiateViewController(withIdentifier: "homeScreen") as! HomeTabBarController
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(homeScreen)
         */
    }
    
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
        performSegue(withIdentifier: "toLoginPage", sender: nil)
    }
    
}
