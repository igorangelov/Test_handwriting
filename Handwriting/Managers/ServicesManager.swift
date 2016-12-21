//
//  ServicesManager.swift
//  OodriveTest
//
//  Created by Igor Angelov on 20/11/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit
import Alamofire


typealias ResultResponseManager = (_ errorResponse: ErrorResponseType, _ jsonResponse: Any?) -> Void

enum ErrorResponseType {
    case Unknown
    case None // No Error
    case Error // All Error
}

enum HeaderContentType : String {
    case Basic = "application/json"
    case Image = "image/png"
    case Download = "application/octet-stream"
}


private let apiKey : String = "ZKQ7ST2N5DFF5SNE"
private let apiSecret : String = "K9G7N1SFJ2KHFG55"


class ServicesManager {

    /**
     Basic get RESTAPI
     
     - parameter url: String
     
     - parameter isCached: Bool
     
     - parameter callback : ResultResponseManager
     */
    class func get(url : String, cached isCached : Bool = false, callback: @escaping ResultResponseManager)
    {
        /* function manager cached data retrun from local */
        func getCachedData()
        {
            if(isCached == false) {
                callback(.Error, nil )
            }
            
            SupraCacheManager.getData(url: url, expiredAt: SupraCacheManager.makeExpiredDayWeek(weekLater: 1), completion: { (errors, data) -> Void in
                
                if errors == nil {
                    
                    /* if can find cached*/
                    if let data = data  {
                        callback(.None, data )
                        return
                    }
                    /* if cannot find cached */
                    callback(.Error, nil )
                    return
                }else
                {
                    callback(.Error, nil )
                }
                
            }, callResource: nil)
        }
        
        if(Reachability.isConnectedToNetwork() == false){
            getCachedData()
        }
        
        let urlm = url.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
      
        Alamofire.request(urlm!,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil
            ).authenticate(user: apiKey, password: apiSecret) // authenticate with api key and secret
            .response { (response) in
                
                guard let code = response.response?.statusCode else
                {
                    getCachedData()
                    callback(.Error, nil )
                    return
                }
                
                debugPrint("code error", code )
                
                ///* Request fine */
                if(ServicesManager.canSendResponse(code: code))
                {
                    //Verifiy Data
                    if let data = response.data{
                        callback(.None, data )
                        //cache Data
                        if(isCached == true)
                        {
                            SupraCacheManager.pushDataToCache(url: url, expiredAt: SupraCacheManager.makeExpiredDayWeek(weekLater: 1), data: data as NSData)
                        }
                        
                    }
                }else{ ///* Request not fine */

                    getCachedData()
                    callback(.Error, nil )
                }
                
        }
        

    }
    
    /**
     get handwriting text to png
     
     - parameter text: String
     
     - parameter callback : ResultResponseManager
     */
    class func getRenderPNG(text: String,callback: @escaping ResultResponseManager) {
        
        ServicesManager.get(url: URLHelper.urlRenderPNG(text: text), callback: callback)
    }
    
    
    /**
     retour bool depend of http code
     
     - parameter code: Int
     
     - retrun bool
     */
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
    
}

