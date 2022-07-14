//
//  Quote.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 11/07/2022.
//

import Foundation

struct Quote: Decodable {
    var _id: String = ""
    var content: String = ""
    var author: String = ""
    var authorSlug: String = ""
    var length: Int = 0
    var tags: [String] = []
}

struct QuoteByAuthor: Decodable {
    var count: Int
    var totalCount: Int
    var page: Int
    var totalPages: Int
    var lastItemIndex: Int
    var results: [Quote]
}
