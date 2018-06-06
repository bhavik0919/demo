//
//  Apiclient.swift
//  enquiryform
//
//  Created by Cognisun on 23/12/16.
//  Copyright © 2016 Cognisun. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {

internal typealias CompletionBlock = (_ data:NSDictionary?,_ error:NSError?) -> Void

// MARK: - Main Common Methos
fileprivate class func executePostAPICallWithMethod(_ method:String ,withParameters parameters:AnyObject?, callback:@escaping CompletionBlock) {
    
    let str = GlobleUrl.BASEURL + method
  
    Alamofire.request(str, method: .post, parameters: parameters as? [String : AnyObject], encoding: JSONEncoding.default).responseJSON { response in
        switch response.result {
        case .success(let JSON):
           
            let response = JSON as! NSDictionary
            
            callback(response,nil)
            break
            
        case .failure(let error):
            print("Request failed with error: \(error)")
            callback(response.result.value as? NSMutableDictionary,error as NSError?)
            break
        }
        }
        .responseString { response in
           
    }
    
}

    
fileprivate class func executeGetAPICallWithMethod(_ method:String, callback:@escaping CompletionBlock) {
        
        let str = GlobleUrl.BASEURL + method
        
        
        Alamofire.request(str, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch response.result {
            case .success(let JSON2):
                if let response = JSON2 as? NSMutableDictionary
                {
                    callback(response,nil)
                }
                else if let response = JSON2 as? NSDictionary
                {
                    callback(response,nil)
                }
                else if JSON2 is NSArray
                {
                    let swjson = JSON(response.result.value!)
                    
                    var myMutableDictionary = [AnyHashable: Any]()
                    myMutableDictionary["myArray"] = swjson
                    
                    callback(myMutableDictionary as NSDictionary?,nil)
                   
                }
                
                break
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                callback(response.result.value as? NSMutableDictionary,error as NSError?)
                break
            }
            }
            .responseString { response in
                print("Response String: \(String(describing: response.result.value))")
        }
    }
    
class func GetApi(url:String,_ detail : [String : AnyObject],completion:@escaping CompletionBlock){
        self.executeGetAPICallWithMethod(url, callback: { (data, error) in
            completion(data,error)
        })
}
    

}


