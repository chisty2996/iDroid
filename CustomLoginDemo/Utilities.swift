//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
import  Firebase
import FirebaseStorage

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        //button.layer.borderWidth = 2
        //button.layer.borderColor = UIColor.blue.cgColor
        button.backgroundColor = UIColor.init(red: 173/255, green: 48/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    static func stylesellButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        //button.layer.borderWidth = 2
        //button.layer.borderColor = UIColor.blue.cgColor
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 15.0
        button.tintColor = UIColor.white
    }
    
    static func styleToolButton(_ button:UIButton) {
        
          /* button.layer.shadowColor = UIColor.black.cgColor
           button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
           button.layer.masksToBounds = false
            button.layer.shadowRadius = 2.0
           button.layer.shadowOpacity = 0.5
          button.layer.cornerRadius = button.frame.width / 2
           button.layer.borderColor = UIColor.green.cgColor
           button.layer.borderWidth = 2.0
           // Hollow rounded corner style
           //button.layer.borderWidth = 2
           //button.layer.borderColor = UIColor.blue.cgColor
           //button.frame = CGRect(x: 10, y: 10, width: 10, height: 10)*/
           button.backgroundColor = UIColor.init(red: 173/255, green: 48/255, blue: 99/255, alpha: 1)
           button.layer.cornerRadius = 15.0
           button.tintColor = UIColor.white
       }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func isEmailValid(_ email : String) -> Bool {
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        return emailTest.evaluate(with: email)
    }
    
    static func isPriceValid(_ price : String) -> Bool {
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@",
                                    "[0-9._%+-]")
        return emailTest.evaluate(with: price)
    }

}
