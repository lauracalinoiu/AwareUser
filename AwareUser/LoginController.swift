//
//  LoginController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 05/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class LoginController: UIViewController, TouchIDDelegate {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var lblMessage: UILabel!
    var storyboardMain: UIStoryboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyboardMain = UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        let touchIDAuth : TouchID = TouchID()
        touchIDAuth.touchIDReasonString = "To access the app."
        touchIDAuth.delegate = self
        touchIDAuth.touchIDAuthentication()
        
        userTextField.hidden = true
        passTextField.hidden = true
        submitButton.hidden = true
    }
    
    func touchIDAuthenticationWasSuccessful() {
        // TODO: Proceed to the app and show its contents after a successful login.
        
        self.lblMessage.text = "Successful Authentication!"
    }
    
    
    func touchIDAuthenticationFailed(errorCode: TouchIDErrorCode) {
        // TODO: Fallback to a custom authentication method when necessary.
        
        switch errorCode{
        case .TouchID_CanceledByTheSystem:
            self.lblMessage.text = "Canceled by the system"
            
        case .TouchID_CanceledByTheUser:
            self.lblMessage.text = "Canceled by the user"
            
        case .TouchID_PasscodeNotSet:
            self.lblMessage.text = "No passcode was set"
            
        case .TouchID_TouchIDNotAvailable:
            self.lblMessage.text = "TouchID is not available"
            
        case .TouchID_TouchIDNotEnrolled:
            self.lblMessage.text = "No enrolled finger was found"
            
        case .TouchID_UserFallback:
            self.lblMessage.text = "Should call custom authentication method"
            
        default:
            self.lblMessage.text = "Authentication failed"
        }
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
