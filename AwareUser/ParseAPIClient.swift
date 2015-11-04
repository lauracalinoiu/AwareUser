//
//  ParseAPIClient.swift
//  AwareUser
//
//  Created by Laura Calinoiu on 02/11/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import Foundation
import Parse
import GameplayKit

class ParseAPIClient {
    
    let NETWORK_INACCESSIBLE = "The network was inaccesible"
    let queryLimit = 10
    let maxResults = 3
    
    func getQuestions(completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let query = PFQuery(className: "question")
        query.limit = queryLimit
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objectsUnwrapped = objects {
                    let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(objectsUnwrapped) as! [PFObject]
                    completionHandler(result: Array<PFObject>(shuffled[0..<self.maxResults]), error: nil)
                    
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
    
    func pinLocallyAScore(score: Int, total: Int){
        let gameScore = PFObject(className:"Score")
        gameScore["score"] = score
        gameScore["total"] = total
        gameScore["when"] = NSDate()
        gameScore.pinInBackground()
    }
    
    func deletePins(){
        
    }
    
    func getScores(completionHandler: (result: [PFObject]!, error: String?) -> Void){
        let query = PFQuery(className: "Score")
        query.fromLocalDatastore()
        query.orderByDescending("when")
        query.findObjectsInBackgroundWithBlock{ [unowned self]
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
