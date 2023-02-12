//
//  ExData.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import Foundation

extension Data {
    
    static func fromURL(_ url: URL) -> Data {
        do {
            let data = try Data(contentsOf: url)
            
            return data
            
        } catch {
            print("\(#function) Error: \(error.localizedDescription)")
        }
        
        return Data()
    }
    
}
