//
//  DateFormatter+Extensions.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 04/09/2024.
//

import Foundation

extension DateFormatter {
    static let sharedDateTimeFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateStyle = .medium
          return formatter
      }()}
