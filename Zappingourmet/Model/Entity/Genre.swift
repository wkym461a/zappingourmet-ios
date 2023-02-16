//
//  Genre.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/14.
//

struct Genre: Codable {
    
    static let `default` = Genre(code: "G002", name: "ダイニングバー")
    
    static let none = Genre(code: "", name: "指定なし")
    
    static func fromHotPepperGenre(_ genre: HotPepperGenreMasterResults.Genre) -> Self {
        return .init(
            code: genre.code,
            name: genre.name
        )
    }
    
    var code: String
    var name: String
    
}
