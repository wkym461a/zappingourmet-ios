//
//  HotPepperGourmetSearchResults.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import Foundation

struct HotPepperGourmetSearchResults: HotPepperResults {
    
    var apiVersion: String?
    var resultsAvailable: Int?
    var resultsReturned: String?
    var resultsStart: Int?
    var shop: [Shop]?
    
    var error: [HotPepperErrorResult]?
    
    
    struct Shop: Codable {
        
        var id: String
        var name: String
        var logoImage: URL?
        var nameKana: String?
        var address: String
        var stationName: String?
        var ktaiCoupon: Int?
        var largeServiceArea: ServiceArea?
        var serviceArea: ServiceArea?
        var largeArea: ServiceArea?
        var middleArea: ServiceArea?
        var smallArea: ServiceArea?
        var lat: Double
        var lng: Double
        var genre: Genre
        var subGenre: SubGenre?
        var budget: Budget?
        var budgetMemo: String?
        var `catch`: String
//        var capacity: Int? // 値があるとInt、空だとString
        var access: String
        var mobileAccess: String?
        var urls: Urls
        var photo: Photo
        var open: String?
        var close: String?
//        var partyCapacity: Int? // 値があるとInt、空だとString
        var wifi: String?
        var wedding: String?
        var course: String?
        var freeDrink: String?
        var freeFood: String?
        var privateRoom: String?
        var horigotatsu: String?
        var tatami: String?
        var card: String?
        var nonSmoking: String?
        var charter: String?
        var ktai: String?
        var parking: String?
        var barrierFree: String?
        var otherMemo: String?
        var sommelier: String?
        var openAir: String?
        var show: String?
        var equipment: String?
        var karaoke: String?
        var band: String?
        var tv: String?
        var english: String?
        var pet: String?
        var child: String?
        var lunch: String?
        var midnight: String?
        var shopDetailMemo: String?
        var couponUrls: CouponUrls?
        
        var special: [Special]?
        var creditCard: [CreditCard]?
        
        struct ServiceArea: Codable {
            var code: String
            var name: String
        }
        
        struct Genre: Codable {
            var code: String?
            var name: String
            var `catch`: String
        }
        
        struct SubGenre: Codable {
            var code: String
            var name: String
        }
        
        struct Budget: Codable {
            var code: String
            var name: String
            var average: String
        }
        
        struct Urls: Codable {
            var pc: URL
        }
        
        struct Photo: Codable {
            var pc: PC
            var mobile: Mobile?
            
            struct PC: Codable {
                var l: URL
                var m: URL
                var s: URL
            }
            
            struct Mobile: Codable {
                var l: URL
                var s: URL
            }
        }
        
        struct CouponUrls: Codable {
            var pc: URL
            var sp: URL
        }
        
        struct Special: Codable {
            var code: String
            var name: String
            var specialCategory: Category
            var title: String
            
            struct Category: Codable {
                var code: String
                var name: String
            }
        }
        
        struct CreditCard: Codable {
            var code: String
            var name: String
        }
        
    }
    
}
