//
//  InvoiceMakerApp.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 03/09/2024.
//

import SwiftUI
import SwiftData

@main
struct InvoiceMakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: [Invoice.self])
    }
}
