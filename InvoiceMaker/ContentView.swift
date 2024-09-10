//
//  ContentView.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 03/09/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 1
    
    var body: some View {
            TabView(selection: $selectedTab,
                    content:  {
                InvoiceScreenView().tabItem { HStack {
                    Image(systemName: "list.bullet.rectangle.fill")
                    Text("Invoices")
                        .font(.headline)
                } }.tag(1)
               AccountScreenView().tabItem {
                   HStack {
                       Image(systemName: "person.circle")
                       Text("Account")
                   }
               }.tag(2)           
            }).tint(.black)

    }
}

#Preview {
    ContentView()
}
//AIzaSyC-Ux5Lq_Kxmsgf4LlIiORybrke6p1HgWw
