//
//  UrlHelper.swift
//  OodriveTest
//
//  Created by Igor Angelov on 30/11/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import UIKit

class URLHelper {

    
    // MARK: - GENERAL
    
    class func getBaseURL()->String
    {
        return "https://api.handwriting.io"
    }
    
   
    // MARK: - Render png

    class func urlRenderPNG(text:String)->String
    {
        return URLHelper.getBaseURL() + "/render/png?text=" + text + "&handwriting_id=8X3WQ7TG00B4"
    }

    
}
