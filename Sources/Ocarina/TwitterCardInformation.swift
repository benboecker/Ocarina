//
//  TwitterCardInformation.swift
//  Ocarina
//
//  Created by Rens Verhoeven on 15/05/2017.
//  Copyright © 2017 awkward. All rights reserved.
//

import Foundation
import AVFoundation

public enum TwitterCardType: String, Codable {
    case summary = "summary"
    case summaryWithLargeImage = "summary_large_image"
    case app = "app"
    case player = "player"
    case other = "other"
    
    public var minimumImageSize: CGSize? {
        switch self {
        case .summary:
            return CGSize(width: 144, height: 144)
        case .summaryWithLargeImage:
            return CGSize(width: 300, height: 157)
        case .player:
            return CGSize(width: 350, height: 196)
        default:
            return nil
        }
    }
}

/// A model containing twitter card information for a URL.
public struct TwitterCardInformation: Codable {
	public static var supportsSecureCoding: Bool = true
	
    
    /// The contents of the twitter:url tag of the link.
    public var url: URL?
    
    /// The contents of the twitter:title tag of the link.
    public var title: String?
    
    /// The contents of the twitter:description tag of the link.
    public var descriptionText: String?
    
    /// An URL to an image that was provided as the twitter:image tag.
    /// The size/ratio can be estimated using the minimumImageSize on the card type.
    public var imageURL: URL?
    
    /// The type of twitter card.
    public var cardType: TwitterCardType
    
    /// The twitter account associated with the URL, without the @ prefix. Parsed from the `twitter:site` tag.
    public var account: String?
    
    /// Create a new instance of TwitterCardInformation with the given URL and title
    ///
    /// - Parameters:
    ///   - html: The html of the page, this is used to search for (head) tags.
    init?(html: HTMLDocument) {
        guard html.head?.toHTML?.contains("\"twitter:") == true else {
            return nil
        }
        if let typeString = html.xpath("/html/head/meta[(@property|@name)=\"og:type\"]/@content").first?.text {
            self.cardType = TwitterCardType(rawValue: typeString) ?? TwitterCardType.other
        } else {
            self.cardType = .other
        }
        
        if let urlString = html.xpath("/html/head/meta[(@property|@name)=\"twitter:url\"]/@content").first?.text {
            self.url = URL(string: urlString)
        }
        
        if let title = html.xpath("/html/head/meta[(@property|@name)=\"twitter:title\"]/@content").first?.text {
            self.title = title
        }
        
        if let descriptionText = html.xpath("/html/head/meta[(@property|@name)=\"twitter:description\"]/@content").first?.text {
            self.descriptionText = descriptionText
        }
        
        if let imageURLString = html.xpath("/html/head/meta[(@property|@name)=\"twitter:image\"]/@content").first?.text {
            self.imageURL = URL(string: imageURLString)
        }
        
        if let accountString = html.xpath("/html/head/meta[(@property|@name)=\"twitter:site\"]/@content").first?.text {
            self.account = accountString.replacingOccurrences(of: "@", with: "")
        }
    }
    
	enum CodingKeys: String, CodingKey {
		case url, title, descriptionText, imageURL, cardType, account
	}
	
}
