//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Main Uddin Chisty on 27/9/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    
    
    @IBOutlet weak var iphoneButton: UIButton!
    @IBOutlet weak var androidButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var Logout: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       

        Utilities.styleToolButton(iphoneButton)
        Utilities.styleToolButton(androidButton)
        //Utilities.stylesellButton(sellButton)
        
        

        // Do any additional setup after loading the view.
    }
        
            
    
    
    @IBAction func slider1Tapped(_ sender: Any) {
        print("Hello World")
    }
    
   
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.transitionToHome()
    }
    
   
    
    func transitionToHome()
    {
        let viewController =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
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
