//
//  AuthorViewModel.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 19/08/2022.
//

// TODO: - JSON API parsing error handling! (for special letters)


import Foundation

struct AuthorModel {
    var authorName: String
    var authorOccupation: String
    var authorImage: String
    var authorQuotes: Int
    var isAuthorSaved: Bool


    init(withAuthor author: Author) {
        self.authorName = author.name
        self.authorOccupation = author.description
        self.authorImage = author.link
        self.authorQuotes = author.quoteCount
        self.isAuthorSaved = false
    }
}

class AuthorViewModel {
    
    var savedAuthors: [Author] = [Author]()
    var author = Author(_id: "", bio: "", description: "", link: "", name: "", slug: "", quoteCount: 0)
    
    var quoteViewModel = QuoteViewModel()
    
    
    func loadAuthorBio(authorName: String) {
//        , completionHandler: @escaping (Author?, Error) -> ()
        let url = "https://quotable.io/authors?slug=" + authorName.replacingOccurrences(of: " ", with: "-").lowercased()
        print(url)
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, responce, error in
            
            guard let data = data, error == nil else { print("data is nil!"); return }
            print(data)
            
            var authorResults: AuthorResults?
            
            do {
                authorResults = try JSONDecoder().decode(AuthorResults.self, from: data)
                guard authorResults != nil else { print("authorResults is nil!"); return }
                
                self.author = authorResults!.results.first!
            }
            catch {
                print(String(describing: error))
            }
            
            
            print("author after loadAuthorBio func: \(self.author)")
            print("loadAuthorBio func has ended!")
            
        })
        task.resume()
    }
}
