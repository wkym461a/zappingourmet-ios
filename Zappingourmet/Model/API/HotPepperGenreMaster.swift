//
//  HotPepperGenreMaster.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/14.
//

import Foundation
import Moya

struct HotPepperGenreMaster {
    
    var code: [String]?
    var keyword: String?
    
}

extension HotPepperGenreMaster: HotPepperTargetType {
    
    struct Response: HotPepperResponse {
        var results: HotPepperGenreMasterResults
    }
    
    var path: String {
        return "/genre/v1"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: Parameters {
        var params: Parameters = [:]
        
        if self.code != nil {
            params["code"] = self.code!.joined(separator: ",")
        }
        
        if self.keyword != nil {
            params["keyword"] = self.keyword
        }
        
        return params
    }
    
}
