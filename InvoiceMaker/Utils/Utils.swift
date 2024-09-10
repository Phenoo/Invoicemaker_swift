//
//  Utils.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 03/09/2024.
//

import Foundation

class Utils {
    func generateInvoiceNumber() -> String {
        let letters = String((0..<2).map { _ in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()! })
        let numbers = String((0..<5).map { _ in "0123456789".randomElement()! })
        return letters + numbers
    }

}
