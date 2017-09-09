//
//  App.swift
//  AppStoreOffsiteTest
//
//  Created by HarryPan on 09/09/2017.
//  Copyright © 2017 HarryPan. All rights reserved.
//

import Foundation

struct App {
    var identifier: String
    var name: String
    var title: String
    var iconURL: URL
    var summary: String
    var price: Decimal
    var currencyCode: String
    var category: String
    var artist: String
    
    var detail: Detail?
    
    struct Detail {
        var screenshotURLs: [URL]
        var userRatingCount: Float
        var averageUserRating: Float
        var releaseDate: Date
    }
    
    init(identifier: String,
         name: String,
         title: String,
         iconURL: URL,
         summary: String,
         price: Decimal,
         currencyCode: String,
         category: String,
         artist: String,
         detail: Detail? = nil) {
        self.identifier = identifier
        self.name = name
        self.title = title
        self.iconURL = iconURL
        self.summary = summary
        self.price = price
        self.currencyCode = currencyCode
        self.category = category
        self.artist = artist
        self.detail = detail
    }
}

extension App: JSONObjectRepresentable {
    fileprivate struct JSONKey {
        static let id = "id"
        static let identifier = "im:id"
        static let name = "im:name"
        static let title = "title"
        static let iconURL = "im:image"
        static let summary = "summary"
        static let price = "im:price"
        static let category = "category"
        static let artist = "im:artist"
        
        static let label = "label"
        static let attributes = "attributes"
        static let amount = "amount"
        static let currency = "currency"
    }
    
    var jsonObject: JSONObject {
        return [:]
    }
    
    static func from(jsonObject: JSONObject) -> App? {
        guard let idJSONObject = (jsonObject[JSONKey.id] as? JSONObject)?[JSONKey.attributes] as? JSONObject,
            let nameJSONObject = jsonObject[JSONKey.name] as? JSONObject,
            let titleJSONObject = jsonObject[JSONKey.title] as? JSONObject,
            let iconURLJSONObject = (jsonObject[JSONKey.iconURL] as? [JSONObject])?.last,
            let summaryJSONObject = jsonObject[JSONKey.summary] as? JSONObject,
            let priceJSONObject = (jsonObject[JSONKey.price] as? JSONObject)?[JSONKey.attributes] as? JSONObject,
            let categoryJSONObject = (jsonObject[JSONKey.category] as? JSONObject)?[JSONKey.attributes] as? JSONObject,
            let artistJSONObject = jsonObject[JSONKey.artist]  as? JSONObject else {
                return nil
        }
        
        guard let identifier: String = idJSONObject.get(JSONKey.identifier),
            let name: String = nameJSONObject.get(JSONKey.label),
            let title: String = titleJSONObject.get(JSONKey.label),
            let iconURL: URL = iconURLJSONObject.get(JSONKey.label),
            let summary: String = summaryJSONObject.get(JSONKey.label),
            let price: Decimal = priceJSONObject.get(JSONKey.amount),
            let currencyCode: String = priceJSONObject.get(JSONKey.currency),
            let category: String = categoryJSONObject.get(JSONKey.label),
            let artist: String = artistJSONObject.get(JSONKey.label) else {
                return nil
        }
        
        return App(identifier: identifier,
                   name: name,
                   title: title,
                   iconURL: iconURL,
                   summary: summary,
                   price: price,
                   currencyCode: currencyCode,
                   category: category,
                   artist: artist)
    }
}


extension App.Detail: JSONObjectRepresentable {
    fileprivate struct JSONKey {
        static let screenshotURLs = "screenshotUrls"
        static let userRatingCount = "userRatingCount"
        static let averageUserRating = "averageUserRatingForCurrentVersion"
        static let releaseDate = "currentVersionReleaseDate"

    }
    
    var jsonObject: JSONObject {
        return [:]
    }
    
    static func from(jsonObject: JSONObject) -> App.Detail? {
        guard let screenshotURLs: [URL] = jsonObject.getList(JSONKey.screenshotURLs),
            let userRatingCount: Float = jsonObject.get(JSONKey.userRatingCount),
            let averageUserRating: Float = jsonObject.get(JSONKey.averageUserRating),
            let releaseDate: Date = jsonObject.get(JSONKey.releaseDate) else {
                return nil
        }
        
        return App.Detail(screenshotURLs: screenshotURLs,
                          userRatingCount: userRatingCount,
                          averageUserRating: averageUserRating,
                          releaseDate: releaseDate)
    }
}
