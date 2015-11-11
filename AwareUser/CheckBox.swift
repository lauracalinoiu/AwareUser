//
//  CheckBox.swift
//  AwareUser
//
//  Created by ab al on 03/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit


//Nice custom button for emulate a swift checkbox, since swift does not contain one
class CheckBox: UIButton {
    let checkedImage = UIImage(named: "checked")
    let uncheckedImage = UIImage(named: "unchecked")

    var isChecked: Bool = false{
        didSet{
            if isChecked {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        isChecked = false
    }
    
    func buttonClicked(sender: UIButton){
        if sender == self {
           isChecked = !isChecked
        }
    }
}
