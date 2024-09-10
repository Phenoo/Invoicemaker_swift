//
//  InvoiceFile.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 04/09/2024.
//

import Foundation


// Invoice.swift

import Foundation

struct InvoiceFile {
    let id: String
    let date: Date
    let items: [InvoiceFileItem]
    let totalAmount: Double
}

struct InvoiceFileItem {
    let description: String
    let quantity: Int
    let unitPrice: Double
    
    var total: Double {
        return Double(quantity) * unitPrice
    }
}
