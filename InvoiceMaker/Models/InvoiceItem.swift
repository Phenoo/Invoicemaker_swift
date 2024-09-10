//
//  InvoiceItem.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 03/09/2024.
//

import Foundation

struct InvoiceItem: Identifiable, Codable {
    
    var id = UUID().uuidString
    var name: String
    var quantity: Int
    var description: String
    var amount: Double
}
