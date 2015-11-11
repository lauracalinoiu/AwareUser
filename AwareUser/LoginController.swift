//
//  LoginController.swift
//  AwareUser
//
//  Created by ab al on 02/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

//Just an initial view controller that goes further on the app if authentication with TouchID is flawless,
//otherwise it displayes errors accordingly

class LoginController: UIViewController, TouchIDDelegate {
    var storyboardMain: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
    var touchIDAuth: TouchID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        touchIDAuth = TouchID()
        touchIDAuth.touchIDReasonString = "To access the app."
        touchIDAuth.delegate = self
        touchIDAuth.touchIDAuthentication()
    }
    
    func touchIDAuthenticationWasSuccessful() {
        // Proceed to the app and show its contents after a successful login.
        let userViewController = storyboard!.instantiateViewControllerWithIdentifier("adminController")
        presentViewController(userViewController, animated: true, completion: nil)
    }
    
    
    func touchIDAuthenticationFailed(errorCode: TouchIDErrorCode) {
        // Fallback to a custom authentication method when necessary.
        switch errorCode{
            
        case .TouchID_PasscodeNotSet, .TouchID_TouchIDNotAvailable, .TouchID_TouchIDNotEnrolled:
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
            
        case .TouchID_CanceledByTheUser:
            let ac = UIAlertController(title: "Only with TouchID auth", message: "App can not be unlocked without TouchID usage!", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
            
            
        case .TouchID_UserFallback:
            let ac = UIAlertController(title: "Passcode? NO, NO ...", message: "It's just Touch ID!", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
            return
            
        case .TouchID_CanceledByTheSystem, .TouchID_AuthenticationFailed:
            let ac = UIAlertController(title: "Authentication failed", message: "Your fingerprint could not be verified; please try again.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default){ (alert: UIAlertAction!) in
                self.touchIDAuth.touchIDAuthentication()
                })
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }
}