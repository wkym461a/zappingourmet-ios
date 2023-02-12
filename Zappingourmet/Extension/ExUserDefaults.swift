//
//  ExUserDefaults.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/12.
//

import Foundation

extension UserDefaults {
    
    func save<T: Encodable>(_ object: T, key: String) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(object) else {
            return
        }
        
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        let jsonDecoder = JSONDecoder()
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let object = try? jsonDecoder.decode(T.self, from: data)
        else {
            return nil
        }
            
        return object
    }
    
}
