//
//  ParseAPIClient.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 02/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation
import Parse

class ParseAPIClient {
    
    let NETWORK_INACCESSIBLE = "The network was inaccesible"
    let queryLimit = 10
    
    func getQuestionsFromParse(completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let query = PFQuery(className: "question")
        query.limit = queryLimit
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    completionHandler(result: objectsUnwrapped, error: nil)
                }
            } else {
                completionHandler(result: nil, error: self.NETWORK_INACCESSIBLE)
            }
        }
    }
    
    func getAnswersForQuestion(question: PFObject , completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let relation = question.relationForKey("answers")
        relation.query()?.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    completionHandler(result: objectsUnwrapped, error: nil)
                }
            } else {
                completionHandler(result: nil, error: self.NETWORK_INACCESSIBLE)
            }
        }
    }
    
    class var sharedInstance: ParseAPIClient{
        struct Static{
            static let instance: ParseAPIClient = ParseAPIClient()
        }
        return Static.instance
    }
    
}
