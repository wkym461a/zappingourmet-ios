//
//  HotPepperResponse.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/16.
//

protocol HotPepperResponse: Codable {
    
    associatedtype Results: HotPepperResults
    
    var results: Results { get }
    
}

protocol HotPepperResults: Codable {
    
    var error: [HotPepperErrorResult]? { get }
    
}

struct HotPepperErrorResult: Codable {
    
    var message: String
    var code: Int
    
}
