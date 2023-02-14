//
//  HotPepperGenreMasterResults.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/14.
//

struct HotPepperGenreMasterResults: HotPepperResults {
    
    var apiVersion: String?
    var resultsAvailable: Int?
    var resultsReturned: String?
    var resultsStart: Int?
    var genre: [Genre]?
    
    var error: [HotPepperErrorResult]?
    
    struct Genre: Codable {
        
        var code: String
        var name: String
        
    }
    
}
