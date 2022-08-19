//
//  Author.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 20/07/2022.
//

import Foundation

struct Author: Decodable, Equatable {
    var _id: String
    var bio: String
    var description: String
    var link: String
    var name: String
    var slug: String
    var quoteCount: Int
    
    init(_id: String, bio: String, description: String, link: String, name: String, slug: String, quoteCount: Int) {
        self._id = _id
        self.bio = bio
        self.description = description
        self.link = link
        self.name = name
        self.slug = slug
        self.quoteCount = quoteCount
    }
}

struct AuthorResults: Decodable {
    var count: Int
    var totalCount: Int
    var page: Int
    var totalPages: Int
    var lastItemIndex: Int?
    var results: [Author]
}
