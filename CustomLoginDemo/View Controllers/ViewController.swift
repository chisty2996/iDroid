//
//  ViewController.swift
//  CustomLoginDemo
//
//  Created by Main Uddin Chisty on 27/9/19.
//  Copyright © 2019 Main Uddin Chisty. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    
    var videoPlayer:AVPlayer?
    var videoPlayerLayer:AVPlayerLayer?
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpElements()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    func setUpElements()
    {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
    
   

}

