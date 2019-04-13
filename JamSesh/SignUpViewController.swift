//
//  SignUpViewController.swift
//  JamSesh
//
//  Created by Monali Chuatico on 4/10/19.
//  Copyright © 2019 Monali Chuatico. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var password2Field: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
//        let username = usernameField.text!
//        let email = emailField.text!
//        let password = passwordField.text!
//        let repeatPassword = password2Field.text!
        
        let user = PFUser();
        user.username = usernameField.text!
        user.email = emailField.text!
        
        // Check if passwords match
        if(passwordField.text == password2Field.text){
            user.password = passwordField.text!
        } else {
            self.displayMyAlertMessage(title:"Password do not match", message: "Please try again")
        }
        
        user.signUpInBackground { (success, error) in
            if success {
                
                // Display message successful
                let myAlert = UIAlertController(title: "Registration successful", message: "Thank you!", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title:"Ok", style:UIAlertAction.Style.default){ action in
                    self.dismiss(animated: true, completion:nil);
                }
                
                myAlert.addAction(okAction);
                self.present(myAlert, animated:true, completion:nil);
                
                
                // Go back to login
                self.performSegue(withIdentifier: "backToLoginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription)")
            }
            
        }
        
        // Check for empty fields
        if (usernameField.text!.isEmpty || emailField.text!.isEmpty || passwordField.text!.isEmpty) {
            self.displayMyAlertMessage(title:"All fields are required",message: "Please try again")
        }
        
        
    }
    
    // Display message for confirmation
    func displayMyAlertMessage(title:String, message:String) {
        
        let myAlert = UIAlertController(title:title, message:message, preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title:"OK", style:UIAlertAction.Style.default, handler:nil);
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
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
