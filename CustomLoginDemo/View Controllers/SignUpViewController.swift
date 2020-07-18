//
//  SignUpViewController.swift
//  CustomLoginDemo
//
//  Created by Main Uddin Chisty on 27/9/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import SVProgressHUD
class user{
    var firstname:String, lastname:String,email: String, uid:String,propic:String;
    init(firstname:String,lastname:String,email:String,uid:String,propic:String) {
        self.firstname = firstname;
        self.lastname = lastname;
        self.email = email;
        self.uid = uid;
        self.propic = propic;
    }
    
}
class SignUpViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements()
    {
        errorLabel.alpha = 0
        
        Utilities.styleTextField(firstNameTextField)
        
        Utilities.styleTextField(lastNameTextField)
        
        Utilities.styleTextField(emailTextField)
        
        Utilities.styleTextField(passwordTextField)
        
        Utilities.styleTextField(confirmPasswordTextField)
        
        Utilities.styleFilledButton(signUpButton)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func validatefields() -> String?
    {
        if (firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! || (confirmPasswordTextField.text?.isEmpty)!
        {
            return "Please fill in all fields."
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
       
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            
            return "Please make sure your password is at least 8 characters, contains 1 special character and a number."
        }
        
        if Utilities.isEmailValid(cleanedEmail) == false {
            
            
            displayregAlertMessage(userMessage: "Type Email Correctly! Example: example@example.com")
           
        }
        return nil
    }
    
    @IBAction func keyboardhide(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func displayMyAlertMessage(userMessage: String)
    {
        let myalert = UIAlertController(title: "Alert!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okaction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        
        myalert.addAction(okaction)
        self.present(myalert, animated: true, completion: nil)
        
    }
    func displayregAlertMessage(userMessage: String)
       {
          
           
           let myalert = UIAlertController(title: "Welcome!", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okaction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
           
           myalert.addAction(okaction)
           self.present(myalert, animated: true, completion: nil)
           
       }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        
        let error = validatefields()
        
        if error != nil {
            
            showError(error!)
        }
        
        else{
            
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let confirmpassword = confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if password != confirmpassword {
                displayMyAlertMessage(userMessage: "Password Do not Match")
            }
            
            else{
           
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if  err != nil {
                    self.showError("Error Creating User!")
                }
                else{
                    let db = Firestore.firestore()
                    let xx = user(firstname: firstname, lastname: lastname, email: email, uid: result!.user.uid, propic: "")
                    db.collection("users").document(result!.user.uid).setData(["firstname" : xx.firstname ,
                                                                               "lastname":xx.lastname,"email":xx.email,
                                                                               "uid":xx.uid,
                                                                               "propic": ""
                    ]);
                    //db.collection("users").setValue(xx, forKey: result!.user.uid)
                    self.displayregAlertMessage(userMessage: "Registration Succesful!")
                    print("ok")
                    self.transitionToHome()
                    
                }
                    
                }
            
            }
            
        }
        
        
    }
    
    
    func transitionToHome()
    {
      let TabViewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? UITabBarController
        
        view.window?.rootViewController = TabViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
