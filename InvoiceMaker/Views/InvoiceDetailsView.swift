//
//  InvoiceDetailsView.swift
//  InvoiceMaker
//
//  Created by Eze Chidera Paschal on 04/09/2024.
//

import SwiftUI

struct InvoiceDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) var context
    
    @State private var invoiceShare: Bool = false
    
    @State private var status: Invoice.Status = .pending
    
    let invoice: Invoice
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 20) {
                Text("Invoices #\(invoice.invoiceNumber)")
                    .font(Font.custom("Manrope-Medium", size: 32, relativeTo: .title))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Invoice date")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                        Text(dateFormatter.string(from: invoice.invoiceDate))
                            .font(Font.custom("Manrope-Medium", size: 16))
                            .fontWeight(.semibold)


                    }
                    
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Amount")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                        Text(invoice.totalAmount, format: .currency(code: invoice.currency))
                            .font(Font.custom("Manrope-Medium", size: 16))
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Status")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                        
                        HStack(spacing: 8){
                            Image(systemName: invoice.imageName)
                            Text(invoice.status.rawValue.capitalized)
                        }
                        .font(Font.custom("Manrope-Medium", size: 16))
                        .fontWeight(.semibold)
                           
                        }
                }.padding(.bottom, 20)
                
                
                Button {
                    status = .paid
                    
                    invoice.status = status
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                } label: {
                    HStack(spacing: 8){
                        if invoice.status != .paid {
                            Image(systemName: "checkmark.circle")
                            Text("Mark as paid")
                        } else {
                            Text("Paid")
                        }
                    }
                        .font(Font.custom("Manrope-Medium", size: 16))
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                  
                }.background {
                    RoundedRectangle(cornerRadius: 12).fill(Color.customGreen)
                }
                .disabled(invoice.status == .paid)
                
                
                HStack(spacing: 10) {
                    Button {
                        invoiceShare = true
                    } label: {
                        HStack(spacing: 8){
                            Image(systemName: "arrow.up.right.square")
                            Text("Share")
                        }
                            .font(Font.custom("Manrope-Medium", size: 16))
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    }.background {
                        RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1)
                    }
                    
                    NavigationLink(destination: AddInvoiceView(invoice: invoice), label: {
                        HStack(spacing: 8){
                            Image(systemName: "pencil.line")
                            Text("Edit")
                        }
                            .font(Font.custom("Manrope-Bold", size: 16))
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background {
                        RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 1)
                    }

                    })
                    
                }
                
            }
            
            .listRowBackground(Color.clear)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .listRowInsets(.init(top: 0, leading: 8, bottom: 0, trailing: 8))
            Section("BILL TO"){
                HStack{
                    Image(systemName: "person")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .padding(4)
                        .background {
                            RoundedRectangle(cornerRadius: 12).fill(Color.customGreen)
                        }
                    VStack(alignment: .leading) {
                        Text(invoice.clientName)
                            .fontWeight(.semibold)
                        Text("\(invoice.clientName)@gmail.com")
                            .foregroundStyle(.gray)
                            .font(.caption)
                    }
                }
            }
            
            
            Section("Items") {
                ForEach(invoice.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(Font.custom("Manrope-Bold", size: 16))
                                .fontWeight(.semibold)
                            Text("\(item.quantity) x \(item.amount)")
                                .font(.caption)
                        }
                        Spacer()
                        Text("\((Int(item.quantity) * Int(item.amount)), format: .currency(code: "\(invoice.currency)"))")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }

            }

        }
        .sheet(isPresented: $invoiceShare) {
            InvoiceView(invoice: invoice)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Invoice Details")
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Image(systemName: "ellipsis")
            }
            ToolbarItem(placement: .topBarLeading){
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.caption)
                    Text("Back")
                }.onTapGesture {
                    dismiss()
                }
            }
        }
    }
}

