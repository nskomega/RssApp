//
//  RssService.swift
//  rssApp
//
//  Created by Mikhail Danilov on 15.01.2021.
//

import AlamofireRSSParser
import Foundation
import Alamofire

class RssService {
    
    func getRssNews(url: String, completion: @escaping (_ items: [RssItem] , _ success: Bool, _ error: String) -> Void) {
        var result = [RssItem]()
        
        AF.request(url).responseRSS() { (response) -> Void in
            if let feed: RSSFeed = response.value {
                /// Do something with your new RSSFeed object!
                for item in feed.items {
                    let title = item.title ?? ""
                    let imagesFromDescription = item.imagesFromDescription
                    let rssItem = RssItem(title: title, imagesFromDescription: imagesFromDescription ?? [])
                    result.append(rssItem)
                }
            }
            completion(result, true, "")
        }
    }
}
