//
//  HotPepperTargetType.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/10.
//

import Foundation
import Moya

protocol HotPepperTargetType: TargetType {
    
    associatedtype Response: HotPepperResponse
    
    typealias Parameters = [String: Any]
    
    var parameters: Parameters { get }
    
}

extension HotPepperTargetType {
    
    var baseURL: URL {
        URL(string: "https://webservice.recruit.co.jp/hotpepper")!
    }
    
    var headers: [String: String]? {
        nil
    }
    
    var task: Task {
        var params = self.parameters
        params["key"] = "e26a23591da4d74b"
        params["format"] = "json"
        
        return .requestParameters(
            parameters: params,
            encoding: URLEncoding.queryString
        )
    }

    var validationType: ValidationType {
        .successCodes
    }

    var sampleData: Data {
        Data()
    }
    
}
