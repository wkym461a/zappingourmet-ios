//
//  HotPepperAPI.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/10.
//

import Foundation
import Moya

enum HotPepperAPI {
    private static let apiKey = "e26a23591da4d74b"
    private static let responseFormat = "json"
    
    case gourmetSearch(latitude: Double, longitude: Double, range: SearchRange)
    
    enum SearchRange: Int {
        case threeHundred = 1
        case fiveHundred = 2
        case oneThousand = 3
        case twoThousand = 4
        case threeThousand = 5
    }
}

extension HotPepperAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "https://webservice.recruit.co.jp/hotpepper")!
    }
    
    var path: String {
        switch self {
        case .gourmetSearch:
            return "/gourmet/v1"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .gourmetSearch(let langitude, let longitude, let range):
            return .requestParameters(
                parameters: [
                    "key": Self.apiKey,
                    "format": Self.responseFormat,
                    "lat": langitude,
                    "lng": longitude,
                    "range": range.rawValue,
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
