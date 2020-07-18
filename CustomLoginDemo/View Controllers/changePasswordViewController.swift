//
//  changePasswordViewController.swift
//  CustomLoginDemo
//
//  Created by Main Uddin Chisty on 21/12/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class passwordclass {
    
    var password:String;
    var uid:String
    init(password:String,uid:String) {
        self.password = password;
        self.uid = uid;
    }
}

class changePasswordViewController: UIViewController {

    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var currentPasswordTextField: UITextField!
    
    @IBOutlet var confirmePasswordTextField: UITextField!
    
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var changeButton: UIButton!
    var ref = Firestore.firestore()
    var usernow = passwordclass(password: "", uid: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.styleTextField(newPasswordTextField)
        Utilities.styleTextField(confirmePasswordTextField)
        Utilities.styleFilledButton(changeButton)
        errorLabel.alpha = 0
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        
        ref = Firestore.firestore()
        let error = validatefields()
        
         
         if error != nil {
             
             showError(error!)
         }
         else {
            let password = self.newPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            
            let confirmpassword = self.confirmePasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                            // User re-authenticated.
            if password != confirmpassword{
                self.displayMyAlertMessage(userMessage: "Password Do not Match")
            }
            else
            {
                Auth.auth().currentUser?.updatePassword(to: password) { (err) in if err != nil {
                            self.showError("Error Saving Password")
                        }
                        else {
                            self.transitionToHome()
                        }
                              // ...
                    }
                }
                          
            }
        }
    func displayMyAlertMessage(userMessage: String)
    {
        let myalert = UIAlertController(title: "Alert!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okaction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
    }
    func transitionToHome()
    {
      let TabViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        
        view.window?.rootViewController = TabViewController
        view.window?.makeKeyAndVisible()
    }
    
    func validatefields() -> String?
       {
           if (newPasswordTextField.text?.isEmpty)! || (confirmePasswordTextField.text?.isEmpty)!
           {
               return "Please fill in all fields."
           }
           
           let cleanedPassword = newPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           
           if Utilities.isPasswordValid(cleanedPassword) == false {
               
               return "Please make sure your password is at least 8 characters, contains 1 special character and a number."
           }
           
           return nil
       }
    
    
    func showError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
