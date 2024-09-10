//
//  InvoiceListItemView.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 04/09/2024.
//

import SwiftUI

struct InvoiceListItemView: View {
    
    let invoice: Invoice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Invoice for \(invoice.items[0].name)")
                        .font(Font.custom("Manrope-Bold", size: 16))

                    Text("Created by ")
                        .font(.caption)
                        .foregroundStyle(.gray)

                    + Text(DateFormatter.sharedDateTimeFormatter.string(from: invoice.invoiceDate))
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Menu {
                    NavigationLink(destination: InvoiceDetailsView(invoice: invoice), label: {
                        Text("View")
                    })
                    NavigationLink(destination: AddInvoiceView(invoice: invoice), label: {
                        Text("Edit")
                    })
                    Button("Mark as paid", action: {})
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Delete")
                            .foregroundStyle(.red)
                            .tint(.red)
                            
                    }).foregroundStyle(.black)
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
            
            Divider()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text(invoice.clientName)
                        .font(Font.custom("Manrope-Bold", size: 16))

                    Text("estherhoward@gmail.com")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                VStack(alignment: .leading) {
                    Text(invoice.currency)
                        .font(.headline)
                        .font(Font.custom("Manrope-Bold", size: 26))
                    Text("Currency")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }


        }
    }
}

