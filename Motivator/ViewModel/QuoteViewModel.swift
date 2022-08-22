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
        
        assert(url != nil, "URL isn't correct!")
        
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
    
    func getQuotesByAuthor(authorName name: String, completionHandler: @escaping (Quote?, Error) -> ()) {

        let url = "https://quotable.io/quotes?author=" + name.replacingOccurrences(of: " ", with: "-").lowercased()

        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in

            guard let data = data, error == nil else {
                print("JSON Parsing error!")
                return
            }

            var quoteByAuthor: QuoteByAuthor?

            do {
                quoteByAuthor = try JSONDecoder().decode(QuoteByAuthor.self, from: data)
            }
            catch {
                print(String(describing: error))
            }

            guard quoteByAuthor != nil else {
                return
            }

            for i in 0...(quoteByAuthor?.results.count)! - 1 {
                let quoteViewModel = QuoteModel(quote: (quoteByAuthor?.results[i])!)
                self.quotes.append(quoteViewModel)
//                print("AUTHOR QUOTES: \(self.quoteViewModel.quotes)")
            }
        })
        task.resume()
    }

}


