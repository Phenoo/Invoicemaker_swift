//
//  InvoiceScreenView.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 03/09/2024.
//

import SwiftUI
import SwiftData


enum SelectList: String, CaseIterable {
    case all = "All"
    case open = "Open"
    case paid = "Paid"
    case templates = "Templates"
}

struct InvoiceScreenView: View {
    @State private var selected: SelectList = .all
    @Environment(\.modelContext) var context
    
    @Query(sort: \Invoice.invoiceDate, order: .forward) private var invoices : [Invoice]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var filteredInvoices: [Invoice] {
            switch selected {
            case .paid:
                return invoices.filter { $0.status == .paid }
            case .open:
                return invoices.filter { $0.status == .pending }
            case .templates:
                return invoices.filter { $0.status == .overdue }
            case .all:
                return invoices
            }
        }
    
    var body: some View {
        NavigationStack {
            List {
                Picker("", selection: $selected) {
                    ForEach(SelectList.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                }.pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                
                Section("\(selected.rawValue)") {
                    if filteredInvoices.isEmpty {
                        ContentUnavailableView("No Invoice Created", systemImage: "tray.fill")
                    } else {
                        ForEach(filteredInvoices) { invoice in
                                InvoiceListItemView(invoice: invoice)
                        }
                    }
                 
                }
                .listRowSpacing(16)
                
            }
            .listRowSpacing(16)
            .navigationTitle("Invoices")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(destination: {
                            AddInvoiceView(invoice: nil)
                        }, label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .foregroundStyle(.black)
                            }

                        })
                    }
                }
        }
    }
}

#Preview {
    InvoiceScreenView()
}
