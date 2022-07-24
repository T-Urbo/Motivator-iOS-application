//
//  QuoteViewModel.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 12/07/2022.
//

//TODO: Add like/dislike functionality

import Foundation

struct QuoteModel {
    var quoteContent: String
    var quoteAuthor: String
    var quoteTags: [String]
    
    init(quote: Quote) {
        self.quoteContent = quote.content
        self.quoteAuthor = quote.author
        self.quoteTags = quote.tags
    }
}

class QuoteViewModel {
    
    var quotes: [QuoteModel] = []
    
    func getQuote(from url: String?, completionHandler: @escaping (Quote?, Error?) -> ()) {
        
        assert(url != nil, "URL isn't correct")
        
        guard let url = url else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("JSON Parsing error!")
                return
            }
            
            do {
                let quote = try JSONDecoder().decode(Quote.self, from: data)
                completionHandler(quote, nil)
                self.quotes.append(QuoteModel(quote: quote))
            }
            catch {
                print(String(describing: error))
            }
            
        })
        task.resume()
    }

}


