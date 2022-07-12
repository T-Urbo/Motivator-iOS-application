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
    var tags: [String] = []
    var length: Int = 0
}
