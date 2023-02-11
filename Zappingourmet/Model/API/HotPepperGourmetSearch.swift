//
//  HotPepperGourmetSearch.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/10.
//

import Foundation
import Moya

struct HotPepperGourmetSearch: HotPepperTargetType {
    
    var keyword: String?
    var lat: Double?
    var lng: Double?
    var range: SearchRange?
    
    var type: OutputType?
    var start: Int?
    var count: Int?
    
    enum SearchRange: Int {
        case threeHundred = 1
        case fiveHundred = 2
        case oneThousand = 3
        case twoThousand = 4
        case threeThousand = 5
    }
    
    enum OutputType: String {
        case lite = "lite"
        case creditCard = "credit_card"
        case special = "special"
        case creditCardAndSpecial = "credit_card+special"
        case normal = ""
    }
    
}

extension HotPepperGourmetSearch {
    
    struct Response: HotPepperResponse {
        var results: HotPepperGourmetSearchResults
    }
    
    var path: String {
        "/gourmet/v1"
    }
    
    var method: Moya.Method {
        .get
    }
    
    var parameters: Parameters {
        var params: Parameters = [:]
        
        if self.keyword != nil {
            params["keyword"] = self.keyword
        }
        
        if self.lat != nil {
            params["lat"] = self.lat
        }
        
        if self.lng != nil {
            params["lng"] = self.lng
        }
        
        if self.range != nil {
            params["range"] = self.range?.rawValue
        }
        
        if self.type != nil {
            params["type"] = self.type?.rawValue
        }
        
        if self.start != nil {
            params["start"] = self.start
        }
        
        if self.count != nil {
            params["count"] = self.count
        }
        
        return params
    }
    
}
