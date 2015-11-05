//
//  LoginController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 05/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    var storyboardMain: UIStoryboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyboardMain = UIStoryboard.init(name: "Main", bundle: nil)
    }


    @IBAction func submitPressed(sender: UIButton) {
        
        if userTextField.text == "" && passTextField.text == ""{
            let userViewController = storyboard!.instantiateViewControllerWithIdentifier("userController")
            presentViewController(userViewController, animated: true, completion: nil)
        }
        
        if userTextField.text == "admin" && passTextField.text == "admin" {
            let userViewController = storyboard!.instantiateViewControllerWithIdentifier("adminController")
            presentViewController(userViewController, animated: true, completion: nil)

        }
    }
}
