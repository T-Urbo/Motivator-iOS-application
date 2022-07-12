//
//  QuoteViewModel.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 12/07/2022.
//

//TODO: Add like/dislike functionality

import Foundation

struct QuoteViewModel {
    var quoteContent: String
    var quoteAuthor: String
    var quoteTags: [String]
    
    init(quote: Quote) {
        self.quoteContent = quote.content
        self.quoteAuthor = quote.author
        self.quoteTags = quote.tags
    }
}
