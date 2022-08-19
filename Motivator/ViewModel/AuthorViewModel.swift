//
//  AuthorViewModel.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 19/08/2022.
//

import Foundation

struct AuthorModel {
    var authorName: String
    var authorOccupation: String
    var authorImage: String
    var authorQuotes: Int
    
    init(author: Author) {
        self.authorName = author.name
        self.authorOccupation = author.description
        self.authorImage = author.link
        self.authorQuotes = author.quoteCount
    }
}

class AuthorViewModel {
    
    
    
}
