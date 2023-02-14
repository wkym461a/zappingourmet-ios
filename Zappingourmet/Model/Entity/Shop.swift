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
//        accessShort: "銀座一丁目駅10番出口徒歩3分",
        access: "銀座駅A2出口でて､みゆき通り右折､徒歩1分",
        photoURL: URL(string: "https://play-lh.googleusercontent.com/pnGn7ehfH_swLzEUNr7o7M1IMDHGAay5smAU59thcHcZChSt5S5rhg6zW1bYMKdckY4")!,
        open: "月～金／11：30～14：00",
        close: "日",
        latitude: 35.6608183454,
        longitude: 139.7754267645,
        url: URL(string: "https://webservice.recruit.co.jp/doc/hotpepper/reference.html")!
//        logoURL: URL(string: "https://play-lh.googleusercontent.com/pnGn7ehfH_swLzEUNr7o7M1IMDHGAay5smAU59thcHcZChSt5S5rhg6zW1bYMKdckY4")!,
//        catch: "TVの口コミランキングで堂々1位に輝いた一口餃子専門店！！",
//        tags: [
//            "Wi-Fi：あり、なし、未確認 のいずれか",
//            "ウェディング･二次会：応相談",
//            "コース：あり",
//            "飲み放題：あり",
//            "食べ放題：あり",
//            "個室：あり",
//            "掘りごたつ：なし",
//            "座敷：なし",
//            "カード：利用可",
//            "禁煙席：一部禁煙",
//            "貸切：貸切不可",
//            "携帯電話：つながりにくい",
//            "駐車場：なし",
//            "バリアフリー：なし",
//            "ソムリエ：いる",
//            "オープンエア：あり",
//            "ライブ・ショー：なし",
//            "エンタメ設備：なし",
//            "カラオケ：なし",
//            "バンド演奏可：不可",
//            "TV・プロジェクター：なし",
//            "英語メニュー：あり",
//            "ペット：可",
//            "お子様連れ：お子様連れ歓迎",
//            "ランチ：あり",
//            "23時以降営業：営業している",
//        ],
//        detailMemo: "プロジェクター利用可",
//        equipmentMemo: "プロジェクターあります。"
    )
    
    static func fromHotPepperShop(_ shop: HotPepperGourmetSearchResults.Shop) -> Self {
        let photoURL = shop.photo.pc.l
        let open = shop.open ?? ""
        let close = shop.close ?? ""
        
        let shopURL = shop.urls.pc
//        let logoURL = shop.logoImage
        
//        var tags: [String] = []
//        if let wifi = shop.wifi { tags.append("Wi-Fi：\(wifi)") }
//        if let wedding = shop.wedding { tags.append("ウェディング･二次会：\(wedding)") }
//        if let course = shop.course { tags.append("コース：\(course)") }
//        if let freeDrink = shop.freeDrink { tags.append("飲み放題：\(freeDrink)") }
//        if let freeFood = shop.freeFood { tags.append("食べ放題：\(freeFood)") }
//        if let privateRoom = shop.privateRoom { tags.append("個室：\(privateRoom)") }
//        if let horigotatsu = shop.horigotatsu { tags.append("掘りごたつ：\(horigotatsu)") }
//        if let tatami = shop.tatami { tags.append("座敷：\(tatami)") }
//        if let card = shop.card { tags.append("カード：\(card)") }
//        if let nonSmoking = shop.nonSmoking { tags.append("禁煙席：\(nonSmoking)") }
//        if let charter = shop.charter { tags.append("貸切：\(charter)") }
//        if let ktai = shop.ktai { tags.append("携帯電話：\(ktai)") }
//        if let parking = shop.parking { tags.append("駐車場：\(parking)") }
//        if let barrierFree = shop.barrierFree { tags.append("バリアフリー：\(barrierFree)") }
//        if let sommelier = shop.sommelier { tags.append("ソムリエ：\(sommelier)") }
//        if let openAir = shop.openAir { tags.append("オープンエア：\(openAir)") }
//        if let show = shop.show { tags.append("ライブ・ショー：\(show)") }
//        if let equipment = shop.equipment { tags.append("エンタメ設備：\(equipment)") }
//        if let karaoke = shop.karaoke { tags.append("カラオケ：\(karaoke)") }
//        if let band = shop.band { tags.append("バンド演奏：\(band)") }
//        if let tv = shop.tv { tags.append("TV・プロジェクター：\(tv)") }
//        if let english = shop.english { tags.append("英語メニュー：\(english)") }
//        if let pet = shop.pet { tags.append("ペット：\(pet)") }
//        if let child = shop.child { tags.append("お子様連れ：\(child)") }
//        if let lunch = shop.lunch { tags.append("ランチ：\(lunch)") }
//        if let midnight = shop.midnight { tags.append("23時以降営業：\(midnight)") }
//
//        let detailMemo = shop.shopDetailMemo ?? "なし"
//        let equipmentMemo = shop.otherMemo ?? "なし"
        
        return Shop(
            id: shop.id,
            name: shop.name,
            address: shop.address,
            access: shop.access,
//            accessShort: shop.mobileAccess,
            photoURL: photoURL,
            open: open,
            close: close,
            latitude: shop.lat,
            longitude: shop.lng,
            url: shopURL
//            logoURL: logoURL,
//            catch: shop.catch,
//            tags: tags,
//            detailMemo: detailMemo,
//            equipmentMemo: equipmentMemo
        )
    }
    
    var id: String
    var name: String
    var address: String
    var access: String
//    var accessShort: String?
    var photoURL: URL
    var open: String
    var close: String
    
    var latitude: Double
    var longitude: Double
    var url: URL
//    var logoURL: URL?
//    var `catch`: String
//    var tags: [String]
//    var detailMemo: String
//    var equipmentMemo: String
    
}
