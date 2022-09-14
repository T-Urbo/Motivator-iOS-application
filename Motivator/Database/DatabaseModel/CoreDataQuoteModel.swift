//
//  CoreDataQuoteModel.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 14/09/2022.
//

import Foundation

public class CoreDataQuoteModel: NSObject {
    let quoteModel: QuoteModel
    
    init(quoteModel: QuoteModel) {
        self.quoteModel = quoteModel
    }
}
