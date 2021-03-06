//
//  EditAnswerController.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 08/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class EditAnswerController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    var answerText: String!
    var cell: AnswerCellOnEdit!
    var delegateForMessage: MessageDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "donePressed")
        textView.delegate = self
        textView.text = answerText
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textView.isFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        answerText = textView.text
    }
    
    func donePressed(){
        delegateForMessage.storeMessage(textView.text)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
