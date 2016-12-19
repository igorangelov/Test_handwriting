//
//  ServicesManager.swift
//  OodriveTest
//
//  Created by Igor Angelov on 20/11/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

typealias ResultResponseManager = (_ errorResponse: ErrorResponseType, _ jsonResponse: Any?) -> Void

enum ErrorResponseType {
    case Unknown
    case None // No Error
    case Error // All Error
}

enum HeaderContentType : String {
    case Basic = "application/json"
    case Download = "application/octet-stream"
    case Upload = "upload" // don't use in header dictionary
}


private let apiKey : String = "ZKQ7ST2N5DFF5SNE"
private let apiSecret : String = "K9G7N1SFJ2KHFG55"


class ServicesManager {

    //*****************
    // Basic get RESTAPI
    //******************
    
    class func get(url : String, cached isCached : Bool = true, callback: @escaping ResultResponseManager)
    {
        //manager cached data func
        func getCachedData()
        {
            
            SupraCacheManager.getData(url: url, expiredAt: SupraCacheManager.makeExpiredDayWeek(weekLater: 1), completion: { (errors, data) -> Void in
                
                if errors == nil {
                    
                    // if can find cached
                    if let swiftyJsonVar : [Any] = JSON(data: data as! Data).arrayObject {
                        callback(.None, swiftyJsonVar )
                        return
                    }
                    // if cannot find cached
                    callback(.Error, nil )
                    return
                }
                
            }, callResource: nil)
        }
        
        if(Reachability.isConnectedToNetwork() == false){
            getCachedData()
        }
        
        debugPrint(url)
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: ServicesManager.requestHeader(type:.Basic )
            ).response { (response) in
                
                guard let code = response.response?.statusCode else
                {
                    getCachedData()
                    callback(.Error, nil )
                    return
                }
                
                
                ///* Request fine */
                if(ServicesManager.canSendResponse(code: code))
                {
                    //Verifiy Data
                    if let data = response.data{
                        let swiftyJsonVar : [Any] = JSON(data: data).arrayObject!
                        callback(.None, swiftyJsonVar )
                        //cache Data
                        SupraCacheManager.pushDataToCache(url: url, expiredAt: SupraCacheManager.makeExpiredDayWeek(weekLater: 1), data: data as NSData)
                    }
                }else{ ///* Request not fine */

                    getCachedData()
                    callback(.Error, nil )
                }
                
        }
        

    }
    
    //***************************
    //get handwriting text
    //***************************
    class func getUsers(text: String,callback: @escaping ResultResponseManager) {
        
        ServicesManager.get(url: URLHelper.urlRenderPNG(text: text), callback: callback)
    }
    
  
    
    
    
    //***************************
    //retour bool depend of http code
    //***************************
    class func canSendResponse(code : Int) -> Bool {
        
        switch code {
        case 200...201 : /* Request fine */
            return true
        case 400...550 : /*errors*/
            return false
        default: /* Error no defined yet */
            return false
        }
        
    
    }
    //***************************
    //return header for request type
    //***************************
    
    //ZKQ7ST2N5DFF5SNE Key
    //K9G7N1SFJ2KHFG55  Secret
    class func requestHeader(type:HeaderContentType, fileName:String = "")->[String:String]
    {
        let plainString : String = apiKey + apiSecret
        let plainData = plainString.data(using: .utf8)
        let base64String = plainData?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        var headers = [
            "Authorization":  "Basic " + base64String!,
            "Content-Type": type.rawValue
        ]
        
        if(type == .Upload)
        {
             headers = [
                "Authorization":  "Basic " + base64String!,
                "Content-Type": HeaderContentType.Download.rawValue,
                "Content-Disposition": "attachment;filename*=utf-8''"+fileName
            ]
        }
        
        debugPrint(headers)
        return headers
        
    }
    
}

