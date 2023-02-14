//
//  Shop.swift
//  Zappingourmet
//
//  Created by 若山大和 on 2023/02/11.
//

import Foundation

struct Shop: Codable {
    
    static let `default` = Shop(
        id: "J999999999",
        name: "居酒屋 ホットペッパー",
        address: "東京都中央区銀座８－４－１７",
        access: "銀座駅A2出口でて､みゆき通り右折､徒歩1分",
        accessShort: "銀座一丁目駅10番出口徒歩3分",
        photoURL: URL(string: "https://play-lh.googleusercontent.com/pnGn7ehfH_swLzEUNr7o7M1IMDHGAay5smAU59thcHcZChSt5S5rhg6zW1bYMKdckY4")!,
        open: "月～金／11：30～14：00",
        close: "日",
        latitude: 35.6608183454,
        longitude: 139.7754267645,
        url: URL(string: "https://webservice.recruit.co.jp/doc/hotpepper/reference.html")!,
        logoURL: URL(string: "https://play-lh.googleusercontent.com/pnGn7ehfH_swLzEUNr7o7M1IMDHGAay5smAU59thcHcZChSt5S5rhg6zW1bYMKdckY4")!,
        catch: "TVの口コミランキングで堂々1位に輝いた一口餃子専門店！！",
        tags: [
            "Wi-Fi：あり、なし、未確認 のいずれか",
            "ウェディング･二次会：応相談",
            "コース：あり",
            "飲み放題：あり",
            "食べ放題：あり",
            "個室：あり",
            "掘りごたつ：なし",
            "座敷：なし",
            "カード：利用可",
            "禁煙席：一部禁煙",
            "貸切：貸切不可",
            "携帯電話：つながりにくい",
            "駐車場：なし",
            "バリアフリー：なし",
            "ソムリエ：いる",
            "オープンエア：あり",
            "ライブ・ショー：なし",
            "エンタメ設備：なし",
            "カラオケ：なし",
            "バンド演奏可：不可",
            "TV・プロジェクター：なし",
            "英語メニュー：あり",
            "ペット：可",
            "お子様連れ：お子様連れ歓迎",
            "ランチ：あり",
            "23時以降営業：営業している",
        ],
        detailMemo: "プロジェクター利用可"
    )
    
    static func fromHotPepperShop(_ shop: HotPepperGourmetSearchResults.Shop) -> Self {
        let photoURL = shop.photo.pc.l
        let open = shop.open ?? ""
        let close = shop.close ?? ""
        
        let shopURL = shop.urls.pc
        let logoURL = shop.logoImage
        let tags = self.createTags(from: shop)
        let detailMemo = shop.shopDetailMemo ?? "なし"
        
        return Shop(
            id: shop.id,
            name: shop.name,
            address: shop.address,
            access: shop.access,
            accessShort: shop.mobileAccess,
            photoURL: photoURL,
            open: open,
            close: close,
            latitude: shop.lat,
            longitude: shop.lng,
            url: shopURL,
            logoURL: logoURL,
            catch: shop.catch,
            tags: tags,
            detailMemo: detailMemo
        )
    }
    
    private static func createTags(from shop: HotPepperGourmetSearchResults.Shop) -> [String] {
        var tags: [String] = []
        
        self.tagFilter(shop.wifi) { tags.append("Wi-Fi：\($0)") }
        self.tagFilter(shop.wedding) { tags.append("ウェディング･二次会：\($0)") }
        self.tagFilter(shop.course) { tags.append("コース：\($0)") }
        self.tagFilter(shop.freeDrink) { tags.append("飲み放題：\($0)") }
        self.tagFilter(shop.freeFood) { tags.append("食べ放題：\($0)") }
        self.tagFilter(shop.privateRoom) { tags.append("個室：\($0)") }
        self.tagFilter(shop.horigotatsu) { tags.append("掘りごたつ：\($0)") }
        self.tagFilter(shop.tatami) { tags.append("座敷：\($0)") }
        self.tagFilter(shop.card) { tags.append("カード：\($0)") }
        self.tagFilter(shop.nonSmoking) { tags.append("禁煙席：\($0)") }
        self.tagFilter(shop.charter) { tags.append("貸切：\($0)") }
        self.tagFilter(shop.ktai) { tags.append("携帯電話：\($0)") }
        self.tagFilter(shop.parking) { tags.append("駐車場：\($0)") }
        self.tagFilter(shop.barrierFree) { tags.append("バリアフリー：\($0)") }
        self.tagFilter(shop.sommelier) { tags.append("ソムリエ：\($0)") }
        self.tagFilter(shop.openAir) { tags.append("オープンエア：\($0)") }
        self.tagFilter(shop.show) { tags.append("ライブ・ショー：\($0)") }
        self.tagFilter(shop.equipment) { tags.append("エンタメ設備：\($0)") }
        self.tagFilter(shop.karaoke) { tags.append("カラオケ：\($0)") }
        self.tagFilter(shop.band) { tags.append("バンド演奏：\($0)") }
        self.tagFilter(shop.tv) { tags.append("TV・プロジェクター：\($0)") }
        self.tagFilter(shop.english) { tags.append("英語メニュー：\($0)") }
        self.tagFilter(shop.pet) { tags.append("ペット：\($0)") }
        self.tagFilter(shop.child) { tags.append("お子様連れ：\($0)") }
        self.tagFilter(shop.lunch) { tags.append("ランチ：\($0)") }
        self.tagFilter(shop.midnight) { tags.append("23時以降：\($0)") }
        
        return tags
    }
    
    private static func tagFilter(_ text: String?, completion: (String) -> ()) {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines), text != "" else {
            return
        }
        
        completion(text)
    }
    
    var id: String
    var name: String
    var address: String
    var access: String
    var accessShort: String?
    var photoURL: URL
    var open: String
    var close: String
    
    var latitude: Double
    var longitude: Double
    var url: URL
    var logoURL: URL?
    var `catch`: String
    var tags: [String]
    var detailMemo: String
    
    func getAccessPreferShort() -> String {
        guard let short = self.accessShort?.trimmingCharacters(in: .whitespacesAndNewlines), short.count > 0 else {
            return self.access
        }
        
        return short
    }
    
}
