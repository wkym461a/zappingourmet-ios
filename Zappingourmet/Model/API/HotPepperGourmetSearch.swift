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
    var range: HotPepperGourmetSearchRange?
    var genre: String?
    
    var type: OutputType?
    var start: Int?
    var count: Int?
    
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
        return "/gourmet/v1"
    }
    
    var method: Moya.Method {
        return .get
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
            params["range"] = self.range?.code
        }
        
        if self.genre != nil {
            params["genre"] = self.genre
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

enum HotPepperGourmetSearchRangeCode: Int, CaseIterable {
    
    case threeHundredMeters = 1
    case fiveHundredMeters = 2
    case oneThousandMeters = 3
    case twoThousandMeters = 4
    case threeThousandMeters = 5
    
    var code: Int { self.rawValue }
    
}

enum HotPepperGourmetSearchRangeName: String, CaseIterable {
    
    case threeHundredMeters = "300m"
    case fiveHundredMeters = "500m"
    case oneThousandMeters = "1000m"
    case twoThousandMeters = "2000m"
    case threeThousandMeters = "3000m"
    
    var name: String { self.rawValue }
    
}

@dynamicMemberLookup
enum HotPepperGourmetSearchRange: CaseIterable {
    
    case threeHundredMeters
    case fiveHundredMeters
    case oneThousandMeters
    case twoThousandMeters
    case threeThousandMeters
    
    var rangeValue: Int {
        switch self {
        case .threeHundredMeters:
            return 300
            
        case .fiveHundredMeters:
            return 500
            
        case .oneThousandMeters:
            return 1000
            
        case .twoThousandMeters:
            return 2000
            
        case .threeThousandMeters:
            return 3000
        }
    }
    
}

extension HotPepperGourmetSearchRange {
    
    init?(code: Int) {
        self.init(HotPepperGourmetSearchRangeCode(rawValue: code))
    }
    
    init?(name: String) {
        self.init(HotPepperGourmetSearchRangeName(rawValue: name))
    }
    
    private init?<T>(_ object: T?) where T: CaseIterable, T.AllCases.Index == AllCases.Index, T: Equatable {
        switch object {
        case let object? where object.offset < Self.allCases.endIndex:
            self = Self.allCases[object.offset]

        case _:
            return nil
        }
    }
    
    subscript<V>(dynamicMember keyPath: KeyPath<HotPepperGourmetSearchRangeCode, V>) -> V? {
        return self[keyPath]
    }

    subscript<V>(dynamicMember keyPath: KeyPath<HotPepperGourmetSearchRangeName, V>) -> V? {
        return self[keyPath]
    }

    private subscript<T, V>(_ keyPath: KeyPath<T, V>) -> V? where T: CaseIterable, T.AllCases.Index == AllCases.Index {
        return (offset < T.allCases.endIndex) ? T.allCases[offset][keyPath: keyPath] : nil
    }
    
}

extension CaseIterable where Self: Equatable {
    
    var offset: AllCases.Index {
        return Self.allCases.firstIndex(of: self)!
    }
    
}
